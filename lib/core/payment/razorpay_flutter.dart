// import 'package:razorpay_flutter/razorpay_flutter.dart';

// late Razorpay _rzp;

// @override
// void initState() {
//   super.initState();
//   _rzp = Razorpay();
//   _rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
//   _rzp.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
//   _rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternal);
// }

// @override
// void dispose() {
//   _rzp.clear();
//   super.dispose();
// }

// void startRazorpayCheckout({
//   required String orderId, // from your server
//   required int amountPaise,
//   required String customerName,
//   required String customerPhone,
//   required String customerEmail,
// }) {
//   final options = {
//     'key': '<YOUR_RAZORPAY_KEY_ID>',
//     'amount': amountPaise, // e.g. (grandTotal * 100).round()
//     'currency': 'INR',
//     'name': 'DriveX',
//     'description': 'Ride payment',
//     'order_id': orderId,
//     'prefill': {
//       'contact': customerPhone,
//       'email': customerEmail,
//       'name': customerName,
//     },
//     'theme': {'color': '#2563EB'},
//   };
//   _rzp.open(options);
// }

// void _onSuccess(PaymentSuccessResponse r) async {
//   // Send r.orderId, r.paymentId, r.signature to your server
//   // Server verifies signature → mark paid → return final receipt to app
// }

// void _onError(PaymentFailureResponse r) {
//   // Show error
// }

// void _onExternal(ExternalWalletResponse r) {
//   // Optional
// }
