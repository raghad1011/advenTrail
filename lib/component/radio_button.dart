import 'package:flutter/material.dart';

enum SingingCharacter { name1, name2,name3 }

class RadioExample extends StatefulWidget {
  // Accept names and title as parameters
  final String title;
  final String name1;
  final String name2;
  final String name3;

  const RadioExample({
    super.key,
    required this.title,
    required this.name1,
    required this.name2,
    required this.name3,

  });

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  SingingCharacter? _character = SingingCharacter.name1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.title,
          style:const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),
        ListTile(
          title: Text(widget.name1), 
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.name1,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(widget.name2), // Use the dynamic name for the second character
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.name2,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
       ListTile(
          title: Text(widget.name3), // Use the dynamic name for the second character
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.name3,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        const Divider(
          color: Colors.black, // Color of the line
          thickness: 1, // Thickness of the line
          height: 20, // Space before and after the line
        ),
      ],
    );
  }
}
