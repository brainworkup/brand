# ==============================================================================
# CARS-2-HF (Childhood Autism Rating Scale, 2nd Edition - High-Functioning)
# Data Structure for R Shiny Application
# ==============================================================================
# Based on: Schopler, Van Bourgondien, Wellman, & Love (2010)
# For use with verbally fluent individuals aged 6+ with IQ >= 80
# ==============================================================================

# ==============================================================================
# DEMOGRAPHIC FIELDS
# ==============================================================================

cars2_hf_demographics <- list(
  name = list(type = "text", label = "Name", required = TRUE),
  case_id = list(type = "text", label = "Case ID Number"),
  test_date = list(type = "date", label = "Test Date", required = TRUE),
  dob = list(type = "date", label = "Date of Birth", required = TRUE),
  age_years = list(type = "numeric", label = "Age (Years)", min = 6, max = 99),
  age_months = list(
    type = "numeric",
    label = "Age (Months)",
    min = 0,
    max = 11
  ),
  gender = list(
    type = "select",
    label = "Gender",
    options = c(
      "",
      "Male",
      "Female",
      "Non-binary",
      "Other",
      "Prefer not to say"
    )
  ),
  ethnic_background = list(type = "text", label = "Ethnic Background"),
  rater_name = list(type = "text", label = "Rater's Name", required = TRUE),
  info_sources = list(type = "text", label = "Based on Information From")
)

# ==============================================================================
# RATING SCALE DEFINITIONS
# ==============================================================================

cars2_hf_rating_scale <- list(
  "1" = list(
    value = 1,
    label = "Age-appropriate / Normal",
    description = "Within normal limits for that age"
  ),
  "1.5" = list(
    value = 1.5,
    label = "Very mildly abnormal",
    description = "Very mildly abnormal for that age"
  ),
  "2" = list(
    value = 2,
    label = "Mildly abnormal",
    description = "Mildly abnormal for that age"
  ),
  "2.5" = list(
    value = 2.5,
    label = "Mildly-to-moderately abnormal",
    description = "Mildly-to-moderately abnormal for that age"
  ),
  "3" = list(
    value = 3,
    label = "Moderately abnormal",
    description = "Moderately abnormal for that age"
  ),
  "3.5" = list(
    value = 3.5,
    label = "Moderately-to-severely abnormal",
    description = "Moderately-to-severely abnormal for that age"
  ),
  "4" = list(
    value = 4,
    label = "Severely abnormal",
    description = "Severely abnormal for that age"
  )
)

# ==============================================================================
# SCORE INTERPRETATION TABLES
# ==============================================================================

# Total Raw Score Ranges for CARS2-HF
cars2_hf_raw_score_categories <- list(
  "15-27.5" = list(
    min = 15,
    max = 27.5,
    category = "Minimal-to-No Symptoms",
    description = "Symptoms of ASD are minimal or absent"
  ),
  "28-33.5" = list(
    min = 28,
    max = 33.5,
    category = "Mild-to-Moderate Symptoms",
    description = "Mild-to-moderate symptoms of ASD are present"
  ),
  "34-60" = list(
    min = 34,
    max = 60,
    category = "Severe Symptoms",
    description = "Severe symptoms of ASD are present"
  )
)

# T-Score Interpretation
cars2_hf_tscore_categories <- list(
  "<30" = list(
    max = 29,
    category = "Very Low",
    description = "Minimal autism-related behaviors"
  ),
  "30-39" = list(
    min = 30,
    max = 39,
    category = "Low",
    description = "Below average autism-related behaviors"
  ),
  "40-59" = list(
    min = 40,
    max = 59,
    category = "Average",
    description = "Average range of autism-related behaviors for clinical sample"
  ),
  "60-69" = list(
    min = 60,
    max = 69,
    category = "High",
    description = "Above average autism-related behaviors"
  ),
  ">=70" = list(
    min = 70,
    category = "Very High",
    description = "Very high autism-related behaviors"
  )
)

# ==============================================================================
# ITEM DEFINITIONS
# ==============================================================================

cars2_hf_items <- list(
  # --------------------------------------------------------------------------
  # Item 1: Social-Emotional Understanding
  # --------------------------------------------------------------------------
  item_01 = list(
    number = 1,
    name = "Social-Emotional Understanding",
    short_name = "social_emotional",
    domain = "Social Cognition",
    median = 2.5,
    definition = "Social-emotional understanding addresses an individual's cognitive understanding of others' communication, behaviors, and differing perspectives. The dimensions of social understanding that are included in this item are the ability to read the nonverbal cues of others and the ability to take another person's perspective. This item does not reflect whether someone has friends or is in a relationship. Rather it deals with an individual's ability to perceive and articulate how another person may feel or what his or her perspective may be in a situation.",
    considerations = "This item is best assessed through a direct interview with the individual. Presenting pictures of a variety of social situations and asking the individual to tell you what he or she thinks the people in the situation are thinking and feeling is a helpful technique. Through the use of either real-life experiences or these depicted situations, the goal of the interview is to determine the degree to which the individual understands and can articulate how others feel and how others may have different perspectives of a social situation. There are a number of theory of mind and social perception tasks, such as the Roberts-2, that also can be used to assess the individual's ability to take another's perspective. Again, this item reflects the individual's cognitive understanding of others and not his or her emotional empathy.",
    scoring = list(
      "1" = "Age-appropriate social-emotional understanding. Clearly understands the facial expressions, gestures, tone of voice, and body language of others. The individual is able to understand that others may have a different perspective and what that perspective may be.",
      "2" = "Mildly impaired social-emotional understanding. The individual is responsive to most facial expressions, expression of emotions in others, gestures, and body language, but may need these to be slightly exaggerated, excluding more subtle expressions such as mild sarcasm, doubt, or ambiguity. The ability to take another's perspective is inconsistent.",
      "3" = "Moderately impaired social-emotional understanding. The individual shows an understanding of facial expressions, tone of voice, and body language only when they are exaggerated. He or she is likely to ignore or misunderstand the expressions or perspectives of others.",
      "4" = "Severely impaired social-emotional understanding. The individual demonstrates virtually no ability to understand appropriate facial expressions, gestures, tone of voice, or body language. He or she is unable to recognize that the perspective, understanding, and expression of others might differ from his or her own."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 2: Emotional Expression and Regulation of Emotions
  # --------------------------------------------------------------------------
  item_02 = list(
    number = 2,
    name = "Emotional Expression and Regulation of Emotions",
    short_name = "emotional_expression",
    domain = "Social Cognition",
    median = 2.5,
    definition = "This rating is based on the individual's ability to express and regulate his or her own emotions.",
    considerations = "This item is based on both direct observation and the reports of others who have observed this person's behavior in other settings. During a direct interaction with the individual, engage in a discussion of events that have happened to him or her that have been both positive and negative. Note whether the individual's facial expression and affect match the content of the discussion. Does the person show the full range of emotions? Does he or she have an exaggerated response to either positive or negative events? Does the individual report having trouble controlling his or her emotions or behaviors when stressed? Do these emotional regulation problems happen in just one or in more than one setting (e.g., home and work)? Parent and observer reports are very important for this item, as individuals who have problems controlling their emotions across multiple settings get higher scores.",
    scoring = list(
      "1" = "Age-appropriate and situation-appropriate emotional response. The individual shows an appropriate type and degree of emotional response, both by word and behavior, including emotional variations such as happy, sad, proud, angry, scared, anxious, and related internal states.",
      "2" = "Mildly abnormal emotional response. The individual's emotional expressions are relatively flat, distorted, or slightly exaggerated. Nonverbal expression of emotions does not always match verbal content. The individual is able to describe several emotions in him- or herself, but this ability is limited compared to his or her developmental level. The individual may have intermittent emotional regulation problems.",
      "3" = "Moderately abnormal emotional response. The individual's expression of emotions is flat, excessive, or frequently inconsistent with the situation or content of a verbalized topic. The individual may display greater emotion than expected about special interests or idiosyncratic concerns. Ability to describe or understand emotional states in him- or herself is limited. He or she has serious problems with emotional regulation that occur frequently in at least one setting.",
      "4" = "Severely abnormal emotional response. The individual has extreme problems with emotional regulation that occur in more than one setting. Responses are extreme or seldom appropriate to the situation or content of discussion. Shows extreme mood shifts that are difficult to change. Expresses only a few emotions in their exaggerated form or perseverates on a particular emotion without understanding."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 3: Relating to People
  # --------------------------------------------------------------------------
  item_03 = list(
    number = 3,
    name = "Relating to People",
    short_name = "relating_to_people",
    domain = "Social Interaction",
    median = 2.0,
    definition = "This is a rating of how the individual behaves in a variety of situations involving interaction with other people. This item is related to the first two items, which also rate aspects of social relationships. This item differs in that it is confined to dimensions related to direct interpersonal interactions, and the person's initiation of interactions and reaction to another individual. The two dimensions that are rated on this item are the individual's initiation of interactions and the reciprocal nature of the interactions.",
    considerations = "Consider both structured and unstructured situations where the individual has a chance to interact with an adult, spouse, peer, sibling, or you (the rater). Consider how the individual reacts to attempts by others to engage him or her in an interaction. These attempts may range from persistent, intensive attempts to get a response to the allowance of complete freedom. Note whether the person initiates interactions, and if yes, whether he or she does so purely for social purposes or only to get specific needs met or to discuss areas of intense special interest. Regardless of who initiates the interaction, note if the individual engages in and helps to maintain the interaction past the initial overtures.",
    scoring = list(
      "1" = "No evidence of difficulty or abnormality in relating to people. Age-appropriate initiation of interactions to get help, to get needs met, and for purely social purposes. Interactions with others are fluid and show a reciprocal, back-and-forth pattern.",
      "2" = "Mildly abnormal relationships. The individual initiates interactions only to get obvious needs met or discuss special interests. There is some give-and-take in interactions, but it lacks consistency, fluidity, or appropriateness. The individual is aware of children/adults of the same age and interested in interactions, but may have difficulty initiating or managing an interaction. Minimal initiation for purely social purposes that does not involve special interests.",
      "3" = "Moderately abnormal relationships. The individual initiates interactions almost totally around his or her special interests, with little attempt to engage others in these interests. He or she responds to overtures from others, but the interaction lacks social give-and-take and/or his or her responses are unusual and not always related to the overture from others. The individual is unable to maintain an interaction past the initial overture.",
      "4" = "Severely abnormal relationships. The individual does not initiate any directed interactions and shows minimal response to overtures from others. Only the most persistent attempts to get the individual to engage have any effect."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 4: Body Use
  # --------------------------------------------------------------------------
  item_04 = list(
    number = 4,
    name = "Body Use",
    short_name = "body_use",
    domain = "Restricted/Repetitive Behaviors",
    median = 2.0,
    definition = "This area represents both coordination and appropriateness of body movements. Subtle forms of fine and gross motor coordination are rated here, as well as deviations such as posturing, spinning, tapping and rocking, toe-walking, and self-directed aggression.",
    considerations = "Consider fine motor activities such as handwriting, drawing, and tying shoes. Fine motor difficulties are rated on this area, with higher ratings given for problems that are so severe that the person actively resists certain tasks. While this item can be scored using another person's report, it should be scored based on current behaviors and directly observed behaviors should be given more weight. Any current obvious deviant behaviors, including posturing, spinning, rocking, toe-walking, and self-directed aggression, automatically earn a rating of 3 or more, depending on the persistence of the behavior.",
    scoring = list(
      "1" = "Age-appropriate body use. The individual moves with the same ease, agility, and coordination of a typical person of the same age.",
      "2" = "Mildly abnormal body use. Some minor peculiarities may be present, such as clumsiness, repetitive movements, or poor coordination or balance. The individual may have fine motor difficulties, such as problems with handwriting or tying shoes, compared to others at the same developmental level.",
      "3" = "Moderately abnormal body use. The individual currently displays an unusual body posture or stance, hand or finger mannerism, flapping, self-directed aggression, picking at body, rocking, spinning or toe-walking. Fine motor or obvious handwriting difficulties are present, which may result in resistance to writing tasks.",
      "4" = "Severely abnormal body use. Intense or frequent movements of the types listed in the other categories are signs of severely abnormal body use."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 5: Object Use in Play
  # --------------------------------------------------------------------------
  item_05 = list(
    number = 5,
    name = "Object Use in Play",
    short_name = "object_use",
    domain = "Restricted/Repetitive Behaviors",
    median = 2.0,
    definition = "This rating includes the person's interest in and use of toys or other objects. In addition to the traditional issues related to repetitive play with parts of objects, the focus of this item also includes the degree to which the individual engages in imaginative symbolic play and the degree to which toy figures are used as agents.",
    considerations = "Consider how the person interacts with toys or other objects, particularly in unstructured activities with a large variety of items available. For older individuals, the rating may need to be based on a parent interview. Any current obvious repetitive or inappropriate use of objects or obvious interest in parts of objects, as opposed to the whole, should be rated as a 3 or higher depending on the persistence. Note the individual's imaginative or creative use of the materials. Does the individual use an object as an agent of action with the other toys? Does he or she engage in make-believe play and use an object to represent something else?",
    scoring = list(
      "1" = "Appropriate interest in, and creative use of, toys and other objects. The individual is able to spontaneously use toys in age-appropriate imaginative symbolic play and is able to use objects to represent something else. The individual shows interest in a variety of toys and leisure materials.",
      "2" = "Mildly inappropriate interest in, or use of, toys and other objects. The individual's play themes tend to be repetitive or appear to reflect things seen in movies or on TV. Some use of toy people as agents of action. Some make-believe play or use of objects to represent something else. The individual responds to attempts by others to engage him or her in pretend play, but there is limited spontaneous initiation of imaginative play. The individual's interests may be unusual in intensity or inappropriate for his or her age. No obvious repetitive or inappropriate use of objects or interest in parts of objects at this level.",
      "3" = "Moderately inappropriate interest in, or use of, toys and other objects. Limited imaginative creative play either spontaneous or in response to others. 'People' typically not used as agents of action, and limited use of objects to represent other things. No original themes in play. May show some repetitive inappropriate use of objects or interest in parts of objects. Interest in play materials is restricted to a few items that may be inappropriate for his or her age or interest is of an unusual intensity.",
      "4" = "Severely inappropriate interest in, or use of, toys and other objects. No creative play. Toys are used in repetitive or inappropriate manner."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 6: Adaptation to Change/Restricted Interests
  # --------------------------------------------------------------------------
  item_06 = list(
    number = 6,
    name = "Adaptation to Change/Restricted Interests",
    short_name = "adaptation_change",
    domain = "Restricted/Repetitive Behaviors",
    median = 2.5,
    definition = "This area concerns difficulty in changing established routines or patterns, difficulties in changing from one activity to another, and restricted special interests.",
    considerations = "Note the individual's reaction to changing from one activity to another, particularly if he or she was actively involved in the previous activity. Note whether the person has a particular activity or interest that appears unusual either in its intensity or narrowness. If engaged in this activity or a conversation about this interest, how readily can the person switch to a different activity or topic? Observe whether the individual is quick to establish routines. Does the person have any unusual rituals around going to bed at night or doing work at school or in the work place? Does he or she insist on arranging certain objects 'just so,' or eating or drinking only with specific utensils? For older individuals, interview them about changes in daily activities and routines, and note their emotional reactions to these events. The rating for this item is based on the most severe level of difficulty in any one of the following three areas: coping with change, ritualistic behaviors, or restricted special interests.",
    scoring = list(
      "1" = "Age-appropriate response to change/variety of interests. While the individual may notice or comment on changes in routines, he or she accepts these changes without undue stress. The individual shows a wide variety of interests, with no one interest or theme predominating.",
      "2" = "Mildly abnormal adaptation to change/variety of interests. Unusually quick to develop new routines. Or when others try to change the task, the person may continue the same activity or use the same materials, though he or she can be directed to change if needed. Or person shows preference for specific activities, toys, or topics of conversation, though he or she can be directed to other topics or activities.",
      "3" = "Moderately abnormal adaptation to change/variety of interests. The individual has definite special interests or a preference for specific activities, toys, or topics. An adult needs to actively work to engage the individual in other topics or activities. The individual shows displeasure and may resist change or try to maintain routine. The individual may become distressed by attempts to interrupt or change an activity or topic. He or she may have rituals or routines that have to be done in a particular way. The person may report subjective feelings of distress about change and/or interruptions or may become overly fixed on a schedule, checklist, or timing of events.",
      "4" = "Severely abnormal adaptation to change/variety of interests. The individual has definite special interests or preferences, or has severe reaction to change. Reacts with extreme anxiety, anger, or resistance to attempts to change an activity, topic, or routine."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 7: Visual Response
  # --------------------------------------------------------------------------
  item_07 = list(
    number = 7,
    name = "Visual Response",
    short_name = "visual_response",
    domain = "Sensory Response",
    median = 2.0,
    definition = "This item covers the use of vision in three areas: visual fascinations, the ease with which the individual can shift visual attention, and the degree to which the individual's eye contact is integrated with actions and communication.",
    considerations = "Consider whether the person uses his or her eyes normally when looking at objects or interacting with people. Does the individual look at the person to whom he or she is talking? When interacting with more than one person, does the person shift his or her visual attention to a new speaker? Distractibility is not the focus of this item. Any obviously unusual visual response—for example, looking at items or fingers out of the corners of the eyes or spinning objects—receives a rating of 3 or higher, depending on the persistence of the behavior.",
    scoring = list(
      "1" = "Age-appropriate visual response. The individual's visual behavior is normal and appropriate for his or her age. No evidence of visual fascinations or difficulty shifting attention. Eye contact is good and integrated with verbal and nonverbal communication skills. Easily shifts visual attention.",
      "2" = "Mildly abnormal visual response. The individual may stare inappropriately at others. Eye contact is not consistently integrated with verbalizations. Included at this level is any inconsistency in eye contact, regardless of the proportion of time the individual makes eye contact. The individual may show more interest in describing small details in a room or in looking at specific objects (moving parts, lights, mirrors) than is typical.",
      "3" = "Moderately abnormal visual response. Eye contact is not integrated with verbalizations. Obvious visual fascination with objects, lights, mirrors, spinning toys, and so on. May use peripheral vision to look at things. Obvious difficulty in shifting visual attention from high-interest items.",
      "4" = "Severely abnormal visual response. Persistent avoidance of eye contact. Excessive interest in looking at specific objects or looking at objects in a peculiar way."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 8: Listening Response
  # --------------------------------------------------------------------------
  item_08 = list(
    number = 8,
    name = "Listening Response",
    short_name = "listening_response",
    domain = "Sensory Response",
    median = 2.0,
    definition = "This rating is based on the person's unusual responses to sounds and how the listening response is coordinated with the use of other senses.",
    considerations = "In direct observation, note the individual's reaction to both speech and other sounds. The individual's ability to respond to his or her name by orienting to the person speaking is scored on this item. Unusual over- or underreactions to noise or sounds are more salient indicators of difficulty than merely being distracted by noises. For example, someone who remarks on the distant sound of a train and comments on the type of engine it must be and the number of cars, or where it is heading, would be demonstrating a more salient behavior than someone who merely turns his or her head toward a loud noise. Older adolescents and adults should be directly asked about their interest in or aversion to certain sounds. To receive a rating of 3 or higher, unusual listening responses must be apparent across more than one setting and they must be directly observed or reported by the individual.",
    scoring = list(
      "1" = "Age-appropriate listening response. The individual's listening behavior is normal and appropriate for his or her age. Listening is used together with other senses (e.g., the individual looks toward the person who is speaking). The individual responds to his or her name.",
      "2" = "Mildly abnormal listening response. Some difficulty responding to verbalizations when background noise is present. Responds to his or her name after repeated attempts to get the individual's attention. There may be some lack of response or mild overreaction to certain sounds. Atypical listening responses are apparent either in direct observation or by report from outside observer, but not both.",
      "3" = "Moderately abnormal listening response. The individual's responses to sounds or verbalizations are inconsistent. May show marked reaction to some sounds, or complete disregard for others. Seldom responds to his or her name when name is called to get the individual's attention. Unusual responses are obvious across settings, either based on direct report by the individual or by combined observer report and direct observation.",
      "4" = "Severely abnormal listening response. The individual overreacts and/or underreacts to sounds to an extremely marked degree. He or she is noticeably less responsive to verbalizations than to noises made by objects. The individual does not respond to repeated attempts to get his or her attention by calling his or her name."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 9: Taste, Smell, and Touch Response and Use
  # --------------------------------------------------------------------------
  item_09 = list(
    number = 9,
    name = "Taste, Smell, and Touch Response and Use",
    short_name = "taste_smell_touch",
    domain = "Sensory Response",
    median = 2.0,
    definition = "This item addresses the person's response to stimulation of his or her taste, smell, and touch senses and to pain. Subtler aspects of the unusual stimulation of these senses include responses to the textures of clothing or food, such that the individual wears a limited variety of fabrics or eats a limited variety of foods.",
    considerations = "In individuals with the cognitive levels specified for the CARS2-HF (IQ over 80, with fluent language), direct observation of the more extreme examples of sensory stimulation (e.g., rubbing objects against the face) are unusual. Any obvious observation of these more classic sensory behaviors warrants a rating of 3 or higher, depending on the persistence of the behavior. For the more subtle sensory behaviors of food or clothing preferences, the degree to which they are pervasive across settings will be an important determinant for which rating to give. Also, the degree to which these unusual sensory reactions induce stress, require environmental modifications, and are resistant to change is an important consideration. Relatively more pervasive difficulties and those more resistant to change are given higher ratings. It is also important to keep in mind that individuals of certain ages (e.g., adolescents) often have strong food and clothing preferences. Look for preferences that do not reflect societal trends or fads. To get a rating of 3 or higher based on these types of behaviors, the unusual clothing or food preferences must be obvious across multiple settings and the individual self-reports these difficulties or they are obvious on direct observation.",
    scoring = list(
      "1" = "Normal use of, and response to, taste, smell, and touch. The individual explores new objects in an age-appropriate manner generally by looking and feeling. Responds appropriately to pain or touch from others. Reacts to minor pains or illnesses by showing appropriate discomfort, but does not overreact. Wears a variety of textures of clothing and eats a wide variety of foods.",
      "2" = "Mildly abnormal use of, and response to, taste, smell, and touch. The individual may occasionally explore objects by subtle attempts to smell, taste, or rub them against part of his or her face or body. The individual may show a mild over- or underreaction to touch or pain. The individual may have obvious clothing or food preferences, but is easily encouraged to try new things. Unusual sensory responses are apparent in direct observation or by report from outside observer, but not both.",
      "2.5" = "Use this rating when observers report obvious sensory behaviors, such as clothing and food preferences that are difficult to change or modify, but these issues are not reported by the individual and not obvious during the interview.",
      "3" = "Moderately abnormal use of, and response to, taste, smell, and touch. The individual obviously explores objects by smelling, tasting, or rubbing them against a part of his or her face or body, or the individual over- or underreacts or stiffens to a touch or pain to a moderate degree. Or the individual has limited clothing he or she will wear or food he or she will eat. Limitations in sensory areas, such as clothing and/or food preferences, are obvious across settings, and the individual self-reports these difficulties or they are obvious on direct observation. Sensory issues are difficult to modify and create stress or require adaptation in everyday environments.",
      "4" = "Severely abnormal use of, and response to, taste, smell, and touch. The individual places extreme limits on the food he or she eats or clothing he or she wears. Or the individual has extreme reactions or underreactions to a touch or pain. Or he or she shows a persistent preoccupation with smelling, touching, or tasting things. Near-receptor issues are a source of extreme stress for the individual, who puts stress on the environment to find ways to cope with these difficulties."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 10: Fear or Anxiety
  # --------------------------------------------------------------------------
  item_10 = list(
    number = 10,
    name = "Fear or Anxiety",
    short_name = "fear_anxiety",
    domain = "Emotional Response",
    median = 2.0,
    definition = "This item focuses on the degree to which the person has unusual fears or anxiety compared to what is appropriate for a situation or context.",
    considerations = "Fearful behavior may include crying, screaming, or nervous giggling. Anxiety may be noted in the person's rate of speech, body posture or tension, facial expression, body movement, or frustration tolerance in approaching tasks. Some individuals will be able to directly express their fears or anxiety. They may perseverate on their concern (e.g., their parent's whereabouts, bees, or other items of concern). Note the pervasiveness of these emotions. Is the person's nervousness obvious during direct observation? Do observers report this behavior in other settings? Note whether the emotional reaction is proportionate to the stimulus. Can the individual be reassured or calmed?",
    scoring = list(
      "1" = "Normal fear or anxiety. The individual's behavior is appropriate to both the situation and his or her age.",
      "2" = "Mildly abnormal fear or anxiety. The individual occasionally shows too much or too little fear or anxiety compared to the reaction of a typical person of the same age in a similar situation. The abnormal response is evident in only one setting (e.g., either on direct observation or based on report from observer in another setting, but not both).",
      "3" = "Moderately abnormal fear or anxiety. The individual shows either quite a bit more or quite a bit less fear or anxiety than is typical even for a younger person in a similar situation. The abnormal response is apparent across more than one setting, and the individual either self-reports these difficulties or they are obvious on direct observation.",
      "4" = "Severely abnormal fear or anxiety. Fear and anxiety are pervasive across all settings and persist even after repeated explanations or experiences with harmless events or objects. It is extremely difficult to calm or comfort the individual. The person may, conversely, show pervasive and persistent disregard for hazards that others of the same age avoid."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 11: Verbal Communication
  # --------------------------------------------------------------------------
  item_11 = list(
    number = 11,
    name = "Verbal Communication",
    short_name = "verbal_communication",
    domain = "Communication",
    median = 2.5,
    definition = "This is a rating of two facets of the individual's speech and language skills. The two concepts rated are verbal oddities, such as formal language, unusual tone or inflection, and repetitive or made-up phrases, and the ability to carry on a reciprocal conversation.",
    considerations = "This item is best evaluated by a direct interaction with the individual. Engage the individual in a discussion of either an immediate stimulus in the room (a game, book, or picture) or a discussion of events that have happened in the person's life or the world in general. Note the content of the individual's language. Is the individual using vocabulary that seems more sophisticated than is typical for his or her age and developmental level? Or is he or she using words incorrectly or repetitively? Note the tonal quality, rhythm, and volume or loudness of the voice. As the conversation is pursued, note whether the person engages in an ongoing sequence of exchanges on the same general topic. Does the individual add more information or make overtures to extend the discussion? Or is the conversation merely a question-and-answer exchange? Can the individual carry on an extended conversation only around high-interest topics? Or can he or she engage in conversation about topics of interest to the other person?",
    scoring = list(
      "1" = "Normal verbal communication, age and situation appropriate. The individual is able to carry on an age-appropriate conversation with another person; he or she is able to respond to others' overtures while also adding additional information (at least a four-element sequence). No evidence of unusual speech inflection, volume, or tone. No evidence of made-up words or repetitive or rote phrases.",
      "2" = "Mildly abnormal verbal communication. Conversational exchanges are more limited than would be expected for someone his or her age. Occasional use of made-up words or repetitive, rote phrases. At times may display unusual vocal intonation or rate of speech. Ratings at this level indicate that the individual has either problems with conversation or verbal oddities, but not both.",
      "3" = "Moderately abnormal verbal communication. Minimal initiation of conversation during direct interaction. Verbalizations include overly formal language or repetitive phrases. Little reciprocal conversation; may speak on his or her own topic, but little sense of interaction. Vocal intonation or rate of speech is often unusual. Some use of unusual words or repetitive speech. The individual has some apparent difficulties in carrying on a reciprocal conversation and displays some type of verbal oddity.",
      "4" = "Severely abnormal verbal communication. The individual is unable to have a conversation with another person. May respond to specific questions, but does not engage in a back-and-forth conversation. Does not initiate communication. Language may be overly formal or pedantic. Marked abnormal speech inflection or tone. Frequently uses made-up words and/or repetitive phrases. The individual has significant difficulties in both areas of expressive communication—reciprocal conversation and verbal oddities."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 12: Nonverbal Communication
  # --------------------------------------------------------------------------
  item_12 = list(
    number = 12,
    name = "Nonverbal Communication",
    short_name = "nonverbal_communication",
    domain = "Communication",
    median = 2.0,
    definition = "This item rates all forms of nonverbal communication, including the use of gaze to regulate and understand interactions and the use of facial expressions and gestures in combination with verbalizations for a variety of communicative functions (instrumental, descriptive, and emphatic). While the person's response to the nonverbal communication of others is also considered, greater emphasis should be placed on the use of these aforementioned forms of communication.",
    considerations = "Consider particularly the individual's use of nonverbal communication at times when the individual has a need or desire to communicate. Also note his or her response to the nonverbal communication of others. Does the person use gestures to point to something of interest or something he or she wants? When describing events or visual stimuli (pictures or books), does the individual use gestures to enhance the description or to emphasize a point? Are the individual's gestures and gaze used in coordination with his or her language to direct the communication toward another person? Does the individual use his or her gaze and gestures to draw another person's attention to an object of interest?",
    scoring = list(
      "1" = "Normal use of nonverbal communication, age and situation appropriate. The individual uses a variety of facial expressions and instrumental, descriptive, and emphatic gestures that are well integrated with verbalizations. The individual responds to facial expressions and gestures from others. The individual's gaze is used to regulate interactions with others.",
      "2" = "Mildly abnormal use of nonverbal communication. The individual uses instrumental gestures (pointing, reaching) to indicate what he or she wants. Descriptive gestures are used infrequently and are not well coordinated with verbalizations. The person responds to very obvious facial expressions or gestures from others. May show too little or exaggerated facial expressions at times, though generally shows appropriate expressions. The individual is inconsistent in the use of gaze to regulate interactions with others.",
      "3" = "Moderately abnormal use of nonverbal communication. Facial expressions are often flat or exaggerated. The individual uses limited instrumental gestures, and these gestures are not well integrated with verbalizations. The individual rarely uses descriptive or emphatic gestures. He or she shows limited response to nonverbal communication from others. Joint attention is rare, as the person seldom uses or responds to gaze or gestures as a means of sharing attention to an object or activity.",
      "4" = "Severely abnormal use of nonverbal communication. Facial expressions are either flat or exaggerated. The individual does not use instrumental, descriptive, or emphatic gestures and shows no awareness of nonverbal communication from others. No evidence of using gaze to regulate activities with others."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 13: Thinking/Cognitive Integration Skills
  # --------------------------------------------------------------------------
  item_13 = list(
    number = 13,
    name = "Thinking/Cognitive Integration Skills",
    short_name = "cognitive_integration",
    domain = "Cognitive",
    median = 2.0,
    definition = "This is a rating of the individual's ability to understand the meaning of larger concepts and to integrate relevant details into a meaningful overview (central coherence). Part of this process involves the person's ability to discriminate between relevant and irrelevant details.",
    considerations = "To assess the individual's cognitive integration skills, there are several types of activities that can be helpful. For some individuals, present them with a short reading exercise or a picture that has a lot of detail and ask them to tell you what the main point or concept behind the reading or the picture is. During a discussion of life events, note the individual's ability to conceptualize the meaning of events and not just report the numerous details. If the individual does not immediately get the main concept, note how he or she responds to your attempts to highlight important information to help him or her see the main issue.",
    scoring = list(
      "1" = "Age-appropriate thinking/cognitive integration skills. The individual is able to understand the meaning of information presented either pictorially, verbally, or in writing. He or she demonstrates central coherence, that is, the ability to attend to relevant versus irrelevant details and to integrate this information into a meaningful overview.",
      "2" = "Mildly impaired in specific thinking/cognitive integration skills. Delayed thinking compared to individuals of the same age. Difficulties may be seen in distinguishing relevant from irrelevant cues for conceptualizing. Or the individual can verbalize an overall understanding, but is unable to articulate how meaning was derived. At times the supportive presence of another person helps with comprehension.",
      "3" = "Moderately impaired in specific thinking/cognitive integration skills. The individual has notable difficulties comprehending meaning and integrating information into overall conceptualization, but shows great attention to specific things and concrete details. Frequently requires specific prompts from others to attend to relevant details or grasp the larger conceptualization.",
      "4" = "Severe delay in specific thinking/cognitive integration skills. The individual shows repeated and consistent difficulty distinguishing relevant from irrelevant details. Even with the persistent efforts of another, he or she may not be able to conceptualize the overall meaning of information."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 14: Level and Consistency of Intellectual Response
  # --------------------------------------------------------------------------
  item_14 = list(
    number = 14,
    name = "Level and Consistency of Intellectual Response",
    short_name = "intellectual_response",
    domain = "Cognitive",
    median = 2.0,
    definition = "This rating is concerned with both the discrepancies in and consistency of the individual's skills as well as his or her general level of intellectual functioning. Some fluctuations in mental functioning occur in many normal individuals. However, this item is intended to identify extremely unusual or 'peak' skills. Discrepancies between academic performance and IQ test scores are not considered in rating this category.",
    considerations = "By definition, this instrument is appropriate only for an individual whose overall IQ score is above 80, so the descriptors make this assumption. For individuals of any age with an IQ less than 80, the CARS2-ST is a more appropriate instrument. The IQ score ranges cited in the ratings are 'rules of thumb' only. As with most test scores, expert discretion based on knowledge about the details of a particular case and the instrument used to derive a given score must be exercised when determining how to best characterize the abilities of a person whose score falls on the border of adjacent ranges. Best practice dictates that formal intellectual assessment data should be included in diagnostic considerations. However, when such formal data are not available, clinical judgment based on a developmental history and relevant observations should be used. Unless the individual has a clearly identified savant skill (this would be given a rating of 4), to get a score other than 1, the individual should be delayed to some degree in his or her adaptive functioning, especially in the area of social skills.",
    scoring = list(
      "1" = "Intelligence is at least normal and reasonably consistent across various areas. The individual has at least near-average intellectual abilities and does not have any unusual intellectual skills or problems. (IQ score is 85 or above, with limited variability.) Adaptive skills are appropriate for age and intellectual abilities. Unless the individual has a savant skill, which always receives a rating of 4, all individuals whose adaptive skills are appropriate for their age and intellectual abilities should receive a rating of 1, regardless of intellectual level or variability in skills.",
      "1.5" = "IQ score is 90 or above, with limited variability across areas. Adaptive skills are less than expected for cognitive level.",
      "2" = "Mildly abnormal intellectual functioning. The individual is not as smart as a typical person of the same age; skills appear evenly delayed across all areas. (IQ score between 80 and 90, with limited variability.) Adaptive skills are less than expected for level of intelligence.",
      "2.5" = "The individual's overall cognitive skills are near the low-average range (IQ score between 80 and 90), but there is significant variability in skills. Adaptive skills are less than expected for level of intelligence.",
      "3" = "Moderately abnormal intellectual functioning. In general, the individual's overall functioning is within the normal range (IQ score between 90 and 115), but he or she shows significant variability in skills. Adaptive skills are less than expected for level of intelligence.",
      "3.5" = "The individual's overall intellectual functioning is above average (IQ score greater than 115), and he or she shows significant variability in skills. Adaptive skills are less than expected for level of intelligence.",
      "4" = "Severely abnormal intellectual functioning. Individual has a skill that is significantly and extremely better than expected for his or her level of intelligence and better than that exhibited by typical peers (savant skill). Cognitive functioning is at least near low-average intelligence (IQ score is 80 or higher). Adaptive skills are typically less than expected for level of intelligence, though in rare instances may be appropriate for cognitive level."
    )
  ),

  # --------------------------------------------------------------------------
  # Item 15: General Impressions
  # --------------------------------------------------------------------------
  item_15 = list(
    number = 15,
    name = "General Impressions",
    short_name = "general_impressions",
    domain = "Overall",
    median = 2.5,
    definition = "This is intended to be an overall rating of autism based on your subjective impression of the degree to which the individual has an ASD, as defined by the other 14 items. This rating should be made without recourse to averaging the other ratings. As with the other items, this rating should be made by taking into account all available data from such sources as the individual's case history, test results, parent and individual interviews, or past records.",
    considerations = NULL,
    scoring = list(
      "1" = "No autism spectrum disorder. The individual shows none of the symptoms characteristic of an autism spectrum disorder.",
      "2" = "Mild autism spectrum disorder. The individual shows only a few symptoms or only a mild degree of an autism spectrum disorder (mild interference with daily functioning).",
      "3" = "Moderate autism spectrum disorder. The individual shows a number of symptoms or a moderate degree of an autism spectrum disorder (moderate interference with daily functioning).",
      "4" = "Severe autism spectrum disorder. The individual shows many symptoms or an extreme degree of an autism spectrum disorder (extreme interference with daily functioning)."
    )
  )
)

# ==============================================================================
# RAW SCORE TO T-SCORE CONVERSION TABLE
# ==============================================================================

cars2_hf_tscore_percentiles <- c(
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  14,
  16,
  18,
  21,
  23,
  25,
  27,
  30,
  32,
  34,
  37,
  40,
  42,
  45,
  50,
  55,
  58,
  61,
  63,
  66,
  69,
  73,
  75,
  77,
  79,
  82,
  84,
  86,
  88,
  89,
  91,
  92,
  93,
  94,
  95,
  96,
  97,
  98,
  99
)
cars2_hf_tscore_values <- c(
  25,
  27,
  28,
  29,
  30,
  31,
  32,
  33,
  34,
  35,
  36,
  37,
  38,
  39,
  40,
  41,
  42,
  43,
  44,
  45,
  46,
  47,
  48,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  57,
  58,
  59,
  60,
  61,
  62,
  63,
  64,
  65,
  66,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  76
)
cars2_hf_raw_scores <- 15:60
cars2_hf_raw_scores <- c(
  cars2_hf_raw_scores,
  rep(
    NA,
    max(0, length(cars2_hf_tscore_percentiles) - length(cars2_hf_raw_scores))
  )
)

cars2_hf_tscore_table <- data.frame(
  percentile = cars2_hf_tscore_percentiles,
  tscore = cars2_hf_tscore_values,
  raw_score = cars2_hf_raw_scores
)

# ==============================================================================
# DOMAIN GROUPINGS
# ==============================================================================

cars2_hf_domains <- list(
  "Social Cognition" = c("item_01", "item_02", "item_03"),
  "Restricted/Repetitive Behaviors" = c("item_04", "item_05", "item_06"),
  "Sensory Response" = c("item_07", "item_08", "item_09"),
  "Emotional Response" = c("item_10"),
  "Communication" = c("item_11", "item_12"),
  "Cognitive" = c("item_13", "item_14"),
  "Overall" = c("item_15")
)

# ==============================================================================
# INFORMATION SOURCE OPTIONS
# ==============================================================================

cars2_hf_info_sources <- c(
  "Direct Observation (O)",
  "Parent Report (P)",
  "Teacher Report (T)",
  "Self-Report (S)",
  "Record Review (R)",
  "Spouse/Partner Report"
)
