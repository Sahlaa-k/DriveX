import 'package:drivex/feature/profile/subscrption/plan_catalog_page.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  const SubscriptionDetailsPage({super.key});

  @override
  State<SubscriptionDetailsPage> createState() => _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  // ----- Mock state -----
  bool hasActivePlan = true;
  bool autoRenew = true;
  String currentPlanId = "pro";
  String currentPlanName = "Pro Plan";
  double currentPrice = 199.0; // ₹/month
  DateTime nextRenewal = DateTime.now().add(const Duration(days: 27));
  int usedUnits = 1500;
  int maxUnits = 2000;

  final List<Map<String, dynamic>> invoices = [
    {"date": DateTime(2025, 9, 1), "amount": 199.0, "status": "Paid", "id": "INV-0925-001"},
    {"date": DateTime(2025, 8, 1), "amount": 199.0, "status": "Paid", "id": "INV-0825-004"},
    {"date": DateTime(2025, 7, 1), "amount": 199.0, "status": "Paid", "id": "INV-0725-002"},
  ];

  String _fmtDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final radius = width * 0.04;
    final cardPad = EdgeInsets.all(width * 0.04);
    final titleStyle = TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w700);
    final labelStyle = TextStyle(fontSize: width * 0.035, color: Colors.black54);
    final valueStyle = TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w600);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("Subscription Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Header gradient with current plan summary ---
          Container(
            width: width,
            padding: EdgeInsets.fromLTRB(width * .05, width * .04, width * .05, width * .06),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B3C8), Color(0xFF64E9EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(width * .06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hasActivePlan ? currentPlanName : "No Active Plan",
                    style: TextStyle(
                      fontSize: width * 0.065,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    )),
                SizedBox(height: width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hasActivePlan ? "₹${currentPrice.toStringAsFixed(0)}/month" : "Choose a plan to get started",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Colors.white.withOpacity(.95),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (hasActivePlan)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * .03, vertical: width * .015),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.2),
                          borderRadius: BorderRadius.circular(width * .03),
                          border: Border.all(color: Colors.white.withOpacity(.35)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: width * .04, color: Colors.white),
                            SizedBox(width: width * .02),
                            Text("Renews ${_fmtDate(nextRenewal)}",
                                style: TextStyle(color: Colors.white, fontSize: width * .033)),
                          ],
                        ),
                      ),
                  ],
                ),
                if (hasActivePlan) SizedBox(height: width * 0.05),
                if (hasActivePlan)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(width * .035),
                    ),
                    padding: EdgeInsets.all(width * .035),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Usage", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        SizedBox(height: width * 0.02),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(width * .02),
                          child: LinearProgressIndicator(
                            value: (usedUnits / maxUnits).clamp(0.0, 1.0),
                            minHeight: width * .02,
                            backgroundColor: Colors.white.withOpacity(.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(height: width * 0.01),
                        Text("$usedUnits of $maxUnits units used",
                            style: TextStyle(color: Colors.white, fontSize: width * .033)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --- Content ---
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: width * 0.05),
              child: Column(
                children: [
                  // Auto-renew + Payment method row
                  Container(
                    width: width,
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
                    padding: cardPad,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Billing Settings", style: titleStyle.copyWith(fontSize: width * 0.05)),
                        SizedBox(height: width * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("Auto-Renewal", style: valueStyle),
                              Text("Enable to renew automatically on ${_fmtDate(nextRenewal)}", style: labelStyle),
                            ]),
                            Switch(
                              value: autoRenew,
                              onChanged: hasActivePlan
                                  ? (v) => setState(() => autoRenew = v)
                                  : null,
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("Payment Method", style: valueStyle),
                              Text("•••• 6789 · Visa", style: labelStyle),
                            ]),
                            IconButton(
                              onPressed: () {
                                _showSnack(context, "Open payment method manager");
                              },
                              icon: const Icon(Icons.chevron_right),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: width * 0.04),

                  // Plan features / limits
                  Container(
                    width: width,
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
                    padding: cardPad,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Plan Benefits", style: titleStyle.copyWith(fontSize: width * 0.05)),
                        SizedBox(height: width * 0.02),
                        Row(children: [
                          Icon(Icons.verified, color: const Color(0xFF00B3C8), size: width * .05),
                          SizedBox(width: width * .02),
                          Expanded(child: Text("Priority support & faster driver matching", style: valueStyle.copyWith(fontWeight: FontWeight.w500, fontSize: width * .038))),
                        ]),
                        SizedBox(height: width * .02),
                        Row(children: [
                          Icon(Icons.trending_up, color: const Color(0xFF00B3C8), size: width * .05),
                          SizedBox(width: width * .02),
                          Expanded(child: Text("Higher daily usage limit ($maxUnits units)", style: valueStyle.copyWith(fontWeight: FontWeight.w500, fontSize: width * .038))),
                        ]),
                        SizedBox(height: width * .02),
                        Row(children: [
                          Icon(Icons.lock, color: const Color(0xFF00B3C8), size: width * .05),
                          SizedBox(width: width * .02),
                          Expanded(child: Text("Access to premium features & perks", style: valueStyle.copyWith(fontWeight: FontWeight.w500, fontSize: width * .038))),
                        ]),
                      ],
                    ),
                  ),

                  SizedBox(height: width * 0.04),

                  // Invoices
                  Container(
                    width: width,
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
                    padding: cardPad,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Invoices", style: titleStyle.copyWith(fontSize: width * 0.05)),
                        SizedBox(height: width * 0.02),
                        for (final inv in invoices)
                          Padding(
                            padding: EdgeInsets.only(bottom: width * 0.03),
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long, size: width * .06, color: Colors.black87),
                                SizedBox(width: width * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(inv["id"], style: valueStyle),
                                      Text(_fmtDate(inv["date"]), style: labelStyle),
                                    ],
                                  ),
                                ),
                                Text("₹${(inv["amount"] as double).toStringAsFixed(0)}",
                                    style: valueStyle),
                                SizedBox(width: width * 0.02),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: width * .03, vertical: width * .012),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8FFF3),
                                    borderRadius: BorderRadius.circular(width * .03),
                                  ),
                                  child: Text(inv["status"], style: TextStyle(color: const Color(0xFF0BA46D), fontSize: width * .033)),
                                ),
                              ],
                            ),
                          ),
                        TextButton.icon(
                          onPressed: () => _showSnack(context, "Open invoices screen"),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text("View all invoices"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.12), // space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // ---- Sticky bottom actions ----
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(width * .05, width * .03, width * .05, width * .05),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: width * .04, offset: Offset(0, -width * .01))],
        ),
        child: hasActivePlan
            ? Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  // Navigate to catalog to pick a different plan
                  final selectedPlan = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PlanCatalogPage()));
                  if (selectedPlan is Map<String, dynamic>) {
                    setState(() {
                      currentPlanId = selectedPlan["id"];
                      currentPlanName = selectedPlan["name"];
                      currentPrice = (selectedPlan["price"] as num).toDouble();
                      hasActivePlan = true;
                    });
                    _showSnack(context, "Plan changed to ${selectedPlan["name"]}");
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: width * .035),
                  side: const BorderSide(color: Color(0xFF00B3C8)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width * .035)),
                ),
                child: Text("Change Plan", style: TextStyle(color: const Color(0xFF00B3C8), fontSize: width * .04, fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(width: width * .03),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final ok = await _confirm(context, "Cancel subscription?",
                      "You can re-subscribe anytime. Your current cycle stays active until ${_fmtDate(nextRenewal)}.");
                  if (ok == true) {
                    setState(() {
                      hasActivePlan = false;
                      autoRenew = false;
                    });
                    _showSnack(context, "Subscription cancelled");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB4D4B),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: width * .035),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width * .035)),
                ),
                child: Text("Delete/Cancel", style: TextStyle(fontSize: width * .04, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final selectedPlan = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PlanCatalogPage()));
                  if (selectedPlan is Map<String, dynamic>) {
                    setState(() {
                      currentPlanId = selectedPlan["id"];
                      currentPlanName = selectedPlan["name"];
                      currentPrice = (selectedPlan["price"] as num).toDouble();
                      hasActivePlan = true;
                      autoRenew = true;
                      nextRenewal = DateTime.now().add(const Duration(days: 30));
                    });
                    _showSnack(context, "Purchased ${selectedPlan["name"]}");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B3C8),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: width * .04),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width * .04)),
                ),
                child: Text("Purchase Plan", style: TextStyle(fontSize: width * .045, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirm(BuildContext context, String title, String msg) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        final width = MediaQuery.sizeOf(ctx).width;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width * .04)),
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes")),
          ],
        );
      },
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
