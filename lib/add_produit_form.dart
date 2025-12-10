// lib/add_produit_form.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

// On garde les imports pour compatibilité, même si on n'utilise plus Drift ici.
import 'package:productapp/data/base.dart';
import 'package:productapp/dao/produit_dao.dart';

// Classe de saisie simple
class ProduitSaisie {
  String? libelle;
  String? description;
  double? prix;

  ProduitSaisie.empty() : prix = 0.0;
}

class AddProduitForm extends StatefulWidget {
  final ProduitDAO produitDAO; // on garde le paramètre, mais on ne l'utilise plus

  const AddProduitForm({super.key, required this.produitDAO});

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  final _formKey = GlobalKey<FormState>();
  final _produitSaisi = ProduitSaisie.empty();

  String? _pickedImagePath;
  File? _storedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
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

  Future<void> _saveProduit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    // 👉 ICI : au lieu d'insérer dans Drift, on ajoute dans Firestore
    final db = FirebaseFirestore.instance;

    await db.collection('produits').add({
      'libelle': _produitSaisi.libelle!,
      'description': _produitSaisi.description ?? '',
      'prix': _produitSaisi.prix ?? 0.0,
      'photo': _pickedImagePath ?? '',
    });

    Navigator.of(context).pop();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).primaryColor),
                      color: Theme.of(context).primaryColorLight,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _storedImage != null
                            ? FileImage(_storedImage!)
                                as ImageProvider<Object>
                            : const AssetImage(
                                'assets/images/produit1.jpeg',
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Libellé'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Entrez un libellé.' : null,
                  onSaved: (value) => _produitSaisi.libelle = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _produitSaisi.description = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || double.tryParse(value) == null
                          ? 'Entrez un prix valide.'
                          : null,
                  onSaved: (value) =>
                      _produitSaisi.prix = double.parse(value!),
                ),
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
      ),
    );
  }
}
