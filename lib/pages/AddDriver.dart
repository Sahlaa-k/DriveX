import 'package:flutter/material.dart';

class AddDriverPage extends StatelessWidget {
  const AddDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Driver')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 8),
            const Text('Languages Spoken:'),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('English')),
                Chip(label: Text('Malayalam')),
                Chip(label: Text('Hindi')),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_pin),
              ),
            ),
            const SizedBox(height: 16),
            const Text('License Details',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const TextField(
              decoration: InputDecoration(labelText: 'License Number'),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(labelText: 'License Expiry Date'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload License Image'),
            ),
            const SizedBox(height: 16),
            const Text('Experience',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Years of Experience'),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
                value: false,
                onChanged: (_) {},
                title: const Text('Elderly-friendly')),
            CheckboxListTile(
                value: false,
                onChanged: (_) {},
                title: const Text('Night Driving')),
            const SizedBox(height: 16),
            const Text('Pricing',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Rate per Hour (₹)'),
            ),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Rate per KM (₹)'),
            ),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Rate per Day (₹)'),
            ),
            const SizedBox(height: 16),
            const Text('Availability',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const TextField(
              decoration:
                  InputDecoration(labelText: 'Working Hours (e.g. 9AM - 6PM)'),
            ),
            const SizedBox(height: 8),
            const Text('Available Days:'),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Mon')),
                Chip(label: Text('Tue')),
                Chip(label: Text('Wed')),
                Chip(label: Text('Thu')),
                Chip(label: Text('Fri')),
                Chip(label: Text('Sat')),
                Chip(label: Text('Sun')),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Add Driver'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
