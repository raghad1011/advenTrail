import 'package:adver_trail/model/app_user.dart';
import 'package:adver_trail/model/booking.dart';
import 'package:adver_trail/model/trips.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReferenceFirebase {
  //  users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');


//  trips
  static CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');

//  CollectionReference -- DocumentReference -- Query

//  bookings
  static CollectionReference Booking =
      FirebaseFirestore.instance.collection('booking');

  static CollectionReference ADD_Book =
      FirebaseFirestore.instance.collection('booking').withConverter<BookModel>(
          fromFirestore: (snapshot, options) {
            var model = BookModel.fromJson(snapshot.data()!);
            model.id = snapshot.id;
            return model;
          },
          toFirestore: (model, options) => model.toJson());

  static DocumentReference<BookModel> GET_Book(String id) =>
      FirebaseFirestore.instance
          .collection('booking')
          .doc(id)
          .withConverter<BookModel>(
              fromFirestore: (snapshot, options) {
                var model = BookModel.fromJson(snapshot.data()!);
                model.id = snapshot.id;
                return model;
              },
              toFirestore: (model, options) => model.toJson());

  static Query<TripsModel> GETAll_Booking =
      FirebaseFirestore.instance.collection('booking').where("is_deleted",isEqualTo: false)
          .withConverter<BookModel>(
          fromFirestore: (snapshot, options) {
            var model = BookModel.fromJson(snapshot.data()!);
            model.id = snapshot.id;
            return model;
          },
          toFirestore: (model, options) => model.toJson()) as Query<TripsModel>;

  static addEditTrips(TripsModel model)async{
    if(model.id.isEmpty){
      await FirebaseService.addTrip(model);

    }else{
      await FirebaseService.getTrip(model.id).update(model.id as Map<Object, Object?>);
    }
  }

}
