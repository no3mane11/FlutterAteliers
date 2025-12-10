// lib/login_ecran.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dao/produit_dao.dart';
import 'produits_list.dart';

class LoginEcran extends StatefulWidget {
  final ProduitDAO produitDAO;

  const LoginEcran({super.key, required this.produitDAO});

  @override
  State<LoginEcran> createState() => _LoginEcranState();
}

class _LoginEcranState extends State<LoginEcran> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInOrSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez saisir un email et un mot de passe.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Le mot de passe doit contenir au moins 6 caractères.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1) Tenter d'abord de créer le compte
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Si ça réussit, l'utilisateur est connecté automatiquement
    } on FirebaseAuthException catch (e) {
      // 2) Si l'email existe déjà, on tente la connexion
      if (e.code == 'email-already-in-use') {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e2) {
          setState(() {
            if (e2.code == 'wrong-password') {
              _errorMessage = 'Mot de passe incorrect.';
            } else {
              _errorMessage = e2.message ?? 'Erreur de connexion (${e2.code}).';
            }
          });
        }
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorMessage = 'Adresse email invalide.';
        });
      } else {
        setState(() {
          _errorMessage =
              e.message ?? 'Erreur lors de la création du compte (${e.code}).';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur inconnue : $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔹 Utilisateur NON connecté → écran de connexion
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Connexion'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Authentification Firebase',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null) ...[
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signInOrSignUp,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Se connecter / Créer un compte'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // 🔹 Utilisateur CONNECTÉ → ton app de gestion de produits
        final user = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gestion de Produits'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Se déconnecter',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info utilisateur connecté
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Connecté en tant que : ${user?.email ?? "Email inconnu"}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Divider(height: 1),
              // 🔥 ICI la correction : on utilise bien ProduitsList
              Expanded(
                child: ProduitsList(produitDAO: widget.produitDAO),
              ),
            ],
          ),
        );
      },
    );
  }
}
