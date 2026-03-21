import 'package:flutter_test/flutter_test.dart';
import 'package:postcraft_ai/models/post_model.dart';

void main() {
  group('PostModel', () {
    test('should create PostModel from JSON', () {
      final json = {
        'id': '1',
        'content': 'Test post content',
        'style': 'Professional',
        'topic': 'Leadership',
        'language': 'English',
        'createdAt': '2024-01-01T00:00:00.000',
        'isFavorite': true,
      };

      final post = PostModel.fromJson(json);

      expect(post.id, '1');
      expect(post.content, 'Test post content');
      expect(post.style, 'Professional');
      expect(post.isFavorite, true);
    });

    test('should convert PostModel to JSON', () {
      final post = PostModel(
        id: '1',
        content: 'Test content',
        style: 'Storytelling',
        topic: 'AI',
        language: 'English',
        createdAt: DateTime(2024, 1, 1),
      );

      final json = post.toJson();

      expect(json['id'], '1');
      expect(json['style'], 'Storytelling');
      expect(json['isFavorite'], false);
    });
  });

  group('WritingStyle', () {
    test('should have 6 styles', () {
      expect(WritingStyle.all.length, 6);
    });

    test('all styles should have name and prompt', () {
      for (final style in WritingStyle.all) {
        expect(style.name.isNotEmpty, true);
        expect(style.prompt.isNotEmpty, true);
      }
    });
  });

  group('PostTemplate', () {
    test('should have 8 templates', () {
      expect(PostTemplate.all.length, 8);
    });
  });

  group('SupportedLanguage', () {
    test('should have 10 languages', () {
      expect(SupportedLanguage.all.length, 10);
    });
  });
}
