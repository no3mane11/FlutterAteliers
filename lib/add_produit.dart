import 'package:flutter/material.dart';

class AddProduit extends StatelessWidget {
  final TextEditingController nomController;
  final void Function()? onAdd;
  final void Function()? onCancel;
  
  const AddProduit({
    super.key,
    required this.nomController,
    required this.onAdd,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un produit"),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            TextField(
              controller: nomController,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                MaterialButton(
                  onPressed: onAdd,
                  child: const Text("Add"),
                ),
                MaterialButton(
                  onPressed: onCancel,
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}