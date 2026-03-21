class PostModel {
  final String id;
  final String content;
  final String style;
  final String topic;
  final String language;
  final DateTime createdAt;
  bool isFavorite;

  PostModel({
    required this.id,
    required this.content,
    required this.style,
    required this.topic,
    required this.language,
    required this.createdAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'style': style,
        'topic': topic,
        'language': language,
        'createdAt': createdAt.toIso8601String(),
        'isFavorite': isFavorite,
      };

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] ?? '',
        content: json['content'] ?? '',
        style: json['style'] ?? '',
        topic: json['topic'] ?? '',
        language: json['language'] ?? 'English',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        isFavorite: json['isFavorite'] ?? false,
      );
}

class WritingStyle {
  final String name;
  final String emoji;
  final String description;
  final String prompt;

  const WritingStyle({
    required this.name,
    required this.emoji,
    required this.description,
    required this.prompt,
  });

  static const List<WritingStyle> all = [
    WritingStyle(
      name: 'Professional',
      emoji: '\uD83D\uDCBC',
      description: 'Corporate & polished',
      prompt: 'Write in a professional, corporate tone with industry insights.',
    ),
    WritingStyle(
      name: 'Storytelling',
      emoji: '\uD83D\uDCD6',
      description: 'Narrative & engaging',
      prompt: 'Write as a compelling personal story with a clear lesson.',
    ),
    WritingStyle(
      name: 'Motivational',
      emoji: '\uD83D\uDD25',
      description: 'Inspiring & bold',
      prompt: 'Write in a motivational, high-energy tone that inspires action.',
    ),
    WritingStyle(
      name: 'Educational',
      emoji: '\uD83C\uDF93',
      description: 'Teach & inform',
      prompt: 'Write in an educational style with clear takeaways and bullet points.',
    ),
    WritingStyle(
      name: 'Conversational',
      emoji: '\uD83D\uDCAC',
      description: 'Casual & relatable',
      prompt: 'Write in a casual, conversational tone like talking to a friend.',
    ),
    WritingStyle(
      name: 'Thought Leader',
      emoji: '\uD83E\uDDE0',
      description: 'Bold & contrarian',
      prompt: 'Write as a thought leader with bold, contrarian perspectives.',
    ),
  ];
}

class PostTemplate {
  final String title;
  final String category;
  final String preview;
  final String template;
  final String icon;

  const PostTemplate({
    required this.title,
    required this.category,
    required this.preview,
    required this.template,
    required this.icon,
  });

  static const List<PostTemplate> all = [
    PostTemplate(
      title: 'Career Milestone',
      category: 'Career',
      icon: '\uD83C\uDFC6',
      preview: 'Share a professional achievement...',
      template:
          'I\'m thrilled to share that [MILESTONE].\n\nThe journey to get here wasn\'t easy:\n\n\u2022 [CHALLENGE 1]\n\u2022 [CHALLENGE 2]\n\u2022 [CHALLENGE 3]\n\nKey lessons I learned:\n\n1. [LESSON 1]\n2. [LESSON 2]\n3. [LESSON 3]\n\nTo anyone on a similar path: [ADVICE]\n\n#Career #Growth #Milestone',
    ),
    PostTemplate(
      title: 'Lessons Learned',
      category: 'Growth',
      icon: '\uD83D\uDCA1',
      preview: 'Share key learnings from experience...',
      template:
          'After [TIME PERIOD] in [INDUSTRY], here are [NUMBER] lessons I wish I knew earlier:\n\n1\uFE0F\u20E3 [LESSON 1]\n\u2192 [EXPLANATION]\n\n2\uFE0F\u20E3 [LESSON 2]\n\u2192 [EXPLANATION]\n\n3\uFE0F\u20E3 [LESSON 3]\n\u2192 [EXPLANATION]\n\nThe biggest takeaway? [SUMMARY]\n\nWhat would you add to this list?\n\n#Lessons #Professional #Growth',
    ),
    PostTemplate(
      title: 'Hot Take',
      category: 'Opinion',
      icon: '\uD83D\uDD25',
      preview: 'Share a contrarian opinion...',
      template:
          'Unpopular opinion: [BOLD STATEMENT]\n\nHere\'s why:\n\nMost people think [COMMON BELIEF].\n\nBut the reality is [YOUR PERSPECTIVE].\n\nI\'ve seen this play out when [EXAMPLE].\n\nThe result? [OUTCOME]\n\nAm I wrong? Let me know in the comments.\n\n#ThoughtLeadership #Innovation',
    ),
    PostTemplate(
      title: 'Day in the Life',
      category: 'Personal',
      icon: '\u2615',
      preview: 'Walk through your daily routine...',
      template:
          'Here\'s what a typical day looks like as a [ROLE]:\n\n6:00 AM \u2014 [MORNING ROUTINE]\n8:00 AM \u2014 [FIRST WORK BLOCK]\n10:00 AM \u2014 [MID-MORNING]\n12:00 PM \u2014 [LUNCH]\n2:00 PM \u2014 [AFTERNOON DEEP WORK]\n5:00 PM \u2014 [WIND DOWN]\n7:00 PM \u2014 [EVENING]\n\nThe secret to staying productive? [TIP]\n\n#DayInTheLife #Productivity',
    ),
    PostTemplate(
      title: 'Tool Recommendation',
      category: 'Tech',
      icon: '\uD83D\uDEE0\uFE0F',
      preview: 'Recommend a tool or resource...',
      template:
          'This [TOOL] changed how I [ACTIVITY].\n\nBefore: [OLD WAY]\nAfter: [NEW WAY]\n\nWhat makes it special:\n\n\u2705 [BENEFIT 1]\n\u2705 [BENEFIT 2]\n\u2705 [BENEFIT 3]\n\nWho should use it: [TARGET AUDIENCE]\n\nHave you tried it? What\'s your go-to tool for [ACTIVITY]?\n\n#Tools #Productivity #Tech',
    ),
    PostTemplate(
      title: 'Hiring Post',
      category: 'Recruiting',
      icon: '\uD83D\uDE80',
      preview: 'Announce a job opening...',
      template:
          '\uD83D\uDCE2 We\'re hiring! [COMPANY] is looking for a [ROLE].\n\nWhat you\'ll do:\n\u2022 [RESPONSIBILITY 1]\n\u2022 [RESPONSIBILITY 2]\n\u2022 [RESPONSIBILITY 3]\n\nWhat we offer:\n\u2728 [PERK 1]\n\u2728 [PERK 2]\n\u2728 [PERK 3]\n\nDM me or apply here: [LINK]\n\nPlease share \u2014 you might help someone find their dream job!\n\n#Hiring #Jobs #Careers',
    ),
    PostTemplate(
      title: 'Book Review',
      category: 'Learning',
      icon: '\uD83D\uDCDA',
      preview: 'Share a book recommendation...',
      template:
          'Just finished reading "[BOOK TITLE]" by [AUTHOR].\n\nRating: [X]/10\n\nTop 3 takeaways:\n\n1. [TAKEAWAY 1]\n   This matters because [WHY]\n\n2. [TAKEAWAY 2]\n   This changed how I [IMPACT]\n\n3. [TAKEAWAY 3]\n   I\'m now [ACTION]\n\nWho should read it: [AUDIENCE]\n\nWhat\'s on your reading list?\n\n#BookReview #Learning #Growth',
    ),
    PostTemplate(
      title: 'Failure Story',
      category: 'Growth',
      icon: '\uD83D\uDCAA',
      preview: 'Share a failure and recovery...',
      template:
          'My biggest professional failure:\n\n[WHAT HAPPENED]\n\nI felt [EMOTION]. But here\'s what I did next:\n\nStep 1: [RECOVERY ACTION]\nStep 2: [LEARNING]\nStep 3: [GROWTH]\n\nLooking back, this failure taught me:\n\n\u2022 [LESSON 1]\n\u2022 [LESSON 2]\n\u2022 [LESSON 3]\n\nFailure isn\'t the opposite of success \u2014 it\'s part of it.\n\n#Growth #Resilience #Lessons',
    ),
  ];
}

class SupportedLanguage {
  final String name;
  final String code;
  final String flag;

  const SupportedLanguage({
    required this.name,
    required this.code,
    required this.flag,
  });

  static const List<SupportedLanguage> all = [
    SupportedLanguage(name: 'English', code: 'en', flag: '\uD83C\uDDFA\uD83C\uDDF8'),
    SupportedLanguage(name: 'Spanish', code: 'es', flag: '\uD83C\uDDEA\uD83C\uDDF8'),
    SupportedLanguage(name: 'French', code: 'fr', flag: '\uD83C\uDDEB\uD83C\uDDF7'),
    SupportedLanguage(name: 'German', code: 'de', flag: '\uD83C\uDDE9\uD83C\uDDEA'),
    SupportedLanguage(name: 'Hindi', code: 'hi', flag: '\uD83C\uDDEE\uD83C\uDDF3'),
    SupportedLanguage(name: 'Portuguese', code: 'pt', flag: '\uD83C\uDDE7\uD83C\uDDF7'),
    SupportedLanguage(name: 'Japanese', code: 'ja', flag: '\uD83C\uDDEF\uD83C\uDDF5'),
    SupportedLanguage(name: 'Korean', code: 'ko', flag: '\uD83C\uDDF0\uD83C\uDDF7'),
    SupportedLanguage(name: 'Chinese', code: 'zh', flag: '\uD83C\uDDE8\uD83C\uDDF3'),
    SupportedLanguage(name: 'Arabic', code: 'ar', flag: '\uD83C\uDDF8\uD83C\uDDE6'),
  ];
}
