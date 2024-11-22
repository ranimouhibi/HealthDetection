import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_list_screen.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  // Fonction de déconnexion
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Supprime toutes les données sauvegardées
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            if (role == 'admin') ...[
              ListTile(
                title: const Text('Liste des utilisateurs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserListScreen()),
                  );
                },
              ),
            ] else ...[
              ListTile(
                title: const Text('Ajouter un mouton'),
                onTap: () {
                  // Navigation vers la page d'ajout de moutons
                },
              ),
              ListTile(
                title: const Text('Liste des moutons'),
                onTap: () {
                  // Navigation vers la liste des moutons
                },
              ),
            ],
            ListTile(
              title: const Text('Se déconnecter'),
              onTap: () {
                logout(context); // Appel de la fonction de déconnexion
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: role == 'admin'
            ? ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserListScreen()),
                  );
                },
                child: const Text('Liste des utilisateurs'),
              )
            : const Text('Bienvenue, utilisateur !'),
      ),
    );
  }
}
