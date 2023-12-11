import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> day_of_the_week = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  int? datetime;
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int? daysInMonth;
  String? currentMonthString;

  void nextMonth() {
    setState(() {
      if (currentMonth == 12) {
        currentMonth = 1;
        currentYear = currentYear! + 1;
      } else {
        currentMonth = currentMonth! + 1;
      }
      updateState();
    });
  }

  void prevMonth() {
    setState(() {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear = currentYear! - 1;
      } else {
        currentMonth = currentMonth! - 1;
      }
      updateState();
    });
  }

  void updateState() {
    currentMonthString = DateFormat('MMMM', 'en_US')
        .format(DateTime(2000, currentMonth!))
        .toString();
    datetime = DateTime(currentYear!, currentMonth!, 1).weekday;
    daysInMonth = DateTime(currentYear, currentMonth, 31).day == 31
        ? 0
        : DateTime(currentYear, currentMonth, 31).day;
  }

  void showChangeYearWindow() {
    showDialog(
        context: context,
        builder: (builder) {
          return SimpleDialog(title: Text("Выбор года"), children: <Widget>[
            for (var i = 1970; i <= 2100; i++)
              SimpleDialogOption(
                child: ElevatedButton(
                  onPressed: () {
                    changeYear(i);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "$i",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
          ]);
        });
  }

  void changeYear(int year) {
    setState(() {
      currentYear = year;
      currentMonth = DateTime.january;

      datetime = DateTime(currentYear!, currentMonth!, 1).weekday;
    });
  }

  void returnCurrentTime() {
    setState(() {
      currentYear = DateTime.now().year;
      currentMonth = DateTime.now().month;

      datetime = DateTime(currentYear!, currentMonth!, 1).weekday;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateState();
    return Scaffold(
      body: Stack(
        children: [
          topPanel(),
          middlePanel(),
          if (DateTime(DateTime.now().year, DateTime.now().month) !=
              DateTime(currentYear, currentMonth))
            bottomButton()
        ],
      ),
    );
  }

  Align middlePanel() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 525,
          margin: EdgeInsets.symmetric(vertical: 150, horizontal: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey,
          ),
          child: GridView.count(
            childAspectRatio: 1.7,
            crossAxisCount: 7,
            children: [
              for (int i = 0; i < 7; i++)
                Center(
                    child: Text(
                  day_of_the_week[i],
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
              for (int i = 1; i < 31 + datetime! - daysInMonth!; i++)
                datetime! > i
                    ? Center(
                        child: Container(
                        height: 60,
                        width: 60,
                        child: Center(),
                      ))
                    : Center(
                        child: Container(
                            height: 60,
                            width: 60,
                            child: ElevatedButton(
                              child: Text(
                                (i - datetime! + 1).toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day) ==
                                        DateTime(currentYear, currentMonth,
                                            i - datetime! + 1)
                                    ? Colors.orange
                                    : Colors.red,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(1),
                              ),
                            )))
            ],
          )),
    );
  }

  Align bottomButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: ElevatedButton(
          onPressed: returnCurrentTime,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 10,
              shape: CircleBorder(),
              padding: EdgeInsets.all(25)),
          child: Icon(
            Icons.keyboard_return,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container topPanel() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentYear > 1970)
          ElevatedButton(
              onPressed: () {
                prevMonth();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(25)),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          ElevatedButton(
              onPressed: showChangeYearWindow,
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: EdgeInsets.all(25)),
              child: Text(
                '$currentYear $currentMonthString',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              )),
          if (currentYear < 2100)
          ElevatedButton(
              onPressed: () {
                nextMonth();
              },
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(25),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
