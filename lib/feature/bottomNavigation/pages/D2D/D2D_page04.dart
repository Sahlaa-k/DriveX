import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class D2DPage04 extends StatefulWidget {
  const D2DPage04({super.key});

  @override
  State<D2DPage04> createState() => _D2DPage04State();
}

class _D2DPage04State extends State<D2DPage04> {
  String? tripId;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;

  Map<String, double>? pickupCoordinates;
  Map<String, double>? dropCoordinates;

  // Pickup controller
  final TextEditingController fromController = TextEditingController();

  // Dynamic destination controllers (start with one)
  final List<TextEditingController> _destControllers = [
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    _createTripDocument();

    // show/hide Destinations dynamically + clear Destinations when Pickup cleared
    fromController.addListener(() {
      final hasPickup = fromController.text.trim().isNotEmpty;
      if (!hasPickup) {
        // (Optional) clear destination values when pickup removed
        for (final c in _destControllers) {
          c.clear();
        }
      }
      if (mounted) setState(() {}); // rebuild to update visibility
    });
  }

  // UI helper
  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Insert a new destination controller (optionally after an index)
  void _addDestination({int? afterIndex}) {
    setState(() {
      final c = TextEditingController();
      if (afterIndex == null ||
          afterIndex < 0 ||
          afterIndex >= _destControllers.length) {
        _destControllers.add(c);
      } else {
        _destControllers.insert(afterIndex + 1, c);
      }
    });
  }

  // Remove a destination (dispose controller to avoid leaks)
  void _removeDestination(int index) {
    if (_destControllers.length == 1) {
      _showSnackBar(context, "At least one destination is required.");
      return;
    }
    setState(() {
      final c = _destControllers.removeAt(index);
      c.dispose();
    });
  }

  void openRequestLocationSheet(BuildContext context, String slot) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (ctx) {
        Future<Map<String, dynamic>>? linkFuture;

        return StatefulBuilder(
          builder: (ctx, setSheet) {
            linkFuture ??= _sendLocationRequest(slot);
            final size = MediaQuery.of(ctx).size;
            final width = size.width;
            final height = size.height;

            return Material(
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: width,
                    height: height * .65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(width * .05),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * .05,
                        vertical: width * .04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // drag handle
                          Center(
                            child: Container(
                              width: width * .18,
                              height: width * .013,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.circular(width * .01),
                              ),
                            ),
                          ),
                          SizedBox(height: width * .035),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Request Location",
                                  style: TextStyle(
                                    fontSize: width * .05,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => Navigator.pop(ctx),
                                child: Icon(
                                  CupertinoIcons.xmark,
                                  size: width * .06,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: width * .01),
                          Text(
                            'Share the link below to get the ${slot.toUpperCase()} location.',
                            style: TextStyle(
                              fontSize: width * .0325,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: width * .04),
                          Expanded(
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: linkFuture,
                              builder: (ctx, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CupertinoActivityIndicator(
                                            radius: 14),
                                        SizedBox(height: width * .03),
                                        Text(
                                          "Generating secure link…",
                                          style: TextStyle(
                                            fontSize: width * .034,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (snap.hasError) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.exclamationmark_triangle,
                                        color: Colors.red,
                                        size: width * .12,
                                      ),
                                      SizedBox(height: width * .02),
                                      Text(
                                        "Couldn't create link",
                                        style: TextStyle(
                                          fontSize: width * .042,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: width * .02),
                                      Text(
                                        "${snap.error}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width * .032,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: width * .04),
                                      CupertinoButton.filled(
                                        onPressed: () => setSheet(
                                          () => linkFuture =
                                              _sendLocationRequest(slot),
                                        ),
                                        child: const Text("Try again"),
                                      ),
                                    ],
                                  );
                                }

                                final data = snap.data!;
                                final link = data['link'] as String;
                                final expiresAt = data['expiresAt'] as String?;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(width * .035),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        border: Border.all(
                                          color: const Color(0xFFE5E9F0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(width * .03),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Share this link",
                                            style: TextStyle(
                                              fontSize: width * .035,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: width * .02),
                                          SelectableText(
                                            link,
                                            style: TextStyle(
                                              fontSize: width * .034,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                          if (expiresAt != null) ...[
                                            SizedBox(height: width * .02),
                                            Text(
                                              "Expires: $expiresAt",
                                              style: TextStyle(
                                                fontSize: width * .03,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                          SizedBox(height: width * .02),
                                          Row(
                                            children: [
                                              // Copy
                                              Expanded(
                                                child: CupertinoButton(
                                                  color:
                                                      const Color(0xFFE8F3FF),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: width * .028,
                                                  ),
                                                  onPressed: () async {
                                                    await Clipboard.setData(
                                                      ClipboardData(text: link),
                                                    );
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Link copied"),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          duration: Duration(
                                                              seconds: 1),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .doc_on_doc,
                                                        size: width * .05,
                                                        color: const Color(
                                                            0xFF1976D2),
                                                      ),
                                                      SizedBox(
                                                          width: width * .02),
                                                      Text(
                                                        "Copy link",
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * .035,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xFF1976D2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * .03),
                                              // Share
                                              Expanded(
                                                child: CupertinoButton.filled(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: width * .028,
                                                  ),
                                                  onPressed: () async {
                                                    await Share.share(
                                                      link,
                                                      subject:
                                                          "Share your ${slot.toUpperCase()} location",
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(CupertinoIcons.share,
                                                          size: width * .05),
                                                      SizedBox(
                                                          width: width * .02),
                                                      Text(
                                                        "Share",
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * .035,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: width * .04),

                                    // Recent Requests placeholder
                                    Text(
                                      "Recent Request",
                                      style: TextStyle(
                                        fontSize: width * .036,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: width * .025),
                                    Container(
                                      height: width * .25,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(width * .03),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.location_solid,
                                              color: Colors.redAccent,
                                              size: width * .06,
                                            ),
                                            SizedBox(width: width * .03),
                                            Text(
                                              "No recent Location",
                                              style: TextStyle(
                                                fontSize: width * .04,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: width * .025),
                                    SizedBox(
                                      width: double.infinity,
                                      child: CupertinoButton(
                                        color: const Color(0xFF1E88E5),
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                          "Done",
                                          style: TextStyle(
                                            fontSize: width * .04,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _createTripDocument() async {
    final docRef =
        await FirebaseFirestore.instance.collection("locationRequests").add({
      "pickupLocation": null,
      "dropLocation": null,
      "senderName": "Kamal",
      "senderPhone": "9876543210",
      "createdAt": FieldValue.serverTimestamp(),
    });

    tripId = docRef.id;
    _listenToTripUpdates();
  }

  void _listenToTripUpdates() {
    tripSub?.cancel();
    final id = tripId;
    if (id == null) return;
    tripSub = FirebaseFirestore.instance
        .collection("locationRequests")
        .doc(id)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) return;
      final data = doc.data();
      if (data == null) return;

      // pickup
      if (data['pickupLocation'] != null) {
        final coords = Map<String, dynamic>.from(data['pickupLocation']);
        setState(() {
          pickupCoordinates = {
            "lat": (coords['lat'] as num).toDouble(),
            "lng": (coords['lng'] as num).toDouble()
          };
          fromController.text =
              "${pickupCoordinates!['lat']}, ${pickupCoordinates!['lng']}";
        });
      }

      // drop → populate the first destination field
      if (data['dropLocation'] != null) {
        final coords = Map<String, dynamic>.from(data['dropLocation']);
        setState(() {
          dropCoordinates = {
            "lat": (coords['lat'] as num).toDouble(),
            "lng": (coords['lng'] as num).toDouble()
          };
          if (_destControllers.isNotEmpty) {
            _destControllers.first.text =
                "${dropCoordinates!['lat']}, ${dropCoordinates!['lng']}";
          }
        });
      }
    });
  }

  Future<Map<String, dynamic>> _sendLocationRequest(String type) async {
    if (tripId == null) {
      await _createTripDocument(); // ensure exists
    }
    final id = tripId!;
    final shareId = const Uuid().v4();
    final expiresAtDt = DateTime.now().add(const Duration(hours: 24));
    final expiresAtIso = expiresAtDt.toIso8601String();

    // your deep link
    final link = "https://drivex-2a34e.web.app/?id=$id&type=$type&sid=$shareId";

    // log the share
    await FirebaseFirestore.instance
        .collection("locationRequests")
        .doc(id)
        .collection("shares")
        .doc(shareId)
        .set({
      "type": type,
      "link": link,
      "status": "sent",
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": Timestamp.fromDate(expiresAtDt),
    });

    return {"link": link, "expiresAt": expiresAtIso, "shareId": shareId};
  }

  // Next page validation
  void _nextPage() {
    final pickup = fromController.text.trim();
    final dests = _destControllers.map((c) => c.text.trim()).toList();

    if (pickup.isEmpty) {
      _showSnackBar(context, "Please enter Pick-Up location.");
      return;
    }
    if (dests.any((d) => d.isEmpty)) {
      _showSnackBar(context, "Please fill all Destination locations.");
      return;
    }

    _showSnackBar(context, "Proceeding with ${dests.length} destination(s).");
    // TODO: Navigate with your data
  }

  @override
  void dispose() {
    fromController.dispose();
    for (final c in _destControllers) {
      c.dispose();
    }
    tripSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: ColorConstant.color1.withOpacity(.15),
        child: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .02),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: width * .1),
                      SizedBox(height: width * .3),
                      SizedBox(
                        width: width * .75,
                        height: width * .5,
                        child: Center(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      width: width * .5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(width * .025),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: width * .02,
                                            offset: Offset(
                                                width * .01, width * .0125),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(width * .01),
                                        child: Text(
                                          "Please use current location or Request location for accurate location",
                                          style:
                                              TextStyle(fontSize: width * .025),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * .1),
                                  // How to use
                                  Container(
                                    width: width * .75,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(width * .025),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: width * .02,
                                          offset: Offset(
                                              width * .01, width * .0125),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(width * .02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "How to use ?",
                                            style: TextStyle(
                                              fontSize: width * .03,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Tap the field to search and select locations. Use "Add Destination" to insert more stops.',
                                            style: TextStyle(
                                              fontSize: width * .0275,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: height * .05,
                                    right: width * .025,
                                  ),
                                  child: Image.asset(
                                    ImageConstant.deliveryman2,
                                    height: width * .25,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // ───────── PICKUP ─────────
                      SizedBox(height: width * .1),
                      Row(
                        children: [
                          Text(
                            "Enter PickUp Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: width * .035,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * .02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // dot
                          Padding(
                            padding: EdgeInsets.only(right: width * .025),
                            child: Container(
                              width: width * 0.04,
                              height: width * 0.04,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: width * .005,
                                  color: Colors.black.withOpacity(.25),
                                ),
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: width * 0.02,
                                  height: width * 0.02,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // field (navigate to place search page)
                          GestureDetector(
                            // onTap: () async {
                            //   await Navigator.push(
                            // context,
                            // CupertinoPageRoute(
                            //   builder: (_) => D2dPlaceSearchPage(
                            //     controller: fromController,
                            //     accentColor: Colors.green,
                            //     label: "Pickup",
                            //   ),
                            // ),
                            // );
                            // setState(() {});
                            // },
                            child: Container(
                              height: width * .125,
                              width: width * .85,
                              padding: EdgeInsets.only(left: width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fromController.text.isEmpty
                                          ? "Enter PickUp location"
                                          : fromController.text,
                                      style: TextStyle(
                                        color: fromController.text.isEmpty
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black,
                                        fontSize: width * 0.035,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * .01),
                                    child: GestureDetector(
                                      onTap: () => openRequestLocationSheet(
                                        context,
                                        "pickup",
                                      ),
                                      child: Container(
                                        height: double.infinity,
                                        width: width * .225,
                                        decoration: BoxDecoration(
                                          color: ColorConstant.greenColor
                                              .withOpacity(.9),
                                          borderRadius: BorderRadius.circular(
                                            width * 0.02,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Request\nLocation",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: width * .03,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ───────── DESTINATIONS (ListView.builder) ─────────
                      if (fromController.text.trim().isNotEmpty) ...[
                        SizedBox(height: width * .05),
                        Row(
                          children: [
                            Text(
                              "Enter Destination Details",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: width * .035,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width * .02),

                        // Builder with shrinkWrap
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _destControllers.length,
                          itemBuilder: (context, index) {
                            final destController = _destControllers[index];
                            final bool isLast =
                                index == _destControllers.length - 1;
                            final bool isFirst = index == 0;

                            final double topSegH = height * .02;
                            final double bottomSegH = height * .03;

                            void _insertAt(int i) {
                              setState(() {
                                _destControllers.insert(
                                    i, TextEditingController());
                              });
                            }

                            void _removeAt(int i) {
                              setState(() {
                                final c = _destControllers.removeAt(i);
                                c.dispose();
                              });
                            }

                            void _showSnack(String msg) =>
                                _showSnackBar(context, msg);

                            return Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // ───────── Add Stop ABOVE this row ─────────
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Left lead-in: hide dots for first index, keep spacing
                                        if (!isFirst)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.025),
                                            child: DottedBorder(
                                              color: Colors.black54,
                                              strokeWidth: width * .0025,
                                              dashPattern: const [4, 3],
                                              strokeCap: StrokeCap.round,
                                              padding: EdgeInsets.zero,
                                              customPath: (size) => Path()
                                                ..moveTo(0, 0)
                                                ..lineTo(0, size.height),
                                              child: SizedBox(
                                                width: width * .05,
                                                height: height * .0375,
                                              ),
                                            ),
                                          )
                                        else
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.025),
                                            child: SizedBox(
                                              width: width * .05,
                                              height: height * .0375,
                                            ),
                                          ),
                                        SizedBox(width: width * .025),

                                        // Add Stop button (GLOBAL guard: all live destinations must be filled)
                                        GestureDetector(
                                          onTap: () {
                                            // Check every current destination has data
                                            final int firstMissing =
                                                _destControllers.indexWhere(
                                                    (c) =>
                                                        c.text.trim().isEmpty);

                                            if (firstMissing != -1) {
                                              _showSnack(
                                                "Please enter Destination ${firstMissing + 1} first.",
                                              );
                                              return;
                                            }

                                            // All fields filled → insert ABOVE (before this row), as per your original code
                                            _insertAt(index);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: width * 0.025),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: width * .0125,
                                                horizontal: width * .04,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  width * .025,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    size: width * .05,
                                                    color: Colors.black54,
                                                  ),
                                                  SizedBox(width: width * .01),
                                                  Text(
                                                    "Add Stop",
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: width * .035,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ───────── Row: left rail + destination card + (outside) delete ─────────
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Left rail
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // TOP segment: spacer for first, dotted for others
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.025),
                                            child: isFirst
                                                ? SizedBox(
                                                    width: width * .05,
                                                    height: topSegH)
                                                : DottedBorder(
                                                    color: Colors.black54,
                                                    strokeWidth: width * .0025,
                                                    dashPattern: const [4, 3],
                                                    strokeCap: StrokeCap.round,
                                                    padding: EdgeInsets.zero,
                                                    customPath: (size) => Path()
                                                      ..moveTo(0, 0)
                                                      ..lineTo(0, size.height),
                                                    child: SizedBox(
                                                      width: width * .05,
                                                      height: topSegH,
                                                    ),
                                                  ),
                                          ),

                                          // RED DOT
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.005),
                                            child: Container(
                                              width: width * 0.04,
                                              height: width * 0.04,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: width * .005,
                                                  color: Colors.black
                                                      .withOpacity(.25),
                                                ),
                                                color: Colors.redAccent[200],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: width * 0.02,
                                                  height: width * 0.02,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // BOTTOM segment — only if NOT last
                                          if (!isLast)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.025),
                                              child: DottedBorder(
                                                color: Colors.black54,
                                                strokeWidth: width * .0025,
                                                dashPattern: const [4, 3],
                                                strokeCap: StrokeCap.round,
                                                padding: EdgeInsets.zero,
                                                customPath: (size) => Path()
                                                  ..moveTo(0, 0)
                                                  ..lineTo(0, size.height),
                                                child: SizedBox(
                                                  width: width * .05,
                                                  height: bottomSegH,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),

                                      SizedBox(width: width * .02),

                                      // Destination card (Flexible to avoid overflow)
                                      Expanded(
                                        child: GestureDetector(
                                          // onTap: () async {
                                          //   await Navigator.push(
                                          //     context,
                                          //     CupertinoPageRoute(
                                          //       builder: (_) =>
                                          //           D2dPlaceSearchPage(
                                          //         controller: destController,
                                          //         accentColor: Colors.redAccent,
                                          //         label:
                                          //             "Destination ${index + 1}",
                                          //       ),
                                          //     ),
                                          //   );
                                          //   setState(() {});
                                          // },
                                          child: Container(
                                            height: width * .125,
                                            padding: EdgeInsets.only(
                                              left: width * 0.03,
                                              right: width * .01,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                width * 0.03,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    destController.text.isEmpty
                                                        ? "Enter Destination location"
                                                        : destController.text,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: destController
                                                              .text.isEmpty
                                                          ? Colors.black
                                                              .withOpacity(.5)
                                                          : Colors.black,
                                                      fontSize: width * 0.035,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      openRequestLocationSheet(
                                                    context,
                                                    "drop",
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      width * .01,
                                                    ),
                                                    child: Container(
                                                      height: double.infinity,
                                                      width: width * .2,
                                                      decoration: BoxDecoration(
                                                        color: ColorConstant
                                                            .greenColor
                                                            .withOpacity(.9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          width * 0.02,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Request\nLocation",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * .028,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: width * .015),

                                      // DELETE — show only if there are 2+ destinations
                                      if (_destControllers.length > 1)
                                        GestureDetector(
                                          onTap: () => _removeAt(index),
                                          child: Container(
                                            height: width * .125,
                                            width: width * .1,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(.12),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                width * .02,
                                              ),
                                              border: Border.all(
                                                color: Colors.redAccent
                                                    .withOpacity(.4),
                                                width: width * .002,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.delete_outline,
                                              size: width * .06,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],

                      // NEXT BUTTON
                      SizedBox(height: width * .08),
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: width * .4,
                          padding: EdgeInsets.symmetric(
                            vertical: width * .025,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(width * .025),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: width * .02,
                                offset: Offset(width * .01, width * .0125),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * .04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: width * .5),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
