import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProduitBox extends StatelessWidget {
  final String nomProduit;
  final bool selProduit;
  final Function(bool?)? onChanged;
  final VoidCallback delProduit;

  const ProduitBox({
    super.key,
    required this.nomProduit,
    this.selProduit = false,
    this.onChanged,
    required this.delProduit,
  });

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(45),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(45),
          ),
          height: 120,
          child: Row(
            children: [
              Checkbox(value: selProduit, onChanged: onChanged),
              Text(nomProduit),
            ],
          ),
        ),
      ),
    );
  }
}