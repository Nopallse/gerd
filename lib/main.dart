import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'pages/home_page.dart';
import 'core/services/alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AlarmService
  await AlarmService().initialize();
  
  runApp(const GerdCareApp());
}

class GerdCareApp extends StatelessWidget {
  const GerdCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GERD Care',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      // Untuk performa yang lebih baik
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
