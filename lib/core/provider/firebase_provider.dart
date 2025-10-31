// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
// final authProvider = Provider((ref) => FirebaseAuth.instance);

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// MAIN project (default app)
// final mainFirestoreProvider = Provider<FirebaseFirestore>(
//   (ref) => FirebaseFirestore.instance,
// );
// final authProvider = Provider<FirebaseAuth>(
//   (ref) => FirebaseAuth.instance,
// );
// final authStateChangesProvider = StreamProvider<User?>(
//   (ref) => ref.watch(authProvider).authStateChanges(),
// );

// /// SECONDARY project (named app: 'gservice')
// final cacheFirestoreProvider = Provider<FirebaseFirestore>(
//   (ref) => FirebaseFirestore.instanceFor(app: Firebase.app('gservice')),
// );

////////////////////////////

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:drivex/firebase_options_secondary.dart' as cache_opts;

// /// MAIN project (default app)
// final mainFirestoreProvider = Provider<FirebaseFirestore>(
//   (ref) => FirebaseFirestore.instance,
// );
// final authProvider = Provider<FirebaseAuth>(
//   (ref) => FirebaseAuth.instance,
// );
// final authStateChangesProvider = StreamProvider<User?>(
//   (ref) => ref.watch(authProvider).authStateChanges(),
// );

// /// Ensure/obtain the SECONDARY app ('gservice')
// final gserviceAppProvider = FutureProvider<FirebaseApp>((ref) async {
//   try {
//     return Firebase.app('gservice');
//   } on FirebaseException {
//     return Firebase.initializeApp(
//       name: 'gservice',
//       options: cache_opts.DefaultFirebaseOptions.currentPlatform,
//     );
//   }
// });

// /// SECONDARY project Firestore (depends on the app above)
// final cacheFirestoreProvider = FutureProvider<FirebaseFirestore>((ref) async {
//   final app = await ref.watch(gserviceAppProvider.future);
//   return FirebaseFirestore.instanceFor(app: app);
// });
// // final cacheDbProvider = FutureProvider<FirebaseFirestore>((ref) async {
// //   final app = await ref.watch(gserviceAppProvider.future);
// //   return FirebaseFirestore.instanceFor(app: app);
// // });

////////////////////////////////////

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:drivex/firebase_options.dart';

// /// Initialize the single (default) Firebase app once.
// final firebaseAppProvider = FutureProvider<FirebaseApp>((ref) async {
//   return Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform);
// });

// /// Default Firestore (depends on default app init).
// final firestoreProvider = Provider<FirebaseFirestore>((ref) {
//   // FirebaseFirestore.instance is for the default app
//   return FirebaseFirestore.instance;
// });

// /// Default Auth (depends on default app init).
// final authProvider = Provider<FirebaseAuth>((ref) {
//   return FirebaseAuth.instance;
// });

// /// Default Auth state stream.
// final authStateChangesProvider = StreamProvider<User?>((ref) {
//   return ref.watch(authProvider).authStateChanges();
// });

//////////////////

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final firestoreProvider =
//     Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
// final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
// final authStateChangesProvider =
//     StreamProvider<User?>((ref) => ref.watch(authProvider).authStateChanges());

/////////////////////////////

// firebase_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final authStateChangesProvider =
    StreamProvider<User?>((ref) => ref.watch(authProvider).authStateChanges());
