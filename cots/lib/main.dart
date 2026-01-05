import 'package:flutter/material.dart';
import 'cots/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const CotsApp());
}

class CotsApp extends StatelessWidget {
  const CotsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kevin Jonson',
      theme: ThemeData(useMaterial3: true),
      home: const DashboardPage(),
    );
  }
}
