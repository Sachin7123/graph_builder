class GraphNode {
  int id;
  List<GraphNode> children;

  GraphNode(this.id) : children = [];

  void addChild(GraphNode child) {
    children.add(child);
  }

  GraphNode? findById(int searchId) {
    if (id == searchId) return this;
    for (var child in children) {
      final result = child.findById(searchId);
      if (result != null) return result;
    }
    return null;
  }

  GraphNode? findParent(int childId) {
    for (var child in children) {
      if (child.id == childId) return this;
      final result = child.findParent(childId);
      if (result != null) return result;
    }
    return null;
  }

  // --- Clone the whole subtree ---
  GraphNode clone() {
    final newNode = GraphNode(id);
    for (var child in children) {
      newNode.addChild(child.clone());
    }
    return newNode;
  }

  // --- Get maximum ID in the subtree ---
  int maxId() {
    int maxVal = id;
    for (var child in children) {
      final cMax = child.maxId();
      if (cMax > maxVal) maxVal = cMax;
    }
    return maxVal;
  }
}
