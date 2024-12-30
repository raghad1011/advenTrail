import 'package:flutter/material.dart';


class FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        ...options.map((option) {
          return ListTile(
            
            contentPadding: EdgeInsets.zero,
            title: Text(option,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
            trailing: Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
              activeColor: Colors.brown,
            ),
          );
        }),
      ],
    );
  }
}


