import 'package:adver_trail/model/booking.dart';
import 'package:adver_trail/model/trips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Read user
  Future<DocumentSnapshot?> getUser(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Update user
  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedUserData) async {
    try {
      await _db.collection('users').doc(userId).update(updatedUserData);
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Get all users
  Future<QuerySnapshot> getAllUsers() async {
    try {
      return await _db.collection('users').get();
    } catch (e) {
      print('Error fetching users: $e');
      return null!;
    }
  }

  // Add Trip
  static Future<void> addTrip(TripsModel model) async {
    try {
      await FirebaseFirestore.instance.collection('trips').add(model.toJson());
      print('Trip added successfully');
    } catch (e) {
      print('Error adding trip: $e');
    }
  }

  // Get a specific Trip
  static DocumentReference<TripsModel> getTrip(String tripId) =>
      FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .withConverter<TripsModel>(
              fromFirestore: (snapshot, options) {
                var model = TripsModel.fromJson(snapshot.data()!);
                model.id = snapshot.id;
                return model;
              },
              toFirestore: (model, options) => model.toJson());

  //update trip
  Future<void> updateTrip(
      String tripId, Map<String, dynamic> updatedTripData) async {
    try {
      await _db.collection('trips').doc(tripId).update(updatedTripData);
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete a trip
  Future<void> deleteTrip(String tripId) async {
    try {
      await _db.collection('trips').doc(tripId).delete();
    } catch (e) {
      print('Error deleting trip: $e');
    }
  }

  // Get all trips
  Future<QuerySnapshot<TripsModel>> getAllTrips() async {
    return await FirebaseFirestore.instance
        .collection('trips')
        .withConverter<TripsModel>(
            fromFirestore: (snapshot, options) {
              var model = TripsModel.fromJson(snapshot.data()!);
              model.id = snapshot.id;
              return model;
            },
            toFirestore: (model, options) => model.toJson())
        .get();
  }

  //add Booking
  Future<void> addBooking(BookingModel model) async {
    await FirebaseFirestore.instance.collection('bookings').add(model.toJson());
  }

  Future<QuerySnapshot<BookingModel>> getAllBookings() async {
    return await FirebaseFirestore.instance
        .collection('bookings')
        .withConverter<BookingModel>(
            fromFirestore: (snapshot, options) {
              var model = BookingModel.fromJson(snapshot.data()!);
              model.id = snapshot.id;
              return model;
            },
            toFirestore: (model, options) => model.toJson())
        .get();
  }

  Future<QuerySnapshot> getBookingsForTrip(String tripId) async {
    return await FirebaseFirestore.instance
        .collection('bookings')
        .where('tripId',
        isEqualTo: FirebaseFirestore.instance.collection('trips').doc(tripId))
        .get();
  }


  Future<QuerySnapshot> getBookingsForUser(String userId) async {
    return await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();
  }

  Future<void> deleteBooking(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .delete();
  }
  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update(data);
  }

}

// static CollectionReference ADD_Book =
// FirebaseFirestore.instance.collection('booking').withConverter<BookingModel>(
//     fromFirestore: (snapshot, options) {
//       var model = BookingModel.fromJson(snapshot.data()!);
//       model.id = snapshot.id;
//       return model;
//     },
//     toFirestore: (model, options) => model.toJson());
//
// static DocumentReference<BookingModel> GET_Book(String id) =>
// FirebaseFirestore.instance
//     .collection('booking')
//     .doc(id)
//     .withConverter<BookingModel>(
// fromFirestore: (snapshot, options) {
// var model = BookingModel.fromJson(snapshot.data()!);
// model.id = snapshot.id;
// return model;
// },
// toFirestore: (model, options) => model.toJson());
//
// static Query<TripsModel> GETAll_Booking = FirebaseFirestore.instance
//     .collection('booking')
//     .where("is_deleted", isEqualTo: false)
//     .withConverter<BookingModel>(
// fromFirestore: (snapshot, options) {
// var model = BookingModel.fromJson(snapshot.data()!);
// model.id = snapshot.id;
// return model;
// },
// toFirestore: (model, options) => model.toJson()) as Query<TripsModel>;
