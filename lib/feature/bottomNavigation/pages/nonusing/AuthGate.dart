// import 'package:drivex/feature/auth/screens/login.dart'; // LoginPage
// import 'package:drivex/feature/bottomNavigationBar/bottomNavigation.dart'; // BottomNavDemo
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// /// Listens to Firebase Auth and routes:
// ///  - Logged in  -> BottomNavDemo()
// ///  - Logged out -> LoginPage()
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snap.data != null) {
//           // ✅ Already signed in
//           return BottomNavDemo();
//         }

//         // ❌ Not signed in
//         return const LoginPage();
//       },
//     );
//   }
// }

// --------------------------------------------------------------

import 'package:drivex/feature/auth/screens/login.dart';
import 'package:drivex/feature/bottomNavigationBar/bottomNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // default (drivex) auth
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snap.data;
        return user != null ? BottomNavDemo() : const LoginPage();
      },
    );
  }
}
