// /lib/add_produit_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productapp/model/produit.dart'; // Importez votre classe Produit

class AddProduitForm extends StatefulWidget {
  final Function(Produit) onSubmit;

  const AddProduitForm({super.key, required this.onSubmit});

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  final _formKey = GlobalKey<FormState>();
  final _produit = Produit.empty(); // Instance de produit vide
  String? _pickedImagePath;

  // Méthode pour sélectionner une image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _pickedImagePath = pickedFile.path;
    });
  }

  // Méthode pour enregistrer le produit
  void _saveProduit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Complète les champs qui ne sont pas dans le formulaire
      _produit.photo = _pickedImagePath;
      _produit.id = DateTime.now().millisecondsSinceEpoch.toString();

      widget.onSubmit(_produit);
      Navigator.of(context).pop();
    }
  }

  // Méthode pour réinitialiser le formulaire
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _pickedImagePath = null;
      // Note: Vous pourriez vouloir réinitialiser l'objet _produit ici aussi si nécessaire
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
              // Sélecteur d'image (GestureDetector)
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
                      image: _pickedImagePath != null
                          ? FileImage(File(_pickedImagePath!)) as ImageProvider<Object>
                          : const AssetImage('assets/images/placeholder.jpg'),
                    ),
                  ),
                ),
              ),

              // 1. Champ Libellé
              TextFormField(
                decoration: const InputDecoration(labelText: 'Libellé'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le libellé';
                  }
                  return null;
                },
                onSaved: (value) => _produit.libelle = value,
              ),
              // 2. Champ Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la description';
                  }
                  return null;
                },
                onSaved: (value) => _produit.description = value,
              ),
              // 3. Champ Prix
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le prix';
                  }
                  // Ajout d'une validation simple pour le format numérique
                  if (double.tryParse(value) == null) {
                     return 'Le prix doit être un nombre valide';
                  }
                  return null;
                },
                onSaved: (value) => _produit.prix = double.parse(value!),
              ),

              // Boutons d'action (Row)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Bouton Réinitialiser
                    TextButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.restore_from_trash_rounded),
                      label: const Text('Réinitialiser'),
                    ),
                    const SizedBox(width: 12),
                    // Bouton Enregistrer
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