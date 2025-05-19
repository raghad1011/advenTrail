import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;

  const ProfileTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                filled: true,
                fillColor: Color(0xffD1C4B9),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xff361C0B)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
