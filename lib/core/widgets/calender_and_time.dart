import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarTimeBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  const CalendarTimeBottomSheet({super.key, required this.scrollController});

  @override
  State<CalendarTimeBottomSheet> createState() => _CalendarTimeBottomSheetState();
}

class _CalendarTimeBottomSheetState extends State<CalendarTimeBottomSheet> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    final leadingEmptyCells = firstDayOfMonth.weekday % 7;
    final totalDays = lastDayOfMonth.day;
    final totalCells = leadingEmptyCells + totalDays;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            "Select Date",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorConstant.color11,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Month Header with arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: ColorConstant.color11),
                onPressed: () {
                  setState(() {
                    _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                  });
                },
              ),
              Text(
                DateFormat.yMMMM().format(_focusedMonth).toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.color11,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right, color: ColorConstant.color11),
                onPressed: () {
                  setState(() {
                    _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                  });
                },
              ),
            ],
          ),

          // Week headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                .map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: d == "SUN"
                        ? Colors.red
                        : ColorConstant.thirdColor,
                  ),
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 8),

          // Calendar Grid
          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              if (index < leadingEmptyCells) return const SizedBox();
              final day = index - leadingEmptyCells + 1;
              final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);

              final today = DateTime.now();
              final isPast = date.isBefore(DateTime(today.year, today.month, today.day));

              final isSelected = _selectedDate != null &&
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;

              return GestureDetector(
                onTap: isPast
                    ? null // disable tap for past dates
                    : () => setState(() => _selectedDate = date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? ColorConstant.color11 : Colors.transparent,
                    borderRadius: BorderRadius.circular(width*0.2),
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPast
                            ? Colors.grey // grey for past dates
                            : isSelected
                            ? Colors.white
                            : ColorConstant.thirdColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),


          const SizedBox(height: 16),

          Text(
            "Select Time",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstant.color11,
            ),
          ),

          SizedBox(
            height: 150,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(
                0,
                0,
                0,
                _selectedTime.hour,
                _selectedTime.minute,
              ),
              use24hFormat: false,
              onDateTimeChanged: (val) {
                setState(() {
                  _selectedTime = TimeOfDay.fromDateTime(val);
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.color11,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_selectedDate != null) {
                final result = DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );
                Navigator.pop(context, result);
              }
            },
            child: const Text(
              "Confirm",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
