# Graph Builder - Flutter

A **Flutter-based interactive tree builder** app that allows users to create, edit, and visualize multi-level trees dynamically.

---

## **Features**

- ✅ Root node created automatically.
- ✅ Tap any node to make it **active** (highlighted).
- ✅ Add child nodes under the active node.
- ✅ Delete the active node and its subtree (root cannot be deleted).
- ✅ **Undo/Redo** operations for changes.
- ✅ Tree layout is **balanced**, children centered under parent.
- ✅ **Zoom & Pan** support using pinch and drag gestures.
- ✅ Info bar shows **active node details** (ID, depth).
- ✅ Nodes and edges rendered dynamically using `CustomPainter`.

---

## **Demo Video**

https://github.com/user-attachments/assets/3f2bfb99-155d-4df2-80df-b51bab7e5663


---

## **Getting Started**

### **Prerequisites**

- Flutter SDK installed ([Flutter installation guide](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code

### **(Main)Project Structure**
```
lib/
├─ main.dart
├─ ui/
│  ├─ home_screen.dart
│  ├─ painter/tree_painter.dart
│  └─ widgets/
│     ├─ node_widget.dart
│     ├─ node_info_bar.dart
│     └─ action_buttons.dart
├─ models/graph_node.dart
└─ state/graph_controller.dart
```

### **Usage**
1. Launch the app.
2. Tap Add to create child nodes under the active node.
3. Tap a node to make it active.
4. Tap Delete to remove active node/subtree.
5. Use Undo / Redo buttons to revert actions.
6. Pinch or Drag to zoom and drag to pan around the tree.


### **Clone the Repository**

```bash
git clone https://github.com/Sachin7123/graph_builder.git
cd graph_builder
