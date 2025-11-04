// lib/produit_box.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:productapp/data/base.dart'; // Importe la classe Produit générée

class ProduitBox extends StatelessWidget {
  final Produit produit;
  final Function(bool?)? onChanged; // Maintenu, mais ignoré/null dans la liste
  final VoidCallback delProduit;
  final VoidCallback onTap; 

  const ProduitBox({
    super.key,
    required this.produit,
    this.onChanged,
    required this.delProduit,
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = produit.photo != null && File(produit.photo!).existsSync();
    final imageProvider = hasPhoto
        ? FileImage(File(produit.photo!)) as ImageProvider<Object>
        : const AssetImage('assets/images/produit1.jpeg');

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
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
        
        child: InkWell( 
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 80, 
            child: Row(
              children: [
                // 🛑 CHECKBOX RETIRÉE car isSelected n'existe plus dans le modèle Drift
                // Si la sélection est nécessaire, une logique d'état local doit être implémentée.

                // Affichage de la photo
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
                
                // Affichage du libellé
                Expanded(
                  child: Text(
                    produit.libelle, 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Flèche pour l'action
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