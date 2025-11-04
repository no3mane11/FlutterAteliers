// lib/add_produit_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path; 

// Imports pour la DB
import 'package:productapp/data/base.dart'; // Modèle Produit généré
import 'package:productapp/dao/produit_dao.dart'; // Le DAO
import 'package:drift/drift.dart' as d; // Alias pour les inserts

// CLASSE DE SAISIE SIMPLE (remplace l'ancien modèle Produit pour les données de formulaire)
class ProduitSaisie {
  String? libelle;
  String? description;
  double? prix;

  ProduitSaisie.empty() : prix = 0.0;
}

class AddProduitForm extends StatefulWidget {
  final ProduitDAO produitDAO; 

  const AddProduitForm({super.key, required this.produitDAO});

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  final _formKey = GlobalKey<FormState>();
  final _produitSaisi = ProduitSaisie.empty(); 
  
  String? _pickedImagePath; // Chemin permanent de l'image
  File? _storedImage; 

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File imageFile = File(pickedFile.path);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path); 
    final permanentPath = '${appDir.path}/$fileName';
    final File savedImage = await imageFile.copy(permanentPath);

    setState(() {
      _pickedImagePath = savedImage.path;
      _storedImage = savedImage;
    });
  }

  void _saveProduit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Création du companion (objet d'insertion Drift)
      final newEntry = ProduitsCompanion(
        libelle: d.Value(_produitSaisi.libelle!),
        description: d.Value(_produitSaisi.description),
        prix: d.Value(_produitSaisi.prix!),
        photo: d.Value(_pickedImagePath), // Le chemin permanent
      );

      await widget.produitDAO.insertProduit(newEntry);
      
      Navigator.of(context).pop();
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _pickedImagePath = null;
      _storedImage = null; 
      _produitSaisi.libelle = null;
      _produitSaisi.description = null;
      _produitSaisi.prix = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un produit')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Sélecteur d'image 
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: Theme.of(context).primaryColorLight,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: _storedImage != null
                          ? FileImage(_storedImage!) as ImageProvider<Object>
                          : const AssetImage('assets/images/produit1.jpeg'),
                    ),
                  ),
                ),
              ),

              // Champs de formulaire
              TextFormField( 
                decoration: const InputDecoration(labelText: 'Libellé'),
                validator: (value) => value == null || value.isEmpty ? 'Entrez un libellé.' : null,
                onSaved: (value) => _produitSaisi.libelle = value,
              ),
              TextFormField( 
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _produitSaisi.description = value,
              ),
              TextFormField( 
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Entrez un prix valide.' : null,
                onSaved: (value) => _produitSaisi.prix = double.parse(value!),
              ),
              
              // Boutons d'action
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.restore_from_trash_rounded),
                      label: const Text('Réinitialiser'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saveProduit,
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}