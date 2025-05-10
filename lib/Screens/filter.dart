import 'package:flutter/material.dart';
import '../component/filter_section.dart';


class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  String? _selectedSort;
  String? _selectedDifficulty;
  String? _selectedSuitable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
          title: const Text(
            'Filter',
            style: TextStyle(
              color: Color(0xff361C0B),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterSection(
              title: 'Sort',
              options: const ['Most popular', 'Closest', 'Newly Added'],
              selectedValue: _selectedSort,
              onChanged: (value) {
                setState(() {
                  _selectedSort = value;
                });
              },
            ),
            const Divider(),
            FilterSection(
              title: 'Difficulty',
              options: const ['Easy', 'Moderate', 'Hard'],
              selectedValue: _selectedDifficulty,
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value;
                });
              },
            ),
            const Divider(),
            FilterSection(
              title: 'Suitable',
              options: const ['Child-friendly', 'Wheelchair-friendly'],
              selectedValue: _selectedSuitable,
              onChanged: (value) {
                setState(() {
                  _selectedSuitable = value;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12),
            ),
            minimumSize: const Size(
             50,
              50,
            ),
          ),
          child: const Text(
            'See trails',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20, // تكبير حجم الخط
            ),
          ),
        ),
      ),
    );
  }
}
