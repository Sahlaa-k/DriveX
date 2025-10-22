// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
// import 'package:flutter/material.dart';
//
// class CancelPage extends StatefulWidget {
//   const CancelPage({super.key});
//
//   @override
//   State<CancelPage> createState() => _CancelPageState();
// }
//
// class _CancelPageState extends State<CancelPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Dropdown
//   final List<String> _reasons = const [
//     'Plan changed',
//     'Booked by mistake',
//     'Driver/Cab is late',
//     'Found a better price',
//     'Wrong pickup/drop',
//     'Health or emergency',
//     'Other',
//   ];
//
//   String? _selectedReason;
//
//   // Notes
//   final TextEditingController _otherReasonCtrl = TextEditingController();
//   final TextEditingController _notesCtrl = TextEditingController();
//
//   bool _submitting = false;
//
//   String _policyNoteFor(String? reason) {
//     if (reason == null) return '';
//     switch (reason) {
//       case 'Driver/Cab is late':
//         return 'No cancellation fee if verified late by our system.';
//       case 'Wrong pickup/drop':
//         return 'You can edit addresses instead of cancelling. Cancellation fee may apply.';
//       case 'Found a better price':
//         return 'A small cancellation fee may apply as per policy.';
//       case 'Booked by mistake':
//         return 'Free cancellation within 2 minutes of booking.';
//       default:
//         return 'Cancellation charges may vary based on timing and trip type.';
//     }
//   }
//
//   Future<void> _submit() async {
//     if (_submitting) return;
//     final isValid = _formKey.currentState?.validate() ?? false;
//     if (!isValid) return;
//
//     final reason = _selectedReason == 'Other'
//         ? _otherReasonCtrl.text.trim()
//         : _selectedReason ?? '';
//
//     final note = _notesCtrl.text.trim();
//
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           backgroundColor: ColorConstant.cardColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: ColorConstant.color11),
//               const SizedBox(width: 8),
//               Text(
//                 'Confirm Cancellation',
//                 style: TextStyle(
//                   color: ColorConstant.thirdColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Do you really want to cancel this booking?',
//                 style: TextStyle(color: ColorConstant.thirdColor.withOpacity(.85)),
//               ),
//               const SizedBox(height: 12),
//               _kvRow('Reason', reason),
//               if (note.isNotEmpty) ...[
//                 const SizedBox(height: 8),
//                 _kvRow('Note', note),
//               ],
//             ],
//           ),
//           actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//           actions: [
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: ColorConstant.color11,
//                 backgroundColor: ColorConstant.color11.withOpacity(0.1),
//                  side: BorderSide(color: ColorConstant.bgColor),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width*0.03)),
//               ),
//               onPressed: () => Navigator.pop(ctx, false),
//               child: const Text('No'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorConstant.color11,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onPressed: () => Navigator.pop(ctx, true),
//               child: const Text('Yes, Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirm != true) return;
//
//     setState(() => _submitting = true);
//     await Future.delayed(const Duration(milliseconds: 600)); // simulate I/O
//
//     if (!mounted) return;
//     Navigator.pop(context, {
//       'cancelled': true,
//       'reason': reason,
//       'note': note,
//     });
//   }
//
//   @override
//   void dispose() {
//     _otherReasonCtrl.dispose();
//     _notesCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//
//     return Scaffold(
//       backgroundColor: ColorConstant.bgColor,
//       body: Backgroundtopgradient(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 10),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Top Bar
//                     Padding(
//                       padding: EdgeInsets.all(width * 0.03),
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () => Navigator.pop(context),
//                             child: Icon(Icons.arrow_back_ios,
//                                 color: ColorConstant.thirdColor.withOpacity(0.7),
//                                 size: width * 0.045),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text("Cancel Booking",
//                                   style: TextStyle(
//                                       fontSize: width * 0.045,
//                                       fontWeight: FontWeight.w600,
//                                       color: ColorConstant.thirdColor.withOpacity(0.7))),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.045), // balance space
//                         ],
//                       ),
//                     ),
//
//                     // Info Card
//                     Container(
//                       padding: EdgeInsets.all(width * 0.03),
//                       decoration: BoxDecoration(
//                         color: ColorConstant.cardColor,
//                         borderRadius: BorderRadius.circular(width * 0.03),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.06),
//                             blurRadius: 14,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                         border: Border.all(
//                           color: ColorConstant.color11.withOpacity(.08),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: ColorConstant.color11.withOpacity(.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(Icons.info_outline,
//                                 color: ColorConstant.color11, size: width * 0.055),
//                           ),
//                           SizedBox(width: width * 0.03),
//                           Expanded(
//                             child: Text(
//                               'Select a reason for cancellation. This helps us improve your experience.',
//                               style: TextStyle(
//                                 color: ColorConstant.thirdColor.withOpacity(.85),
//                                 height: 1.35,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                      SizedBox(height: width*0.03),
//
//                     // Reason
//                     DropdownButtonFormField<String>(
//                       dropdownColor: ColorConstant.bgColor,
//                       value: _selectedReason,
//                       decoration: _fieldDecoration('Cancellation reason'),
//                       items: _reasons
//                           .map((r) => DropdownMenuItem(value: r, child: Text(r)))
//                           .toList(),
//                       validator: (v) =>
//                       (v == null || v.isEmpty) ? 'Please select a reason' : null,
//                       onChanged: (val) => setState(() => _selectedReason = val),
//                     ),
//                     const SizedBox(height: 14),
//
//                     // Other reason
//                     if (_selectedReason == 'Other') ...[
//                       TextFormField(
//                         controller: _otherReasonCtrl,
//                         maxLength: 120,
//                         decoration: _fieldDecoration('Describe your reason')
//                             .copyWith(hintText: 'Type your reason…'),
//                         validator: (v) {
//                           if (_selectedReason == 'Other') {
//                             if (v == null || v.trim().isEmpty) {
//                               return 'Please describe your reason';
//                             }
//                             if (v.trim().length < 4) {
//                               return 'Please write at least 4 characters';
//                             }
//                           }
//                           return null;
//                         },
//                       ),
//                        SizedBox(height: width*0.03),
//                     ],
//
//                     // Notes
//                     TextFormField(
//                       controller: _notesCtrl,
//                       minLines: 3,
//                       maxLines: 5,
//                       maxLength: 300,
//                       decoration: _fieldDecoration('Notes (optional)')
//                           .copyWith(hintText: 'Add any additional details for support…'),
//                     ),
//                     const SizedBox(height: 12),
//
//                     // Policy banner
//                     if (_selectedReason != null) ...[
//                       Container(
//                         padding: EdgeInsets.all(width * 0.035),
//                         decoration: BoxDecoration(
//                           color: ColorConstant.color11.withOpacity(.06),
//                           borderRadius: BorderRadius.circular(width * 0.03),
//                           border: Border.all(
//                             color: ColorConstant.color11.withOpacity(.25),
//                           ),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(Icons.policy, size: 20, color: ColorConstant.color11),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 _policyNoteFor(_selectedReason),
//                                 style: TextStyle(
//                                   color: ColorConstant.thirdColor.withOpacity(.9),
//                                   height: 1.35,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//
//                     // Actions
//                     Row(
//                       children: [
//
//
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: _submitting ? null : _submit,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: _submitting
//                                     ? ColorConstant.color11.withOpacity(0.6) // disabled look
//                                     : ColorConstant.color11,
//                                 borderRadius: BorderRadius.circular(width * 0.03),
//                               ),
//                               child: _submitting
//                                   ? const SizedBox(
//                                 height: 20, width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               )
//                                   : const Text(
//                                 'Confirm Cancel',
//                                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                         )
//
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//
//                     // Footnote
//                     Text(
//                       'By cancelling, you agree to our Cancellation & Refund Policy.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: ColorConstant.thirdColor.withOpacity(.6),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ----- helpers (kept in the same file, no external themes) -----
//   InputDecoration _fieldDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: ColorConstant.thirdColor.withOpacity(.8)),
//       filled: true,
//       fillColor: ColorConstant.cardColor,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: ColorConstant.color11.withOpacity(.25)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: ColorConstant.color11.withOpacity(.25)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: ColorConstant.color11, width: .25),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//     );
//   }
//
//   Widget _kvRow(String k, String v) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(k,
//             style: TextStyle(
//               color: ColorConstant.thirdColor.withOpacity(.6),
//               fontWeight: FontWeight.w600,
//             )),
//         const SizedBox(height: 2),
//         Text(
//           v,
//           style: TextStyle(
//             color: Colors.red,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCancelDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final List<String> reasons = [
    'Plan changed',
    'Booked by mistake',
    'Driver/Cab is late',
    'Found a better price',
    'Wrong pickup/drop',
    'Health or emergency',
    'Other',
  ];

  String? selectedReason;
  final TextEditingController otherReasonCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  String policyNoteFor(String? reason) {
    if (reason == null) return '';
    switch (reason) {
      case 'Driver/Cab is late':
        return 'No cancellation fee if verified late by our system.';
      case 'Wrong pickup/drop':
        return 'You can edit addresses instead of cancelling. Cancellation fee may apply.';
      case 'Found a better price':
        return 'A small cancellation fee may apply as per policy.';
      case 'Booked by mistake':
        return 'Free cancellation within 2 minutes of booking.';
      default:
        return 'Cancellation charges may vary based on timing and trip type.';
    }
  }

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: ColorConstant.cardColor,
        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 0), // ↓ less vertical padding
        actionsPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),   // ↓ reduce bottom gap
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        title: Text(
          'Are You Sure You want to Cancel\n this booking?',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorConstant.thirdColor,
              fontWeight: FontWeight.w600,
              fontSize: width * 0.04),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  decoration: InputDecoration(
                    labelText: 'Cancellation reason',
                    labelStyle: TextStyle(color: ColorConstant.textColor3,fontSize: width*0.035),
                    isDense: true, // ↓ makes the field shorter
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                          color: ColorConstant.thirdColor.withOpacity(0.3),
                          width: 1),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: ColorConstant.thirdColor.withOpacity(0.3), width: 1),
                    ),
                  ),
                  items: reasons
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(r),
                          ))
                      .toList(),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please select a reason'
                      : null,
                  onChanged: (val) {
                    selectedReason = val;
                  },
                ),
                 SizedBox(height: width*0.02),

                if (selectedReason == 'Other')
                  TextFormField(
                    controller: otherReasonCtrl,
                    maxLength: 120,
                    decoration: InputDecoration(
                      labelText: 'Describe your reason',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (selectedReason == 'Other' &&
                          (v == null || v.trim().isEmpty)) {
                        return 'Please describe your reason';
                      }
                      return null;
                    },
                  ),

                TextFormField(
                  controller: notesCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    labelStyle: TextStyle(color: ColorConstant.textColor3,fontSize: width*0.035),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: ColorConstant.thirdColor.withOpacity(0.3), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: ColorConstant.thirdColor.withOpacity(0.3), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: ColorConstant.thirdColor.withOpacity(0.3), width: 1),
                    ),
                  ),
                ),
                 SizedBox(height: width*0.02),
                // if (selectedReason != null)
                //   Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: ColorConstant.color11.withOpacity(.06),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Icons.policy,
                //             size: 18, color: ColorConstant.color11),
                //         const SizedBox(width: 6),
                //         Expanded(
                //           child: Text(
                //             policyNoteFor(selectedReason),
                //             style: TextStyle(
                //               color: ColorConstant.thirdColor.withOpacity(.9),
                //               fontSize: 13,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, {'cancelled': false}),
            child: Text(
              'Back',
              style: TextStyle(color: ColorConstant.thirdColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.color11,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final reason = selectedReason == 'Other'
                    ? otherReasonCtrl.text.trim()
                    : selectedReason ?? '';
                final note = notesCtrl.text.trim();

                Navigator.pop(ctx, {
                  'cancelled': true,
                  'reason': reason,
                  'note': note,
                });
              }
            },
            child: const Text('Confirm Cancel'),
          ),
        ],
      );
    },
  );

  // result is what you pop from dialog
  if (result != null && result['cancelled'] == true) {
    debugPrint(
        'User cancelled with reason: ${result['reason']} note: ${result['note']}');
  }
}
