import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // for MatrixUtils.transformPoint
import '../state/graph_controller.dart';
import 'painter/tree_painter.dart';
import 'widgets/node_info_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late GraphController controller;
  late TransformationController _transformController;
  late AnimationController _animController;
  late Animation<Matrix4> _anim;

  double _scale = 1.0;
  static const double _nodeRadius = 22.0;

  @override
  void initState() {
    super.initState();
    controller = GraphController();
    _transformController = TransformationController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _transformController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Graph Builder"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Info bar (simple)
          NodeInfoBar(
            activeNode: controller.activeNode,
            depth: controller.getDepth(controller.activeNode),
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize = constraints.biggest;
                final positions = controller.computeLayout(canvasSize);

                return InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 0.5,
                  maxScale: 3.0,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  onInteractionUpdate: (_) {
                    setState(() {
                      _scale = _transformController.value.getMaxScaleOnAxis();
                    });
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      // Convert the pointer position (in screen widget coordinates)
                      // into the scene coordinates used by CustomPaint by applying
                      // the inverse of the transformation matrix.
                      final matrix = _transformController.value;
                      final inverse = Matrix4.copy(matrix)..invert();
                      final sceneTap = MatrixUtils.transformPoint(inverse, details.localPosition);

                      // Hit-test against node centers in scene coords
                      for (final entry in positions.entries) {
                        final id = entry.key;
                        final pos = entry.value;
                        if ((pos - sceneTap).distance <= _nodeRadius) {
                          final node = controller.root.findById(id);
                          if (node != null) {
                            setState(() => controller.setActive(node));
                          }
                          break;
                        }
                      }
                    },
                    child: CustomPaint(
                      size: canvasSize,
                      painter: TreePainter(
                        root: controller.root,
                        positions: positions,
                        activeId: controller.activeNode.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            onPressed: () {
              setState(() {
                const zoomFactor = 1.2;
                _scale = (_scale * zoomFactor).clamp(0.5, 3.0);
                final zoomMatrix = Matrix4.identity()..scale(zoomFactor);
                _transformController.value =
                    _transformController.value.multiplied(zoomMatrix);
              });
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "zoomOut",
            onPressed: () {
              setState(() {
                const zoomFactor = 1 / 1.2;
                _scale = (_scale * zoomFactor).clamp(0.5, 3.0);
                final zoomMatrix = Matrix4.identity()..scale(zoomFactor);
                _transformController.value =
                    _transformController.value.multiplied(zoomMatrix);
              });
            },
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "resetView",
            onPressed: () {
              final begin = _transformController.value;
              final end = Matrix4.identity();

              _anim = Matrix4Tween(begin: begin, end: end).animate(
                CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
              );

              _animController.addListener(() {
                _transformController.value = _anim.value;
              });

              _animController.forward(from: 0);
              _scale = 1.0;
            },
            child: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {
                try {
                  setState(() => controller.addChild());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Node"),
                    content: const Text("Are you sure you want to delete this node?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    setState(() => controller.deleteActive());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),


            IconButton(
              icon: const Icon(Icons.undo, color: Colors.orange),
              onPressed: () => setState(() => controller.undo()),
            ),
            IconButton(
              icon: const Icon(Icons.redo, color: Colors.blue),
              onPressed: () => setState(() => controller.redo()),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.purple),
              onPressed: () => setState(() => controller.resetTree()),
            ),
          ],
        ),
      ),
    );
  }
}
