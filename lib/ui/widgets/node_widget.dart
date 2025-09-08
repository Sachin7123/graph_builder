import 'package:flutter/material.dart';

class NodeWidget extends StatefulWidget {
  final int id;
  final bool isActive;
  final bool isRemoving;
  final Offset position;
  final VoidCallback onTap;

  const NodeWidget({
    super.key,
    required this.id,
    required this.isActive,
    this.isRemoving = false,
    required this.position,
    required this.onTap,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = widget.isRemoving ? 0.0 : 1.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: widget.position.dx - 22,
      top: widget.position.dy - 22,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutBack,
          child: AnimatedOpacity(
            opacity: widget.isRemoving ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                double pulse = widget.isActive ? 1 + 0.1 * _pulseController.value : 1.0;
                return Transform.scale(
                  scale: pulse,
                  child: child,
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isActive ? Colors.orange : Colors.indigo,
                    width: widget.isActive ? 4 : 2,
                  ),
                  boxShadow: widget.isActive
                      ? [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.id.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
