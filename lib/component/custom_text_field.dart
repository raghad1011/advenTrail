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
      width: 390, // العرض المطلوب
      height: 50, // الارتفاع المطلوب
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: const Color(0xff122424),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
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
            borderRadius: BorderRadius.circular(12.0),
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











// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final IconData icon;
//   final String hintText;
//   final bool obscureText;
//   final IconData? suffixIcon;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;
//
//   const CustomTextField({
//     super.key,
//     required this.icon,
//     required this.hintText,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.controller,
//     this.validator,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 390, // العرض المطلوب
//       height: 50, // الارتفاع المطلوب
//       child: TextField(
//         obscureText: obscureText,
//         controller: controller,
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             icon,
//             color: const Color(0xff122424),
//           ),
//           suffixIcon: suffixIcon != null
//               ? Icon(
//                   suffixIcon,
//                   color: const Color(0xff122424),
//                 )
//               : null,
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.grey),
//           filled: true,
//           fillColor: const Color(0xffD1C4B9),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: const BorderSide(
//               color: Colors.brown,
//               width: 1.5,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }