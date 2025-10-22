import 'package:flutter/material.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  // --- Brand colors (feel free to hook into your ColorConstant) ---
  static const Color thirdColor = Color(0xFF000000);
  static const Color backgroundColor = Color(0xFFF4F6FA);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color color11 = Color(0xFF004c4c); // accent (teal)

  final TextEditingController _searchCtrl = TextEditingController();

  String? _selectedCategory; // null or one of categories => "All" like behaviour when null
  final Map<int, int> _helpfulYes = {};
  final Map<int, int> _helpfulNo = {};
  final Map<int, bool?> _givenFeedback = {}; // track if user picked yes/no for that item

  // --- FAQ data ---
  late final List<Map<String, String>> _faqs = [
    {
      "cat": "Getting Started",
      "q": "How do I create an account?",
      "a":
      "Open the app → Tap ‘Sign up’ → Enter your phone/email → Verify with OTP → Add basic profile details. That’s it!"
    },
    {
      "cat": "Getting Started",
      "q": "How do I book my first ride/service?",
      "a":
      "From Home, choose the service (Driver, Cab, Rental, D2D). Set pickup & drop (or item details), review fare, and tap ‘Confirm’.",
    },
    {
      "cat": "Account",
      "q": "How can I change my phone number or email?",
      "a":
      "Go to Profile → Account Settings → Edit phone/email. We’ll re-verify using OTP or a confirmation link.",
    },
    {
      "cat": "Account",
      "q": "I forgot my password—what do I do?",
      "a":
      "On the login screen tap ‘Forgot password’. Enter your registered email/phone to receive reset instructions.",
    },
    {
      "cat": "Booking",
      "q": "Can I reschedule or cancel a booking?",
      "a":
      "Yes. Open the booking details → choose ‘Reschedule’ to pick a new time or ‘Cancel’. Cancellation fees may apply based on policy.",
    },
    {
      "cat": "Payments",
      "q": "What payment methods are supported?",
      "a":
      "We accept UPI, cards, net-banking, and cash (where available). You can set a default method in Payments & Wallet.",
    },
    {
      "cat": "Payments",
      "q": "My payment failed but the money was debited.",
      "a":
      "Most failed payments auto-revert within 2–5 business days. If not, share the transaction ID from your bank/UPI with support.",
    },
    {
      "cat": "Safety",
      "q": "How is my safety ensured during a ride?",
      "a":
      "We verify drivers, track trips live, and provide SOS & share-trip features. Always verify driver and vehicle details before starting.",
    },
    {
      "cat": "Technical",
      "q": "Location isn’t accurate or maps aren’t loading.",
      "a":
      "Enable GPS & high-accuracy location, check internet, and allow app location permission. Restart the app if needed.",
    },
    {
      "cat": "Technical",
      "q": "App looks stuck or keeps crashing.",
      "a":
      "Clear recent apps and relaunch. If it persists, update to the latest version. You can also clear cache from system settings.",
    },
  ];

  // Build category list from data
  late final List<String> _categories = [
    "All",
    ...{
      for (final m in _faqs) m["cat"]!,
    }.toList()
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final String query = _searchCtrl.text.trim().toLowerCase();
    final String? cat = (_selectedCategory == null || _selectedCategory == "All")
        ? null
        : _selectedCategory;

    // Filter by category + search
    final List<Map<String, String>> filtered = _faqs.where((m) {
      final bool catOk = cat == null ? true : (m["cat"] == cat);
      if (!catOk) return false;
      if (query.isEmpty) return true;
      final q = m["q"]!.toLowerCase();
      final a = m["a"]!.toLowerCase();
      return q.contains(query) || a.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Get Help"),
        centerTitle: true,
        backgroundColor: color11,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with subtle gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(width * 0.04, width * 0.05, width * 0.04, width * 0.04),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF006b6b), Color(0xFF008080), Color(0xFF00a3a3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("How can we help?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: width * 0.03),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.03),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: width * 0.03,
                        offset: Offset(0, width * 0.01),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search FAQs (e.g., payment, booking)…",
                          ),
                        ),
                      ),
                      if (query.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(height: width * 0.03),
                // Categories chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((c) {
                      final bool selected = (_selectedCategory ?? "All") == c;
                      return Padding(
                        padding: EdgeInsets.only(right: width * 0.02),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = c == "All" ? null : c;
                            });
                          },
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selected ? Colors.transparent : Colors.white.withOpacity(.6),
                            ),
                          ),
                          selectedColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? color11 : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: Colors.white.withOpacity(.15),
                          elevation: selected ? 2 : 0,
                          pressElevation: 0,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: filtered.isEmpty
                  ? _buildEmptyState(width)
                  : ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => SizedBox(height: width * 0.03),
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  // Find the *global* index so feedback maps remain consistent even when filtered
                  final int globalIndex = _faqs.indexOf(item);

                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(width * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: width * 0.04,
                          offset: Offset(0, width * 0.02),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: width * 0.02),
                        childrenPadding: EdgeInsets.fromLTRB(
                            width * 0.04, 0, width * 0.04, width * 0.035),
                        leading: Container(
                          width: width * 0.1,
                          height: width * 0.1,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color11.withOpacity(.1),
                            borderRadius: BorderRadius.circular(width * 0.025),
                          ),
                          child: Icon(Icons.help_outline, color: color11),
                        ),
                        title: Text(
                          item["q"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.042,
                            color: thirdColor,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: width * 0.01),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.025, vertical: width * 0.01),
                            decoration: BoxDecoration(
                              color: color11.withOpacity(.08),
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: Text(
                              item["cat"]!,
                              style: TextStyle(
                                fontSize: width * 0.028,
                                color: color11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item["a"]!,
                              style: TextStyle(
                                fontSize: width * 0.036,
                                height: 1.35,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: width * 0.03),
                          // Helpful?
                          Row(
                            children: [
                              Text(
                                "Was this helpful?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: width * 0.034,
                                ),
                              ),
                              const Spacer(),
                              _feedbackButton(
                                width: width,
                                label: "Yes",
                                icon: Icons.thumb_up_alt_outlined,
                                selected: _givenFeedback[globalIndex] == true,
                                onTap: () {
                                  setState(() {
                                    if (_givenFeedback[globalIndex] != true) {
                                      _helpfulYes[globalIndex] =
                                          (_helpfulYes[globalIndex] ?? 0) + 1;
                                      if (_givenFeedback[globalIndex] == false) {
                                        // if it was No earlier, reduce No count
                                        final cur = _helpfulNo[globalIndex] ?? 0;
                                        _helpfulNo[globalIndex] = cur > 0 ? cur - 1 : 0;
                                      }
                                      _givenFeedback[globalIndex] = true;
                                    }
                                  });
                                },
                                count: _helpfulYes[globalIndex] ?? 0,
                              ),
                              SizedBox(width: width * 0.02),
                              _feedbackButton(
                                width: width,
                                label: "No",
                                icon: Icons.thumb_down_alt_outlined,
                                selected: _givenFeedback[globalIndex] == false,
                                onTap: () {
                                  setState(() {
                                    if (_givenFeedback[globalIndex] != false) {
                                      _helpfulNo[globalIndex] =
                                          (_helpfulNo[globalIndex] ?? 0) + 1;
                                      if (_givenFeedback[globalIndex] == true) {
                                        // if it was Yes earlier, reduce Yes count
                                        final cur = _helpfulYes[globalIndex] ?? 0;
                                        _helpfulYes[globalIndex] = cur > 0 ? cur - 1 : 0;
                                      }
                                      _givenFeedback[globalIndex] = false;
                                    }
                                  });
                                },
                                count: _helpfulNo[globalIndex] ?? 0,
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.01),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Sticky bottom actions
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(width * 0.045, width * 0.03, width * 0.045, width * 0.04),
          decoration: BoxDecoration(
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: width * 0.04,
                offset: Offset(0, -width * 0.02),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: width * 0.035),
                    side: BorderSide(color: color11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                  ),
                  onPressed: () {
                    _openContactSheet(context, width);
                  },
                  icon: Icon(Icons.support_agent, color: color11),
                  label: Text(
                    "Contact Support",
                    style: TextStyle(
                      color: color11,
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color11,
                    padding: EdgeInsets.symmetric(vertical: width * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    _openReportSheet(context, width);
                  },
                  icon: const Icon(Icons.flag_outlined, color: Colors.white),
                  label: Text(
                    "Report a Problem",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(double width) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: width * 0.18, color: Colors.black26),
          SizedBox(height: width * 0.03),
          Text(
            "No results found",
            style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: width * 0.01),
          Text(
            "Try a different keyword or pick another category.",
            style: TextStyle(fontSize: width * 0.034, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helpful chip-like buttons
  Widget _feedbackButton({
    required double width,
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required int count,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(1000),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.018),
        decoration: BoxDecoration(
          color: selected ? color11.withOpacity(.12) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(color: selected ? color11 : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: width * 0.045, color: selected ? color11 : Colors.black54),
            SizedBox(width: width * 0.012),
            Text(
              "$label",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? color11 : Colors.black87,
                fontSize: width * 0.032,
              ),
            ),
            SizedBox(width: width * 0.012),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.018, vertical: width * 0.006),
              decoration: BoxDecoration(
                color: selected ? color11 : Colors.black.withOpacity(.06),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: width * 0.028,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom sheet: quick contact options
  void _openContactSheet(BuildContext context, double width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(width * 0.05)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.support_agent, color: color11),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Contact Support",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.04),
              _contactTile(
                width: width,
                icon: Icons.call_outlined,
                title: "Call Us",
                subtitle: "+91 90000 00000 (9 AM – 7 PM)",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Calling support… (hook with url_launcher)")),
                  );
                },
              ),
              _contactTile(
                width: width,
                icon: Icons.call,
                title: "WhatsApp",
                subtitle: "Get quick answers on chat",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Opening WhatsApp… (hook with url_launcher)")),
                  );
                },
              ),
              _contactTile(
                width: width,
                icon: Icons.email_outlined,
                title: "Email",
                subtitle: "support@drivex.app",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Composing email… (hook with url_launcher)")),
                  );
                },
              ),
              SizedBox(height: width * 0.02),
            ],
          ),
        );
      },
    );
  }

  Widget _contactTile({
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: width * 0.12,
        height: width * 0.12,
        decoration: BoxDecoration(
          color: color11.withOpacity(.1),
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        child: Icon(icon, color: color11),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: width * 0.04),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.black54, fontSize: width * 0.032),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.black45),
      onTap: onTap,
    );
  }

  // Bottom sheet: report a problem with simple form
  void _openReportSheet(BuildContext context, double width) {
    final TextEditingController topicCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(width * 0.05)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.05,
            bottom: MediaQuery.of(context).viewInsets.bottom + width * 0.05,
            top: width * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_outlined, color: color11),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Report a Problem",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.04),
              TextField(
                controller: topicCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Topic",
                  hintText: "Payment issue, booking bug, etc.",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: width * 0.03),
              TextField(
                controller: descCtrl,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Describe the issue",
                  hintText: "Tell us what went wrong and steps to reproduce.",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: width * 0.04),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: width * 0.035),
                        side: BorderSide(color: color11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.03),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: color11),
                      label: Text(
                        "Cancel",
                        style: TextStyle(
                          color: color11,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color11,
                        padding: EdgeInsets.symmetric(vertical: width * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.03),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Problem submitted. We’ll get back soon.")),
                        );
                        topicCtrl.dispose();
                        descCtrl.dispose();
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
