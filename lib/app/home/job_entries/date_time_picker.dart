import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/job_entries/format.dart';
import 'package:time_tracker/app/home/job_entries/input_dropdown.dart';

class DateTimePicker extends StatelessWidget {
   DateTimePicker({
    required this.labelText,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectDate,
    required this.selectTime,
  });

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      selectDate(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      selectTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headline6;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText,
            valueText: Format.date(selectedDate),
            valueStyle: valueStyle!,
            onPressed: () => _selectDate(context),
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }
}
