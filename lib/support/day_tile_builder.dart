import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
// import 'package:calendarro/default_day_tile.dart';
import 'package:flutter/material.dart';

class CalendarroDayItem extends StatelessWidget {
  CalendarroDayItem({this.date, this.calendarroState, this.onTap});

  DateTime date;
  CalendarroState calendarroState;
  DateTimeCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);
    bool daySelected = calendarroState.isDateSelected(date);
    var textColor = daySelected ? Colors.white : Colors.grey;

    BoxDecoration boxDecoration;
    if (daySelected) {
      boxDecoration = BoxDecoration(
        color:Color.fromRGBO(63, 92, 200, 1), 
        shape: BoxShape.circle
      );
    } else if (isToday) {
      boxDecoration = BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
        shape: BoxShape.circle
      );
    }

    return Expanded(
        child: GestureDetector(
          child: Container(
              height: 40.0,
              decoration: boxDecoration,
              child: Center(
                  child: Text(
                    "${date.day}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ))),
          onTap: handleTap,
          behavior: HitTestBehavior.translucent,
        ));
  }

  void handleTap() {
    if (onTap != null) {
      onTap(date);
    }
  }
}


class CustomDayTileBuilder extends DayTileBuilder {

  CustomDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap) {
    return CalendarroDayItem(date: date,
        calendarroState: Calendarro.of(context),
        onTap: onTap,
    );
  }
}