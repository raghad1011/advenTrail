import 'dart:io';
import 'package:adver_trail/model/trips.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;
import 'package:intl/intl.dart';

class ManageTripsScreen extends StatefulWidget {
  const ManageTripsScreen({super.key});

  @override
  _ManageTripsScreenState createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Manage Trips'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _navigateToAddEditTrip(context, null);
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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

  void tripInfo(BuildContext context, Map<String, dynamic> tripData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  tripData['name'] ?? '',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              if (tripData['imageUrl'] != null && tripData['imageUrl'] != '')
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      tripData['imageUrl'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 16),
              _infoRow('Category', tripData['category']),
              _infoRow('Price', tripData['price']?.toString() ?? 'N/A'),
              _infoRow('Location', tripData['location']),
              _infoRow('Latitude', tripData['trailRoute']?.latitude?.toString() ?? ''),
              _infoRow('Longitude', tripData['trailRoute']?.longitude?.toString() ?? ''),
              _infoRow('Difficulty', tripData['difficulty']),
              _infoRow('Accessibility', tripData['accessbility']),
              _infoRow('Distance', tripData['distance']),
              _infoRow('Duration', tripData['duration']),
              _infoRow('maxGuests', tripData['maxGuests'].toString()),
              _infoRow('Trip Date', _formatTimestamp(tripData['tripDate'])),
              _infoRow('Status', tripData['status'] ?? 'N/A'),
              SizedBox(height: 10),
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(tripData['description'] ?? 'No description available.'),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String? _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final DateTime dateTime = timestamp.toDate();
      return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
    }
    return null;
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value ?? '', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripsModel>>(
      future: firebaseService
          .getAllTrips()
          .then((snapshot) => snapshot.docs.map((doc) => doc.data()!).toList()),
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
            return Slidable(
              key: UniqueKey(),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
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
                        if (context.findAncestorStateOfType<
                                _ManageTripsScreenState>() !=
                            null) {
                          context
                              .findAncestorStateOfType<
                                  _ManageTripsScreenState>()!
                              .setState(() {});
                        }
                      });
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      _showDeleteConfirmationDialog(context, trip.id);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                title: Text(trip.name),
                subtitle: Text('${trip.location} - ${trip.difficulty}'),
                onTap: () {
                  tripInfo(context, trip.toJson());
                },
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
      barrierDismissible: false,
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
                if (context
                        .findAncestorStateOfType<_ManageTripsScreenState>() !=
                    null) {
                  context
                      .findAncestorStateOfType<_ManageTripsScreenState>()!
                      .setState(() {});
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
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _difficultyController = TextEditingController();
  TextEditingController _accessibilityController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _maxGuestsController = TextEditingController();
  DateTime? _tripDate;
  TextEditingController _tripDateController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  // bool _isDeleted = false;
  File? _imageFile; // To store the selected image file
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      final trip = widget.trip!;
      _nameController.text = trip.name;
      _priceController.text = trip.price?.toString() ?? '';
      _categoryController.text = trip.category;
      _descriptionController.text = trip.description ?? '';
      _locationController.text = trip.location;
      _latitudeController.text = trip.trailRoute.latitude.toString();
      _longitudeController.text = trip.trailRoute.longitude.toString();
      _difficultyController.text = trip.difficulty;
      _accessibilityController.text = trip.accessibility;
      _distanceController.text = trip.distance;
      _durationController.text = trip.duration;
      _maxGuestsController.text = trip.maxGuests.toString();
      _tripDate = trip.tripDate?.toDate(); // Convert Timestamp to DateTime
      _tripDateController.text = _tripDate != null ? DateFormat('yyyy-MM-dd – hh:mm a').format(_tripDate!) : '';
      _statusController.text = trip.status ?? '';
      _imageUrl = trip.imageUrl;
    }
  }


  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      return null;
    }

    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('trips/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final firebase_storage.UploadTask uploadTask =
          storageRef.putFile(_imageFile!);
      await uploadTask.whenComplete(() => null);
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image.')),
      );
      return null;
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
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        )
                      : _imageUrl != null
                          ? Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Text('Failed to load image'));
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.image,
                                      size: 40, color: Colors.grey),
                                  Text('Tap to upload image',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the trip name'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: 'Price (optional)',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                    labelText: 'Category', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the category'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                    labelText: 'Location', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the location'
                    : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          labelText: 'Latitude', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter latitude';
                        if (double.tryParse(value) == null)
                          return 'Invalid latitude';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          labelText: 'Longitude', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter longitude';
                        if (double.tryParse(value) == null)
                          return 'Invalid longitude';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _difficultyController,
                decoration: InputDecoration(
                    labelText: 'Difficulty', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the difficulty'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _accessibilityController,
                decoration: InputDecoration(
                    labelText: 'accessbility', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the accessbility'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(
                    labelText: 'Distance', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the distance'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                    labelText: 'Duration', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the duration'
                    : null,
              ),
              SizedBox(height: 10),TextFormField(
                controller: _maxGuestsController,
                decoration: InputDecoration(
                    labelText: 'maxGuests', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the maxGuests'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _tripDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Trip Day & Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // dismiss keyboard

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _tripDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _tripDateController.text = DateFormat('yyyy-MM-dd – hh:mm a').format(_tripDate!);
                      });
                    }
                  }
                },
                validator: (value) => _tripDate == null ? 'Please enter the trip day and time' : null,
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                    labelText: 'Status (optional)',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? uploadedImageUrl;
                    if (_imageFile != null) {
                      uploadedImageUrl = await _uploadImage();
                      if (uploadedImageUrl == null &&
                          widget.trip?.imageUrl == null) {
                        return; // Stop if image upload fails and no existing image
                      }
                    }

                    final int? price = int.tryParse(_priceController.text);
                    final int? maxGuests = int.tryParse(_maxGuestsController.text);
                    final double latitude =
                        double.parse(_latitudeController.text);
                    final double longitude =
                        double.parse(_longitudeController.text);
                    final GeoPoint trailRoute = GeoPoint(latitude, longitude);

                    final newTrip = TripsModel(
                      id: widget.trip?.id ?? '',
                      name: _nameController.text,
                      price: price,
                      category: _categoryController.text,
                      description: _descriptionController.text,
                      location: _locationController.text,
                      trailRoute: trailRoute,
                      difficulty: _difficultyController.text,
                      accessibility: _accessibilityController.text,
                      distance: _distanceController.text,
                      duration: _durationController.text,
                      imageUrl: uploadedImageUrl ?? widget.trip?.imageUrl ?? '',
                      // Use uploaded URL or existing
                      tripDate: _tripDate != null ? Timestamp.fromDate(_tripDate!) : null,
                      status: _statusController.text.isNotEmpty
                          ? _statusController.text
                          : null,
                        maxGuests : maxGuests,
                    );
                    if (widget.trip == null) {
                      await FirebaseService.addTrip(newTrip);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Trip added successfully!')),
                      );
                    } else {
                      await widget.firebaseService
                          .updateTrip(newTrip.id, newTrip.toJson());
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
