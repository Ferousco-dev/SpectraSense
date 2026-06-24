import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/scan_screen.dart';

void main() => runApp(const SpectraSenseApp());

class SpectraSenseApp extends StatelessWidget {
  const SpectraSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpectraSense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const ScanScreen(),
    );
  }
}
