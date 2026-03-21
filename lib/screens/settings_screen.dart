import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postcraft_ai/theme/app_theme.dart';
import 'package:postcraft_ai/theme/glassmorphism.dart';
import 'package:postcraft_ai/services/settings_service.dart';
import 'package:postcraft_ai/services/favorites_service.dart';
import 'package:postcraft_ai/models/post_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _endpointController;
  late TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsService>();
    _endpointController = TextEditingController(text: settings.endpoint);
    _modelController = TextEditingController(text: settings.model);
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: Consumer<SettingsService>(
        builder: (context, settings, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // API Settings
                _SectionHeader(title: 'API Configuration'),
                const SizedBox(height: 12),
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Endpoint URL',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _endpointController,
                        decoration: InputDecoration(
                          hintText: 'https://sai.sharedllm.com',
                          hintStyle: TextStyle(color: Colors.white24),
                          prefixIcon: const Icon(Icons.link, size: 20),
                        ),
                        onChanged: (value) => settings.setEndpoint(value),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Model',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _modelController,
                        decoration: InputDecoration(
                          hintText: 'gpt-4o-mini',
                          hintStyle: TextStyle(color: Colors.white24),
                          prefixIcon:
                              const Icon(Icons.smart_toy, size: 20),
                        ),
                        onChanged: (value) => settings.setModel(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Appearance
                _SectionHeader(title: 'Appearance'),
                const SizedBox(height: 12),
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(4),
                  child: SwitchListTile(
                    title: Text(
                      'Dark Mode',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      settings.isDarkMode ? 'Dark theme active' : 'Light theme active',
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                    secondary: Icon(
                      settings.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: AppTheme.primaryLight,
                    ),
                    value: settings.isDarkMode,
                    onChanged: (_) => settings.toggleDarkMode(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 28),

                // Language
                _SectionHeader(title: 'Default Language'),
                const SizedBox(height: 12),
                GlassmorphicContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: settings.language,
                      isExpanded: true,
                      dropdownColor: AppTheme.cardDark,
                      items: SupportedLanguage.all.map((lang) {
                        return DropdownMenuItem(
                          value: lang.name,
                          child: Text('${lang.flag}  ${lang.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) settings.setLanguage(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Data Management
                _SectionHeader(title: 'Data Management'),
                const SizedBox(height: 12),
                GlassmorphicContainer(
                  padding: const EdgeInsets.all(4),
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      'Clear All Data',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                    subtitle: Text(
                      'Reset settings, clear favorites',
                      style: TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear All Data?'),
                          content: const Text(
                            'This will reset all settings and delete all saved favorites. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                settings.clearData();
                                context.read<FavoritesService>().clearAll();
                                _endpointController.text = settings.endpoint;
                                _modelController.text = settings.model;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All data cleared'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // App info
                Center(
                  child: Column(
                    children: [
                      Text(
                        'PostCraft AI',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Built with Flutter & AI',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryLight,
      ),
    );
  }
}
