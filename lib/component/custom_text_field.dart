import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        validator: widget.validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          prefixIcon: Icon(
            widget.icon,
            color: const Color(0xff122424),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xff122424),
            ),
            onPressed: _toggleVisibility,
          )
              : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xffD1C4B9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.brown,
              width: 1.5,
            ),
          ),

        ),

      ),
    );
  }
}