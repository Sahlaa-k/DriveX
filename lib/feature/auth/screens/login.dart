// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:drivex/feature/auth/screens/signUp.dart';
// import 'package:drivex/feature/bottomNavigationBar/bottomNavigation.dart'; // BottomNavDemo()
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// /// DriveX — Customer App (Login)
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   // ────────────────────────────────────────────────────────────────────────────
//   // State
//   // ────────────────────────────────────────────────────────────────────────────
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   bool _obscure = true;
//   bool _isLoading = false;
//   bool _rememberMe = true;
//
//   final _auth = FirebaseAuth.instance;
//
//   // ────────────────────────────────────────────────────────────────────────────
//   // Lifecycle
//   // ────────────────────────────────────────────────────────────────────────────
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   // ────────────────────────────────────────────────────────────────────────────
//   // Helpers
//   // ────────────────────────────────────────────────────────────────────────────
//   void _toast(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
//
//   void _goHome() {
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => BottomNavDemo()),
//       (_) => false,
//     );
//   }
//
//   // ────────────────────────────────────────────────────────────────────────────
//   // Post-sign-in: link phone + save profile
//   // ────────────────────────────────────────────────────────────────────────────
//
//   Future<void> _postSignInFlow() async {
//     final u = _auth.currentUser;
//     if (u == null) return;
//
//     // Ask once for phone and try to link with OTP.
//     final typedOrLinkedPhone = await _ensurePhoneLinked();
//
//     // Save/merge profile to Firestore
//     await _upsertUserProfile(overridePhone: typedOrLinkedPhone);
//
//     _goHome();
//   }
//
//   /// If user has no phone on the Firebase user object, we:
//   /// 1) Ask for a phone
//   /// 2) Verify with OTP and link to the same Firebase user (mobile flow)
//   /// Returns: the phone we should store (linked phone if success, else typed phone, else null).
//   Future<String?> _ensurePhoneLinked() async {
//     final u = _auth.currentUser;
//     if (u == null) return null;
//
//     // Already has phone
//     final existing = u.phoneNumber?.trim();
//     if (existing != null && existing.isNotEmpty) return existing;
//
//     // Ask for phone
//     final typed = await _askPhoneNumber();
//     if (typed == null || typed.isEmpty) return null;
//
//     // Only mobile flow implemented (Android/iOS).
//     if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
//       final completer = Completer<void>();
//
//       await _auth.verifyPhoneNumber(
//         phoneNumber: typed,
//         verificationCompleted: (PhoneAuthCredential cred) async {
//           try {
//             await u.linkWithCredential(cred);
//           } on FirebaseAuthException catch (e) {
//             if (e.code != 'provider-already-linked') {
//               _toast(e.message ?? 'Phone link failed.');
//             }
//           } finally {
//             completer.complete();
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           _toast(e.message ?? 'Verification failed.');
//           completer.complete();
//         },
//         codeSent: (String verificationId, int? _) async {
//           final code = await _askSmsCode();
//           if (code == null || code.isEmpty) {
//             completer.complete();
//             return;
//           }
//           final cred = PhoneAuthProvider.credential(
//             verificationId: verificationId,
//             smsCode: code,
//           );
//           try {
//             await u.linkWithCredential(cred);
//           } on FirebaseAuthException catch (e) {
//             if (e.code == 'credential-already-in-use') {
//               _toast('That phone is already used by another account.');
//             } else if (e.code != 'provider-already-linked') {
//               _toast(e.message ?? 'Phone link failed.');
//             }
//           } finally {
//             completer.complete();
//           }
//         },
//         codeAutoRetrievalTimeout: (_) {},
//       );
//
//       await completer.future;
//
//       // Reload to get the latest phoneNumber
//       await u.reload();
//       final after = _auth.currentUser?.phoneNumber?.trim();
//       if (after != null && after.isNotEmpty) return after;
//
//       // Linking failed — still return typed so we can store it in Firestore (optional).
//       return typed;
//     }
//
//     // (Optional) Web flow requires reCAPTCHA; not implemented here.
//     // Return typed so it can at least be stored in Firestore.
//     return typed;
//   }
//
//   /// Upsert user profile in Firestore: users/{uid}
//   Future<void> _upsertUserProfile({String? overridePhone}) async {
//     final u = _auth.currentUser!;
//     final users = FirebaseFirestore.instance.collection('users');
//     final docRef = users.doc(u.uid);
//     final snap = await docRef.get();
//     final now = FieldValue.serverTimestamp();
//
//     final phoneForDoc = (overridePhone?.trim().isNotEmpty ?? false)
//         ? overridePhone!.trim()
//         : (u.phoneNumber ?? '');
//
//     await docRef.set({
//       'uid': u.uid,
//       'name': u.displayName ?? '',
//       'email': u.email ?? '',
//       'phone': phoneForDoc,
//       'photoURL': u.photoURL ?? '',
//       'providerIds': u.providerData.map((p) => p.providerId).toList(),
//       'updatedAt': now,
//       if (!snap.exists) 'createdAt': now,
//     }, SetOptions(merge: true));
//   }
//
//   /// Ask for phone number
//   Future<String?> _askPhoneNumber() async {
//     final ctrl = TextEditingController();
//     return showDialog<String>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Add phone number'),
//         content: TextField(
//           controller: ctrl,
//           keyboardType: TextInputType.phone,
//           decoration: const InputDecoration(
//             hintText: '+91 9876543210',
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(ctx), child: const Text('Skip')),
//           TextButton(
//               onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
//               child: const Text('Continue')),
//         ],
//       ),
//     );
//   }
//
//   /// Ask for the received OTP
//   Future<String?> _askSmsCode() async {
//     final ctrl = TextEditingController();
//     return showDialog<String>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Enter OTP'),
//         content: TextField(
//           controller: ctrl,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(hintText: '6-digit code'),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
//           TextButton(
//               onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
//               child: const Text('Verify')),
//         ],
//       ),
//     );
//   }
//
//   // ────────────────────────────────────────────────────────────────────────────
//   // Actions
//   // ────────────────────────────────────────────────────────────────────────────
//
//   /// Email / Password
//   Future<void> _onLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//     try {
//       final email = emailController.text.trim();
//       final pass = passwordController.text;
//
//       await _auth.signInWithEmailAndPassword(email: email, password: pass);
//
//       // Optional: enforce email verification
//       // if (!_auth.currentUser!.emailVerified) {
//       //   _toast('Please verify your email before continuing.');
//       //   await _auth.signOut();
//       //   return;
//       // }
//
//       // ▶ post flow (link phone + save profile)
//       await _postSignInFlow();
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'invalid-email':
//           _toast('The email address is badly formatted.');
//           break;
//         case 'user-disabled':
//           _toast('This account has been disabled.');
//           break;
//         case 'user-not-found':
//           _toast('No user found with this email.');
//           break;
//         case 'wrong-password':
//           _toast('Incorrect password. Please try again.');
//           break;
//         case 'too-many-requests':
//           _toast('Too many attempts. Try again later.');
//           break;
//         case 'network-request-failed':
//           _toast('Network error. Check your connection.');
//           break;
//         default:
//           _toast(e.message ?? 'Sign-in failed.');
//       }
//     } catch (_) {
//       _toast('Something went wrong. Please try again.');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   /// Google Sign-In (mobile & web)
//   Future<void> _onGoogleSignIn() async {
//     setState(() => _isLoading = true);
//     try {
//       if (kIsWeb) {
//         final provider = GoogleAuthProvider()
//           ..addScope('email')
//           ..setCustomParameters({'prompt': 'select_account'});
//         await FirebaseAuth.instance.signInWithPopup(provider);
//         await _postSignInFlow();
//         return;
//       }
//
//       final gsi = GoogleSignIn(scopes: ['email']);
//       final account = await gsi.signIn();
//       if (account == null) return; // user cancelled
//
//       final auth = await account.authentication;
//       final cred = GoogleAuthProvider.credential(
//         accessToken: auth.accessToken,
//         idToken: auth.idToken,
//       );
//
//       await FirebaseAuth.instance.signInWithCredential(cred);
//       await _postSignInFlow();
//     } on PlatformException catch (e) {
//       // On Android, code '10' = DEVELOPER_ERROR (SHA/package mismatch)
//       debugPrint(
//           'GoogleSignIn PlatformException: code=${e.code}, msg=${e.message}, details=${e.details}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Google sign-in error (code: ${e.code}). See logs.')),
//       );
//     } on FirebaseAuthException catch (e) {
//       debugPrint('FirebaseAuthException: code=${e.code}, msg=${e.message}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('FirebaseAuth: ${e.code}')),
//       );
//     } catch (e) {
//       debugPrint('Unexpected Google sign-in error: $e');
//       _toast('Google sign-in failed. Please try again.');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   /// Apple Sign-In:
//   /// - iOS/macOS: uses Firebase `AppleAuthProvider` (native UI)
//   /// - Web: uses OAuth popup for 'apple.com'
//   /// - Android: shows unsupported message
//   Future<void> _onAppleSignIn() async {
//     setState(() => _isLoading = true);
//     try {
//       if (kIsWeb) {
//         final apple = OAuthProvider('apple.com')..addScope('email');
//         await _auth.signInWithPopup(apple);
//         await _postSignInFlow();
//         return;
//       }
//
//       if (!(Platform.isIOS || Platform.isMacOS)) {
//         _toast('Apple Sign-In is only available on Apple devices.');
//         return;
//       }
//
//       final provider = AppleAuthProvider()
//         ..addScope('email')
//         ..addScope('name');
//
//       final cred = await _auth.signInWithProvider(provider);
//       if (cred.user == null) {
//         _toast('Apple sign-in failed.');
//         return;
//       }
//       await _postSignInFlow();
//     } on FirebaseAuthException catch (e) {
//       // user-cancelled variants
//       if (e.code == 'canceled' ||
//           e.code == 'user-cancelled' ||
//           e.code == 'user_cancelled') {
//         return;
//       }
//       _toast(e.message ?? 'Apple sign-in failed.');
//     } catch (_) {
//       _toast('Apple sign-in failed. Please try again.');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _onForgotPassword() async {
//     final controller = TextEditingController(text: emailController.text.trim());
//     await showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(width * .04),
//           ),
//           title: Text(
//             'Reset password',
//             style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
//           ),
//           content: TextField(
//             controller: controller,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Enter your email',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(width * .02),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: width * .03,
//                 vertical: width * .025,
//               ),
//             ),
//           ),
//           actionsPadding: EdgeInsets.only(
//             right: width * .02,
//             bottom: width * .02,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = controller.text.trim();
//                 Navigator.pop(ctx);
//                 if (email.isEmpty) {
//                   _toast('Enter an email to receive the reset link.');
//                   return;
//                 }
//                 try {
//                   await _auth.sendPasswordResetEmail(email: email);
//                   _toast('Reset link sent to $email');
//                 } on FirebaseAuthException catch (e) {
//                   _toast(e.message ?? 'Failed to send reset link.');
//                 } catch (_) {
//                   _toast('Failed to send reset link.');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(width * .02),
//                 ),
//               ),
//               child: const Text('Send link'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // ────────────────────────────────────────────────────────────────────────────
//   // UI helpers
//   // ────────────────────────────────────────────────────────────────────────────
//   InputDecoration _inputDecoration({
//     required String label,
//     Widget? prefixIcon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: GoogleFonts.montserrat(
//         fontSize: width * .035,
//         color: ColorConstant.thirdColor.withOpacity(.9),
//         fontWeight: FontWeight.w500,
//       ),
//       filled: true,
//       fillColor: Colors.white,
//       prefixIcon: prefixIcon,
//       suffixIcon: suffixIcon,
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: width * .04,
//         vertical: width * .03,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(width * .03),
//         borderSide: BorderSide(
//           color: Colors.black.withOpacity(.12),
//           width: width * .002,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(width * .03),
//         borderSide: BorderSide(
//           color: ColorConstant.primaryColor,
//           width: width * .003,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(width * .03),
//         borderSide: BorderSide(
//           color: Colors.redAccent,
//           width: width * .0025,
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(width * .03),
//         borderSide: BorderSide(
//           color: Colors.redAccent,
//           width: width * .003,
//         ),
//       ),
//     );
//   }
//
//   // Google 4-dot brand chip (width-based)
//   Widget _googleDots() {
//     final box = width * .06; // square container
//     final d = width * .018; // dot diameter
//     final gap = width * .012;
//     return SizedBox(
//       width: box,
//       height: box,
//       child: Stack(
//         children: [
//           _dot(left: 0, top: 0, size: d, color: Colors.blue),
//           _dot(left: d + gap, top: 0, size: d, color: Colors.red),
//           _dot(left: 0, top: d + gap, size: d, color: Colors.yellow[800]!),
//           _dot(left: d + gap, top: d + gap, size: d, color: Colors.green),
//         ],
//       ),
//     );
//   }
//
//   Positioned _dot({
//     required double left,
//     required double top,
//     required double size,
//     required Color color,
//   }) {
//     return Positioned(
//       left: left,
//       top: top,
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//       ),
//     );
//   }
//
//   // ────────────────────────────────────────────────────────────────────────────
//   // Build
//   // ────────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final titleStyle = GoogleFonts.montserrat(
//       fontSize: width * .06,
//       fontWeight: FontWeight.w700,
//       color: ColorConstant.primaryColor,
//       letterSpacing: .2,
//     );
//
//     final subtitleStyle = GoogleFonts.montserrat(
//       fontSize: width * .035,
//       color: ColorConstant.thirdColor.withOpacity(.75),
//       fontWeight: FontWeight.w500,
//     );
//
//     return Scaffold(
//       backgroundColor: ColorConstant.backgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: width * .06),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: width * .12),
//
//               // Header: Logo + Identity + Titles (center aligned)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const _DriveXBadge(), // brand identity
//
//                   SizedBox(height: width * .05),
//                   Text("Welcome back",
//                       style: titleStyle, textAlign: TextAlign.center),
//                   SizedBox(height: width * .01),
//                   Text("Sign in to continue",
//                       style: subtitleStyle, textAlign: TextAlign.center),
//                 ],
//               ),
//
//               SizedBox(height: width * .08),
//
//               // Form Card (centered, compact)
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(width * .04),
//                   border: Border.all(
//                     color: Colors.black.withOpacity(.10),
//                     width: width * .002,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(.03),
//                       blurRadius: width * .03,
//                       offset: Offset(0, width * .01),
//                     ),
//                   ],
//                 ),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width * .05,
//                   vertical: width * .05,
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // Email
//                       TextFormField(
//                         controller: emailController,
//                         textInputAction: TextInputAction.next,
//                         keyboardType: TextInputType.emailAddress,
//                         style: GoogleFonts.montserrat(
//                           color: ColorConstant.thirdColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * .036,
//                         ),
//                         decoration: _inputDecoration(
//                           label: "Email",
//                           prefixIcon: Icon(
//                             Icons.email_outlined,
//                             color: ColorConstant.thirdColor,
//                             size: width * .055,
//                           ),
//                         ),
//                         validator: (v) {
//                           final value = (v ?? '').trim();
//                           if (value.isEmpty) return "Please enter your email";
//                           final rx = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
//                           if (!rx.hasMatch(value)) return "Enter a valid email";
//                           return null;
//                         },
//                       ),
//
//                       SizedBox(height: width * .04),
//
//                       // Password
//                       TextFormField(
//                         controller: passwordController,
//                         textInputAction: TextInputAction.done,
//                         obscureText: _obscure,
//                         style: GoogleFonts.montserrat(
//                           color: ColorConstant.thirdColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: width * .036,
//                         ),
//                         decoration: _inputDecoration(
//                           label: "Password",
//                           prefixIcon: Icon(
//                             Icons.lock_outline,
//                             color: ColorConstant.thirdColor,
//                             size: width * .055,
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () =>
//                                 setState(() => _obscure = !_obscure),
//                             icon: Icon(
//                               _obscure
//                                   ? Icons.visibility_off_outlined
//                                   : Icons.visibility_outlined,
//                               color: ColorConstant.thirdColor,
//                               size: width * .06,
//                             ),
//                           ),
//                         ),
//                         onFieldSubmitted: (_) => _onLogin(),
//                         validator: (v) {
//                           final value = (v ?? '').trim();
//                           if (value.isEmpty) return "Please enter password";
//                           if (value.length < 6) return "Minimum 6 characters";
//                           return null;
//                         },
//                       ),
//
//                       SizedBox(height: width * .02),
//
//                       // Options Row
//                       Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.0,
//                             child: Checkbox(
//                               value: _rememberMe,
//                               onChanged: (v) =>
//                                   setState(() => _rememberMe = v ?? true),
//                               activeColor: ColorConstant.primaryColor,
//                               materialTapTargetSize:
//                                   MaterialTapTargetSize.shrinkWrap,
//                               visualDensity: VisualDensity.compact,
//                             ),
//                           ),
//                           SizedBox(width: width * .01),
//                           Text(
//                             "Remember me",
//                             style: GoogleFonts.montserrat(
//                               color: ColorConstant.thirdColor,
//                               fontWeight: FontWeight.w500,
//                               fontSize: width * .032,
//                             ),
//                           ),
//                           const Spacer(),
//                           TextButton(
//                             onPressed: _onForgotPassword,
//                             child: Text(
//                               "Forgot password?",
//                               style: GoogleFonts.montserrat(
//                                 color: ColorConstant.primaryColor,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: width * .032,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       SizedBox(height: width * .02),
//
//                       // Login button (width-based height)
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _onLogin,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorConstant.primaryColor,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(width * .03),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               vertical: width * .035,
//                             ),
//                             elevation: 0,
//                           ),
//                           child: _isLoading
//                               ? SizedBox(
//                                   width: width * .05,
//                                   height: width * .05,
//                                   child: const CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : Text(
//                                   "Login",
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: width * .042,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: width * .06),
//
//               // Divider "OR"
//               Row(
//                 children: [
//                   Expanded(
//                     child: Divider(
//                       color: Colors.black.withOpacity(.12),
//                       thickness: width * .002,
//                       height: width * .002,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * .02),
//                     child: Text(
//                       "OR",
//                       style: GoogleFonts.montserrat(
//                         color: ColorConstant.thirdColor.withOpacity(.7),
//                         fontWeight: FontWeight.w600,
//                         fontSize: width * .035,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Divider(
//                       color: Colors.black.withOpacity(.12),
//                       thickness: width * .002,
//                       height: width * .002,
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: width * .04),
//
//               // Social Buttons — aligned, width-based sizing
//               Column(
//                 children: [
//                   // Google: white, light border, dot brand chip
//                   SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton(
//                       onPressed: _isLoading ? null : _onGoogleSignIn,
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         side: BorderSide(
//                           color: Colors.black.withOpacity(.12),
//                           width: width * .002,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(width * .03),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: width * .032,
//                           horizontal: width * .04,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _googleDots(),
//                           SizedBox(width: width * .02),
//                           Text(
//                             "Continue with Google",
//                             style: GoogleFonts.montserrat(
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * .038,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: width * .03),
//
//                   // Apple: solid black, pill
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _onAppleSignIn,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(width * .03),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: width * .032,
//                           horizontal: width * .04,
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.apple,
//                               size: width * .055, color: Colors.white),
//                           SizedBox(width: width * .02),
//                           Text(
//                             "Continue with Apple",
//                             style: GoogleFonts.montserrat(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * .038,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: width * .08),
//
//               // Sign up prompt
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account? ",
//                     style: GoogleFonts.montserrat(
//                       color: ColorConstant.thirdColor,
//                       fontSize: width * .034,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SignUpPage()),
//                         (_) => false,
//                       );
//                     },
//                     child: Text(
//                       "Sign Up",
//                       style: GoogleFonts.montserrat(
//                         color: ColorConstant.primaryColor,
//                         fontWeight: FontWeight.w800,
//                         fontSize: width * .034,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: width * .12),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// DriveX identity badge for customer app (not partner)
// class _DriveXBadge extends StatelessWidget {
//   const _DriveXBadge();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: width * .035,
//         vertical: width * .022,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(width * .08),
//         border: Border.all(
//           color: Colors.black.withOpacity(.12),
//           width: width * .002,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Brand icon circle
//           Container(
//             width: width * .095,
//             height: width * .095,
//             decoration: BoxDecoration(
//               color: ColorConstant.primaryColor.withOpacity(.1),
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: Icon(
//               Icons.directions_car_rounded,
//               size: width * .055,
//               color: ColorConstant.primaryColor,
//             ),
//           ),
//           // Vertical divider
//           Container(
//             width: width * .002,
//             height: width * .07,
//             margin: EdgeInsets.symmetric(horizontal: width * .03),
//             color: Colors.black.withOpacity(.1),
//           ),
//           // Wordmark
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "DriveX",
//                 style: GoogleFonts.montserrat(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w800,
//                   fontSize: width * .04,
//                 ),
//               ),
//               SizedBox(height: width * .004),
//               Text(
//                 "Customer App",
//                 style: GoogleFonts.montserrat(
//                   color: Colors.black54,
//                   fontSize: width * .028,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(width: width * .02),
//           // Verified tick (optional)
//           Container(
//             padding: EdgeInsets.all(width * .012),
//             decoration: BoxDecoration(
//               color: ColorConstant.primaryColor.withOpacity(.08),
//               borderRadius: BorderRadius.circular(width * .02),
//             ),
//             child: Icon(
//               Icons.verified_rounded,
//               size: width * .04,
//               color: ColorConstant.primaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
