// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final String role; // Passer le rôle de l'utilisateur (admin ou user) à ce widget

  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Application'),
        actions: _buildActions(context, role), // Actions dynamiques en fonction du rôle
      ),
      body: Center(
        child: Text(role == 'admin' ? 'Page d\'accueil de l\'admin' : 'Page d\'accueil de l\'utilisateur'),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, String role) {
    if (role == 'admin') {
      return [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile'); // Accéder au profil
          },
        ),
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.pushNamed(context, '/users'); // Liste des utilisateurs
          },
        ),
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            logout(context); // Déconnexion
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile'); // Accéder au profil
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/addSheep'); // Ajouter un mouton
          },
        ),
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.pushNamed(context, '/sheepList'); // Liste des moutons
          },
        ),
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            logout(context); // Déconnexion
          },
        ),
      ];
    }
  }

  // Fonction pour gérer la déconnexion
 Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Supprimer le token d'authentification
  await prefs.remove('authToken');

  // Revenir à l'écran de connexion (login)
  Navigator.pushReplacementNamed(context, '/login');
}

}
