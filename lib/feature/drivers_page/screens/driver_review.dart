import 'package:flutter/material.dart';

// Accent color you asked for
const Color color11 = Color(0xFF004c4c);

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  // Sample data
  final List<Map<String, dynamic>> _reviews = [
    {
      "name": "Devid R.",
      "verified": true,
      "rating": 5.0,
      "date": DateTime(2025, 8, 14),
      "text":
      "Rahul is very knowledgeable and kept everything smooth during the journey. Highly recommended!",
    },
    {
      "name": "Mary S",
      "verified": true,
      "rating": 4.0,
      "date": DateTime(2025, 8, 2),
      "text":
      "Patient driver and safe driving style. Car was kept clean and communication was good.",
    },
    {
      "name": "Ajay K",
      "verified": false,
      "rating": 5.0,
      "date": DateTime(2025, 7, 25),
      "text":
      "On time pickup and helped with luggage. Definitely booking again.",
    },
    {
      "name": "Nisha P",
      "verified": true,
      "rating": 3.0,
      "date": DateTime(2025, 7, 12),
      "text":
      "Overall okay. Could improve AC cooling at noon. Otherwise fine.",
    },
  ];

  // Filters
  int _minStars = 0; // 0 = All, 4 = 4★+, 5 = 5★
  bool _recentFirst = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Only the bottom button uses green
    final Color green = const Color(0xFF14A86A);
    final Color text1 = const Color(0xFF0E1726);
    final Color text2 = const Color(0xFF6B7280);
    final Color border = const Color(0xFFE5E7EB);
    final Color starColor = const Color(0xFFFFC107); // yellow/amber

    // compute summary
    double avg = 0;
    final counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in _reviews) {
      final int s = (r["rating"] as double).round().clamp(1, 5);
      counts[s] = (counts[s]! + 1);
      avg += (r["rating"] as double);
    }
    avg = _reviews.isEmpty ? 0 : avg / _reviews.length;
    final int total = _reviews.length;

    // apply filters
    List<Map<String, dynamic>> list = _reviews.where((r) {
      final double rating = r["rating"] as double;
      final bool starsOk = _minStars == 0 || rating >= _minStars;
      return starsOk;
    }).toList();

    list.sort((a, b) {
      if (_recentFirst) {
        return (b["date"] as DateTime).compareTo(a["date"] as DateTime);
      } else {
        return (a["date"] as DateTime).compareTo(b["date"] as DateTime);
      }
    });

    // local builders
    Widget starRow(double value) {
      final int full = value.floor();
      final bool half = (value - full) >= 0.5 && full < 5;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (i) {
          if (i < full) {
            return Icon(Icons.star_rounded, size: width * .045, color: starColor);
          } else if (i == full && half) {
            return Icon(Icons.star_half_rounded, size: width * .045, color: starColor);
          }
          return Icon(Icons.star_border_rounded, size: width * .045, color: starColor);
        }),
      );
    }

    Widget histoRow(int stars) {
      final int c = counts[stars]!;
      final double pct = total == 0 ? 0 : c / total;
      return Padding(
        padding: EdgeInsets.only(bottom: width * .015),
        child: Row(
          children: [
            SizedBox(
              width: width * .08,
              child: Text("$stars★",
                  style: TextStyle(fontSize: width * .032, color: text2)),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: width * .025,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(width * .02),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: pct,
                    child: Container(
                      height: width * .025,
                      decoration: BoxDecoration(
                        color: color11.withOpacity(.85), // use color11 with opacity
                        borderRadius: BorderRadius.circular(width * .02),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: width * .02),
            SizedBox(
              width: width * .12,
              child: Text("$c",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: width * .032, color: text2)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * .045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header row (no AppBar) =====
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(width * .08),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Padding(
                      padding: EdgeInsets.all(width * .015),
                      child: Icon(Icons.arrow_back, size: width * .07, color: color11.withOpacity(.95)),
                    ),
                  ),
                  SizedBox(width: width * .02),
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: width * .055,
                      fontWeight: FontWeight.w900,
                      color: color11.withOpacity(.95),
                    ),
                  ),
                ],
              ),

              SizedBox(height: width * .04),

              // Summary card
              Container(
                padding: EdgeInsets.all(width * .04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * .04),
                  border: Border.all(color: border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: width * .04,
                      offset: Offset(0, width * .01),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // left: average
                    SizedBox(
                      width: width * .28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            avg.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: width * .12,
                              height: 0.9,
                              fontWeight: FontWeight.w900,
                              color: text1,
                            ),
                          ),
                          SizedBox(height: width * .01),
                          starRow(avg),
                          SizedBox(height: width * .008),
                          Text("$total reviews",
                              style: TextStyle(fontSize: width * .032, color: text2)),
                        ],
                      ),
                    ),
                    SizedBox(width: width * .03),
                    // right: histogram
                    Expanded(
                      child: Column(
                        children: [
                          histoRow(5),
                          histoRow(4),
                          histoRow(3),
                          histoRow(2),
                          histoRow(1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * .04),

              // Filter chips (use color11, not green)
              Wrap(
                spacing: width * .02,
                runSpacing: width * .02,
                children: [
                  ChoiceChip(
                    label: const Text("All"),
                    selected: _minStars == 0,
                    onSelected: (_) => setState(() => _minStars = 0),
                    selectedColor: color11.withOpacity(.10),
                    labelStyle: TextStyle(
                      color: _minStars == 0 ? color11 : text1,
                      fontWeight: FontWeight.w700,
                      fontSize: width * .034,
                    ),
                    side: BorderSide(color: _minStars == 0 ? color11 : border),
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: const Text("5★"),
                    selected: _minStars == 5,
                    onSelected: (_) => setState(() => _minStars = 5),
                    selectedColor: color11.withOpacity(.10),
                    labelStyle: TextStyle(
                      color: _minStars == 5 ? color11 : text1,
                      fontWeight: FontWeight.w700,
                      fontSize: width * .034,
                    ),
                    side: BorderSide(color: _minStars == 5 ? color11 : border),
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: const Text("4★+"),
                    selected: _minStars == 4,
                    onSelected: (_) => setState(() => _minStars = 4),
                    selectedColor: color11.withOpacity(.10),
                    labelStyle: TextStyle(
                      color: _minStars == 4 ? color11 : text1,
                      fontWeight: FontWeight.w700,
                      fontSize: width * .034,
                    ),
                    side: BorderSide(color: _minStars == 4 ? color11 : border),
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: Text(_recentFirst ? "Recent" : "Oldest"),
                    selected: true,
                    onSelected: (_) => setState(() => _recentFirst = !_recentFirst),
                    selectedColor: color11.withOpacity(.10),
                    labelStyle: TextStyle(
                      color: color11,
                      fontWeight: FontWeight.w700,
                      fontSize: width * .034,
                    ),
                    side: BorderSide(color: color11),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),

              SizedBox(height: width * .03),

              // Reviews list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: width * .03),
                itemBuilder: (context, i) {
                  final r = list[i];
                  return Container(
                    padding: EdgeInsets.all(width * .035),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width * .035),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: width * .055,
                              backgroundColor: const Color(0xFFF3F4F6),
                              child: Text(
                                r["name"].toString().substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: text1,
                                  fontSize: width * .05,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(width: width * .03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        r["name"],
                                        style: TextStyle(
                                          fontSize: width * .04,
                                          fontWeight: FontWeight.w800,
                                          color: text1,
                                        ),
                                      ),
                                      if (r["verified"] == true) ...[
                                        SizedBox(width: width * .01),
                                        Icon(Icons.verified_rounded,
                                            color: color11.withOpacity(.9),
                                            size: width * .045),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: width * .004),
                                  Text(
                                    "${r["date"].toString().split(' ').first}",
                                    style: TextStyle(fontSize: width * .03, color: text2),
                                  ),
                                ],
                              ),
                            ),
                            starRow(r["rating"]),
                          ],
                        ),

                        SizedBox(height: width * .02),

                        Text(
                          r["text"],
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: width * .036, color: text1),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: width * .12),
            ],
          ),
        ),
      ),
      // Only the bottom button is green
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(width * .045, 0, width * .045, width * .04),
        child: SizedBox(
          height: width * .13,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * .035),
              ),
            ),
            onPressed: () {},
            child: Text(
              "Write a Review",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: width * .042,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
