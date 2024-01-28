import "package:flutter/material.dart";

class SquareButton extends StatelessWidget {
  final double? left;
  final double? right;
  final Widget icon;
  final VoidCallback onPressed;
  const SquareButton({
    required this.onPressed,
    required this.icon,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) => Positioned(
    bottom: 72, 
    left: left, 
    right: right,
    child: SizedBox(
      height: 100, 
      width: 100, 
      child: Material(
        elevation: 16,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onPressed,
          child: icon, 
        ),
      ),
    ),
  );
}

Widget rejectButton({required VoidCallback onPressed}) => SquareButton(
  left: 24,
  onPressed: onPressed, 
  icon: const Icon(Icons.close, size: 48, color: Colors.red),
);

Widget acceptButton({required VoidCallback onPressed}) => SquareButton(
  right: 24,
  onPressed: onPressed, 
  icon: const Icon(Icons.handshake, size: 48, color: Colors.green),
);
