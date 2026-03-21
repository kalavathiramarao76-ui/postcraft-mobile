import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postcraft_ai/services/settings_service.dart';
import 'package:postcraft_ai/models/post_model.dart';

class AiService extends ChangeNotifier {
  final SettingsService settingsService;

  bool _isLoading = false;
  String _streamedContent = '';
  String _error = '';

  bool get isLoading => _isLoading;
  String get streamedContent => _streamedContent;
  String get error => _error;

  AiService({required this.settingsService});

  String get _baseUrl => settingsService.endpoint;
  String get _model => settingsService.model;

  Future<String> generatePost({
    required String topic,
    required WritingStyle style,
    required String language,
  }) async {
    _isLoading = true;
    _streamedContent = '';
    _error = '';
    notifyListeners();

    try {
      final prompt = '''You are a LinkedIn post expert. Write a compelling LinkedIn post about: "$topic"

Style: ${style.prompt}
Language: $language

Requirements:
- Keep it between 800-1500 characters for optimal LinkedIn engagement
- Use line breaks for readability
- Include relevant emojis sparingly
- End with a call-to-action question
- Add 3-5 relevant hashtags at the end
- Do NOT use markdown formatting
- Write ONLY the post content, no explanations''';

      final response = await _makeRequest(prompt);
      _streamedContent = response;
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return '';
    }
  }

  Future<List<String>> generateHooks({required String topic}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final prompt = '''Generate exactly 10 powerful LinkedIn post hooks/opening lines about: "$topic"

Requirements:
- Each hook should be on its own line
- Number them 1-10
- Make them attention-grabbing, scroll-stopping
- Mix different hook styles: questions, bold statements, statistics, stories
- Keep each hook to 1-2 sentences max
- Do NOT use markdown formatting''';

      final response = await _makeRequest(prompt);
      final hooks = response
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.replaceFirst(RegExp(r'^\d+[\.\)]\s*'), '').trim())
          .where((line) => line.isNotEmpty)
          .toList();

      _isLoading = false;
      notifyListeners();
      return hooks;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<List<String>> generateHashtags({required String postContent}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final prompt = '''Analyze this LinkedIn post and suggest 15 relevant hashtags. Mix popular and niche hashtags for maximum reach.

Post:
"$postContent"

Requirements:
- Return ONLY hashtags, one per line
- Include the # symbol
- Mix popular (high reach) and niche (targeted) hashtags
- Order from most to least relevant
- No explanations, just hashtags''';

      final response = await _makeRequest(prompt);
      final hashtags = response
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.startsWith('#') && line.length > 1)
          .toList();

      _isLoading = false;
      notifyListeners();
      return hashtags;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<String> analyzeAndSuggestTone({required String postContent}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final prompt = '''Analyze the tone of this LinkedIn post and provide suggestions:

Post:
"$postContent"

Provide:
1. Current tone analysis (2-3 words)
2. Engagement score (1-10)
3. 3 specific suggestions to improve engagement
4. A rewritten version with improved tone

Format clearly with sections. No markdown.''';

      final response = await _makeRequest(prompt);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return '';
    }
  }

  Future<String> _makeRequest(String prompt) async {
    final url = Uri.parse('$_baseUrl/v1/chat/completions');

    final body = jsonEncode({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': 'You are a LinkedIn content expert.'},
        {'role': 'user', 'content': prompt},
      ],
      'temperature': 0.8,
      'max_tokens': 2000,
    });

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void clearContent() {
    _streamedContent = '';
    notifyListeners();
  }
}
