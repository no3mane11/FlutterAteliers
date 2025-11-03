// lib/produits_list.dart

import 'package:flutter/material.dart';
import 'package:productapp/produit_box.dart';
import 'package:productapp/add_produit_form.dart'; // Utilisation du formulaire complet
import 'package:productapp/model/produit.dart';
import 'package:productapp/produit_details.dart'; // Import de la page de détails

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {

  // La liste doit être vide initialement, comme spécifié
  List<Produit> liste = []; 

  // ... (Fonctions onChanged, saveProduit, delProduit, delSelectedProduits, addProduit inchangées du dernier guide) ...
  
  // Fonction saveProduit mise à jour pour le produit venant du formulaire
  void saveProduit(Produit nouveauProduit) {
    setState(() {
      liste.add(nouveauProduit); 
    });
  }

  void addProduit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProduitForm(onSubmit: saveProduit), 
      ),
    );
  }
  
  void onChanged(bool? value, int index) {
    setState(() {
      liste[index].isSelected = value ?? false;
    });
  }
  
  void delProduit(int index) {
    setState(() {
      liste.removeAt(index);
    });
  }

  void delSelectedProduits() {
    setState(() {
      liste.removeWhere((produit) => produit.isSelected);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Produits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: delSelectedProduits, 
            tooltip: 'Supprimer la sélection',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduit,
        child: const Icon(Icons.add),
      ),
      body: liste.isEmpty
          ? const Center(child: Text("Aucun produit. Ajoutez-en un !")) // Message si la liste est vide
          : ListView.builder(
              itemCount: liste.length,
              itemBuilder: (context, index) {
                final produit = liste[index]; 
                return ProduitBox(
                  produit: produit, 
                  onChanged: (value) => onChanged(value, index),
                  delProduit: () => delProduit(index),
                  // Point 5 : Navigation vers la page de détails lors du tap
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
            ),
    );
  }
}