import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StarSyncGoApp());
}

class StarSyncGoApp extends StatelessWidget {
  const StarSyncGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarSync-GO',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFD32F2F),
        ),
        textTheme: ThemeData.dark().textTheme,
      ),
      home: const SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 