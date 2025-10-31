import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> testBothFirebases() async {
  final mainDb = FirebaseFirestore.instance; // MAIN (drivex)
  final cacheDb = FirebaseFirestore.instanceFor(
      app: Firebase.app('gservice')); // SECONDARY (g-service)

  // write to SECONDARY
  await cacheDb.collection('health').doc('ping').set({
    'ok': true,
    'project': 'g-service',
    'ts': FieldValue.serverTimestamp(),
  });

  // write to MAIN
  await mainDb.collection('health').doc('main').set({
    'ok': true,
    'project': 'drivex',
    'ts': FieldValue.serverTimestamp(),
  });

  // read back from SECONDARY
  final snap = await cacheDb.collection('health').doc('ping').get();
  debugPrint('✅ Secondary cache ping: ${snap.data()}');
}
