// lib/produits_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productapp/produit_box.dart';
import 'package:productapp/add_produit_form.dart';
import 'package:productapp/produit_details.dart';

import 'package:productapp/dao/produit_dao.dart'; // encore passé en param, mais plus utilisé
import 'package:productapp/data/base.dart';      // on réutilise la classe Produit (Drift) comme "model"

class ProduitsList extends StatelessWidget {
  final ProduitDAO produitDAO;

  const ProduitsList({super.key, required this.produitDAO});

  void addProduit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProduitForm(
          produitDAO: produitDAO, // param gardé pour compatibilité, mais ignoré dans le form
        ),
      ),
    );
  }

  Future<void> _deleteProduit(String docId) async {
    await FirebaseFirestore.instance
        .collection('produits')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Produits"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addProduit(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur : ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("Aucun produit n'est disponible."),
            );
          }

          // On mappe chaque document Firestore vers un objet Produit (de Drift) pour réutiliser ProduitBox/Details.
          final List<Produit> liste = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Produit(
              id: 0, // l'id Firestore est string, on ne l'utilise plus pour supprimer
              libelle: data['libelle'] ?? '',
              description: data['description'],
              prix: (data['prix'] ?? 0).toDouble(),
              photo: (data['photo'] as String?) ?? '',
            );
          }).toList();

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final produit = liste[index];
              final docId = docs[index].id;

              return ProduitBox(
                produit: produit,
                onChanged: null,
                delProduit: () => _deleteProduit(docId), // on supprime via Firestore
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProduitDetails(produit: produit),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
