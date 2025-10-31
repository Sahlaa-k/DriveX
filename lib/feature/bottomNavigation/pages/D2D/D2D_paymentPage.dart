// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class D2dPaymentpage extends StatefulWidget {
//   const D2dPaymentpage({super.key});

//   @override
//   State<D2dPaymentpage> createState() => _D2dPaymentpageState();
// }

// class _D2dPaymentpageState extends State<D2dPaymentpage> {
//   // Inputs (from previous page)
//   double baseFare = 0; // required
//   double distanceKm = 0; // optional
//   int etaMins = 0; // optional
//   int stopsCount = 0; // optional
//   double perKmRate = 10; // optional (defaults)
//   int perStopCharge = 5; // optional (defaults)

//   // UI state
//   String paymentMethod = "UPI"; // UPI | Cash | Card
//   final TextEditingController upiVpaC = TextEditingController();
//   final TextEditingController cashGivenC = TextEditingController();
//   final TextEditingController cardLast4C = TextEditingController();
//   final TextEditingController promoC = TextEditingController();
//   final TextEditingController tipCustomC = TextEditingController();
//   final TextEditingController noteC = TextEditingController();

//   // Pricing state
//   double promoDiscount = 0; // computed after "Apply"
//   double tip = 0; // from chips/custom
//   bool promoApplied = false;

//   // Validation helpers
//   bool get _upiOk =>
//       paymentMethod != "UPI" || upiVpaC.text.trim().contains("@");
//   bool get _cashOk {
//     if (paymentMethod != "Cash") return true;
//     final v = double.tryParse(cashGivenC.text.trim());
//     return v != null && v >= _grandTotal;
//   }

//   bool get _cardOk =>
//       paymentMethod != "Card" || cardLast4C.text.trim().length == 4;

//   double get _stopsAmount => (stopsCount * perStopCharge).toDouble();
//   double get _subTotal => (baseFare - promoDiscount).clamp(0, double.infinity);
//   double get _grandTotal => (_subTotal + tip).clamp(0, double.infinity);

//   @override
//   void initState() {
//     super.initState();
//     // Read args after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is Map) {
//         baseFare = (args['fare'] as num?)?.toDouble() ?? baseFare;
//         distanceKm = (args['distance_km'] as num?)?.toDouble() ?? distanceKm;
//         etaMins = (args['eta_mins'] as num?)?.toInt() ?? etaMins;
//         stopsCount = (args['stops_count'] as num?)?.toInt() ?? stopsCount;
//         perKmRate = (args['per_km_rate'] as num?)?.toDouble() ?? perKmRate;
//         perStopCharge =
//             (args['per_stop_charge'] as num?)?.toInt() ?? perStopCharge;
//         setState(() {});
//       }
//     });
//   }

//   @override
//   void dispose() {
//     upiVpaC.dispose();
//     cashGivenC.dispose();
//     cardLast4C.dispose();
//     promoC.dispose();
//     tipCustomC.dispose();
//     noteC.dispose();
//     super.dispose();
//   }

//   void _applyPromo() {
//     final code = promoC.text.trim().toUpperCase();
//     // Simple demo rules (customize as needed)
//     // DA50 → flat ₹50 off if fare >= 200
//     // KM5  → 5% off distance component only
//     // STOP10 → 10% off stop charges
//     double discount = 0;
//     if (code == "DA50" && baseFare >= 200) {
//       discount = 50;
//     } else if (code == "KM5" && distanceKm > 0) {
//       final distanceComponent = distanceKm * perKmRate;
//       discount = distanceComponent * 0.05;
//     } else if (code == "STOP10" && stopsCount > 0) {
//       discount = _stopsAmount * 0.10;
//     } else {
//       // invalid or not eligible
//       discount = 0;
//     }
//     setState(() {
//       promoDiscount = discount;
//       promoApplied = code.isNotEmpty && discount > 0;
//     });
//     final snack = SnackBar(
//       content: Text(
//         promoApplied
//             ? "Promo applied: -₹${discount.toStringAsFixed(0)}"
//             : "Promo not eligible / invalid",
//       ),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snack);
//   }

//   void _setTip(double v) {
//     tipCustomC.clear();
//     setState(() => tip = v);
//   }

//   void _useCustomTip() {
//     final t = double.tryParse(tipCustomC.text.trim());
//     if (t == null || t < 0) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Enter a valid tip")));
//       return;
//     }
//     setState(() => tip = t);
//   }

//   void _proceed() {
//     if (!_upiOk || !_cashOk || !_cardOk) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Please complete required payment details")),
//       );
//       return;
//     }

//     final payload = {
//       "payment_method": paymentMethod,
//       "fare_breakdown": {
//         "base_fare": baseFare,
//         "distance_km": distanceKm,
//         "eta_mins": etaMins,
//         "per_km_rate": perKmRate,
//         "stops_count": stopsCount,
//         "per_stop_charge": perStopCharge,
//         "stops_amount": _stopsAmount,
//         "promo_discount": promoDiscount,
//         "tip": tip,
//       },
//       "note": noteC.text.trim(),
//       "total_payable": _grandTotal,
//       "payment_details": {
//         "upi_vpa": upiVpaC.text.trim(),
//         "cash_given": double.tryParse(cashGivenC.text.trim()) ?? 0,
//         "card_last4": cardLast4C.text.trim(),
//       }
//     };

//     Navigator.pop(context, payload);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;

//     // Sizing tokens
//     final double padSm = width * 0.03;
//     final double padMd = width * 0.04;
//     final double br = width * 0.035;
//     final double blur = width * 0.025;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F7),
//       appBar: AppBar(
//         title: Text("Payment", style: TextStyle(fontSize: width * 0.048)),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.fromLTRB(
//                   width * 0.05, width * 0.03, width * 0.05, width * 0.34),
//               children: [
//                 // Summary card
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text("Ride Summary",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Distance",
//                               style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: width * 0.034)),
//                           Text(
//                               distanceKm > 0
//                                   ? "${distanceKm.toStringAsFixed(1)} km"
//                                   : "--",
//                               style: TextStyle(
//                                   fontSize: width * 0.036,
//                                   fontWeight: FontWeight.w700)),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.01),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("ETA",
//                               style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: width * 0.034)),
//                           Text(etaMins > 0 ? "~$etaMins min" : "--",
//                               style: TextStyle(
//                                   fontSize: width * 0.036,
//                                   fontWeight: FontWeight.w700)),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.01),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Stops",
//                               style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: width * 0.034)),
//                           Text("$stopsCount",
//                               style: TextStyle(
//                                   fontSize: width * 0.036,
//                                   fontWeight: FontWeight.w700)),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: width * 0.03),
//                         child: const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                       ),
//                       // Fare breakdown style: left label math, right amount
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Per km: ₹${perKmRate.toStringAsFixed(0)} × ${distanceKm.toStringAsFixed(1)} km",
//                             style: TextStyle(
//                                 fontSize: width * 0.034, color: Colors.black87),
//                           ),
//                           Text(
//                             "₹${(distanceKm * perKmRate).toStringAsFixed(0)}",
//                             style: TextStyle(
//                                 fontSize: width * 0.036,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.018),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Stops: $stopsCount × ₹$perStopCharge",
//                               style: TextStyle(
//                                   fontSize: width * 0.034,
//                                   color: Colors.black87)),
//                           Text("₹${_stopsAmount.toStringAsFixed(0)}",
//                               style: TextStyle(
//                                   fontSize: width * 0.036,
//                                   fontWeight: FontWeight.w700)),
//                         ],
//                       ),
//                       // Promo line (if applied)
//                       if (promoApplied || promoDiscount > 0) ...[
//                         SizedBox(height: width * 0.018),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Promo discount",
//                                 style: TextStyle(
//                                     fontSize: width * 0.034,
//                                     color: Colors.green.shade700)),
//                             Text("-₹${promoDiscount.toStringAsFixed(0)}",
//                                 style: TextStyle(
//                                     fontSize: width * 0.036,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.green.shade700)),
//                           ],
//                         ),
//                       ],
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: width * 0.03),
//                         child: const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                       ),
//                       // Subtotal (before tip)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Subtotal",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: width * 0.038)),
//                           Text("₹${_subTotal.toStringAsFixed(0)}",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: width * 0.040)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Promo
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Promo code",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: promoC,
//                               decoration: InputDecoration(
//                                 hintText: "DA50 / KM5 / STOP10",
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: padMd, vertical: padSm),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           FilledButton(
//                             onPressed: _applyPromo,
//                             child: const Text("Apply"),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Tip
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Tip (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: [
//                           ChoiceChip(
//                             label: const Text("₹0"),
//                             selected: tip == 0,
//                             onSelected: (_) => _setTip(0),
//                           ),
//                           ChoiceChip(
//                             label: const Text("₹10"),
//                             selected: tip == 10,
//                             onSelected: (_) => _setTip(10),
//                           ),
//                           ChoiceChip(
//                             label: const Text("₹20"),
//                             selected: tip == 20,
//                             onSelected: (_) => _setTip(20),
//                           ),
//                           ChoiceChip(
//                             label: const Text("₹50"),
//                             selected: tip == 50,
//                             onSelected: (_) => _setTip(50),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: tipCustomC,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: "Custom amount",
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: padMd, vertical: padSm),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           OutlinedButton(
//                             onPressed: _useCustomTip,
//                             child: const Text("Set"),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Payment method
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Payment method",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.01),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "UPI",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("UPI"),
//                         subtitle: paymentMethod == "UPI"
//                             ? TextField(
//                                 controller: upiVpaC,
//                                 decoration: const InputDecoration(
//                                   hintText: "yourname@upi",
//                                 ),
//                               )
//                             : null,
//                       ),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "Cash",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("Cash"),
//                         subtitle: paymentMethod == "Cash"
//                             ? TextField(
//                                 controller: cashGivenC,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                   hintText: "Cash given (₹)",
//                                 ),
//                               )
//                             : null,
//                       ),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "Card",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("Card"),
//                         subtitle: paymentMethod == "Card"
//                             ? TextField(
//                                 controller: cardLast4C,
//                                 maxLength: 4,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                   hintText: "Last 4 digits",
//                                   counterText: "",
//                                 ),
//                               )
//                             : null,
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Notes
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Notes (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       TextField(
//                         controller: noteC,
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           hintText: "Any special instruction…",
//                           contentPadding: EdgeInsets.all(padMd),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Sticky bottom: total + proceed
//           Container(
//             padding: EdgeInsets.fromLTRB(
//               width * 0.05,
//               padSm,
//               width * 0.05,
//               padSm + MediaQuery.of(context).padding.bottom,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(width * 0.045)),
//               boxShadow: [
//                 BoxShadow(
//                     blurRadius: width * 0.045,
//                     color: Colors.black12,
//                     offset: Offset(0, -width * 0.015))
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: padMd, vertical: padSm),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F5F9),
//                       borderRadius: BorderRadius.circular(width * 0.035),
//                       border: Border.all(color: const Color(0xFFE9ECF2)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Tip",
//                                 style: TextStyle(
//                                     fontSize: width * 0.033,
//                                     color: Colors.black54)),
//                             Text("₹${tip.toStringAsFixed(0)}",
//                                 style: TextStyle(
//                                     fontSize: width * 0.035,
//                                     fontWeight: FontWeight.w700)),
//                           ],
//                         ),
//                         SizedBox(height: width * 0.01),
//                         const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                         SizedBox(height: width * 0.01),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Total",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * 0.040)),
//                             Text("₹${_grandTotal.toStringAsFixed(0)}",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w800,
//                                     fontSize: width * 0.045)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: width * 0.03),
//                 FilledButton.icon(
//                   onPressed: (_upiOk && _cashOk && _cardOk) ? _proceed : null,
//                   icon: const Icon(Icons.check_circle),
//                   label: Text("Proceed",
//                       style: TextStyle(fontSize: width * 0.038)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ---------------------------------

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class D2dPaymentpage extends StatefulWidget {
//   const D2dPaymentpage({super.key});

//   @override
//   State<D2dPaymentpage> createState() => _D2dPaymentpageState();
// }

// class _D2dPaymentpageState extends State<D2dPaymentpage> {
//   // -------- Original inputs (all nullable; NO presets) --------
//   double? baseFare; // original fare from previous page (required by you)
//   double? distanceKm; // informational
//   int? etaMins; // informational
//   int? stopsCount; // informational
//   double? perKmRate; // informational
//   int? perStopCharge; // informational
//   late Razorpay _rzp;

//   // -------- UI state --------
//   String paymentMethod = "UPI"; // default visual choice but no hidden values
//   final TextEditingController upiVpaC = TextEditingController();
//   final TextEditingController cashGivenC = TextEditingController();
//   final TextEditingController cardLast4C = TextEditingController();
//   final TextEditingController promoC = TextEditingController();
//   final TextEditingController tipCustomC = TextEditingController();
//   final TextEditingController noteC = TextEditingController();

//   // -------- Pricing extras (do not alter original fare) --------
//   double promoDiscount = 0; // applied on top of original fare (subtract)
//   double tip = 0; // optional add
//   bool promoApplied = false;

//   // Derived (informational only; does not change baseFare)
//   double get _distanceComponent {
//     if (distanceKm == null || perKmRate == null) return 0;
//     return distanceKm! * perKmRate!;
//   }

//   double get _stopsComponent {
//     if (stopsCount == null || perStopCharge == null) return 0;
//     return (stopsCount! * perStopCharge!).toDouble();
//   }

//   // Payable math — starts from original baseFare only
//   double get _subtotal {
//     if (baseFare == null) return 0;
//     final v = baseFare! - promoDiscount;
//     return v < 0 ? 0 : v;
//   }

//   double get _grandTotal => _subtotal + tip;

//   // Validation helpers
//   bool get _upiOk =>
//       paymentMethod != "UPI" || upiVpaC.text.trim().contains("@");
//   bool get _cashOk {
//     if (paymentMethod != "Cash") return true;
//     final v = double.tryParse(cashGivenC.text.trim());
//     return v != null && v >= _grandTotal && _grandTotal > 0;
//   }

//   bool get _cardOk =>
//       paymentMethod != "Card" || cardLast4C.text.trim().length == 4;
//   bool get _hasBaseFare => baseFare != null;

//   @override
//   void initState() {
//     super.initState();

//     _rzp = Razorpay();
//     _rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
//     _rzp.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
//     _rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternal);
//     // Read arguments only; DO NOT inject demo values
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is Map) {
//         baseFare = (args['fare'] as num?)?.toDouble();
//         distanceKm = (args['distance_km'] as num?)?.toDouble();
//         etaMins = (args['eta_mins'] as num?)?.toInt();
//         stopsCount = (args['stops_count'] as num?)?.toInt();
//         perKmRate = (args['per_km_rate'] as num?)?.toDouble();
//         perStopCharge = (args['per_stop_charge'] as num?)?.toInt();
//         setState(() {});
//       }
//     });
//   }

//   void startRazorpayCheckout({
//     required String orderId, // from your server
//     required int amountPaise,
//     required String customerName,
//     required String customerPhone,
//     required String customerEmail,
//   }) {
//     final options = {
//       'key': '<YOUR_RAZORPAY_KEY_ID>',
//       'amount': amountPaise, // e.g. (grandTotal * 100).round()
//       'currency': 'INR',
//       'name': 'DriveX',
//       'description': 'Ride payment',
//       'order_id': orderId,
//       'prefill': {
//         'contact': customerPhone,
//         'email': customerEmail,
//         'name': customerName,
//       },
//       'theme': {'color': '#2563EB'},
//     };
//     _rzp.open(options);
//   }

//   void _onSuccess(PaymentSuccessResponse r) async {
//     // Send r.orderId, r.paymentId, r.signature to your server
//     // Server verifies signature → mark paid → return final receipt to app
//   }

//   void _onError(PaymentFailureResponse r) {
//     // Show error
//   }

//   void _onExternal(ExternalWalletResponse r) {
//     // Optional
//   }

//   @override
//   void dispose() {
//     //
//     _rzp.clear();
//     //

//     upiVpaC.dispose();
//     cashGivenC.dispose();
//     cardLast4C.dispose();
//     promoC.dispose();
//     tipCustomC.dispose();
//     noteC.dispose();
//     super.dispose();
//   }

//   void _applyPromo() {
//     // This is optional and independent from your original fare inputs.
//     final code = promoC.text.trim().toUpperCase();
//     double discount = 0;

//     // Example demo rules that reference the informational components when present.
//     // Remove/replace with your server-side rules as needed.
//     if (code == "DA50" && (baseFare ?? 0) >= 200) {
//       discount = 50;
//     } else if (code == "KM5" && _distanceComponent > 0) {
//       discount = _distanceComponent * 0.05;
//     } else if (code == "STOP10" && _stopsComponent > 0) {
//       discount = _stopsComponent * 0.10;
//     } else {
//       discount = 0;
//     }

//     setState(() {
//       promoDiscount = discount;
//       promoApplied = code.isNotEmpty && discount > 0;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           promoApplied
//               ? "Promo applied: -₹${discount.toStringAsFixed(0)}"
//               : "Promo not eligible / invalid",
//         ),
//       ),
//     );
//   }

//   void _setTip(double v) {
//     tipCustomC.clear();
//     setState(() => tip = v);
//   }

//   void _useCustomTip() {
//     final t = double.tryParse(tipCustomC.text.trim());
//     if (t == null || t < 0) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Enter a valid tip")));
//       return;
//     }
//     setState(() => tip = t);
//   }

//   void _proceed() {
//     if (!_upiOk || !_cashOk || !_cardOk || !_hasBaseFare) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please complete required details")),
//       );
//       return;
//     }

//     final payload = {
//       "payment_method": paymentMethod,
//       "fare_breakdown": {
//         // ORIGINALS (as provided)
//         "base_fare": baseFare,
//         "distance_km": distanceKm,
//         "eta_mins": etaMins,
//         "per_km_rate": perKmRate,
//         "stops_count": stopsCount,
//         "per_stop_charge": perStopCharge,

//         // INFO components (calculated but NOT used to override base fare)
//         "distance_component_info": _distanceComponent,
//         "stops_component_info": _stopsComponent,

//         // Adjustments
//         "promo_discount": promoDiscount,
//         "tip": tip,
//       },
//       "note": noteC.text.trim(),
//       "total_payable": _grandTotal,
//       "payment_details": {
//         "upi_vpa": upiVpaC.text.trim(),
//         "cash_given": double.tryParse(cashGivenC.text.trim()) ?? 0,
//         "card_last4": cardLast4C.text.trim(),
//       }
//     };

//     Navigator.pop(context, payload);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//     final double padSm = width * 0.03;
//     final double padMd = width * 0.04;
//     final double br = width * 0.035;
//     final double blur = width * 0.025;

//     Future<void> payViaUpiIntent({
//       required String vpa, // e.g. "yourname@upi" or merchant VPA
//       required String name, // “DriveX”
//       required double amount,
//       String? txnNote,
//     }) async {
//       final uri = Uri.parse(
//         'upi://pay?pa=$vpa&pn=$name&am=${amount.toStringAsFixed(2)}'
//         '&tn=${Uri.encodeComponent(txnNote ?? "Ride payment")}&cu=INR',
//       );
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         // show fallback / error snackbar
//       }
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F7),
//       appBar: AppBar(
//         title: Text("Payment", style: TextStyle(fontSize: width * 0.048)),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.fromLTRB(
//                   width * 0.05, width * 0.03, width * 0.05, width * 0.34),
//               children: [
//                 // -------- ORIGINAL SUMMARY (just display what was passed) --------
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text("Ride Summary",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       // _kvLine(
//                       //     width,
//                       //     "Base Fare (original)",
//                       //     baseFare != null
//                       //         ? "₹${baseFare!.toStringAsFixed(0)}"
//                       //         : "--"),
//                       _kvLine(
//                           width,
//                           "Distance",
//                           distanceKm != null
//                               ? "${distanceKm!.toStringAsFixed(1)} km"
//                               : "--"),
//                       _kvLine(width, "ETA",
//                           etaMins != null ? "~$etaMins min" : "--"),
//                       _kvLine(width, "Stops", stopsCount?.toString() ?? "--"),
//                       _kvLine(
//                           width,
//                           "Per-km Rate",
//                           perKmRate != null
//                               ? "₹${perKmRate!.toStringAsFixed(0)}"
//                               : "--"),
//                       _kvLine(width, "Per-stop Charge",
//                           perStopCharge != null ? "₹$perStopCharge" : "--"),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: width * 0.03),
//                         child: const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                       ),

//                       // Informational breakdown (does not modify base fare)
//                       _mathLine(
//                         width,
//                         left: "Per km: "
//                             "${perKmRate != null ? "₹${perKmRate!.toStringAsFixed(0)}" : "₹–"}"
//                             " × ${distanceKm != null ? distanceKm!.toStringAsFixed(1) : "–"} km",
//                         right: _distanceComponent > 0
//                             ? "₹${_distanceComponent.toStringAsFixed(0)}"
//                             : "—",
//                       ),
//                       SizedBox(height: width * 0.018),
//                       _mathLine(
//                         width,
//                         left:
//                             "Stops: ${stopsCount ?? "–"} × ₹${perStopCharge ?? "–"}",
//                         right: _stopsComponent > 0
//                             ? "₹${_stopsComponent.toStringAsFixed(0)}"
//                             : "—",
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: width * 0.03),
//                         child: const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                       ),

//                       // Subtotal starts from ORIGINAL base fare (minus promo only)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Subtotal (original – promo)",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: width * 0.038)),
//                           Text(
//                             baseFare != null
//                                 ? "₹${_subtotal.toStringAsFixed(0)}"
//                                 : "--",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: width * 0.040),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Promo (optional)
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Promo code (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: promoC,
//                               style: TextStyle(
//                                 fontSize: width * 0.034,
//                               ),
//                               textInputAction: TextInputAction.done,
//                               decoration: InputDecoration(
//                                 isDense: true, // makes height smaller
//                                 hintText: "Enter code",
//                                 hintStyle: TextStyle(
//                                   color: Colors.black45,
//                                   fontSize: width * 0.034,
//                                 ),
//                                 filled: true,
//                                 fillColor:
//                                     const Color(0xFFF7F9FC), // light background

//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: padMd * 0.8,
//                                   vertical: width * 0.018,
//                                 ),

//                                 // prefixIcon: Icon(Icons.discount_outlined,
//                                 //     color: Colors.blueAccent,
//                                 //     size: width * 0.045),

//                                 suffixIcon: promoC.text.isNotEmpty
//                                     ? IconButton(
//                                         icon: const Icon(Icons.clear,
//                                             color: Colors.black38),
//                                         iconSize: width * 0.045,
//                                         onPressed: () => promoC.clear(),
//                                       )
//                                     : null,

//                                 border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFFE1E6EF)),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFFE1E6EF)),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFF3B82F6), width: 1.2),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           FilledButton(
//                             onPressed: baseFare == null ? null : _applyPromo,
//                             child: const Text("Apply"),
//                           ),
//                         ],
//                       ),
//                       if (promoDiscount > 0) ...[
//                         SizedBox(height: width * 0.02),
//                         _mathLine(
//                           width,
//                           left: "Promo discount",
//                           right: "-₹${promoDiscount.toStringAsFixed(0)}",
//                           rightColor: Colors.green.shade700,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Tip (optional)
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Tip (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: [
//                           ChoiceChip(
//                               label: const Text("₹0"),
//                               selected: tip == 0,
//                               onSelected: (_) => _setTip(0)),
//                           ChoiceChip(
//                               label: const Text("₹10"),
//                               selected: tip == 10,
//                               onSelected: (_) => _setTip(10)),
//                           ChoiceChip(
//                               label: const Text("₹20"),
//                               selected: tip == 20,
//                               onSelected: (_) => _setTip(20)),
//                           ChoiceChip(
//                               label: const Text("₹50"),
//                               selected: tip == 50,
//                               onSelected: (_) => _setTip(50)),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: tipCustomC,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: "Custom amount",
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: padMd, vertical: padSm),
//                                 border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025)),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           OutlinedButton(
//                               onPressed: _useCustomTip,
//                               child: const Text("Set")),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Payment method
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Payment method",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.01),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "UPI",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("UPI"),
//                         subtitle: paymentMethod == "UPI"
//                             ? TextField(
//                                 controller: upiVpaC,
//                                 decoration: const InputDecoration(
//                                     hintText: "yourname@upi"),
//                               )
//                             : null,
//                       ),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "Cash",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("Cash"),
//                         subtitle: paymentMethod == "Cash"
//                             ? TextField(
//                                 controller: cashGivenC,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                     hintText: "Cash given (₹)"),
//                               )
//                             : null,
//                       ),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "Card",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("Card"),
//                         subtitle: paymentMethod == "Card"
//                             ? TextField(
//                                 controller: cardLast4C,
//                                 maxLength: 4,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                     hintText: "Last 4 digits", counterText: ""),
//                               )
//                             : null,
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Notes
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Notes (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       TextField(
//                         controller: noteC,
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           hintText: "Any special instruction…",
//                           contentPadding: EdgeInsets.all(padMd),
//                           border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(width * .025)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // -------- Sticky bottom: Total + Proceed --------
//           Container(
//             padding: EdgeInsets.fromLTRB(
//               width * 0.05,
//               padSm,
//               width * 0.05,
//               padSm + MediaQuery.of(context).padding.bottom,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(width * 0.045)),
//               boxShadow: [
//                 BoxShadow(
//                     blurRadius: width * 0.045,
//                     color: Colors.black12,
//                     offset: Offset(0, -width * 0.015))
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: padMd, vertical: padSm),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F5F9),
//                       borderRadius: BorderRadius.circular(width * 0.035),
//                       border: Border.all(color: const Color(0xFFE9ECF2)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Tip",
//                                 style: TextStyle(
//                                     fontSize: width * 0.033,
//                                     color: Colors.black54)),
//                             Text("₹${tip.toStringAsFixed(0)}",
//                                 style: TextStyle(
//                                     fontSize: width * 0.035,
//                                     fontWeight: FontWeight.w700)),
//                           ],
//                         ),
//                         SizedBox(height: width * 0.01),
//                         const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                         SizedBox(height: width * 0.01),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Total",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * 0.040)),
//                             Text(
//                               baseFare != null
//                                   ? "₹${_grandTotal.toStringAsFixed(0)}"
//                                   : "--",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: width * 0.045),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: width * 0.03),
//                 FilledButton.icon(
//                   onPressed: (_upiOk && _cashOk && _cardOk && _hasBaseFare)
//                       ? _proceed
//                       : null,
//                   icon: const Icon(Icons.check_circle),
//                   label: Text("Proceed",
//                       style: TextStyle(fontSize: width * 0.038)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ------- little UI helpers (no external widgets) -------
//   Widget _kvLine(double width, String k, String v) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: width * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(k,
//               style: TextStyle(color: Colors.black54, fontSize: width * 0.034)),
//           Text(v,
//               style: TextStyle(
//                   fontSize: width * 0.036, fontWeight: FontWeight.w700)),
//         ],
//       ),
//     );
//   }

//   Widget _mathLine(double width,
//       {required String left, required String right, Color? rightColor}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//             child: Text(left,
//                 style:
//                     TextStyle(fontSize: width * 0.034, color: Colors.black87))),
//         Text(
//           right,
//           style: TextStyle(
//             fontSize: width * 0.036,
//             fontWeight: FontWeight.w700,
//             color: rightColor ?? Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// }

// ---------------------------------

// import 'dart:io';

// import 'package:android_intent_plus/android_intent.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class D2dPaymentpage extends StatefulWidget {
//   const D2dPaymentpage({super.key});

//   @override
//   State<D2dPaymentpage> createState() => _D2dPaymentpageState();
// }

// class _UpiApp {
//   final String name;
//   final String package;
//   final IconData icon;
//   const _UpiApp(this.name, this.package, this.icon);
// }

// final List<_UpiApp> _upiApps = const [
//   _UpiApp("GPay", "com.google.android.apps.nbu.paisa.user",
//       Icons.account_balance_wallet_outlined),
//   _UpiApp("PhonePe", "com.phonepe.app", Icons.payments_outlined),
//   _UpiApp("Paytm", "net.one97.paytm", Icons.account_balance_outlined),
//   _UpiApp("BHIM", "in.org.npci.upiapp", Icons.account_balance_wallet),
// ];

// class _D2dPaymentpageState extends State<D2dPaymentpage> {
//   // -------- Original inputs (all nullable; NO presets) --------
//   double? baseFare; // original fare from previous page (required by you)
//   double? distanceKm; // informational
//   int? etaMins; // informational
//   int? stopsCount; // informational
//   double? perKmRate; // informational
//   int? perStopCharge; // informational

//   late Razorpay _rzp;
//   Future<void> _openSpecificUpiApp({
//     required _UpiApp app,
//     required String vpa, // your merchant VPA
//     required String name, // “DriveX”
//     required double amount, // _grandTotal
//     String? txnNote,
//   }) async {
//     final upiUri = 'upi://pay?pa=$vpa&pn=$name&am=${amount.toStringAsFixed(2)}'
//         '&tn=${Uri.encodeComponent(txnNote ?? "Ride payment")}&cu=INR';

//     if (!Platform.isAndroid) {
//       // iOS can't target a specific UPI app reliably → fallback to generic
//       await payViaUpiIntent(
//           vpa: vpa, name: name, amount: amount, txnNote: txnNote);
//       return;
//     }

//     try {
//       final intent = AndroidIntent(
//         action: 'action_view',
//         data: upiUri,
//         package: app.package, // ← forces that specific app
//       );
//       await intent.launch();
//     } catch (_) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${app.name} not available on this device')),
//         );
//       }
//     }
//   }

//   // -------- UI state --------
//   String paymentMethod = "UPI"; // default visual choice but no hidden values
//   final TextEditingController upiVpaC = TextEditingController();
//   final TextEditingController cashGivenC = TextEditingController();
//   final TextEditingController cardLast4C = TextEditingController();
//   final TextEditingController promoC = TextEditingController();
//   final TextEditingController tipCustomC = TextEditingController();
//   final TextEditingController noteC = TextEditingController();

//   // -------- Pricing extras (do not alter original fare) --------
//   double promoDiscount = 0; // applied on top of original fare (subtract)
//   double tip = 0; // optional add
//   bool promoApplied = false;

//   // Derived (informational only; does not change baseFare)
//   double get _distanceComponent {
//     if (distanceKm == null || perKmRate == null) return 0;
//     return distanceKm! * perKmRate!;
//   }

//   double get _stopsComponent {
//     if (stopsCount == null || perStopCharge == null) return 0;
//     return (stopsCount! * perStopCharge!).toDouble();
//   }

//   // Payable math — starts from original baseFare only
//   double get _subtotal {
//     if (baseFare == null) return 0;
//     final v = baseFare! - promoDiscount;
//     return v < 0 ? 0 : v;
//   }

//   double get _grandTotal => _subtotal + tip;

//   // Payment helpers
//   bool get _isUPI => paymentMethod == "UPI";
//   bool get _isCash => paymentMethod == "Cash";
//   bool get _isCard => paymentMethod == "Card";

//   // Validation helpers
//   bool get _upiOk => !_isUPI || upiVpaC.text.trim().contains("@");
//   bool get _cashOk {
//     if (!_isCash) return true;
//     final v = double.tryParse(cashGivenC.text.trim());
//     return v != null && v >= _grandTotal && _grandTotal > 0;
//   }

//   bool get _cardOk => !_isCard || cardLast4C.text.trim().length == 4;
//   bool get _hasBaseFare => baseFare != null;

//   // Enable Proceed if base fare exists and ONE method is valid
//   bool get _canProceed => _hasBaseFare && (_upiOk || _cashOk || _cardOk);

//   @override
//   void initState() {
//     super.initState();

//     _rzp = Razorpay();
//     _rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
//     _rzp.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
//     _rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternal);

//     // Rebuild when promo text changes (so suffixIcon toggles)
//     promoC.addListener(() {
//       if (mounted) setState(() {});
//     });

//     // Read arguments only; DO NOT inject demo values
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is Map) {
//         baseFare = (args['fare'] as num?)?.toDouble();
//         distanceKm = (args['distance_km'] as num?)?.toDouble();
//         etaMins = (args['eta_mins'] as num?)?.toInt();
//         stopsCount = (args['stops_count'] as num?)?.toInt();
//         perKmRate = (args['per_km_rate'] as num?)?.toDouble();
//         perStopCharge = (args['per_stop_charge'] as num?)?.toInt();
//         setState(() {});
//       }
//     });
//   }

//   // ---------- Payments ----------

//   Future<void> payViaUpiIntent({
//     required String vpa, // e.g. "yourmerchant@upi"
//     required String name, // “DriveX”
//     required double amount,
//     String? txnNote,
//   }) async {
//     final uri = Uri.parse(
//       'upi://pay?pa=$vpa&pn=$name&am=${amount.toStringAsFixed(2)}'
//       '&tn=${Uri.encodeComponent(txnNote ?? "Ride payment")}&cu=INR',
//     );
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No UPI app available")),
//         );
//       }
//     }
//   }

//   void startRazorpayCheckout({
//     required String orderId, // from your server
//     required int amountPaise,
//     required String customerName,
//     required String customerPhone,
//     required String customerEmail,
//   }) {
//     final options = {
//       'key': '<YOUR_RAZORPAY_KEY_ID>',
//       'amount': amountPaise, // e.g. (grandTotal * 100).round()
//       'currency': 'INR',
//       'name': 'DriveX',
//       'description': 'Ride payment',
//       'order_id': orderId,
//       'prefill': {
//         'contact': customerPhone,
//         'email': customerEmail,
//         'name': customerName,
//       },
//       'theme': {'color': '#2563EB'},
//     };
//     _rzp.open(options);
//   }

//   Future<String> _createOrderOnServer(int amountPaise) async {
//     // TODO: Replace with real API call to your backend to create an order.
//     // Must return Razorpay order_id.
//     return "<ORDER_ID_FROM_SERVER>";
//   }

//   void _onSuccess(PaymentSuccessResponse r) async {
//     // Send r.orderId, r.paymentId, r.signature to your server
//     // Server verifies signature → mark paid → return final receipt to app
//     _finishWithPayload(status: "card_success", extra: {
//       "razorpay_order_id": r.orderId,
//       "razorpay_payment_id": r.paymentId,
//       "razorpay_signature": r.signature,
//     });
//   }

//   void _onError(PaymentFailureResponse r) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment failed: ${r.code}")),
//     );
//   }

//   void _onExternal(ExternalWalletResponse r) {
//     // Optional
//   }

//   @override
//   void dispose() {
//     _rzp.clear();

//     upiVpaC.dispose();
//     cashGivenC.dispose();
//     cardLast4C.dispose();
//     promoC.dispose();
//     tipCustomC.dispose();
//     noteC.dispose();
//     super.dispose();
//   }

//   void _applyPromo() {
//     final code = promoC.text.trim().toUpperCase();
//     double discount = 0;

//     // Example demo rules (replace with server rules if needed)
//     if (code == "DA50" && (baseFare ?? 0) >= 200) {
//       discount = 50;
//     } else if (code == "KM5" && _distanceComponent > 0) {
//       discount = _distanceComponent * 0.05;
//     } else if (code == "STOP10" && _stopsComponent > 0) {
//       discount = _stopsComponent * 0.10;
//     } else {
//       discount = 0;
//     }

//     setState(() {
//       promoDiscount = discount;
//       promoApplied = code.isNotEmpty && discount > 0;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           promoApplied
//               ? "Promo applied: -₹${discount.toStringAsFixed(0)}"
//               : "Promo not eligible / invalid",
//         ),
//       ),
//     );
//   }

//   void _setTip(double v) {
//     tipCustomC.clear();
//     setState(() => tip = v);
//   }

//   void _useCustomTip() {
//     final t = double.tryParse(tipCustomC.text.trim());
//     if (t == null || t < 0) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Enter a valid tip")));
//       return;
//     }
//     setState(() => tip = t);
//   }

//   void _finishWithPayload(
//       {required String status, Map<String, dynamic>? extra}) {
//     final payload = {
//       "status": status,
//       "payment_method": paymentMethod,
//       "fare_breakdown": {
//         // ORIGINALS (as provided)
//         "base_fare": baseFare,
//         "distance_km": distanceKm,
//         "eta_mins": etaMins,
//         "per_km_rate": perKmRate,
//         "stops_count": stopsCount,
//         "per_stop_charge": perStopCharge,

//         // INFO components (calculated but NOT used to override base fare)
//         "distance_component_info": _distanceComponent,
//         "stops_component_info": _stopsComponent,

//         // Adjustments
//         "promo_discount": promoDiscount,
//         "tip": tip,
//       },
//       "note": noteC.text.trim(),
//       "total_payable": _grandTotal,
//       "payment_details": {
//         "upi_vpa": upiVpaC.text.trim(),
//         "cash_given": double.tryParse(cashGivenC.text.trim()) ?? 0,
//         "card_last4": cardLast4C.text.trim(),
//       }
//     };

//     // if (extra != null) payload.addAll(extra);
//     Navigator.pop(context, payload);
//   }

//   void _proceed() async {
//     if (!_canProceed) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please complete required details")),
//       );
//       return;
//     }

//     if (_isCash) {
//       final cash = double.tryParse(cashGivenC.text.trim()) ?? 0;
//       final change = (cash - _grandTotal).clamp(0, double.infinity);
//       _finishWithPayload(
//           status: "cash_confirmed", extra: {"cash_change": change});
//       return;
//     }

//     if (_isUPI) {
//       await payViaUpiIntent(
//         vpa: upiVpaC.text.trim(),
//         name: "DriveX",
//         amount: _grandTotal,
//         txnNote: "Ride payment",
//       );
//       _finishWithPayload(status: "upi_initiated");
//       return;
//     }

//     if (_isCard) {
//       final orderId = await _createOrderOnServer((_grandTotal * 100).round());
//       startRazorpayCheckout(
//         orderId: orderId,
//         amountPaise: (_grandTotal * 100).round(),
//         customerName: "Customer",
//         customerPhone: "0000000000",
//         customerEmail: "user@example.com",
//       );
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//     final double padSm = width * 0.03;
//     final double padMd = width * 0.04;
//     final double br = width * 0.035;
//     final double blur = width * 0.025;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F7),
//       appBar: AppBar(
//         title: Text("Payment", style: TextStyle(fontSize: width * 0.048)),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.fromLTRB(
//                   width * 0.05, width * 0.03, width * 0.05, width * 0.34),
//               children: [
//                 // -------- ORIGINAL SUMMARY (just display what was passed) --------
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text("Ride Summary",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       _kvLine(
//                           width,
//                           "Distance",
//                           distanceKm != null
//                               ? "${distanceKm!.toStringAsFixed(1)} km"
//                               : "--"),
//                       _kvLine(width, "ETA",
//                           etaMins != null ? "~$etaMins min" : "--"),
//                       _kvLine(width, "Stops", stopsCount?.toString() ?? "--"),
//                       _kvLine(
//                           width,
//                           "Per-km Rate",
//                           perKmRate != null
//                               ? "₹${perKmRate!.toStringAsFixed(0)}"
//                               : "--"),
//                       _kvLine(width, "Per-stop Charge",
//                           perStopCharge != null ? "₹$perStopCharge" : "--"),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: width * 0.03),
//                         child: const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                       ),

//                       // Informational breakdown (does not modify base fare)
//                       _mathLine(
//                         width,
//                         left: "Per km: "
//                             "${perKmRate != null ? "₹${perKmRate!.toStringAsFixed(0)}" : "₹–"}"
//                             " × ${distanceKm != null ? distanceKm!.toStringAsFixed(1) : "–"} km",
//                         right: _distanceComponent > 0
//                             ? "₹${_distanceComponent.toStringAsFixed(0)}"
//                             : "—",
//                       ),
//                       SizedBox(height: width * 0.018),
//                       _mathLine(
//                         width,
//                         left:
//                             "Stops: ${stopsCount ?? "–"} × ₹${perStopCharge ?? "–"}",
//                         right: _stopsComponent > 0
//                             ? "₹${_stopsComponent.toStringAsFixed(0)}"
//                             : "—",
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: width * 0.03),
//                         child: const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                       ),

//                       // Subtotal starts from ORIGINAL base fare (minus promo only)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Subtotal (original – promo)",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: width * 0.038)),
//                           Text(
//                             baseFare != null
//                                 ? "₹${_subtotal.toStringAsFixed(0)}"
//                                 : "--",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: width * 0.040),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Promo (optional)
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Promo code (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: promoC,
//                               style: TextStyle(fontSize: width * 0.034),
//                               textInputAction: TextInputAction.done,
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 hintText: "Enter code",
//                                 hintStyle: TextStyle(
//                                   color: Colors.black45,
//                                   fontSize: width * 0.034,
//                                 ),
//                                 filled: true,
//                                 fillColor: const Color(0xFFF7F9FC),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: padMd * 0.8,
//                                   vertical: width * 0.018,
//                                 ),
//                                 suffixIcon: promoC.text.isNotEmpty
//                                     ? IconButton(
//                                         icon: const Icon(Icons.clear,
//                                             color: Colors.black38),
//                                         iconSize: width * 0.045,
//                                         onPressed: () => promoC.clear(),
//                                       )
//                                     : null,
//                                 border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFFE1E6EF)),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFFE1E6EF)),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFF3B82F6), width: 1.2),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           FilledButton(
//                             onPressed: baseFare == null ? null : _applyPromo,
//                             child: const Text("Apply"),
//                           ),
//                         ],
//                       ),
//                       if (promoDiscount > 0) ...[
//                         SizedBox(height: width * 0.02),
//                         _mathLine(
//                           width,
//                           left: "Promo discount",
//                           right: "-₹${promoDiscount.toStringAsFixed(0)}",
//                           rightColor: Colors.green.shade700,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Tip (optional)
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Tip (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: [
//                           ChoiceChip(
//                               label: const Text("₹0"),
//                               selected: tip == 0,
//                               onSelected: (_) => _setTip(0)),
//                           ChoiceChip(
//                               label: const Text("₹10"),
//                               selected: tip == 10,
//                               onSelected: (_) => _setTip(10)),
//                           ChoiceChip(
//                               label: const Text("₹20"),
//                               selected: tip == 20,
//                               onSelected: (_) => _setTip(20)),
//                           ChoiceChip(
//                               label: const Text("₹50"),
//                               selected: tip == 50,
//                               onSelected: (_) => _setTip(50)),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: tipCustomC,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: "Custom amount",
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: padMd, vertical: padSm),
//                                 border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025)),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           OutlinedButton(
//                               onPressed: _useCustomTip,
//                               child: const Text("Set")),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),
//                 // --- Pay with UPI app (quick launch) ---
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Pay with UPI app",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: upiVpaC,
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 hintText: "Merchant UPI ID (e.g. drivex@upi)",
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: padMd * 0.8,
//                                     vertical: width * 0.018),
//                                 border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * 0.025)),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.02),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: padMd * 0.6,
//                                 vertical: width * 0.018),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF3F5F9),
//                               borderRadius: BorderRadius.circular(999),
//                               border:
//                                   Border.all(color: const Color(0xFFE1E6EF)),
//                             ),
//                             child: Text(
//                               baseFare != null
//                                   ? "₹${_grandTotal.toStringAsFixed(0)}"
//                                   : "₹—",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: width * 0.034),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: width * 0.02),
//                       Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: _upiApps.map((app) {
//                           return GestureDetector(
//                             onTap: (baseFare == null ||
//                                     upiVpaC.text.trim().isEmpty)
//                                 ? null
//                                 : () => _openSpecificUpiApp(
//                                       app: app,
//                                       vpa: upiVpaC.text.trim(),
//                                       name: "DriveX",
//                                       amount: _grandTotal,
//                                       txnNote:
//                                           "Ride #${DateTime.now().millisecondsSinceEpoch}",
//                                     ),
//                             child: Opacity(
//                               opacity: (baseFare == null ||
//                                       upiVpaC.text.trim().isEmpty)
//                                   ? 0.5
//                                   : 1,
//                               child: Container(
//                                 width: (width - (width * 0.05 * 2) - 10 * 3) /
//                                     4, // 4 per row
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: width * 0.035),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF7F9FC),
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                       color: const Color(0xFFE1E6EF)),
//                                 ),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(app.icon,
//                                         size: width * 0.07,
//                                         color: Colors.blueAccent),
//                                     SizedBox(height: 6),
//                                     Text(app.name,
//                                         style: TextStyle(
//                                             fontSize: width * 0.030,
//                                             fontWeight: FontWeight.w600)),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       SizedBox(height: width * 0.01),
//                       Text(
//                         "Tip: enter your merchant UPI ID to enable quick launch.",
//                         style: TextStyle(
//                             fontSize: width * 0.030, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Payment method
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Payment method",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.01),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "UPI",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("UPI"),
//                         subtitle: paymentMethod == "UPI"
//                             ? TextField(
//                                 controller: upiVpaC,
//                                 decoration: const InputDecoration(
//                                     hintText: "yourname@upi"),
//                               )
//                             : null,
//                       ),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "Cash",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("Cash"),
//                         subtitle: paymentMethod == "Cash"
//                             ? TextField(
//                                 controller: cashGivenC,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                     hintText: "Cash given (₹)"),
//                               )
//                             : null,
//                       ),
//                       RadioListTile<String>(
//                         dense: true,
//                         value: "Card",
//                         groupValue: paymentMethod,
//                         onChanged: (v) => setState(() => paymentMethod = v!),
//                         title: const Text("Card"),
//                         subtitle: paymentMethod == "Card"
//                             ? TextField(
//                                 controller: cardLast4C,
//                                 maxLength: 4,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                     hintText: "Last 4 digits", counterText: ""),
//                               )
//                             : null,
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: width * 0.04),

//                 // Notes
//                 Container(
//                   padding: EdgeInsets.all(padMd),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(br),
//                     border: Border.all(color: const Color(0xFFE9ECF2)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: blur,
//                           color: const Color(0x14000000),
//                           offset: Offset(0, width * 0.01))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Notes (optional)",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: width * 0.040)),
//                       SizedBox(height: width * 0.02),
//                       TextField(
//                         controller: noteC,
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           hintText: "Any special instruction…",
//                           contentPadding: EdgeInsets.all(padMd),
//                           border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(width * .025)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // -------- Sticky bottom: Total + Proceed --------
//           Container(
//             padding: EdgeInsets.fromLTRB(
//               width * 0.05,
//               padSm,
//               width * 0.05,
//               padSm + MediaQuery.of(context).padding.bottom,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(width * 0.045)),
//               boxShadow: [
//                 BoxShadow(
//                     blurRadius: width * 0.045,
//                     color: Colors.black12,
//                     offset: Offset(0, -width * 0.015))
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: padMd, vertical: padSm),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F5F9),
//                       borderRadius: BorderRadius.circular(width * 0.035),
//                       border: Border.all(color: const Color(0xFFE9ECF2)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Tip",
//                                 style: TextStyle(
//                                     fontSize: width * 0.033,
//                                     color: Colors.black54)),
//                             Text("₹${tip.toStringAsFixed(0)}",
//                                 style: TextStyle(
//                                     fontSize: width * 0.035,
//                                     fontWeight: FontWeight.w700)),
//                           ],
//                         ),
//                         SizedBox(height: width * 0.01),
//                         const Divider(
//                             height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
//                         SizedBox(height: width * 0.01),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Total",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * 0.040)),
//                             Text(
//                               baseFare != null
//                                   ? "₹${_grandTotal.toStringAsFixed(0)}"
//                                   : "--",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: width * 0.045),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: width * 0.03),
//                 FilledButton.icon(
//                   onPressed: _canProceed ? _proceed : null,
//                   icon: const Icon(Icons.check_circle),
//                   label: Text("Proceed",
//                       style: TextStyle(fontSize: width * 0.038)),
//                   style: FilledButton.styleFrom(
//                     backgroundColor: _canProceed
//                         ? Colors.blueAccent
//                         : Colors.blueAccent.withOpacity(0.4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(width * 0.025),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       vertical: width * 0.025,
//                       horizontal: width * 0.08,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ------- little UI helpers (no external widgets) -------
//   Widget _kvLine(double width, String k, String v) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: width * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(k,
//               style: TextStyle(color: Colors.black54, fontSize: width * 0.034)),
//           Text(v,
//               style: TextStyle(
//                   fontSize: width * 0.036, fontWeight: FontWeight.w700)),
//         ],
//       ),
//     );
//   }

//   Widget _mathLine(double width,
//       {required String left, required String right, Color? rightColor}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//             child: Text(left,
//                 style:
//                     TextStyle(fontSize: width * 0.034, color: Colors.black87))),
//         Text(
//           right,
//           style: TextStyle(
//             fontSize: width * 0.036,
//             fontWeight: FontWeight.w700,
//             color: rightColor ?? Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// }

// ------------------------------------------------------

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class D2dPaymentpage extends StatefulWidget {
  const D2dPaymentpage({super.key});

  @override
  State<D2dPaymentpage> createState() => _D2dPaymentpageState();
}

// ---------- UPI app model & list ----------
class _UpiApp {
  final String name;
  final String package;
  final IconData icon;
  const _UpiApp(this.name, this.package, this.icon);
}

final List<_UpiApp> _upiApps = const [
  _UpiApp("GPay", "com.google.android.apps.nbu.paisa.user",
      Icons.account_balance_wallet_outlined),
  _UpiApp("PhonePe", "com.phonepe.app", Icons.payments_outlined),
  _UpiApp("Paytm", "net.one97.paytm", Icons.account_balance_outlined),
  _UpiApp("BHIM", "in.org.npci.upiapp", Icons.account_balance_wallet),
];

class _D2dPaymentpageState extends State<D2dPaymentpage> {
  // -------- Original inputs (all nullable; NO presets) --------
  double? baseFare; // original fare from previous page (required by you)
  double? distanceKm; // informational
  int? etaMins; // informational
  int? stopsCount; // informational
  double? perKmRate; // informational
  int? perStopCharge; // informational

  late Razorpay _rzp;

  // -------- UI state --------
  String paymentMethod = "UPI"; // default visual choice but no hidden values
  final TextEditingController upiVpaC = TextEditingController();
  final TextEditingController cashGivenC = TextEditingController();
  final TextEditingController cardLast4C = TextEditingController();
  final TextEditingController promoC = TextEditingController();
  final TextEditingController tipCustomC = TextEditingController();
  final TextEditingController noteC = TextEditingController();

  // -------- Pricing extras (do not alter original fare) --------
  double promoDiscount = 0; // applied on top of original fare (subtract)
  double tip = 0; // optional add
  bool promoApplied = false;

  // -------- Derived (informational only; does not change baseFare) --------
  double get _distanceComponent {
    if (distanceKm == null || perKmRate == null) return 0;
    return distanceKm! * perKmRate!;
  }

  double get _stopsComponent {
    if (stopsCount == null || perStopCharge == null) return 0;
    return (stopsCount! * perStopCharge!).toDouble();
  }

  // Payable math — starts from original baseFare only
  double get _subtotal {
    if (baseFare == null) return 0;
    final v = baseFare! - promoDiscount;
    return v < 0 ? 0 : v;
  }

  double get _grandTotal => _subtotal + tip;

  // Payment helpers
  bool get _isUPI => paymentMethod == "UPI";
  bool get _isCash => paymentMethod == "Cash";
  bool get _isCard => paymentMethod == "Card";

  // Validation helpers
  bool get _upiOk => !_isUPI || upiVpaC.text.trim().contains("@");
  bool get _cashOk {
    if (!_isCash) return true;
    final v = double.tryParse(cashGivenC.text.trim());
    return v != null && v >= _grandTotal && _grandTotal > 0;
  }

  bool get _cardOk => !_isCard || cardLast4C.text.trim().length == 4;
  bool get _hasBaseFare => baseFare != null;

  // Enable Proceed if base fare exists and ONE method is valid
  bool get _canProceed => _hasBaseFare && (_upiOk || _cashOk || _cardOk);

  @override
  void initState() {
    super.initState();

    _rzp = Razorpay();
    _rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _rzp.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternal);

    // Rebuild when promo text changes (so suffixIcon toggles)
    promoC.addListener(() {
      if (mounted) setState(() {});
    });

    // Read arguments only; DO NOT inject demo values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        baseFare = (args['fare'] as num?)?.toDouble();
        distanceKm = (args['distance_km'] as num?)?.toDouble();
        etaMins = (args['eta_mins'] as num?)?.toInt();
        stopsCount = (args['stops_count'] as num?)?.toInt();
        perKmRate = (args['per_km_rate'] as num?)?.toDouble();
        perStopCharge = (args['per_stop_charge'] as num?)?.toInt();
        setState(() {});
      }
    });
  }

  // ---------- Payments ----------

  // Open generic UPI chooser (or iOS-compatible)
  Future<void> payViaUpiIntent({
    required String vpa, // e.g. "yourmerchant@upi"
    required String name, // “DriveX”
    required double amount,
    String? txnNote,
  }) async {
    final uri = Uri.parse(
      'upi://pay?pa=$vpa&pn=$name&am=${amount.toStringAsFixed(2)}'
      '&tn=${Uri.encodeComponent(txnNote ?? "Ride payment")}&cu=INR',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No UPI app available")),
        );
      }
    }
  }

  // Open a specific Android UPI app directly
  Future<void> _openSpecificUpiApp({
    required _UpiApp app,
    required String vpa, // your merchant VPA
    required String name, // “DriveX”
    required double amount, // _grandTotal
    String? txnNote,
  }) async {
    final upiUri = 'upi://pay?pa=$vpa&pn=$name&am=${amount.toStringAsFixed(2)}'
        '&tn=${Uri.encodeComponent(txnNote ?? "Ride payment")}&cu=INR';

    if (!Platform.isAndroid) {
      // iOS can't target a specific UPI app reliably → fallback to generic
      await payViaUpiIntent(
        vpa: vpa,
        name: name,
        amount: amount,
        txnNote: txnNote,
      );
      return;
    }

    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data: upiUri,
        package: app.package, // ← target that specific app
      );
      await intent.launch();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${app.name} not available on this device')),
        );
      }
    }
  }

  void startRazorpayCheckout({
    required String orderId, // from your server
    required int amountPaise,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
  }) {
    final options = {
      'key': '<YOUR_RAZORPAY_KEY_ID>',
      'amount': amountPaise, // e.g. (grandTotal * 100).round()
      'currency': 'INR',
      'name': 'DriveX',
      'description': 'Ride payment',
      'order_id': orderId,
      'prefill': {
        'contact': customerPhone,
        'email': customerEmail,
        'name': customerName,
      },
      'theme': {'color': '#2563EB'},
    };
    _rzp.open(options);
  }

  Future<String> _createOrderOnServer(int amountPaise) async {
    // TODO: Replace with real API call to your backend to create an order.
    // Must return Razorpay order_id.
    return "<ORDER_ID_FROM_SERVER>";
  }

  void _onSuccess(PaymentSuccessResponse r) async {
    // Send r.orderId, r.paymentId, r.signature to your server
    // Server verifies signature → mark paid → return final receipt to app
    _finishWithPayload(status: "card_success", extra: {
      "razorpay_order_id": r.orderId,
      "razorpay_payment_id": r.paymentId,
      "razorpay_signature": r.signature,
    });
  }

  void _onError(PaymentFailureResponse r) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${r.code}")),
    );
  }

  void _onExternal(ExternalWalletResponse r) {
    // Optional
  }

  @override
  void dispose() {
    _rzp.clear();

    upiVpaC.dispose();
    cashGivenC.dispose();
    cardLast4C.dispose();
    promoC.dispose();
    tipCustomC.dispose();
    noteC.dispose();
    super.dispose();
  }

  // ---------- Pricing UI actions ----------
  void _applyPromo() {
    final code = promoC.text.trim().toUpperCase();
    double discount = 0;

    // Example demo rules (replace with server rules if needed)
    if (code == "DA50" && (baseFare ?? 0) >= 200) {
      discount = 50;
    } else if (code == "KM5" && _distanceComponent > 0) {
      discount = _distanceComponent * 0.05;
    } else if (code == "STOP10" && _stopsComponent > 0) {
      discount = _stopsComponent * 0.10;
    } else {
      discount = 0;
    }

    setState(() {
      promoDiscount = discount;
      promoApplied = code.isNotEmpty && discount > 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          promoApplied
              ? "Promo applied: -₹${discount.toStringAsFixed(0)}"
              : "Promo not eligible / invalid",
        ),
      ),
    );
  }

  void _setTip(double v) {
    tipCustomC.clear();
    setState(() => tip = v);
  }

  void _useCustomTip() {
    final t = double.tryParse(tipCustomC.text.trim());
    if (t == null || t < 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter a valid tip")));
      return;
    }
    setState(() => tip = t);
  }

  // ---------- Finish / Proceed ----------
  void _finishWithPayload({
    required String status,
    Map<String, dynamic>? extra,
  }) {
    final payload = {
      "status": status,
      "payment_method": paymentMethod,
      "fare_breakdown": {
        // ORIGINALS (as provided)
        "base_fare": baseFare,
        "distance_km": distanceKm,
        "eta_mins": etaMins,
        "per_km_rate": perKmRate,
        "stops_count": stopsCount,
        "per_stop_charge": perStopCharge,

        // INFO components (calculated but NOT used to override base fare)
        "distance_component_info": _distanceComponent,
        "stops_component_info": _stopsComponent,

        // Adjustments
        "promo_discount": promoDiscount,
        "tip": tip,
      },
      "note": noteC.text.trim(),
      "total_payable": _grandTotal,
      "payment_details": {
        "upi_vpa": upiVpaC.text.trim(),
        "cash_given": double.tryParse(cashGivenC.text.trim()) ?? 0,
        "card_last4": cardLast4C.text.trim(),
      }
    };

    if (extra != null) payload.addAll(extra.cast<String, Object>());
    Navigator.pop(context, payload);
  }

  void _proceed() async {
    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete required details")),
      );
      return;
    }

    if (_isCash) {
      final cash = double.tryParse(cashGivenC.text.trim()) ?? 0;
      final change = (cash - _grandTotal).clamp(0, double.infinity);
      _finishWithPayload(
        status: "cash_confirmed",
        extra: {"cash_change": change},
      );
      return;
    }

    if (_isUPI) {
      await payViaUpiIntent(
        vpa: upiVpaC.text.trim(),
        name: "DriveX",
        amount: _grandTotal,
        txnNote: "Ride payment",
      );
      _finishWithPayload(status: "upi_initiated");
      return;
    }

    if (_isCard) {
      final orderId = await _createOrderOnServer((_grandTotal * 100).round());
      startRazorpayCheckout(
        orderId: orderId,
        amountPaise: (_grandTotal * 100).round(),
        customerName: "Customer",
        customerPhone: "0000000000",
        customerEmail: "user@example.com",
      );
      // Success/error handled in callbacks
      return;
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final double padSm = width * 0.03;
    final double padMd = width * 0.04;
    final double br = width * 0.035;
    final double blur = width * 0.025;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F7),
      appBar: AppBar(
        title: Text("Payment", style: TextStyle(fontSize: width * 0.048)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, width * 0.03, width * 0.05, width * 0.34),
              children: [
                // -------- Ride Summary --------
                Container(
                  padding: EdgeInsets.all(padMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(br),
                    border: Border.all(color: const Color(0xFFE9ECF2)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: blur,
                          color: const Color(0x14000000),
                          offset: Offset(0, width * 0.01))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Ride Summary",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.040)),
                      SizedBox(height: width * 0.02),
                      _kvLine(
                          width,
                          "Distance",
                          distanceKm != null
                              ? "${distanceKm!.toStringAsFixed(1)} km"
                              : "--"),
                      _kvLine(width, "ETA",
                          etaMins != null ? "~$etaMins min" : "--"),
                      _kvLine(width, "Stops", stopsCount?.toString() ?? "--"),
                      _kvLine(
                          width,
                          "Per-km Rate",
                          perKmRate != null
                              ? "₹${perKmRate!.toStringAsFixed(0)}"
                              : "--"),
                      _kvLine(width, "Per-stop Charge",
                          perStopCharge != null ? "₹$perStopCharge" : "--"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: width * 0.03),
                        child: const Divider(
                            height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
                      ),
                      _mathLine(
                        width,
                        left: "Per km: "
                            "${perKmRate != null ? "₹${perKmRate!.toStringAsFixed(0)}" : "₹–"}"
                            " × ${distanceKm != null ? distanceKm!.toStringAsFixed(1) : "–"} km",
                        right: _distanceComponent > 0
                            ? "₹${_distanceComponent.toStringAsFixed(0)}"
                            : "—",
                      ),
                      SizedBox(height: width * 0.018),
                      _mathLine(
                        width,
                        left:
                            "Stops: ${stopsCount ?? "–"} × ₹${perStopCharge ?? "–"}",
                        right: _stopsComponent > 0
                            ? "₹${_stopsComponent.toStringAsFixed(0)}"
                            : "—",
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: width * 0.03),
                        child: const Divider(
                            height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtotal (original – promo)",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.038)),
                          Text(
                            baseFare != null
                                ? "₹${_subtotal.toStringAsFixed(0)}"
                                : "--",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: width * 0.040),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // -------- Promo (optional) --------
                Container(
                  padding: EdgeInsets.all(padMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(br),
                    border: Border.all(color: const Color(0xFFE9ECF2)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: blur,
                          color: const Color(0x14000000),
                          offset: Offset(0, width * 0.01))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Promo code (optional)",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.040)),
                      SizedBox(height: width * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: promoC,
                              style: TextStyle(fontSize: width * 0.034),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Enter code",
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: width * 0.034,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF7F9FC),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: padMd * 0.8,
                                  vertical: width * 0.018,
                                ),
                                suffixIcon: promoC.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Colors.black38),
                                        iconSize: width * 0.045,
                                        onPressed: () => promoC.clear(),
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE1E6EF)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE1E6EF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3B82F6), width: 1.2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          FilledButton(
                            onPressed: baseFare == null ? null : _applyPromo,
                            child: const Text("Apply"),
                          ),
                        ],
                      ),
                      if (promoDiscount > 0) ...[
                        SizedBox(height: width * 0.02),
                        _mathLine(
                          width,
                          left: "Promo discount",
                          right: "-₹${promoDiscount.toStringAsFixed(0)}",
                          rightColor: Colors.green.shade700,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // -------- Tip (optional) --------
                Container(
                  padding: EdgeInsets.all(padMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(br),
                    border: Border.all(color: const Color(0xFFE9ECF2)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: blur,
                          color: const Color(0x14000000),
                          offset: Offset(0, width * 0.01))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tip (optional)",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.040)),
                      SizedBox(height: width * 0.02),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ChoiceChip(
                              label: const Text("₹0"),
                              selected: tip == 0,
                              onSelected: (_) => _setTip(0)),
                          ChoiceChip(
                              label: const Text("₹10"),
                              selected: tip == 10,
                              onSelected: (_) => _setTip(10)),
                          ChoiceChip(
                              label: const Text("₹20"),
                              selected: tip == 20,
                              onSelected: (_) => _setTip(20)),
                          ChoiceChip(
                              label: const Text("₹50"),
                              selected: tip == 50,
                              onSelected: (_) => _setTip(50)),
                        ],
                      ),
                      SizedBox(height: width * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tipCustomC,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Custom amount",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: padMd, vertical: padSm),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .025)),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          OutlinedButton(
                              onPressed: _useCustomTip,
                              child: const Text("Set")),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // -------- Pay with UPI app (quick launch) --------
                Container(
                  padding: EdgeInsets.all(padMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(br),
                    border: Border.all(color: const Color(0xFFE9ECF2)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: blur,
                          color: const Color(0x14000000),
                          offset: Offset(0, width * 0.01))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pay with UPI app",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.040)),
                      SizedBox(height: width * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: upiVpaC,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Merchant UPI ID (e.g. drivex@upi)",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: padMd * 0.8,
                                  vertical: width * 0.018,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: padMd * 0.6,
                              vertical: width * 0.018,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F5F9),
                              borderRadius: BorderRadius.circular(999),
                              border:
                                  Border.all(color: const Color(0xFFE1E6EF)),
                            ),
                            child: Text(
                              baseFare != null
                                  ? "₹${_grandTotal.toStringAsFixed(0)}"
                                  : "₹—",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.034,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.02),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _upiApps.map((app) {
                          final disabled =
                              (baseFare == null || upiVpaC.text.trim().isEmpty);
                          return GestureDetector(
                            onTap: disabled
                                ? null
                                : () => _openSpecificUpiApp(
                                      app: app,
                                      vpa: upiVpaC.text.trim(),
                                      name: "DriveX",
                                      amount: _grandTotal,
                                      txnNote:
                                          "Ride #${DateTime.now().millisecondsSinceEpoch}",
                                    ),
                            child: Opacity(
                              opacity: disabled ? 0.5 : 1,
                              child: Container(
                                width: (width - (width * 0.05 * 2) - 10 * 3) /
                                    4, // 4 per row
                                padding: EdgeInsets.symmetric(
                                    vertical: width * 0.035),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F9FC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFE1E6EF)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(app.icon,
                                        size: width * 0.07,
                                        color: Colors.blueAccent),
                                    const SizedBox(height: 6),
                                    Text(app.name,
                                        style: TextStyle(
                                            fontSize: width * 0.030,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: width * 0.01),
                      Text(
                        "Tip: enter your merchant UPI ID to enable quick launch.",
                        style: TextStyle(
                            fontSize: width * 0.030, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // -------- Payment method (fallback flows) --------
                Container(
                  padding: EdgeInsets.all(padMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(br),
                    border: Border.all(color: const Color(0xFFE9ECF2)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: blur,
                        color: const Color(0x14000000),
                        offset: Offset(0, width * 0.01),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment method",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.040)),
                      SizedBox(height: width * 0.01),
                      RadioListTile<String>(
                        dense: true,
                        value: "UPI",
                        groupValue: paymentMethod,
                        onChanged: (v) => setState(() => paymentMethod = v!),
                        title: const Text("UPI"),
                        subtitle: paymentMethod == "UPI"
                            ? TextField(
                                controller: upiVpaC,
                                decoration: const InputDecoration(
                                    hintText: "yourname@upi"),
                              )
                            : null,
                      ),
                      RadioListTile<String>(
                        dense: true,
                        value: "Cash",
                        groupValue: paymentMethod,
                        onChanged: (v) => setState(() => paymentMethod = v!),
                        title: const Text("Cash"),
                        subtitle: paymentMethod == "Cash"
                            ? TextField(
                                controller: cashGivenC,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Cash given (₹)"),
                              )
                            : null,
                      ),
                      RadioListTile<String>(
                        dense: true,
                        value: "Card",
                        groupValue: paymentMethod,
                        onChanged: (v) => setState(() => paymentMethod = v!),
                        title: const Text("Card"),
                        subtitle: paymentMethod == "Card"
                            ? TextField(
                                controller: cardLast4C,
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Last 4 digits", counterText: ""),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // -------- Notes --------
                Container(
                  padding: EdgeInsets.all(padMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(br),
                    border: Border.all(color: const Color(0xFFE9ECF2)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: blur,
                          color: const Color(0x14000000),
                          offset: Offset(0, width * 0.01))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Notes (optional)",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.040)),
                      SizedBox(height: width * 0.02),
                      TextField(
                        controller: noteC,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Any special instruction…",
                          contentPadding: EdgeInsets.all(padMd),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(width * .025)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // -------- Sticky bottom: Total + Proceed --------
          Container(
            padding: EdgeInsets.fromLTRB(
              width * 0.05,
              padSm,
              width * 0.05,
              padSm + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(width * 0.045)),
              boxShadow: [
                BoxShadow(
                    blurRadius: width * 0.045,
                    color: Colors.black12,
                    offset: Offset(0, -width * 0.015))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: padMd, vertical: padSm),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F9),
                      borderRadius: BorderRadius.circular(width * 0.035),
                      border: Border.all(color: const Color(0xFFE9ECF2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tip",
                                style: TextStyle(
                                    fontSize: width * 0.033,
                                    color: Colors.black54)),
                            Text("₹${tip.toStringAsFixed(0)}",
                                style: TextStyle(
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        SizedBox(height: width * 0.01),
                        const Divider(
                            height: 1, thickness: 1, color: Color(0xFFE1E6EF)),
                        SizedBox(height: width * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * 0.040)),
                            Text(
                              baseFare != null
                                  ? "₹${_grandTotal.toStringAsFixed(0)}"
                                  : "--",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: width * 0.045),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                FilledButton.icon(
                  onPressed: _canProceed ? _proceed : null,
                  icon: const Icon(Icons.check_circle),
                  label: Text("Proceed",
                      style: TextStyle(fontSize: width * 0.038)),
                  style: FilledButton.styleFrom(
                    backgroundColor: _canProceed
                        ? Colors.blueAccent
                        : Colors.blueAccent.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.025),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: width * 0.025,
                      horizontal: width * 0.08,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------- little UI helpers (no external widgets) -------
  Widget _kvLine(double width, String k, String v) {
    return Padding(
      padding: EdgeInsets.only(bottom: width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: TextStyle(color: Colors.black54, fontSize: width * 0.034)),
          Text(v,
              style: TextStyle(
                  fontSize: width * 0.036, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _mathLine(double width,
      {required String left, required String right, Color? rightColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(left,
                style:
                    TextStyle(fontSize: width * 0.034, color: Colors.black87))),
        Text(
          right,
          style: TextStyle(
            fontSize: width * 0.036,
            fontWeight: FontWeight.w700,
            color: rightColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
