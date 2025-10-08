// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:drivex/feature/auth/screens/login.dart';

// import 'package:drivex/feature/bottomNavigationBar/bottomNavigation.dart';

// import 'package:drivex/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const ProviderScope(child: DriveXApp()));
// }

// class DriveXApp extends StatelessWidget {
//   const DriveXApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus!.unfocus();
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: LoginPage(),
//         // home:  BottomNavDemo(),

//         theme: ThemeData(
//           textTheme: GoogleFonts.kulimParkTextTheme(),
//         ),
//       ),
//     );
//   }
// }

// lib/main.dart
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/login.dart'; // LoginPage
import 'package:drivex/feature/bottomNavigationBar/bottomNavigation.dart'; // BottomNavDemo

import 'package:drivex/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: DriveXApp()));
}

class DriveXApp extends StatelessWidget {
  const DriveXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DriveX',
      theme: ThemeData(textTheme: GoogleFonts.kulimParkTextTheme()),
      // 🔐 Always decide the start screen based on auth state
      home: const AuthGate(),
      // ✅ Safely set global width/height + dismiss keyboard on tap anywhere
      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);
        height = size.height;
        width = size.width;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: child,
        );
      },
    );
  }
}

/// Listens to Firebase Auth and routes:
///  - Logged in  -> BottomNavDemo()
///  - Logged out -> LoginPage()
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Optional: if you require verified emails only
        // final u = snap.data;
        // if (u != null && !(u.emailVerified)) return const VerifyEmailPage();

        if (snap.data != null) {
          // ✅ Already signed in
          return BottomNavDemo();
        }

        // ❌ Not signed in
        return const LoginPage();
      },
    );
  }
}
