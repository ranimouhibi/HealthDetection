import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Vérification du token au démarrage de l'application
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(role: prefs.getString('userRole') ?? 'user')),
      );
    }
  }

  @override
  void dispose() {
    // Nettoyer les contrôleurs pour éviter les fuites de mémoire
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fonction pour enregistrer le token et le rôle dans SharedPreferences
  Future<void> _saveToken(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userRole', role);
  }

  // Fonction de validation des champs
  bool _validateFields(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return false;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
      });
      return false;
    }

    return true;
  }

  // Fonction pour valider une adresse email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Fonction de connexion
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Réinitialiser le message d'erreur
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Valider les champs
    if (!_validateFields(email, password)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await ApiService.login(email, password);

      if (response['token'] != null) {
        // Sauvegarder le token et le rôle
        await _saveToken(response['token'], response['role']);

        // Naviguer vers l'écran d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(role: response['role']),
          ),
        );
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Invalid credentials.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: ${error.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Champ de texte pour l'email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _errorMessage == 'Please enter a valid email address.'
                    ? _errorMessage
                    : null,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            // Champ de texte pour le mot de passe
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorMessage == 'All fields are required.'
                        ? _errorMessage
                        : null,
              ),
              onChanged: (value) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            // Bouton de connexion
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
            const SizedBox(height: 10),
            // Affichage des erreurs
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
