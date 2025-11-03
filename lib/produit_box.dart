// lib/produit_box.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:productapp/model/produit.dart'; // Import de la classe Produit

class ProduitBox extends StatelessWidget {
  final Produit produit;
  final Function(bool?)? onChanged;
  final VoidCallback delProduit;
  final VoidCallback onTap; // Ajout de la fonction onTap

  const ProduitBox({
    super.key,
    required this.produit,
    this.onChanged,
    required this.delProduit,
    required this.onTap, // Requis
  });

  @override
  Widget build(BuildContext context) {
    // Détermine l'ImageProvider (fichier ou placeholder)
    final bool hasPhoto = produit.photo != null && File(produit.photo!).existsSync();
    final imageProvider = hasPhoto
        ? FileImage(File(produit.photo!)) as ImageProvider<Object>
        : const AssetImage('assets/images/produit1.jpeg');

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        // ... ActionPane pour la suppression (Glissement)
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => delProduit(),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(15), 
            ),
          ],
        ),
        
        // Contenu principal du produit (gestion du tap)
        child: InkWell( // Remplacé Container par InkWell pour l'effet de tap
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 80, // Hauteur ajustée
            child: Row(
              children: [
                // Checkbox pour la sélection
                Checkbox(value: produit.isSelected, onChanged: onChanged),

                // Affichage de la photo (Point 4)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  ),
                ),
                
                // Affichage du libellé (Point 4)
                Expanded(
                  child: Text(
                    produit.libelle ?? 'Sans Libellé',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // (Optionnel) Ajout d'une flèche pour indiquer l'action
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}