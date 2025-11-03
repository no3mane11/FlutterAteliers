import 'package:flutter/material.dart';
import 'package:productapp/produit_box.dart';
import 'package:productapp/add_produit.dart';

class ProduitsList extends StatefulWidget {
  ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  final TextEditingController nomController = TextEditingController();

  // La structure de données pour stocker le nom du produit et son état de sélection (bool)
  List liste = [
    ["1 Produit", false],
    ["2 Produit", true],
    ["3 Produit", false],
    ["4 Produit", false],
    ["5 Produit", false],
  ];

  // 1. Fonction pour la SELECTION (onChanged du Checkbox)
  void onChanged(bool? value, int index) {
    setState(() {
      liste[index][1] = value ?? false;
    });
  }

  // 2. Fonction pour AJOUTER un produit (Correction de la logique)
  void saveProduit() {
    setState(() {
      // ✅ CORRECTION : Ajoute le texte de l'utilisateur ET l'état de sélection par défaut (false)
      liste.add([nomController.text, false]); 
      nomController.clear();
      Navigator.of(context).pop();
    });
  }

  void addProduit() {
    showDialog(
      context: context,
      builder: (context) {
        return AddProduit(
          nomController: nomController,
          onAdd: saveProduit,
          onCancel: () {
            nomController.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // 3. Fonction pour SUPPRIMER UN SEUL produit (via Slidable)
  void delProduit(int index) {
    setState(() {
      liste.removeAt(index);
    });
  }

  // 4. Fonction pour SUPPRIMER LA SELECTION de produits (Nouvelle fonctionnalité)
  void delSelectedProduits() {
    setState(() {
      // ✅ NOUVEAU : Filtre la liste pour garder uniquement les produits NON sélectionnés
      liste.removeWhere((produit) => produit[1] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Produits"),
        // ✅ NOUVEAU : Bouton dans l'AppBar pour la suppression en lot
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: delSelectedProduits, // Appelle la nouvelle fonction
            tooltip: 'Supprimer la sélection',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduit,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: liste.length,
        itemBuilder: (context, index) {
          // Utilisation de la liste des produits pour afficher l'UI
          return ProduitBox(
            nomProduit: liste[index][0],
            selProduit: liste[index][1],
            onChanged: (value) => onChanged(value, index),
            delProduit: () => delProduit(index),
          );
        },
      ),
    );
  }
}