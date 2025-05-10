import 'package:flutter/material.dart';

class buildMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? color;

  const buildMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color, this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity(vertical: -4,),
          leading: Icon(icon, color: color ?? Colors.grey[500]),
          title: Text(
            title,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        // Divider(height: 1),
      ],
    );
  }
}
