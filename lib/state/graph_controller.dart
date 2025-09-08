import 'package:flutter/material.dart';
import '../models/graph_node.dart';

class GraphController {
  late GraphNode root;
  late int nextId;
  late GraphNode activeNode;

  final List<GraphNode> _undoStack = [];
  final List<GraphNode> _redoStack = [];

  GraphController() {
    resetTree();
  }

  void _saveState() {
    _undoStack.add(root.clone());
    _redoStack.clear();
  }

  void addChild() {
    _saveState();
    if (getDepth(activeNode) >= 100) {
      throw Exception("Max depth 100 reached!");
    }

    final newNode = GraphNode(nextId++);
    activeNode.addChild(newNode);
  }

  void deleteActive() {
    if (activeNode == root) {
      throw Exception("Cannot delete root node.");
    }
    _saveState();
    final parent = root.findParent(activeNode.id);
    parent?.children.removeWhere((c) => c.id == activeNode.id);
    activeNode = parent ?? root;
  }

  void setActive(GraphNode node) {
    activeNode = node;
  }

  void resetTree() {
    root = GraphNode(1);
    activeNode = root;
    nextId = 2;
    _undoStack.clear();
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(root.clone());
    root = _undoStack.removeLast();
    activeNode = root;
    nextId = root.maxId() + 1;
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(root.clone());
    root = _redoStack.removeLast();
    activeNode = root;
    nextId = root.maxId() + 1;
  }

  int getDepth(GraphNode node, [GraphNode? current, int depth = 0]) {
    current ??= root;
    if (current == node) return depth;
    for (var child in current.children) {
      final d = getDepth(node, child, depth + 1);
      if (d != -1) return d;
    }
    return -1;
  }
}

// --- Stable recursive layout ---
extension GraphLayout on GraphController {
  Map<int, Offset> computeLayout(Size size) {
    final positions = <int, Offset>{};
    const xGap = 60.0;
    const yGap = 100.0;
    const nodeRadius = 20.0;

    double _layout(GraphNode node, double x, double y) {
      if (node.children.isEmpty) {
        positions[node.id] = Offset(x, y);
        return x;
      }

      double childX = x;
      for (var child in node.children) {
        childX = _layout(child, childX, y + yGap) + xGap;
      }

      final firstChild = node.children.first.id;
      final lastChild = node.children.last.id;
      final centerX =
          (positions[firstChild]!.dx + positions[lastChild]!.dx) / 2;
      positions[node.id] = Offset(centerX, y);

      return childX - xGap;
    }

    _layout(root, size.width / 2, nodeRadius + 20);

    // --- Center tree once ---
    double minX = positions.values.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    double maxX = positions.values.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    double offsetX = (size.width / 2) - ((minX + maxX) / 2);

    positions.updateAll((key, pos) => Offset(pos.dx + offsetX, pos.dy));


    return positions;
  }
}
