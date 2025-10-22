// plan_catalog_page.dart
import 'package:flutter/material.dart';
import 'plan_details_page.dart';

class PlanCatalogPage extends StatelessWidget {
  const PlanCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final radius = width * .04;

    // 👇 Explicit type so values are Map<String, dynamic>
    final List<Map<String, dynamic>> plans = [
      {
        "id": "basic",
        "name": "Basic",
        "price": 99.0,
        "desc": "Good for light users",
        "features": <String>["Standard support", "Up to 500 units", "Essential features"],
      },
      {
        "id": "pro",
        "name": "Pro",
        "price": 199.0,
        "desc": "Best for regular users",
        "features": <String>["Priority support", "Up to 2000 units", "Premium features"],
      },
      {
        "id": "business",
        "name": "Business",
        "price": 399.0,
        "desc": "For teams and heavy usage",
        "features": <String>["Dedicated support", "Up to 8000 units", "All features unlocked"],
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Choose a Plan")),
      backgroundColor: const Color(0xFFF7F8FA),
      body: ListView.separated(
        padding: EdgeInsets.all(width * .05),
        itemBuilder: (_, i) {
          final p = plans[i];

          // 👇 Safe, typed locals (stop Object? errors)
          final String id = p['id'] as String;
          final String name = p['name'] as String;
          final String desc = p['desc'] as String;
          final double price = (p['price'] as num).toDouble();
          final List<String> features = (p['features'] as List).cast<String>();

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: width * .03,
                  offset: Offset(0, width * .01),
                )
              ],
            ),
            padding: EdgeInsets.all(width * .045),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * .03, vertical: width * .015),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B3C8).withOpacity(.1),
                        borderRadius: BorderRadius.circular(width * .03),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(color: Color(0xFF00B3C8), fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "₹${price.toStringAsFixed(0)}/month",
                      style: TextStyle(fontSize: width * .045, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(height: width * .02),
                Text(desc, style: TextStyle(color: Colors.black54, fontSize: width * .036)),
                SizedBox(height: width * .02),
                for (final f in features)
                  Padding(
                    padding: EdgeInsets.only(bottom: width * .01),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF00B3C8)),
                        SizedBox(width: width * .02),
                        Expanded(child: Text(f, style: TextStyle(fontSize: width * .038))),
                      ],
                    ),
                  ),
                SizedBox(height: width * .02),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlanDetailsPage(
                                plan: {
                                  "id": id,
                                  "name": name,
                                  "price": price,
                                  "desc": desc,
                                  "features": features,
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text("View Details"),
                      ),
                    ),
                    SizedBox(width: width * .03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, {
                          "id": id,
                          "name": name,
                          "price": price,
                          "desc": desc,
                          "features": features,
                        }),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B3C8)),
                        child: const Text("Choose Plan"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: width * .04),
        itemCount: plans.length,
      ),
    );
  }
}
