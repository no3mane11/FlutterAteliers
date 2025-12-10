// lib/favorite_button.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final String produitDocId;

  const FavoriteButton({super.key, required this.produitDocId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  bool isFav = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    if (user == null) {
      setState(() {
        isFav = false;
        _loading = false;
      });
      return;
    }

    final doc = await db
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.produitDocId)
        .get();

    setState(() {
      isFav = doc.exists;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (user == null) return;

    final favRef = db
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.produitDocId);

    if (isFav) {
      await favRef.delete();
    } else {
      await favRef.set({
        'produitId': widget.produitDocId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: Colors.pink,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
