import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:postcraft_ai/app.dart';
import 'package:postcraft_ai/services/ai_service.dart';
import 'package:postcraft_ai/services/favorites_service.dart';
import 'package:postcraft_ai/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final settingsService = SettingsService();
  await settingsService.init();

  final favoritesService = FavoritesService();
  await favoritesService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsService),
        ChangeNotifierProvider.value(value: favoritesService),
        ChangeNotifierProvider(
          create: (_) => AiService(settingsService: settingsService),
        ),
      ],
      child: const PostCraftApp(),
    ),
  );
}
