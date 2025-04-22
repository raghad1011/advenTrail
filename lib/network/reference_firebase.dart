import 'package:adver_trail/model/trips.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReferenceFirebase {
  final storageRef = FirebaseStorage.instance.ref();
  //  users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

//  trips
  static CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');

//  CollectionReference -- DocumentReference -- Query

//  bookings
  static CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');

  static addEditTrips(TripsModel model) async {
    if (model.id.isEmpty) {
      await FirebaseService.addTrip(model);
    } else {
      await FirebaseService.getTrip(model.id)
          .update(model.id as Map<Object, Object?>);
    }
  }
}
