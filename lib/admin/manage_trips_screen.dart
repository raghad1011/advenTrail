
import 'package:adver_trail/model/trips.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageTripsScreen extends StatefulWidget {
  @override
  _ManageTripsScreenState createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _navigateToAddEditTrip(context, null); // Null for adding new
              },
              child: Text('Add New Trip'),
            ),
          ),
          Expanded(
            child: TripList(firebaseService: _firebaseService),
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditTrip(BuildContext context, TripsModel? trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTripScreen(
          firebaseService: _firebaseService,
          trip: trip,
        ),
      ),
    ).then((value) {
      // Refresh the trip list after adding/editing
      setState(() {});
    });
  }
}

class TripList extends StatelessWidget {
  final FirebaseService firebaseService;

  const TripList({Key? key, required this.firebaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripsModel>>(
      future: firebaseService.getAllTrips().then((snapshot) =>
          snapshot.docs.map((doc) => doc.data()!).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading trips: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No trips available.'));
        }

        final trips = snapshot.data!;
        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return ListTile(
              title: Text(trip.name),
              subtitle: Text('${trip.location} - ${trip.difficulty}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditTripScreen(
                            firebaseService: firebaseService,
                            trip: trip,
                          ),
                        ),
                      ).then((value) {
                        // Manually trigger a rebuild of the parent AdminScreen
                        // to refresh the TripList
                        if (context.findAncestorStateOfType<_ManageTripsScreenState>() != null) {
                          context.findAncestorStateOfType<_ManageTripsScreenState>()!.setState(() {});
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, trip.id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String tripId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this trip?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await firebaseService.deleteTrip(tripId);
                // Manually trigger a rebuild of the parent AdminScreen
                if (context.findAncestorStateOfType<_ManageTripsScreenState>() != null) {
                  context.findAncestorStateOfType<_ManageTripsScreenState>()!.setState(() {});
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddEditTripScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  final TripsModel? trip;

  const AddEditTripScreen({Key? key, required this.firebaseService, this.trip})
      : super(key: key);

  @override
  _AddEditTripScreenState createState() => _AddEditTripScreenState();
}

class _AddEditTripScreenState extends State<AddEditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  // For GeoPoint, you'd likely have more complex UI (e.g., map input)
  // For simplicity, we'll use text fields for latitude and longitude
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _difficultyController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _nameController.text = widget.trip!.name;
      _priceController.text = widget.trip!.price?.toString() ?? '';
      _descriptionController.text = widget.trip!.description;
      _locationController.text = widget.trip!.location;
      _latitudeController.text = widget.trip!.trailRoute.latitude.toString();
      _longitudeController.text = widget.trip!.trailRoute.longitude.toString();
      _difficultyController.text = widget.trip!.difficulty;
      _durationController.text = widget.trip!.duration;
      _statusController.text = widget.trip!.status ?? '';
      _isDeleted = widget.trip!.isDeleted ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip == null ? 'Add New Trip' : 'Edit Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the trip name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Price (optional)', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the description' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the location' : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Latitude', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter latitude';
                        if (double.tryParse(value) == null) return 'Invalid latitude';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Longitude', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter longitude';
                        if (double.tryParse(value) == null) return 'Invalid longitude';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _difficultyController,
                decoration: InputDecoration(labelText: 'Difficulty', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the difficulty' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the duration' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status (optional)', border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    value: _isDeleted,
                    onChanged: (value) {
                      setState(() {
                        _isDeleted = value!;
                      });
                    },
                  ),
                  Text('Is Deleted'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final double? price = double.tryParse(_priceController.text);
                    final double latitude = double.parse(_latitudeController.text);
                    final double longitude = double.parse(_longitudeController.text);
                    final GeoPoint trailRoute = GeoPoint(latitude, longitude);

                    final newTrip = TripsModel(
                      id: widget.trip?.id ?? '', // Keep the existing ID for edit
                      name: _nameController.text,
                      price: price,
                      description: _descriptionController.text,
                      location: _locationController.text,
                      trailRoute: trailRoute,
                      difficulty: _difficultyController.text,
                      duration: _durationController.text,
                      status: _statusController.text.isNotEmpty ? _statusController.text : null,
                      isDeleted: _isDeleted,
                    );

                    if (widget.trip == null) {
                      await FirebaseService.addTrip(newTrip);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Trip added successfully!')),
                      );
                    } else {
                      await widget.firebaseService.updateTrip(newTrip.id, newTrip.toJson());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Trip updated successfully!')),
                      );
                    }
                    Navigator.of(context).pop(); // Go back to the admin screen
                  }
                },
                child: Text(widget.trip == null ? 'Add Trip' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}