import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  const ActionButtons({
    super.key,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "btn1",
          onPressed: onAdd,
          label: const Text("Add"),
          icon: const Icon(Icons.add_circle_outline),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "btn2",
          onPressed: onDelete,
          label: const Text("Delete"),
          icon: const Icon(Icons.remove_circle_outline),
          backgroundColor: Colors.redAccent,
        ),
      ],
    );
  }
}
