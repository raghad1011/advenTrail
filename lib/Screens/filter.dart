import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/filtered_trips_page.dart';
import '../model/trips.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  List<TripsModel> allTrips = [];
  List<TripsModel> filteredTrips = [];
  List<String> selectedDuration = [];
  List<String> selectedDifficultyLevel = [];
  List<String> selectedSuitableFor = [];
  List<String> selectedBudget = [];

  final Map<String, List<String>> filterOptions = {
    'Duration': ['Under 3 hours', '3 - 6 hours', 'Over 6 hours'],
    'Difficulty Level': ['Easy', 'Moderate', 'Hard'],
    'Suitable For': ['Kids', 'Families', 'Adventurers', 'People with Disabilities'],
    'Budget': ['Under 10 JD', '10 - 20 JD', 'Over 20 JD'],
  };

  void _applyFilters() async {
    if (selectedDuration.isEmpty &&
        selectedDifficultyLevel.isEmpty &&
        selectedSuitableFor.isEmpty &&
        selectedBudget.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one filter')),
      );
      return;
    }

    final snapshot = await FirebaseFirestore.instance.collection('trips').get();
    final trips = snapshot.docs.map((doc) => TripsModel.fromJson(doc.data())).toList();

    List<TripsModel> results = trips;

    if (selectedDifficultyLevel.isNotEmpty) {
      results = results.where((trip) => selectedDifficultyLevel.contains(trip.difficulty)).toList();
    }

    if (selectedSuitableFor.isNotEmpty) {
      results = results.where((trip) => selectedSuitableFor.contains(trip.accessibility?.toLowerCase())).toList();
    }

    if (selectedBudget.isNotEmpty) {
      results = results.where((trip) {
        final price = trip.price ?? 0;
        for (var budget in selectedBudget) {
          if (budget == 'Under 10 JD' && price < 10) return true;
          if (budget == '10 - 20 JD' && price >= 10 && price <= 20) return true;
          if (budget == 'Over 20 JD' && price > 20) return true;
        }
        return false;
      }).toList();
    }

    if (results.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No trips match the selected filters.')),
      );
      return;
    }
    Get.to(() => FilteredTripsPage(trips: results), transition: Transition.fadeIn);
  }

  void _resetFilters() {
    setState(() {
      selectedDuration.clear();
      selectedDifficultyLevel.clear();
      selectedSuitableFor.clear();
      selectedBudget.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Filters',
            style: TextStyle(
              color: Color(0xff361C0B),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset', style: TextStyle(color: Color(0xff361C0B))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: filterOptions.keys.map((category) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.brown), ),
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown[900]),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: filterOptions[category]!.map((option) {
                        bool isSelected = false;
                        switch (category) {
                          case 'Duration':
                            isSelected = selectedDuration.contains(option);
                            break;
                          case 'Difficulty Level':
                            isSelected = selectedDifficultyLevel.contains(option);
                            break;
                          case 'Suitable For':
                            isSelected = selectedSuitableFor.contains(option);
                            break;
                          case 'Budget':
                            isSelected = selectedBudget.contains(option);
                            break;
                        }
                        return FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          selectedColor: Colors.brown[300],
                          backgroundColor: Colors.brown[100],
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.brown[900],
                            fontWeight: FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              switch (category) {
                                case 'Duration':
                                  selected
                                      ? selectedDuration.add(option)
                                      : selectedDuration.remove(option);
                                  break;
                                case 'Difficulty Level':
                                  selected
                                      ? selectedDifficultyLevel.add(option)
                                      : selectedDifficultyLevel.remove(option);
                                  break;
                                case 'Suitable For':
                                  selected
                                      ? selectedSuitableFor.add(option)
                                      : selectedSuitableFor.remove(option);
                                  break;
                                case 'Budget':
                                  selected
                                      ? selectedBudget.add(option)
                                      : selectedBudget.remove(option);
                                  break;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff361C0B),
            minimumSize: Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: Icon(Icons.map_outlined, color: Colors.white),
          label: Text(
            'See trails',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}