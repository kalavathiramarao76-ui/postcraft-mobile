import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postcraft_ai/theme/app_theme.dart';
import 'package:postcraft_ai/theme/glassmorphism.dart';
import 'package:postcraft_ai/screens/generate_screen.dart';
import 'package:postcraft_ai/screens/hooks_screen.dart';
import 'package:postcraft_ai/screens/hashtags_screen.dart';
import 'package:postcraft_ai/screens/templates_screen.dart';
import 'package:postcraft_ai/screens/favorites_screen.dart';
import 'package:postcraft_ai/screens/settings_screen.dart';
import 'package:postcraft_ai/screens/tone_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const GenerateScreen(),
    const HooksScreen(),
    const TemplatesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white10
                  : Colors.black12,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_rounded),
              label: 'Generate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_rounded),
              label: 'Hooks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize_rounded),
              label: 'Templates',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PostCraft AI',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Craft posts that convert',
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritesScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_rounded),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Tool Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.1,
              children: [
                _ToolCard(
                  title: 'Generate Post',
                  subtitle: 'AI-powered posts',
                  icon: Icons.auto_awesome_rounded,
                  gradient: [AppTheme.primaryColor, AppTheme.primaryLight],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GenerateScreen()),
                  ),
                ),
                _ToolCard(
                  title: 'Hook Generator',
                  subtitle: 'Scroll-stopping openers',
                  icon: Icons.flash_on_rounded,
                  gradient: [Colors.orange, Colors.deepOrange],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HooksScreen()),
                  ),
                ),
                _ToolCard(
                  title: 'Hashtags',
                  subtitle: 'AI tag suggestions',
                  icon: Icons.tag_rounded,
                  gradient: [Colors.teal, Colors.cyan],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HashtagsScreen()),
                  ),
                ),
                _ToolCard(
                  title: 'Tone Analyzer',
                  subtitle: 'Optimize your voice',
                  icon: Icons.equalizer_rounded,
                  gradient: [Colors.purple, Colors.purpleAccent],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ToneScreen()),
                  ),
                ),
                _ToolCard(
                  title: 'Templates',
                  subtitle: '8 ready formats',
                  icon: Icons.dashboard_customize_rounded,
                  gradient: [AppTheme.accentColor, Color(0xFF0891B2)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TemplatesScreen()),
                  ),
                ),
                _ToolCard(
                  title: 'Favorites',
                  subtitle: 'Saved posts',
                  icon: Icons.favorite_rounded,
                  gradient: [Colors.redAccent, Colors.pinkAccent],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Quick tip
            GlassmorphicContainer(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lightbulb_rounded,
                      color: AppTheme.primaryLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pro Tip',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Posts between 800-1500 characters get 2x more engagement on LinkedIn.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
