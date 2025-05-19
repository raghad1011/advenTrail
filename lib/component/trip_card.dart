import 'package:adver_trail/model/trips.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Screens/trip_details_screen.dart';

class TripCard extends StatelessWidget {
  final TripsModel trip;

  const TripCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.off(() => TripDetailsPage(trip: trip)),
      child: Container(

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      trip.imageUrl,
                      width: double.infinity,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Text(
                        trip.tripDate != null
                            ? DateFormat('EEEE, MMMM dd, yyyy')
                                .format(trip.tripDate!.toDate())
                            : 'No date',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5,left: 5),
                child: Text(
                  trip.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 12, color: Color(0xff361C0B)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        trip.location,
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
