// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Supprimer le token d'authentification
  await prefs.remove('authToken');

  // Revenir à l'écran de connexion (login)
  Navigator.pushReplacementNamed(context, '/login');
}
