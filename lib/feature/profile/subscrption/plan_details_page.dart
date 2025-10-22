import 'package:flutter/material.dart';

class PlanDetailsPage extends StatelessWidget {
  final Map<String, dynamic> plan;
  const PlanDetailsPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final radius = width * .05;
    final features = (plan["features"] as List).cast<String>();

    return Scaffold(
      appBar: AppBar(title: Text("${plan["name"]} Details")),
      backgroundColor: const Color(0xFFF7F8FA),
      body: Padding(
        padding: EdgeInsets.all(width * .05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(width * .05),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B3C8), Color(0xFF64E9EE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan["name"], style: TextStyle(fontSize: width * .07, color: Colors.white, fontWeight: FontWeight.w900)),
                  SizedBox(height: width * .02),
                  Text("₹${(plan["price"] as num).toStringAsFixed(0)}/month",
                      style: TextStyle(fontSize: width * .05, color: Colors.white, fontWeight: FontWeight.w700)),
                  SizedBox(height: width * .02),
                  Text(plan["desc"], style: TextStyle(color: Colors.white.withOpacity(.9))),
                ],
              ),
            ),
            SizedBox(height: width * .05),
            Text("What you get", style: TextStyle(fontSize: width * .05, fontWeight: FontWeight.w700)),
            SizedBox(height: width * .02),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: width * .03, offset: Offset(0, width * .01))],
                ),
                padding: EdgeInsets.all(width * .045),
                child: ListView.separated(
                  itemCount: features.length,
                  itemBuilder: (_, i) => Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF00B3C8)),
                      SizedBox(width: width * .02),
                      Expanded(child: Text(features[i], style: TextStyle(fontSize: width * .04))),
                    ],
                  ),
                  separatorBuilder: (_, __) => Divider(height: width * .06),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(width * .05, width * .02, width * .05, width * .05),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, plan), // return plan to caller
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B3C8),
            padding: EdgeInsets.symmetric(vertical: width * .04),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width * .04)),
          ),
          child: Text("Choose ${plan["name"]}", style: TextStyle(fontSize: width * .045, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}
