import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/material.dart';
import 'package:drivex/core/constants/color_constant.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController luggageController = TextEditingController();
  final TextEditingController emergencyController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  String? tripType;
  String? needVehicle;
  String? paymentMethod;
  String? tripFrequency;
  String selectedVehicle = 'Select';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int selectedPassengers = 1;

  final List<String> vehicleTypes = ['Select', 'Automatic', 'Manual'];
  final List<String> needVehicleOptions = ['Select', 'Yes', 'No'];
  final List<String> tripTypeOptions = ['Select', '1 Side', '2 Side'];
  final List<String> paymentOptions = ['Select', 'Cash', 'UPI', 'Card'];
  final List<String> tripFrequencyOptions = [
    'Select',
    'Only this time',
    'Daily'
  ];

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void _submitRequest() {
    if (tripType == null || tripType == 'Select') {
      _showSnackBar("Please select Trip Type.");
      return;
    }
    if (needVehicle == null || needVehicle == 'Select') {
      _showSnackBar("Please select if you need a vehicle.");
      return;
    }
    if (needVehicle == 'No' && selectedVehicle == 'Select') {
      _showSnackBar("Please select a vehicle type.");
      return;
    }
    if (paymentMethod == null || paymentMethod == 'Select') {
      _showSnackBar("Please select a payment method.");
      return;
    }
    if (tripFrequency == null || tripFrequency == 'Select') {
      _showSnackBar("Please select trip frequency.");
      return;
    }
    if (emergencyController.text.trim().isEmpty) {
      _showSnackBar("Please enter an emergency contact.");
      return;
    }

    _showSnackBar("Driver requested successfully!");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatTimeWithAmPm(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: ColorConstant.color1,
        title: Text("Request Driver", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Backgroundtopgradient(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: fromController,
                decoration: InputDecoration(
                  labelText: "From",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: width * 0.03),
              TextField(
                controller: toController,
                decoration: InputDecoration(
                  labelText: "To",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: width * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trip Type:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: tripType ?? 'Select',
                    onChanged: (value) => setState(() => tripType = value),
                    items: tripTypeOptions
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                  ),
                ],
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.calendar_month, color: Colors.blueAccent),
                title: Text("Travel Date"),
                subtitle: Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Choose a date",
                ),
                onTap: () => _pickDate(context),
              ),
              ListTile(
                leading: Icon(Icons.access_time, color: Colors.blueAccent),
                title: Text("Travel Time"),
                subtitle: Text(
                  selectedTime != null
                      ? _formatTimeWithAmPm(selectedTime!)
                      : "Choose a time",
                ),
                onTap: () => _pickTime(context),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Need Vehicle from us?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: needVehicle ?? 'Select',
                    onChanged: (value) => setState(() => needVehicle = value),
                    items: needVehicleOptions
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),
              if (needVehicle == 'Yes') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Passengers:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<int>(
                      value: selectedPassengers,
                      onChanged: (value) =>
                          setState(() => selectedPassengers = value!),
                      items: List.generate(6, (index) => index + 1)
                          .map((num) => DropdownMenuItem(
                              value: num, child: Text(num.toString())))
                          .toList(),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.03),
              ],
              if (needVehicle == 'No') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vehicle Type:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: selectedVehicle,
                      onChanged: (value) =>
                          setState(() => selectedVehicle = value!),
                      items: vehicleTypes
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.03),
                TextField(
                  controller: luggageController,
                  decoration: InputDecoration(
                    labelText: "Luggage Info (optional)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: width * 0.03),
              ],

              // Estimated Fare (just text for now)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Estimated Fare:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("₹200 - ₹500", style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(height: width * 0.03),

              // Payment method
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Method:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: paymentMethod ?? 'Select',
                    onChanged: (value) => setState(() => paymentMethod = value),
                    items: paymentOptions
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),

              // Trip Frequency
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trip Frequency:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: tripFrequency ?? 'Select',
                    onChanged: (value) => setState(() => tripFrequency = value),
                    items: tripFrequencyOptions
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),

              // Emergency contact
              TextField(
                controller: emergencyController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Emergency Contact *",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: width * 0.03),

              // Purpose of Travel
              TextField(
                controller: purposeController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Purpose of Travel",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: width * 0.03),

              // Notes
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Note (optional)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: width * 0.05),
              ElevatedButton.icon(
                onPressed: _submitRequest,
                icon: Icon(Icons.send, color: Colors.white),
                label: Text("Submit Request",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: ColorConstant.primaryColor,
                ),
              ),
              SizedBox(height: width * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
