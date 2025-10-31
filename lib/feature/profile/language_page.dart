import 'package:flutter/material.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedCode = 'en';

  final List<Map<String, String>> _languages = const [
    {
      "code": "en",
      "label": "English",
      "native": "English",
      "demo": "Hello, welcome to DriveX"
    },
    {
      "code": "ml",
      "label": "Malayalam",
      "native": "മലയാളം",
      "demo": "ഹലോ, ഡ്രൈവ്‌എക്സ്‌ലേക്ക് സ്വാഗതം"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString('app_language_code') ?? 'en';
      setState(() => _selectedCode = code);
    } catch (_) {
      // If anything fails, keep default 'en'
    }
  }

  Future<void> _applyLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language_code', _selectedCode);
    } catch (_) {
      // ignore errors silently to avoid crashing UI
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedCode == 'en'
              ? 'Language set to English'
              : 'ഭാഷ മലയാളമായി ക്രമീകരിച്ചു',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Send the selected code back if the caller wants to react immediately.
    Navigator.pop(context, _selectedCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width * 0.02),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: width * 0.1,
                      height: width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.025),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: width * 0.025,
                            offset: Offset(0, width * 0.01),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back,
                          size: width * 0.06, color: ColorConstant.thirdColor),
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Text(
                    "Language",
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.thirdColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.04),
              Text(
                "Choose your app language",
                style: TextStyle(
                  fontSize: width * 0.038,
                  color: ColorConstant.thirdColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: width * 0.04),

              // Card: language list
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: width * 0.04,
                      offset: Offset(0, width * 0.015),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(_languages.length, (i) {
                    final item = _languages[i];
                    final selected = _selectedCode == item['code'];
                    return InkWell(
                      onTap: () =>
                          setState(() => _selectedCode = item['code']!),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: width * 0.035,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: i == 0
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.04),
                                  topRight: Radius.circular(width * 0.04),
                                )
                              : (i == _languages.length - 1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(width * 0.04),
                                      bottomRight:
                                          Radius.circular(width * 0.04),
                                    )
                                  : BorderRadius.zero),
                          border: Border(
                            top: BorderSide(
                                color: i == 0
                                    ? Colors.transparent
                                    : Colors.grey.withOpacity(0.15),
                                width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.12,
                              height: width * 0.12,
                              decoration: BoxDecoration(
                                color: selected
                                    ? ColorConstant.color11.withOpacity(0.12)
                                    : ColorConstant.color11.withOpacity(0.06),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? ColorConstant.color11
                                      : Colors.transparent,
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  item['code'] == 'en' ? 'EN' : 'മ',
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.thirdColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item['label'] ?? '',
                                        style: TextStyle(
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstant.thirdColor,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: width * 0.007,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorConstant.color11
                                              .withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(
                                              width * 0.02),
                                        ),
                                        child: Text(
                                          item['native'] ?? '',
                                          style: TextStyle(
                                            fontSize: width * 0.032,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.color11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: width * 0.01),
                                  Text(
                                    item['code'] == 'en'
                                        ? "Default for most users"
                                        : "ഇന്ത്യയിലെ ഉപയോക്താക്കൾക്ക് ശുപാർശ ചെയ്‌തിരിക്കുന്നു",
                                    style: TextStyle(
                                      fontSize: width * 0.032,
                                      color: ColorConstant.thirdColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: item['code']!,
                              groupValue: _selectedCode,
                              activeColor: ColorConstant.color11,
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedCode = v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: width * 0.05),

              // Preview chip/card
              Container(
                width: width,
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.035),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: width * 0.03,
                      offset: Offset(0, width * 0.01),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.translate,
                        color: ColorConstant.color11.withOpacity(0.9),
                        size: width * 0.065),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: Text(
                        (_languages.firstWhere(
                                (e) => e['code'] == _selectedCode)['demo']) ??
                            '',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: ColorConstant.thirdColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Apply button
              SizedBox(
                width: width,
                height: width * 0.13,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.color11,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.035),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _applyLanguage,
                  child: Text(
                    _selectedCode == 'en'
                        ? "Apply English"
                        : "ഭാഷ പ്രയോഗിക്കുക (മലയാളം)",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: width * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
