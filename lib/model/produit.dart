// /lib/model/produit.dart (Version Finale)

class Produit {
  String? id;
  String? libelle;
  String? description;
  double? prix;
  String? photo;
  bool isSelected; // NOUVEAU

  // Constructeur principal
  Produit({
    this.id,
    this.libelle,
    this.description,
    this.prix,
    this.photo,
    this.isSelected = false, // Par défaut à false
  });

  // Constructeur nommé 'empty'
  Produit.empty({
    this.id = '',
    this.libelle = '',
    this.description = '',
    this.prix = 0.0,
    this.photo = '',
    this.isSelected = false,
  });
}