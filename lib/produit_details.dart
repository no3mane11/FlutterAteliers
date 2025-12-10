// lib/produit_details.dart

import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:productapp/data/base.dart';

class ProduitDetails extends StatelessWidget {
  final Produit produit;

  const ProduitDetails({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (!kIsWeb &&
        produit.photo != null &&
        produit.photo!.isNotEmpty) {
      final file = File(produit.photo!);
      if (file.existsSync()) {
        imageProvider = FileImage(file);
      } else {
        imageProvider = const AssetImage('assets/images/produit1.jpeg');
      }
    } else {
      imageProvider = const AssetImage('assets/images/produit1.jpeg');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          produit.libelle,
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
              Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Prix : ${produit.prix.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Description : ${produit.description ?? 'Non fournie'}',
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
