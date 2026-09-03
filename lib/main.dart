import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/initial_setup_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cal',
      theme: AppTheme.lightTheme,
      home: const InitialSetupScreen(),
    );
  }
}
