import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../model/trips.dart';
import '../network/firebase_services.dart';

class AddEditTripScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  final TripsModel? trip;

  const AddEditTripScreen({super.key, required this.firebaseService, this.trip});

  @override
  AddEditTripScreenState createState() => AddEditTripScreenState();
}

class AddEditTripScreenState extends State<AddEditTripScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController difficultyController = TextEditingController();
  TextEditingController accessibilityController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController maxGuestsController = TextEditingController();
  DateTime? tripDate;
  TextEditingController tripDateController = TextEditingController();
  TextEditingController tripStatusController = TextEditingController();

  File? imageFile;
  String? imageUrl;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      final trip = widget.trip!;
      nameController.text = trip.name;
      priceController.text = trip.price?.toString() ?? '';
      categoryController.text = trip.category;
      descriptionController.text = trip.description ?? '';
      locationController.text = trip.location;
      latitudeController.text = trip.trailRoute.latitude.toString();
      longitudeController.text = trip.trailRoute.longitude.toString();
      difficultyController.text = trip.difficulty;
      accessibilityController.text = trip.accessibility ?? '';
      distanceController.text = trip.distance;
      durationController.text = trip.duration;
      maxGuestsController.text = trip.maxGuests.toString();
      tripDate = trip.tripDate?.toDate(); // Convert Timestamp to DateTime
      tripDateController.text = tripDate != null
          ? DateFormat('yyyy-MM-dd – hh:mm a').format(tripDate!)
          : '';
      tripStatusController.text = trip.tripStatus ?? '';
      imageUrl = trip.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (imageFile == null) {
      return null;
    }

    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('trips/${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg');
      final firebase_storage.UploadTask uploadTask =
      storageRef.putFile(imageFile!);
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E6),
      appBar: AppBar(
        backgroundColor: Color(0xFF6D8B5D),
        title: Text(
          widget.trip == null ? 'Add New Trip' : 'Edit Trip',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF556B2F)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: imageFile != null
                      ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )
                      : imageUrl != null
                      ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Failed to load image'));
                    },
                  )
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.image, size: 40, color: Colors.grey),
                        Text('Tap to upload image', style: TextStyle(
                            color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration('Name'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the trip name'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration('Price (optional)'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                decoration: _inputDecoration('Category'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the category'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _inputDecoration('Description (optional)'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                decoration: _inputDecoration('Location'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the location'
                    : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: latitudeController,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: _inputDecoration('Latitude'),
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
                      controller: longitudeController,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: _inputDecoration('Longitude'),
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
                controller: difficultyController,
                decoration: _inputDecoration('Difficulty'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the difficulty'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: accessibilityController,
                decoration: _inputDecoration('Accessibility'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the accessibility'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: distanceController,
                decoration: _inputDecoration('Distance'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the distance'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: durationController,
                decoration: _inputDecoration('Duration'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the duration'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: maxGuestsController,
                decoration: _inputDecoration('maxGuests',
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Please enter the maxGuests'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: tripDateController,
                readOnly: true,
                decoration: _inputDecoration('Trip Day & Time'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
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
                        tripDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        tripDateController.text = DateFormat(
                            'yyyy-MM-dd – hh:mm a').format(tripDate!);
                      });
                    }
                  }
                },
                validator: (value) =>
                tripDate == null
                    ? 'Please enter the trip day and time'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: tripStatusController,
                decoration: _inputDecoration('Status (optional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF556B2F),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    String? uploadedImageUrl;
                    if (imageFile != null) {
                      uploadedImageUrl = await _uploadImage();
                      if (uploadedImageUrl == null &&
                          widget.trip?.imageUrl == null) {
                        return;
                      }
                    }
                    final int? price = int.tryParse(priceController.text);
                    final int? maxGuests = int.tryParse(
                        maxGuestsController.text);
                    final double latitude = double.parse(
                        latitudeController.text);
                    final double longitude = double.parse(
                        longitudeController.text);
                    final GeoPoint trailRoute = GeoPoint(latitude, longitude);
                    final newTrip = TripsModel(
                      id: widget.trip?.id ?? '',
                      name: nameController.text,
                      price: price,
                      category: categoryController.text,
                      description: descriptionController.text,
                      location: locationController.text,
                      trailRoute: trailRoute,
                      difficulty: difficultyController.text,
                      accessibility: accessibilityController.text,
                      distance: distanceController.text,
                      duration: durationController.text,
                      imageUrl: uploadedImageUrl ?? widget.trip?.imageUrl ?? '',
                      tripDate: tripDate != null ? Timestamp.fromDate(
                          tripDate!) : null,
                      tripStatus: tripStatusController.text.isNotEmpty
                          ? tripStatusController.text
                          : null,
                      maxGuests: maxGuests,
                    );
                    if (widget.trip == null) {
                      await FirebaseService.addTrip(newTrip);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Trip added successfully!')),
                      );
                    } else {
                      await widget.firebaseService.updateTrip(
                          newTrip.id, newTrip.toJson());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Trip updated successfully!')),
                      );
                    }
                    Navigator.of(context).pop();
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF556B2F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF556B2F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF556B2F), width: 2),
      ),
    );
  }
}