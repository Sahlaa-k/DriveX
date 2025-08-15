import 'package:drivex/feature/bottomNavigation/pages/sample03.dart';
import 'package:flutter/material.dart';

class Sample2 extends StatefulWidget {
  const Sample2({super.key});

  @override
  State<Sample2> createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController packageDetailsController =
      TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Door-to-Door Delivery"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Pickup Location", pickupController),
            SizedBox(height: 12),
            buildTextField("Drop Location", dropController),
            SizedBox(height: 20),
            buildTextField("Package Details", packageDetailsController,
                maxLines: 2),
            SizedBox(height: 20),
            Divider(),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Receiver Info",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(height: 12),
            buildTextField("Receiver Name", receiverNameController),
            SizedBox(height: 12),
            buildTextField("Receiver Phone", receiverPhoneController,
                keyboardType: TextInputType.phone),
            SizedBox(height: 20),
            Divider(),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Delivery Type",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPickerPage(),));
                    },
                    child: Expanded(child: deliveryOption("Instant", true))),
                Expanded(child: deliveryOption("Scheduled", false)),
              ],
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Assign Delivery Personnel",
                border: OutlineInputBorder(),
              ),
              items: ["Ravi", "Anjali", "David"].map((name) {
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Estimated Fare:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("₹120",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Payment Method",
                border: OutlineInputBorder(),
              ),
              items: ["Cash", "UPI", "Card"].map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // place order logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Place Order", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget deliveryOption(String text, bool selected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.teal : Colors.grey.shade300,
          foregroundColor: selected ? Colors.white : Colors.black,
        ),
        child: Text(text),
      ),
    );
  }
}
