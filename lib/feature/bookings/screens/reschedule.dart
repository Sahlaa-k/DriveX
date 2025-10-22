import 'package:drivex/core/widgets/calender_and_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:intl/intl.dart';

class ReschedulePage extends StatefulWidget {
  const ReschedulePage({super.key});

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDateTime;
  bool _busy = false;
  final TextEditingController _notesCtrl = TextEditingController();
  final TextEditingController _fromCtrl = TextEditingController();
  final TextEditingController _toCtrl = TextEditingController();
  Future<void> _pickDateTime() async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.6,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: ColorConstant.cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CalendarTimeBottomSheet(scrollController: controller),
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateTime = picked);
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  // // Combined Date + Time Picker
  // Future<void> _pickDateTime() async {
  //   final now = DateTime.now();
  //
  //   final date = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDateTime ?? now,
  //     firstDate: now,
  //     lastDate: now.add(const Duration(days: 60)),
  //     builder: (ctx, child) => Theme(
  //       data: Theme.of(ctx).copyWith(
  //         colorScheme: ColorScheme.light(
  //           primary: ColorConstant.color11,
  //           onPrimary: Colors.white,
  //           onSurface: ColorConstant.thirdColor,
  //         ),
  //       ),
  //       child: child!,
  //     ),
  //   );
  //   if (date == null) return;
  //
  //   final time = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedDateTime != null
  //         ? TimeOfDay.fromDateTime(_selectedDateTime!)
  //         : TimeOfDay.now(),
  //     builder: (ctx, child) => Theme(
  //       data: Theme.of(ctx).copyWith(
  //         timePickerTheme: TimePickerThemeData(
  //           dialBackgroundColor: ColorConstant.cardColor,
  //           dialHandColor: ColorConstant.color11,
  //         ),
  //       ),
  //       child: child!,
  //     ),
  //   );
  //   if (time == null) return;
  //
  //   setState(() {
  //     _selectedDateTime = DateTime(
  //       date.year,
  //       date.month,
  //       date.day,
  //       time.hour,
  //       time.minute,
  //     );
  //   });
  // }

  String _prettyDate(DateTime? d) =>
      d == null ? '--' : DateFormat('dd').format(d);
  String _prettyMonth(DateTime? d) =>
      d == null ? 'MMM' : DateFormat('MMM').format(d).toUpperCase();
  String _prettyTime(DateTime? d) =>
      d == null ? '--:--' : DateFormat('hh:mm a').format(d);

  Future<void> _submit() async {
    if (_busy) return;
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date & time.')),
      );
      return;
    }
    if (_fromCtrl.text.trim().isEmpty || _toCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter pickup and drop locations.')),
      );
      return;
    }

    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    Navigator.pop(context, {
      'rescheduled': true,
      'newDateTime': _selectedDateTime!.toIso8601String(),
      'from': _fromCtrl.text.trim(),
      'to': _toCtrl.text.trim(),
      'note': _notesCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.back,
                          color: ColorConstant.thirdColor.withOpacity(0.7),
                        )),
                    Spacer(),
                    Text(
                      "Reschedule Booking",
                      style: TextStyle(
                        color: ColorConstant.color11,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.055,
                      ),
                    ),
                    Spacer(),
                  ],
                ),

                Align(
                    alignment: Alignment.center,
                    child: Image(
                        image: AssetImage("assets/images/reschedule.png"),height: width*0.6,)),

                // Combined Date + Time card
                // Combined Date + Time card
                GestureDetector(
                  onTap: _pickDateTime, // <-- directly call bottomsheet function
                  child: Container(
                    height: width * 0.125,
                    decoration: BoxDecoration(
                      color: ColorConstant.cardColor,
                      borderRadius: BorderRadius.circular(width * 0.03),
                      border: Border.all(color: ColorConstant.color11.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        // Left date
                        Container(
                          width: width * 0.25,
                          decoration: BoxDecoration(
                            color: ColorConstant.color11,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width * 0.03),
                              bottomLeft: Radius.circular(width * 0.03),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDateTime == null
                                    ? "--"
                                    : DateFormat('dd').format(_selectedDateTime!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _selectedDateTime == null
                                    ? "MMM"
                                    : DateFormat('MMM').format(_selectedDateTime!).toUpperCase(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),

                        // Right time
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedDateTime == null
                                      ? "--:--"
                                      : DateFormat('hh:mm a').format(_selectedDateTime!),
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.thirdColor,
                                  ),
                                ),
                                Text(
                                  "FROM",
                                  style: TextStyle(
                                    color: ColorConstant.thirdColor.withOpacity(0.6),
                                    fontSize: width * 0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),




                SizedBox(height: width * 0.04),
                Text(
                  "Change Locations",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.thirdColor,
                  ),
                ),
                SizedBox(height: width * 0.03),
                // From Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column with icons + curved dotted line
                    Padding(
                      padding: EdgeInsets.only(top:width*0.02),
                      child: Column(
                        children: [
                          Icon(Icons.my_location, color: Colors.teal, size: width * 0.05),

                          // Curved dotted line
                          SizedBox(
                            height: width * 0.13,
                            width: width * 0.08,
                            child: CustomPaint(
                              painter: CurvedDottedLinePainter(), // right-side curved line
                            ),
                          ),

                          Icon(Icons.location_on, color: Colors.teal, size: width * 0.05),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.01),

                    // From & To text fields
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _fromCtrl,
                            decoration: InputDecoration(
                              labelText: 'From Location',
                              labelStyle: TextStyle(
                                color: ColorConstant.textColor3,
                                fontSize: width * 0.035,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width * 0.03),
                                borderSide: BorderSide(
                                  color: ColorConstant.thirdColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width * 0.03),
                                borderSide: BorderSide(
                                  color: ColorConstant.thirdColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: width * 0.06),

                          TextFormField(
                            controller: _toCtrl,
                            decoration: InputDecoration(
                              labelText: 'To Location',
                              labelStyle: TextStyle(
                                color: ColorConstant.textColor3,
                                fontSize: width * 0.035,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width * 0.03),
                                borderSide: BorderSide(
                                  color: ColorConstant.thirdColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(width * 0.03),
                                borderSide: BorderSide(
                                  color: ColorConstant.thirdColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
,
                SizedBox(height: width * 0.05),




                // Notes
                TextFormField(
                  controller: _notesCtrl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Notes(Optional)',
                    labelStyle: TextStyle(
                        color: ColorConstant.textColor3,
                        fontSize: width * 0.035),
                    isDense: true, // ↓ makes the field shorter
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                          color: ColorConstant.thirdColor.withOpacity(0.3),
                          width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                          color: ColorConstant.thirdColor.withOpacity(0.3),
                          width: 1),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.1),

                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _busy ? null : _submit,
                    child: Container(
                      width: width * 0.55, // button width
                      padding: EdgeInsets.symmetric(
                        vertical: width * 0.04,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: ColorConstant.color11,
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.03))),
                      child: _busy
                          ? SizedBox(
                              height: width * 0.05,
                              width: width * 0.05,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Confirm Reschedule',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
    );
  }
}
class CurvedDottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Curved path (to the right side now)
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(
        0, size.height / 2,        // control point (curve inward to right side)
        size.width / 2, size.height, // end point
      );

    // Draw dotted effect
    double dashWidth = 3, dashSpace = 3, distance = 0.0;
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


