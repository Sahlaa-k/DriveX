import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppFire {
  // Default app = drivex-2a34e
  static FirebaseApp get mainApp => Firebase.app();
  static FirebaseFirestore get mainDb =>
      FirebaseFirestore.instanceFor(app: mainApp);
  static FirebaseAuth get mainAuth => FirebaseAuth.instanceFor(app: mainApp);
  static FirebaseStorage get mainStorage =>
      FirebaseStorage.instanceFor(app: mainApp);

  // Secondary app = g-service-d45fd (named "gservice")
  static FirebaseApp get gServiceApp => Firebase.app('gservice');
  static FirebaseFirestore get gServiceDb =>
      FirebaseFirestore.instanceFor(app: gServiceApp);
  static FirebaseAuth get gServiceAuth =>
      FirebaseAuth.instanceFor(app: gServiceApp);
  static FirebaseStorage get gServiceStorage =>
      FirebaseStorage.instanceFor(app: gServiceApp);
}
