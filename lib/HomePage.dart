// General
import 'package:cchs_hub/ClassesPage.dart';
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
      Icons.settings,
      color: Colors.white,
      size: 30,
    ),
  );
}

// OPTIONS MENU
_optionsMenu() {}

// CURRENT CLASS INFORMATION CONTAINER
// this stores the active class index
int activeClass = 0;
// this is the "global" reference allowing for other functions
// -to see the active class
List<dynamic> allClasses = [];
// Compare times, and update active class if needed
updateActiveClass() {
  allClasses = Boxes.getClasses().values.toList().cast();
  // Only run logic if classes exist
  activeClass = 0;
  if (Boxes.getClasses().isNotEmpty) {
    // determine what class should be active
    // ensrue that the school day is still happening
    int timeStat = activeClassUpdateCheck(checkTimes[6]);
    if (timeStat <= 0) {
      // if it is determine the active class
      for (int i = 1; activeClass < i + 1; i++) {
        int status = activeClassUpdateCheck(checkTimes[activeClass + offset]);
        if (status == 1 && activeClass != 6) {
          activeClass += 1;
        } else {
          break;
        }
      }
    }
  } else {
    print("VALUES NULL");
    return;
  }
}

// CURRENT CLASS
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
                      _getActiveClassTime(),
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
                    _getActiveClassName(),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
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
                      _getActiveClassRoom(),
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

// GET ACTIVE CLASS INFO
// the functions act to ensure the value given is never null
// returns the active class NAME
String _getActiveClassName() {
  print(activeClass.toString());
  int timeStat = activeClassUpdateCheck(checkTimes[6]);
  if (timeStat <= 0) {
    // ensures the value is not null
    if (Boxes.getClasses().isEmpty && allClasses.isEmpty) {
      // If there are no classes then say so
      return 'No Classes';
    } else {
      if (Boxes.getClasses().length < activeClass) {
        // If the active class time doesnt match any classes then tell the user
        return "No Class Scheduled";
      } else {
        // Handling early bird times
        if (Boxes.getClasses().length < 7) {
          // no early bird
          return allClasses[activeClass].name;
        } else {
          // early bird
          print('Offset: ' + offset.toString());
          return allClasses[activeClass - 1].name;
        }
      }
    }
  } else {
    return 'School Is Out';
  }
}

// returns the active class TIME
String _getActiveClassTime() {
  int timeStat = activeClassUpdateCheck(checkTimes[6]);
  if (timeStat <= 0) {
    // ensures the value is not null
    if (Boxes.getClasses().isEmpty && allClasses.isEmpty) {
      // If there are no classes then say so
      return 'No Classes';
    } else {
      if (Boxes.getClasses().length < activeClass) {
        // If the active class time doesnt match any classes then tell the user
        return "";
      } else {
        // Handling early bird times
        if (Boxes.getClasses().length < 7) {
          // no early bird
          return allClasses[activeClass].time;
        } else {
          // early bird
          return allClasses[activeClass - 1].time;
        }
      }
    }
  } else {
    if (Boxes.getClasses().length < 7) {
      return '3:00(pm)-8:30(am)';
    } else {
      return '3:00(pm)-7:30(am)';
    }
  }
}

// returns the active class ROOM
String _getActiveClassRoom() {
  int timeStat = activeClassUpdateCheck(checkTimes[6]);
  if (timeStat <= 0) {
    // ensures the value is not null
    if (Boxes.getClasses().isEmpty && allClasses.isEmpty) {
      // If there are no classes then say so
      return 'No Classes';
    } else {
      if (Boxes.getClasses().length < activeClass) {
        // If the active class time doesnt match any classes then tell the user
        return "";
      } else {
        // Handling early bird times
        if (Boxes.getClasses().length < 7) {
          // no early bird
          return allClasses[activeClass].room;
        } else {
          // early bird
          return allClasses[activeClass - 1].room;
        }
      }
    }
  } else {
    return '';
  }
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
