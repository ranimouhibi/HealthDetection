import 'package:flutter/material.dart';

class SheepListScreen extends StatelessWidget {
  const SheepListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des moutons'),
      ),
      body: ListView.builder(
        itemCount: 10, // Remplacez par le nombre de moutons dans votre base de données
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.pets),
            title: Text('Mouton ${index + 1}'),
            subtitle: Text('Détails sur le mouton ${index + 1}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Action à effectuer lors de la sélection d'un mouton
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Mouton ${index + 1}'),
                  content: const Text('Plus de détails sur ce mouton.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Fermer'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter une logique pour créer un nouveau mouton
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ajouter un nouveau mouton')),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un mouton',
      ),
    );
  }
}
