import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: onPressed,
    );
  }
}
