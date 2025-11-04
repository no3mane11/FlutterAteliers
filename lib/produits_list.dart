// lib/produits_list.dart

import 'package:flutter/material.dart';
import 'package:productapp/produit_box.dart';
import 'package:productapp/add_produit_form.dart'; 
import 'package:productapp/produit_details.dart'; 
import 'package:productapp/dao/produit_dao.dart'; // Le DAO
import 'package:productapp/data/base.dart'; // Le modèle Produit généré par Drift

class ProduitsList extends StatelessWidget {
  final ProduitDAO produitDAO;

  const ProduitsList({super.key, required this.produitDAO});

  void addProduit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProduitForm(
          produitDAO: produitDAO, 
        ),
      ),
    );
  }

  void delProduit(int id) {
    produitDAO.deleteProduitById(id);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Produits"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addProduit(context),
        child: const Icon(Icons.add),
      ),
      
      body: StreamBuilder<List<Produit>>(
        stream: produitDAO.getProduitsStream(), // Stream du DAO
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final List<Produit> liste = snapshot.data ?? [];

          if (liste.isEmpty) {
            return const Center(child: Text("Aucun produit n'est disponible."));
          }

          return ListView.builder(
            itemCount: liste.length,
            itemBuilder: (context, index) {
              final produit = liste[index]; 
              return ProduitBox(
                produit: produit, 
                onChanged: null, // isSelected retiré
                delProduit: () => delProduit(produit.id),
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