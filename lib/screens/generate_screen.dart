import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:postcraft_ai/theme/app_theme.dart';
import 'package:postcraft_ai/theme/glassmorphism.dart';
import 'package:postcraft_ai/models/post_model.dart';
import 'package:postcraft_ai/services/ai_service.dart';
import 'package:postcraft_ai/services/favorites_service.dart';
import 'package:postcraft_ai/widgets/style_chip.dart';
import 'package:postcraft_ai/widgets/linkedin_preview_card.dart';
import 'package:postcraft_ai/widgets/character_counter.dart';
import 'package:postcraft_ai/widgets/loading_shimmer.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _topicController = TextEditingController();
  WritingStyle _selectedStyle = WritingStyle.all[0];
  SupportedLanguage _selectedLanguage = SupportedLanguage.all[0];
  String _generatedContent = '';
  bool _showPreview = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _generate() async {
    if (_topicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    final aiService = context.read<AiService>();

    final result = await aiService.generatePost(
      topic: _topicController.text.trim(),
      style: _selectedStyle,
      language: _selectedLanguage.name,
    );

    if (result.isNotEmpty) {
      setState(() {
        _generatedContent = result;
        _showPreview = false;
      });
    }
  }

  void _saveToFavorites() {
    if (_generatedContent.isEmpty) return;
    final post = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _generatedContent,
      style: _selectedStyle.name,
      topic: _topicController.text.trim(),
      language: _selectedLanguage.name,
      createdAt: DateTime.now(),
      isFavorite: true,
    );
    context.read<FavoritesService>().addFavorite(post);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to favorites!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Post', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: Consumer<AiService>(
        builder: (context, aiService, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Input
                Text(
                  'What\'s your topic?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _topicController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'e.g., Leadership lessons from building a startup...',
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                ),
                const SizedBox(height: 24),

                // Style Selection
                Text(
                  'Writing Style',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: WritingStyle.all.map((style) {
                    return StyleChipWidget(
                      style: style,
                      isSelected: _selectedStyle.name == style.name,
                      onTap: () => setState(() => _selectedStyle = style),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Language Selector
                Text(
                  'Language',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SupportedLanguage>(
                      value: _selectedLanguage,
                      isExpanded: true,
                      dropdownColor: AppTheme.cardDark,
                      items: SupportedLanguage.all.map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text('${lang.flag}  ${lang.name}'),
                        );
                      }).toList(),
                      onChanged: (lang) {
                        if (lang != null) {
                          setState(() => _selectedLanguage = lang);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Generate Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: aiService.isLoading ? null : _generate,
                    icon: aiService.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_awesome_rounded),
                    label: Text(
                      aiService.isLoading ? 'Generating...' : 'Generate Post',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                // Error
                if (aiService.error.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            aiService.error,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Loading
                if (aiService.isLoading) ...[
                  const SizedBox(height: 24),
                  GlassmorphicContainer(
                    padding: const EdgeInsets.all(20),
                    child: const LoadingShimmer(),
                  ),
                ],

                // Generated Content
                if (_generatedContent.isNotEmpty && !aiService.isLoading) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Generated Post',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() => _showPreview = !_showPreview);
                            },
                            icon: Icon(
                              _showPreview ? Icons.text_fields : Icons.preview,
                              size: 18,
                            ),
                            label: Text(
                              _showPreview ? 'Raw' : 'Preview',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CharacterCounter(count: _generatedContent.length),
                  const SizedBox(height: 12),

                  if (_showPreview)
                    LinkedInPreviewCard(content: _generatedContent)
                  else
                    GlassmorphicContainer(
                      padding: const EdgeInsets.all(16),
                      child: SelectableText(
                        _generatedContent,
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ),

                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _generatedContent),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied!')),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copy'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saveToFavorites,
                          icon: const Icon(Icons.favorite, size: 18),
                          label: const Text('Save'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Share.share(_generatedContent);
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
