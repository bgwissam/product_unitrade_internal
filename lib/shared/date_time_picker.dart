import 'package:flutter/material.dart';
import 'package:Products/shared/constants.dart';
import 'strings.dart';
import 'package:Products/quotes/quote_view/quote_grid.dart';

class DateTimePicker extends StatefulWidget {
  final String userId;
  DateTimePicker({this.userId});
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTimeRange selectedDate;
  List<String> splitedDate = [];
  DateTime startingDate, endingDate;

  Future _selectDate() async {
    final DateTimeRange picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDate,
      firstDate: DateTime(2018, 0),
      lastDate: DateTime(2100, 0),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (selectedDate != null)
          splitedDate = selectedDate.toString().split(' ');
        startingDate = DateTime.parse(splitedDate[0]);
        endingDate = DateTime.parse(splitedDate[splitedDate.length - 2]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SELECT_PERIOD),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: TextButton(
                child: Text(
                  PICK_DATE_RANGE,
                  style: textStyle8.copyWith(color: Colors.amber),
                ),
                onPressed: () => _selectDate(),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                child: splitedDate.isNotEmpty
                    ? Text(
                        '${startingDate.toLocal().toString().split(' ' )[0]} - ${endingDate.toLocal().toString().split(' ')[0]}',
                        style: textStyle3,
                      )
                    : Container(),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            splitedDate.isNotEmpty
                ? Center(
                    child: FlatButton(
                      child: Text(
                        VIEW_QUOTES,
                        style: textStyle9,
                      ),
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.black),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuoteGrid(
                              userId: widget.userId,
                              startingDate: startingDate,
                              endingDate: endingDate,
                            ),
                          )),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
