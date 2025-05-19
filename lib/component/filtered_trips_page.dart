import 'package:flutter/material.dart';
import '../model/trips.dart';

class FilteredTripsPage extends StatelessWidget {
  final List<TripsModel> trips;

  const FilteredTripsPage({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Trips'),
        // backgroundColor: const Color(0xff361C0B),
      ),
      body:  ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(trip.name ),
              subtitle: Text('Price: ${trip.price ?? 0} JD'),
            ),
          );
        },
      ),
    );
  }
}
