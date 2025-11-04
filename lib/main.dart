// lib/main.dart (Version Corrigée)

import 'package:flutter/material.dart';
import 'package:productapp/data/base.dart'; // La base de données
import 'package:productapp/dao/produit_dao.dart'; // Le DAO
import 'package:productapp/produits_list.dart';

void main() {
  // Garantit que les widgets binding sont initialisés avant d'ouvrir la DB
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de la base de données
  final database = ProduitsDatabase(); 
  
  // Initialisation du DAO
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Passe le DAO à la liste des produits
      home: ProduitsList(produitDAO: produitDAO),
    );
  }
}