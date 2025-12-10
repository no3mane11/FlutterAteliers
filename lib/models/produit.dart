import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  final String id;
  final String libelle;
  final String description;
  final double prix;
  final String photo;

  Produit({
    required this.id,
    required this.libelle,
    required this.description,
    required this.prix,
    required this.photo,
  });

  /// ✅ fromFirestore (obligatoire dans ton TP)
  factory Produit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Produit(
      id: doc.id,
      libelle: data['libelle'] ?? '',
      description: data['description'] ?? '',
      prix: (data['prix'] ?? 0).toDouble(),
      photo: data['photo'] ?? '',
    );
  }

  /// ✅ toJson (pour ajout/suppression)
  Map<String, dynamic> toJson() {
    return {
      'libelle': libelle,
      'description': description,
      'prix': prix,
      'photo': photo,
    };
  }
}
