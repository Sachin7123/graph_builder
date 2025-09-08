import 'package:flutter/material.dart';
import '../../models/graph_node.dart';

class NodeInfoBar extends StatelessWidget {
  final GraphNode activeNode;
  final int depth;

  const NodeInfoBar({super.key, required this.activeNode, required this.depth});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          "Active Node: ${activeNode.id} | Depth: $depth",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
