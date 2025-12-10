// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/firebase_options.dart';
import 'data/base.dart';
import 'dao/produit_dao.dart';
import 'login_ecran.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialisation de ta base locale + DAO
  final database = ProduitsDatabase();
  final produitDAO = ProduitDAO(database);

  runApp(MyApp(produitDAO: produitDAO));
}

class MyApp extends StatelessWidget {
  final ProduitDAO produitDAO;

  const MyApp({super.key, required this.produitDAO});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Produits',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // On commence toujours par l’écran de login
      home: LoginEcran(produitDAO: produitDAO),
    );
  }
}
