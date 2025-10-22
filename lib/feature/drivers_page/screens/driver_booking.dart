import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/drivers_page/screens/drivers_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DriverBookingPage extends StatefulWidget {
  const DriverBookingPage({super.key});

  @override
  State<DriverBookingPage> createState() => _DriverBookingPageState();
}

class _DriverBookingPageState extends State<DriverBookingPage> {
  bool agreedToTerms = false;
  bool showError = false;
  DateTime? pickupDate;
  TimeOfDay? pickupTime;
  String selectedMethod = 'Cash';
  String? selectedPassenger;

  final passengerOptions = [
    "1 passenger",
    "2 passengers",
    "3 passengers",
    "4 passengers",
    "5 passengers",
    "6 passengers",
  ];

  final TextEditingController requestController = TextEditingController();

  String _formatDate(DateTime? date) {
    if (date == null) return "mm/dd/yyyy";
    return "${date.day}/${date.month}/${date.year}";
  }

  void pickPickupDate() async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) setState(() => pickupDate = dateTime);
  }

  void pickPickupTime() async {
    final TimeOfDay? time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => pickupTime = time);
  }
  String? selectedPriceType;
  String? carModelName;
  String _getSelectedPrice() {
    if (selectedPriceType == "Per Hour (₹150/hr)") {
      return "₹150/hr";
    } else if (selectedPriceType == "Per Day (₹1200/day)") {
      return "₹1200";
    } else if (selectedPriceType == "Outstation (₹2000 + Fuel)") {
      return "₹2000 + Fuel";
    }
    return "₹0";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Backgroundtopgradient(
        child: Padding(
          padding: EdgeInsets.only(
              left: width * 0.04, right: width * 0.04, bottom: width * 0.2),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width * 0.09),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: ColorConstant.thirdColor.withOpacity(0.7),
                      size: width * 0.045,
                    ),
                    SizedBox(width: width * 0.3),
                    Text(
                      "Booking Details",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.thirdColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.06),

                /// PICKUP & DROP LOCATIONS
                _buildLocationCard("Pickup Location", "Enter pickup location"),
                SizedBox(height: width * 0.04),
                _buildLocationCard("Drop-off Location", "Enter drop location"),


                SizedBox(height: width * 0.05),

                /// RENTAL DATE & TIME
                Text("Rental Date & Time",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.04,
                        color: ColorConstant.thirdColor)),
                SizedBox(height: width * 0.02),
                Row(
                  children: [
                    Expanded(child: _buildDatePicker()),
                    SizedBox(width: width * 0.03),
                    Expanded(child: _buildTimePicker()),
                  ],
                ),

                SizedBox(height: width * 0.05),

                /// PASSENGERS
                Text("Number of Passengers",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.04,
                        color: ColorConstant.thirdColor)),
                SizedBox(height: 6),
                SizedBox(
                  height: 48, // 👈 control the height
                  child: DropdownButtonFormField<String>(
                    hint: Text("Number of passengers"),
                    value: selectedPassenger,
                    decoration: InputDecoration(
                      isDense: true, // 👈 reduces default padding
                      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300), // 👈 border color when not focused
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300), // 👈 border color when focused
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: passengerOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedPassenger = value),
                  ),
                ),






                SizedBox(height: width * 0.05),

                Text("Select Price Type",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.04,
                        color: ColorConstant.thirdColor)),
                SizedBox(height: 6),

                DropdownButtonFormField<String>(
                  value: selectedPriceType,
                  decoration: InputDecoration(
                    labelText: "Price Type",
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Per Hour (₹150/hr)", "Per Day (₹1200/day)", "Outstation (₹2000 + Fuel)"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedPriceType = val;
                    });
                  },
                ),

                SizedBox(height: width * 0.05),

                /// PAYMENT METHOD
                Text("Payment Method *",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.04,
                        color: ColorConstant.thirdColor)),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMethod,
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      items: <String>['Cash', 'GPay', 'UPI', 'Card']
                          .map((value) => DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: [
                            Icon(
                              value == 'Cash'
                                  ? Icons.money
                                  : value == 'GPay'
                                  ? Icons.account_balance_wallet
                                  : value == 'UPI'
                                  ? Icons.qr_code_scanner
                                  : Icons.credit_card,
                              size: width * 0.05,
                              color:  Color(0xFF14A86A),
                            ),
                            SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      ))
                          .toList(),
                      onChanged: (newVal) =>
                          setState(() => selectedMethod = newVal!),
                    ),
                  ),
                ),

                SizedBox(height: width * 0.05),

                /// TERMS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: agreedToTerms,
                        onChanged: (val) {
                          setState(() {
                            agreedToTerms = val ?? false;
                            showError = !agreedToTerms;
                          });
                        }),
                    Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black87, fontSize: width * 0.035),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                              const TextSpan(
                                  text:
                                  ", Privacy Policy, and rental policies including cancellation and late charges."),
                            ],
                          ),
                        )),
                  ],
                ),
                if (showError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("Please accept Terms & Conditions",
                        style: TextStyle(color: Colors.red, fontSize: 13)),
                  ),

                SizedBox(height: width * 0.05),
                SizedBox(height: width * 0.05),

                /// CAR DETAILS
                Text("Your Car Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.045,
                        color: ColorConstant.thirdColor)),
                SizedBox(height: 10),

// Car Model
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      carModelName = val; // save car name dynamically
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Car Model / Name",
                    hintText: "Eg: Toyota Innova",
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(height: 12),

// Transmission
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Transmission",
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300), // 👈 border color when not focused
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300), // 👈 border color when focused
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Manual", "Automatic"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    // save transmission value here if needed
                  },
                ),
                SizedBox(height: 12),

// AC Availability
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "AC Availability",
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300), // 👈 border color when not focused
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300), // 👈 border color when focused
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Yes", "No"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    // save AC value here if needed
                  },
                ),

                SizedBox(height: width * 0.05),

                /// BOOKING SUMMARY
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Booking Summary",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(),

                      _buildSummaryRow("Car Model", carModelName ?? "Not entered"),
                      _buildSummaryRow("Date", pickupDate != null ? _formatDate(pickupDate) : "Not selected"),
                      _buildSummaryRow("Time", pickupTime != null ? pickupTime!.format(context) : "Not selected"),
                      _buildSummaryRow("Price Type", selectedPriceType ?? "Not selected"),

                      const Divider(),
                      _buildSummaryRow("Total Amount",
                          selectedPriceType == "Per Hour (₹150/hr)" ? "₹150/hr"
                              : selectedPriceType == "Per Day (₹1200/day)" ? "₹1200"
                              : selectedPriceType == "Outstation (₹2000 + Fuel)" ? "₹2000 + Fuel"
                              : "Pending",
                          highlight: true),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

      /// BOTTOM FIXED BAR
      bottomNavigationBar: Container(
        height: width * 0.18,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(
                  _getSelectedPrice(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),

              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (!agreedToTerms) {
                  setState(() => showError = true);
                  return;
                }
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(IconConstants.confirm_booking,
                            height: 60),
                        const SizedBox(height: 10),
                        const Text("Booking Confirmed ✅",
                            textAlign: TextAlign.center),
                      ],
                    ),
                    content: const Text(
                        "Your booking has been successfully confirmed.",
                        textAlign: TextAlign.center),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DriversListTabPage())),
                          child: const Text("OK")),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("View Info")),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xFF14A86A),
                  padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text("Confirm Booking",
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),);
  }

  /// --- HELPERS ---
  Widget _buildLocationCard(String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.04,
            color: ColorConstant.thirdColor,
          ),
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width * 0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(width * 0.02),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: width * 0.055,
                backgroundColor: ColorConstant.bgColor,
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: width * 0.05,
                  color:  Color(0xFF14A86A),
                ),
              ),
              SizedBox(width: width * 0.03),

              /// TextFormField for location input
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: width * 0.033,
                      color: ColorConstant.textColor2,
                    ),
                    border: InputBorder.none, // remove default underline
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: pickPickupDate,
      child: Container(
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(width * 0.02),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Date", style: TextStyle(color: Colors.grey)),
              Text(_formatDate(pickupDate),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.035,
                      color: ColorConstant.thirdColor)),
            ]),
            Icon(Icons.calendar_today, size: width * 0.05, color: ColorConstant.color11.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: pickPickupTime,
      child: Container(
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(width * 0.02),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Time", style: TextStyle(color: Colors.grey)),
              Text(
                  pickupTime != null
                      ? pickupTime!.format(context)
                      : "Select Time",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.035,
                      color: ColorConstant.thirdColor)),
            ]),
            Icon(Icons.access_time, size: width * 0.05, color: ColorConstant.color11.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: Colors.black54, fontSize: 14)),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                color: highlight ? Color(0xFF14A86A) : Colors.black87)),
      ]),
    );
  }
}
