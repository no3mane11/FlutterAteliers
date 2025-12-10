// lib/produit_box.dart

import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:productapp/data/base.dart'; // Modèle Produit généré par Drift

class ProduitBox extends StatelessWidget {
  final Produit produit;
  final Function(bool?)? onChanged;
  final VoidCallback? delProduit; // nullable maintenant
  final VoidCallback? onTap; // nullable pour plus de flexibilité

  const ProduitBox({
    super.key,
    required this.produit,
    this.onChanged,
    this.delProduit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // On n’utilise File/existsSync que si on N’EST PAS sur le web
    bool hasPhoto = false;
    ImageProvider imageProvider;

    if (!kIsWeb && produit.photo != null && produit.photo!.isNotEmpty) {
      final file = File(produit.photo!);
      if (file.existsSync()) {
        hasPhoto = true;
        imageProvider = FileImage(file);
      } else {
        imageProvider = const AssetImage('assets/images/produit1.jpeg');
      }
    } else {
      // Sur le web ou si pas de chemin → image par défaut
      imageProvider = const AssetImage('assets/images/produit1.jpeg');
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        // Si delProduit est null, on garde le Slidable mais sans action delete
        endActionPane: delProduit != null
            ? ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      // on appelle delProduit si il existe
                      if (delProduit != null) delProduit!();
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ],
              )
            : const ActionPane(
                motion: StretchMotion(),
                children: [], // pas d'actions
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
                Expanded(
                  child: Text(
                    produit.libelle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
