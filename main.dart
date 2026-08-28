import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'services/storage_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init (Google/Facebook login + Cloud Storage backup)
  await Firebase.initializeApp();

  // Hive init (offline local cache for files/metadata)
  await Hive.initFlutter();
  await Hive.openBox('files_box');
  await Hive.openBox('settings_box');

  runApp(const SuperStorageApp());
}

class SuperStorageApp extends StatelessWidget {
  const SuperStorageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => StorageService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: 'Super Storage',
            debugShowCheckedModeBanner: false,
            themeMode: themeService.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(0xFF2E7D32),
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2E7D32),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            home: Consumer<AuthService>(
              builder: (context, auth, _) {
                return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
