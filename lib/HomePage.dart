// General
import 'package:flutter/material.dart';
// Time Management
import 'time_management.dart';
// Hive DataBase
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';
// TEST (switching between pages outside of main.dart)
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          // TO-DO LIST FOR THE DAY
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
    padding: const EdgeInsets.all(10.0),
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _optionsMenuButton(),
        const Center(
          child: Text(
            "Current Class",
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
      ],
    ),
  );
}

// OPTIONS MENU BUTTON
_optionsMenuButton() {
  return IconButton(
    onPressed: () => {},
    icon: const Icon(
      Icons.settings_applications_sharp,
      color: Colors.white,
      size: 35,
    ),
  );
}

// OPTIONS MENU
_optionsMenu() {}

// CURRENT CLASS INFORMATION CONTAINER
// this stores the active class index
int activeClass = 0;
List<dynamic> newClasses = Boxes.getClasses().values.toList().cast();
// Compare times, and update active class if needed
updateActiveClass() {
  newClasses = Boxes.getClasses().values.toList().cast();
  activeClass = 0;
  int x = 1;
  while (activeClass < x) {
    x += 1;
    int status = activeClassUpdateCheck(checkTimes[activeClass]);
    if (activeClass < Boxes.getClasses().length) {
      if (status == 1) {
        activeClass += 1;
      } else {
        print(activeClass.toString() + ' no update needed');
        break;
      }
    } else {
      print('no more classes');
      break;
    }
  }
}

// this contains, and styles the container showing the current class, time, and room
_currentClassInfo() {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 25.0,
    ),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      '${newClasses[activeClass].time}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${newClasses[activeClass].name}',
                    style: const TextStyle(fontSize: 22, color: Colors.blue),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.meeting_room_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      '${newClasses[activeClass].room}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
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
    margin: const EdgeInsets.all(15.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              // TITLE
              Text(
                "Today's Lunch",
                style: TextStyle(fontSize: 23),
              ),
              Spacer(),
              // TIME
              Text(
                "11:30-12:00",
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
        // LUNCH ITEMS
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Pizza, fruit cup, breadsticks, milk",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}

// TO-DO LIST FOR THE DAY
_todoListForTheDay() {
  return Container(
    margin: const EdgeInsets.all(15.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color(0xFF333333),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      children: [
        Row(
          children: [
            // TITLE
            const Text(
              "Your To-do List",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            const Spacer(),
            // ADD MORE BUTTON
            // button that brings the user to the planner page allowing them to add more
            TextButton(
              onPressed: () => {globalNewPageSelected(1)},
              style: TextButton.styleFrom(primary: Colors.grey),
              child: Row(
                children: const [
                  Text(
                    "See All ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white)
                ],
              ),
            )
          ],
        ),
        // TO-DO LIST ITEMS
        Divider(
          color: Colors.grey.shade700,
        ),
        _todoListItem("Makers Club", "3:10-4:20"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _todoListItem("Track Meet", "5:00-8:00"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _todoListItem("Math Homework", "9:00"),
      ],
    ),
  );
}

// TO-DO ITEM TILE
_todoListItem(String title, String time) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 0.0,
      horizontal: 8.0,
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    subtitle: Text(
      time,
      style: const TextStyle(fontSize: 16),
    ),
    trailing: IconButton(
      color: Colors.white,
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () => {},
    ),
    textColor: Colors.grey,
    tileColor: const Color(0xFF333333),
  );
}
