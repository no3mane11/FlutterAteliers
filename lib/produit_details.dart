// lib/produit_details.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:productapp/model/produit.dart'; // Assurez-vous d'avoir le bon chemin vers produit.dart

class ProduitDetails extends StatelessWidget {
  final Produit produit;

  const ProduitDetails({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    // Vérification pour l'affichage de l'image
    final bool hasPhoto = produit.photo != null && File(produit.photo!).existsSync();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          produit.libelle ?? 'Détails du Produit',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Affichage de l'image ou d'un placeholder
              Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: hasPhoto
                        ? FileImage(File(produit.photo!)) as ImageProvider<Object>
                        : const AssetImage('assets/images/produit1.jpeg'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Affichage du Prix
              Text(
                'Prix: ${produit.prix?.toStringAsFixed(2) ?? 'N/A'} €',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Affichage de la Description
              Text(
                'Description: ${produit.description ?? 'Non fournie'}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}