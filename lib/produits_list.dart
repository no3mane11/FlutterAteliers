// lib/produits_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:productapp/produit_box.dart';
import 'package:productapp/add_produit_form.dart';
import 'package:productapp/produit_details.dart';

import 'package:productapp/dao/produit_dao.dart';
import 'package:productapp/data/base.dart'; // classe Produit (Drift)

import 'favorite_button.dart';

class ProduitsList extends StatefulWidget {
  final ProduitDAO produitDAO;

  const ProduitsList({super.key, required this.produitDAO});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  bool isAdmin = false;
  bool isLoadingRole = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  // Récupération du rôle depuis Firestore
  Future<void> _loadUserRole() async {
    if (user == null) {
      setState(() {
        isAdmin = false;
        isLoadingRole = false;
      });
      return;
    }

    try {
      final doc = await db.collection('users').doc(user!.uid).get();

      if (doc.exists) {
        setState(() {
          isAdmin = (doc.data()?['isAdmin'] ?? false) as bool;
        });
      } else {
        setState(() {
          isAdmin = false;
        });
      }
    } catch (e) {
      setState(() {
        isAdmin = false;
      });
    } finally {
      setState(() {
        isLoadingRole = false;
      });
    }
  }

  // Ajouter produit (ADMIN seulement)
  void addProduit(BuildContext context) {
    if (!isAdmin) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProduitForm(
          produitDAO: widget.produitDAO,
        ),
      ),
    );
  }

  // Supprimer produit (ADMIN seulement, avec confirmation)
  Future<void> _confirmAndDeleteProduit(String docId) async {
    if (!isAdmin) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Supprimer ce produit ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Oui"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await db.collection('produits').doc(docId).delete();
    }
  }

  // Wrapper synchrone pour le paramètre VoidCallback
  void _onDeletePressed(String docId) {
    // Appelle l'async sans retourner le Future
    _confirmAndDeleteProduit(docId);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingRole) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Produits"),
      ),

      // FloatingActionButton visible UNIQUEMENT pour admin
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => addProduit(context),
              child: const Icon(Icons.add),
            )
          : null,

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

          // Mapping Firestore → Produit (Drift)
          final List<Produit> liste = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Produit(
              id: 0, // id Drift ignoré pour Firestore
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

              return Stack(
                children: [
                  ProduitBox(
                    produit: produit,
                    onChanged: null,
                    // On passe un VoidCallback synchron (wrapper) ou null si pas admin
                    delProduit:
                        isAdmin ? () => _onDeletePressed(docId) : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProduitDetails(produit: produit),
                        ),
                      );
                    },
                  ),
                  // Bouton favoris en haut à droite
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(produitDocId: docId),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
