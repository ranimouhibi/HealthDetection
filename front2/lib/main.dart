import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ProfileScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Utilisateurs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
    '/login': (context) => const LoginScreen(),
    '/home': (context) => const HomeScreen(role: 'user'),
    '/admin_home': (context) => const HomeScreen(role: 'admin'),
    '/Profile': (context) => const ProfileScreen(),
    
    // Ajoutez d'autres routes nécessaires ici
  },
      
    );
  }
}
