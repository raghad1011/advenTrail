import 'package:flutter/material.dart';

class WeekDaysSelector extends StatelessWidget {
  final String selectedDay;
  final List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

   WeekDaysSelector({
    super.key,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekDays.map((day) {
        final bool isSelected = day == selectedDay;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.brown : Colors.brown.shade200,
            shape: BoxShape.circle,
          ),
          child: Text(
            day,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}