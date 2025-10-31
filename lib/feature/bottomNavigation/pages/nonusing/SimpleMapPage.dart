// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class Simplemappage extends StatefulWidget {
//   const Simplemappage({super.key});

//   @override
//   State<Simplemappage> createState() => _SimplemappageState();
// }

// class _SimplemappageState extends State<Simplemappage> {
//   // Controllers for first set
//   final TextEditingController field1Controller1 = TextEditingController();
//   final TextEditingController field2Controller1 = TextEditingController();

//   // Controllers for second set
//   final TextEditingController field1Controller2 = TextEditingController();
//   final TextEditingController field2Controller2 = TextEditingController();

//   void _saveFirstSet() {
//     final val1 = field1Controller1.text;
//     final val2 = field2Controller1.text;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Saved 1st set: $val1, $val2")),
//     );
//   }

//   void _saveSecondSet() {
//     final val1 = field1Controller2.text;
//     final val2 = field2Controller2.text;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Saved 2nd set: $val1, $val2")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Simple Map Page"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(width * 0.05),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Form Set 1",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: field1Controller1,
//                 decoration: const InputDecoration(
//                   labelText: "Field 1",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: field2Controller1,
//                 decoration: const InputDecoration(
//                   labelText: "Field 2",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: _saveFirstSet,
//                 child: const Text("Save 1st"),
//               ),
//               const Divider(height: 40),
//               const Text("Form Set 2",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: field1Controller2,
//                 decoration: const InputDecoration(
//                   labelText: "Field 1",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: field2Controller2,
//                 decoration: const InputDecoration(
//                   labelText: "Field 2",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: _saveSecondSet,
//                 child: const Text("Save 2nd"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//-------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Simplemappage extends StatefulWidget {
  const Simplemappage({
    super.key,
    required this.mainDb,
    required this.gServiceDb,
  });

  final FirebaseFirestore mainDb; // -> drivex-2a34e
  final FirebaseFirestore gServiceDb; // -> g-service-d45fd

  @override
  State<Simplemappage> createState() => _SimplemappageState();
}

class _SimplemappageState extends State<Simplemappage> {
  // One field per form (as requested)
  final TextEditingController form1C = TextEditingController();
  final TextEditingController form2C = TextEditingController();

  bool _saving1 = false;
  bool _saving2 = false;

  Future<void> _saveToMain() async {
    final text = form1C.text.trim();
    if (text.isEmpty) {
      _toast('Form 1 is empty');
      return;
    }
    setState(() => _saving1 = true);
    try {
      await widget.mainDb.collection('form1_entries').add({
        'value': text,
        'project': 'drivex-2a34e',
        'createdAt': FieldValue.serverTimestamp(),
      });
      form1C.clear();
      _toast('Saved to MAIN (drivex-2a34e)');
    } catch (e) {
      _toast('Form 1 error: $e');
    } finally {
      if (mounted) setState(() => _saving1 = false);
    }
  }

  Future<void> _saveToSecondary() async {
    final text = form2C.text.trim();
    if (text.isEmpty) {
      _toast('Form 2 is empty');
      return;
    }
    setState(() => _saving2 = true);
    try {
      await widget.gServiceDb.collection('form2_entries').add({
        'value': text,
        'project': 'g-service-d45fd',
        'createdAt': FieldValue.serverTimestamp(),
      });
      form2C.clear();
      _toast('Saved to SECONDARY (g-service-d45fd)');
    } catch (e) {
      _toast('Form 2 error: $e');
    } finally {
      if (mounted) setState(() => _saving2 = false);
    }
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void dispose() {
    form1C.dispose();
    form2C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final gap = SizedBox(height: w * 0.03);

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Map Page')),
      body: Padding(
        padding: EdgeInsets.all(w * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- FORM 1 (MAIN) ----------
              const Text(
                "Form 1 → Save to MAIN (drivex-2a34e)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              gap,
              TextFormField(
                controller: form1C,
                decoration: const InputDecoration(
                  labelText: "Enter value for Form 1",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _saveToMain(),
              ),
              gap,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving1 ? null : _saveToMain,
                  child: _saving1
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Save to MAIN"),
                ),
              ),

              const Divider(height: 40),

              // ---------- FORM 2 (SECONDARY) ----------
              const Text(
                "Form 2 → Save to SECONDARY (g-service-d45fd)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              gap,
              TextFormField(
                controller: form2C,
                decoration: const InputDecoration(
                  labelText: "Enter value for Form 2",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _saveToSecondary(),
              ),
              gap,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving2 ? null : _saveToSecondary,
                  child: _saving2
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Save to SECONDARY"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
