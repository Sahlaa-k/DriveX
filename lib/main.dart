import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/login.dart';
import 'package:drivex/feature/bottomNavigationBar/bottomNavigation.dart';
import 'package:drivex/feature/onboarding/onboardingPage.dart';
import 'package:drivex/feature/onboarding/splash.dart';
import 'package:drivex/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomNavDemo(),
      ),
    );
  }
}
