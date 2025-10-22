import 'package:drivex/core/constants/color_constant.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  String? _reason;
  final TextEditingController _otherCtrl = TextEditingController();
  bool _ack = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDeleteDialog(context));
  }

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: ColorConstant.backgroundColor);
  }

  void _showDeleteDialog(BuildContext ctx) {
    final width = MediaQuery.of(ctx).size.width;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          final reasons = <String>[
            'Privacy concerns',
            'Too expensive',
            'Creating a new account',
            'App usability issues',
            'Taking a break',
            'Other',
          ];

          final isOther = _reason == 'Other';
          final otherValid = !isOther || _otherCtrl.text.trim().isNotEmpty;
          final reasonValid = _reason != null && otherValid;
          final canDelete = reasonValid && _ack;

          return AlertDialog(
            backgroundColor: ColorConstant.cardColor,
            insetPadding: EdgeInsets.symmetric(horizontal: width * 0.06),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.04),
            ),
            titlePadding: EdgeInsets.fromLTRB(width * 0.06, width * 0.05, width * 0.06, 0),
            contentPadding: EdgeInsets.fromLTRB(width * 0.06, width * 0.02, width * 0.06, width * 0.04),
            title: Row(
              children: [
                Container(
                  width: width * 0.11,
                  height: width * 0.11,
                  decoration: BoxDecoration(
                    color: ColorConstant.color11.withOpacity(.12),
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: ColorConstant.color11),
                ),
                SizedBox(width: width * 0.035),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete account?',
                        style: TextStyle(
                          fontSize: width * 0.048,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.thirdColor,
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Text(
                        'This action is permanent. Your bookings, history, and saved data will be removed.',
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: ColorConstant.thirdColor.withOpacity(.65),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: width * 0.03),
                  Text(
                    'Select a reason',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.thirdColor,
                    ),
                  ),
                  SizedBox(height: width * 0.025),

                  // Reason list
                  ...reasons.map((r) {
                    final selected = _reason == r;
                    return Container(
                      margin: EdgeInsets.only(bottom: width * 0.02),
                      decoration: BoxDecoration(
                        color: selected ? ColorConstant.backgroundColor : ColorConstant.cardColor,
                        borderRadius: BorderRadius.circular(width * 0.03),
                        border: Border.all(
                          color: selected ? ColorConstant.color11.withOpacity(.6) : Colors.black12,
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          radioTheme: RadioThemeData(
                            fillColor: WidgetStatePropertyAll(ColorConstant.color11),
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: r,
                          groupValue: _reason,
                          onChanged: (v) => setState(() => _reason = v),
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          title: Text(
                            r,
                            style: TextStyle(fontSize: width * 0.038, color: ColorConstant.thirdColor),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  // Other text field
                  if (isOther) ...[
                    SizedBox(height: width * 0.015),
                    TextField(
                      controller: _otherCtrl,
                      maxLines: 2,
                      onChanged: (_) => setState(() {}),
                      cursorColor: ColorConstant.color11,
                      decoration: InputDecoration(
                        hintText: 'Tell us a bit more…',
                        hintStyle: TextStyle(color: ColorConstant.thirdColor.withOpacity(.45)),
                        filled: true,
                        fillColor: ColorConstant.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          borderSide: const BorderSide(color: Colors.black12, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          borderSide: const BorderSide(color: ColorConstant.color11, width: 1.2),
                        ),
                        contentPadding: EdgeInsets.all(width * 0.03),
                      ),
                      style: const TextStyle(color: ColorConstant.thirdColor),
                    ),
                    if (!otherValid)
                      Padding(
                        padding: EdgeInsets.only(top: width * 0.015, left: width * 0.005),
                        child: Text(
                          'Please describe your reason.',
                          style: TextStyle(color: Colors.red.shade600, fontSize: width * 0.032),
                        ),
                      ),
                  ],

                  SizedBox(height: width * 0.03),

                  // Acknowledgement
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _ack,
                        onChanged: (v) => setState(() => _ack = v ?? false),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        activeColor: ColorConstant.color11,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: width * 0.015),
                          child: Text(
                            'I understand this cannot be undone and all my data will be deleted.',
                            style: TextStyle(fontSize: width * 0.035, color: ColorConstant.thirdColor, height: 1.25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.fromLTRB(width * 0.06, 0, width * 0.06, width * 0.05),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).maybePop(); // leave page
                },
                child: Text('Cancel', style: TextStyle(fontSize: width * 0.04, color: ColorConstant.color11)),
              ),
              SizedBox(width: width * 0.02),
              // Keep destructive action red for clarity
              ElevatedButton.icon(
                onPressed: canDelete
                    ? () async {
                  // TODO: hook your deletion logic
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('Account deletion requested.')),
                    );
                    Navigator.of(ctx).maybePop();
                  }
                }
                    : null,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text('Delete account', style: TextStyle(fontSize: width * 0.04)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Colors.red.withOpacity(.35),
                  foregroundColor: Colors.white,
                  minimumSize: Size(width * 0.35, width * 0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width * 0.03)),
                  elevation: 0,
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
