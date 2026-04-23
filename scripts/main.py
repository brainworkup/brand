from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Iterable
from urllib import error, parse, request


API_BASE = "https://api.github.com"


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="gh-repo-nuke",
        description="Delete multiple GitHub repositories from the terminal.",
    )
    parser.add_argument(
        "--owner",
        required=True,
        help="GitHub user or organization that owns the repositories.",
    )
    parser.add_argument(
        "--repo",
        dest="repos",
        action="append",
        default=[],
        help="Repository name. Pass multiple times for multiple repos.",
    )
    parser.add_argument(
        "--repos",
        dest="repo_csv",
        default="",
        help="Comma-separated repository names.",
    )
    parser.add_argument(
        "--file",
        type=Path,
        help="Path to a newline-delimited file of repository names.",
    )
    parser.add_argument(
        "--token",
        default=os.getenv("GITHUB_TOKEN", ""),
        help="GitHub token. Defaults to GITHUB_TOKEN env var.",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip interactive confirmation.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be deleted without deleting.",
    )
    return parser.parse_args(argv)


def unique_repo_names(args: argparse.Namespace) -> list[str]:
    names: list[str] = []
    names.extend(args.repos)

    if args.repo_csv:
        names.extend(name.strip() for name in args.repo_csv.split(",") if name.strip())

    if args.file:
        if not args.file.exists():
            raise FileNotFoundError(f"Repo list file not found: {args.file}")
        file_lines = args.file.read_text(encoding="utf-8").splitlines()
        names.extend(
            line.strip()
            for line in file_lines
            if line.strip() and not line.strip().startswith("#")
        )

    seen: set[str] = set()
    unique: list[str] = []
    for name in names:
        if name not in seen:
            seen.add(name)
            unique.append(name)

    return unique


def request_github(
    method: str,
    endpoint: str,
    token: str,
) -> tuple[int, str]:
    req = request.Request(
        url=parse.urljoin(API_BASE, endpoint),
        method=method,
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
            "User-Agent": "gh-repo-nuke",
        },
    )

    try:
        with request.urlopen(req) as resp:
            body = resp.read().decode("utf-8", errors="replace")
            return resp.status, body
    except error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        return exc.code, body


def extract_api_message(body: str) -> str:
    if not body:
        return ""
    try:
        payload = json.loads(body)
    except json.JSONDecodeError:
        return body.strip()

    if isinstance(payload, dict) and "message" in payload:
        return str(payload["message"])
    return body.strip()


def delete_repo(owner: str, repo: str, token: str, dry_run: bool) -> tuple[bool, str]:
    full_name = f"{owner}/{repo}"
    if dry_run:
        return True, f"DRY RUN: would delete {full_name}"

    status, body = request_github("DELETE", f"/repos/{owner}/{repo}", token)
    if status == 204:
        return True, f"Deleted {full_name}"

    message = extract_api_message(body)
    if not message:
        message = f"HTTP {status}"
    return False, f"Failed {full_name}: {message}"


def confirm_or_exit(owner: str, repos: Iterable[str], assume_yes: bool) -> None:
    repo_list = list(repos)
    if assume_yes:
        return

    sys.stdout.write("The following repositories will be deleted:\n")
    for repo in repo_list:
        sys.stdout.write(f"- {owner}/{repo}\n")
    sys.stdout.write("\nThis is permanent and cannot be undone.\n")
    sys.stdout.write("Type DELETE to continue: ")
    entered = input().strip()
    if entered != "DELETE":
        sys.stderr.write("Aborted. No repositories were deleted.\n")
        raise SystemExit(1)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    repos = unique_repo_names(args)

    if not repos:
        sys.stderr.write("No repositories provided. Use --repo, --repos, or --file.\n")
        return 2

    if not args.token and not args.dry_run:
        sys.stderr.write("Missing token. Set --token or GITHUB_TOKEN.\n")
        return 2

    confirm_or_exit(args.owner, repos, args.yes)

    failures = 0
    for repo in repos:
        ok, message = delete_repo(args.owner, repo, args.token, args.dry_run)
        target = sys.stdout if ok else sys.stderr
        target.write(f"{message}\n")
        failures += 0 if ok else 1

    if failures:
        sys.stderr.write(f"Completed with {failures} failure(s).\n")
        return 1

    sys.stdout.write(f"Completed: {len(repos)} repositories processed successfully.\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
