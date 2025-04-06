import 'package:adver_trail/component/custom_text_field.dart';
import 'package:adver_trail/model/trips.dart';
import 'package:adver_trail/network/firebase.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:adver_trail/network/reference_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ManageTripsScreen extends StatefulWidget {
  const ManageTripsScreen({super.key});

  @override
  State<ManageTripsScreen> createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  final FirebaseService firebaseService = FirebaseService();
  // late Future<QuerySnapshot> tripsFuture = firebaseService.getAllTrips();

  Future<QuerySnapshot>? tripsFuture;

  @override
  void initState() {
    super.initState();
    tripsFuture = firebaseService.getAllTrips();
  }

  final tripNameController = TextEditingController();
  final priceController = TextEditingController();

  void _addEditTrip(BuildContext context, String tripId, TripsModel model) {
    if (model.id.isNotEmpty) {
      tripNameController.text = model.tripName!;
      priceController.text = model.price.toString();
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(model.id.isEmpty ? "Add Trip" : "Edit Trip", style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Text("Trip Name")),
                      Expanded(
                        child: CustomTextField(
                          controller: tripNameController,
                          icon: Icons.directions,
                          hintText: 'Enter Trip Name',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Text("Price")),
                      Expanded(
                        child: CustomTextField(
                          controller: priceController,
                          icon: Icons.attach_money,
                          hintText: 'Enter Price',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      model.tripName = tripNameController.text;
                      model.price = double.tryParse(priceController.text);
                      var success = await ReferenceFirebase.addEditTrips(model);
                      Navigator.pop(context);
                    },
                    child: Text(model.id.isEmpty ? "Add" : "Edit", style: TextStyle(color: Colors.brown)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void addTrip() {
    tripNameController.clear();
    priceController.clear();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add New Trip", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              CustomTextField(
                controller: tripNameController,
                icon: Icons.directions,
                hintText: 'Enter Trip Name',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: priceController,
                icon: Icons.attach_money,
                hintText: 'Enter Price',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> newTripData = {
                    'tripName': tripNameController.text,
                    'price': double.tryParse(priceController.text) ?? 0,
                  };

                  await FirebaseService.addTrip(newTripData as TripsModel);

                  setState(() {
                    tripsFuture = firebaseService.getAllTrips();
                  });

                  Navigator.pop(context);
                },
                child: Text("Add", style: TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        );
      },
    );
  }

  void tripInfo(BuildContext context, Map<String, dynamic> tripData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Trip Name: ${tripData['tripName']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Price: ${tripData['price']}', style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      },
    );
  }

  void deleteTrip(String tripId) async {
    await firebaseService.deleteTrip(tripId);
    setState(() {
      tripsFuture = firebaseService.getAllTrips();
    });
  }

  void updateTrip(String tripId) async {
    Map<String, dynamic> updatedTripData = {
      'tripName': tripNameController.text,
      'price': double.tryParse(priceController.text) ?? 0,
    };

    await firebaseService.updateTrip(tripId, updatedTripData);
    setState(() {
      tripsFuture = firebaseService.getAllTrips();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Trips"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addTrip,
            // _addEditTrip(context, trip.id, trip as TripsModel),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: tripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No trips found.'));
          }

          var trips = snapshot.data!.docs;
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];
              // var tripData = trip.data() as Map<String, dynamic>;

              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => tripInfo(context, trip.data() as Map<String, dynamic>),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.info_outline,
                      label: 'Info',
                    ),
                    SlidableAction(
                      onPressed: (context) => _addEditTrip(context, trip.id, trip as TripsModel),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) => deleteTrip(trip.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    trip['tripName'],
                    style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Price: \$${trip['price']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}