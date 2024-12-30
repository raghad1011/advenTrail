import 'package:flutter/material.dart';

class CustomTextFieldsRow extends StatelessWidget {
  const CustomTextFieldsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // لضبط المسافة بين الـ TextField
      children: [
        const Padding(
      padding: EdgeInsets.only(right: 10), ),
        SizedBox(
          width: 54,
          height: 54,
          child: TextField(
            decoration: InputDecoration(
              hintStyle:const TextStyle(color: Color(0xffD1C4B9)),
              filled: true,
              fillColor:const Color(0xffD1C4B9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:const BorderSide(color: Color(0xff361C0B), width: 1.0),
              ),
            ),
          ),
        ),]);}}