import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // TOP SECTION
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              _topSection(),
              _currentClassInfo(),
            ],
          ),
          // LUNCH FOR THE DAY
          _lunchForTheDay(),
          // TODO LIST FOR THE DAY
          _todoListForTheDay(),
        ],
      ),
    );
  }
}

// TOP SECTION (BLUE BACKGROUND)
_topSection() {
  return Container(
    color: Colors.blue,
    padding: EdgeInsets.all(10.0),
    height: 200,
    child: Center(
      child: Text(
        "Current Class",
        style: TextStyle(
          fontSize: 35,
        ),
      ),
    ),
  );
}

// CURRENT CLASS INFORMATION CONTAINER
// this contains, and styles the container showing the current class, time, and room
_currentClassInfo() {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 25.0,
    ),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Center(
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Text(
                '7:30-8:20',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              Text(
                'AP Biology   ',
                style: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              Spacer(),
              Text(
                ' D203',
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    ),
  );
}

// LUNCH FOR THE CURRENT DAY CONTAINER
_lunchForTheDay() {
  return Container(
    margin: EdgeInsets.all(15.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // TITLE
              Text(
                "Today's Lunch",
                style: TextStyle(fontSize: 23),
              ),
              Spacer(),
              // TIME
              Text(
                "11:30-12:00",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        // LUNCH ITEMS
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Pizza, fruit cup, breadsticks, milk",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    ),
  );
}

// TODO LIST FOR THE DAY
_todoListForTheDay() {
  return Container(
    margin: EdgeInsets.all(15.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      children: [
        // TITLE
        Text(
          "Your To-do List",
          style: TextStyle(fontSize: 23),
        ),
        // TODO ITEMS
        _todoListItem("Makers Club", "3:10-4:20"),
        _todoListItem("Track Meet", "5:00-8:00"),
        _todoListItem("Math Homework", "9:00"),
      ],
    ),
  );
}

// TODO ITEM TILE
_todoListItem(String title, String time) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(
      vertical: 0.0,
      horizontal: 8.0,
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    subtitle: Text(
      time,
      style: TextStyle(fontSize: 16),
    ),
    trailing: IconButton(
      color: Colors.white,
      icon: Icon(Icons.more_vert_rounded),
      onPressed: () => {},
    ),
    textColor: Colors.white,
    tileColor: Color(0xFF333333),
  );
}
