import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;

  const ProfileTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xffD1C4B9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xff361C0B), width: 1),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.brown),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
