// General
import 'package:cchs_hub/ClassesPage.dart';
import 'package:flutter/material.dart';
// Time Management
import 'time_management.dart';
// Events (To-Do List)
import 'model/event.dart';
// Popups
import 'package:rflutter_alert/rflutter_alert.dart';
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
              _topSection(context),
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
_topSection(BuildContext context) {
  return Container(
    color: Colors.blue,
    padding: const EdgeInsets.all(10.0),
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _optionsMenuButton(context),
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
_optionsMenuButton(BuildContext context) {
  return IconButton(
    onPressed: () => {_optionsMenu(context)},
    icon: const Icon(
      Icons.bug_report_rounded,
      color: Colors.white,
      size: 30,
    ),
  );
}

// CONTROLLERS FOR TEXTFIELDS
// Event Name Controller
final bugReportController = TextEditingController(text: '');
// OPTIONS MENU
_optionsMenu(BuildContext context) {
// EDIT EVENT POPUP
// this displays when the user has slected to edit a event
// -that has already been made
// initialize controller
  bugReportController.text = '';
  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Find A Bug?",
      content: Column(
        children: <Widget>[
          // Event name input field
          TextField(
            controller: bugReportController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.bug_report_rounded,
                color: Colors.white,
              ),
              labelText: 'Tell Us About It...',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // Confirm button
      buttons: [
        DialogButton(
          onPressed: () => {
            // get rid of pop up
            Navigator.pop(context),
            // display sent snackbar
            _bugReportSent(context)
          },
          child: const Text(
            "Send",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// BUG REPORT SENT SELECTED SNACKBAR
// this snackbar will be displayed when a user submits a bug report
_bugReportSent(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text(
      'Sent. Thanks for informing us!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.0),
    ),
    backgroundColor: Colors.greenAccent.shade700,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
  ));
}

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
          return allClasses[activeClass].name;
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
          return allClasses[activeClass].time;
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
          return allClasses[activeClass].room;
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
    margin:
        const EdgeInsets.only(top: 15.0, bottom: 0, left: 15.0, right: 15.0),
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
              "Your Plans For Today",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
          ],
        ),
        // TO-DO LIST ITEMS
        ValueListenableBuilder<Box<Event>>(
            valueListenable: Boxes.getEvents().listenable(),
            builder: (context, box, _) {
              final newEvents = box.values.toList().cast<Event>();
              return buildEvents(newEvents);
            }),
      ],
    ),
  );
}

// PLANS TODAY
// returns false is there are no plans for the day
// returns true if there are plans for the day
bool plansToday(List<Event> allEvents) {
  if (Boxes.getEvents().isEmpty) {
    return false;
  } else {
    // Check if any events are relevant for the day
    for (int i = 0; i < allEvents.length; i++) {
      if (allEvents[i].date.day == DateTime.now().day) {
        // plans were ofund for the day
        return true;
      }
    }
  }
  return false;
}

// BUILD EVENTS
// Contruction of the event list happens here
Widget buildEvents(List<Event> allEvents) {
  // Check if any events exist

  if (allEvents.isEmpty || plansToday(allEvents) == false) {
    // if not then tell the user
    return Column(
      children: [
        Divider(
          color: Colors.grey.shade700,
        ),
        const Text(
          "You have no plans today.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  } else {
    return Column(
      children: [
        // this dynamically creates a new card (ListTile) for each event
        ListView.builder(
          padding: const EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allEvents.length,
          itemBuilder: (BuildContext context, int index) {
            if (allEvents[index].date.day == DateTime.now().day) {
              final newEvent = allEvents[index];
              return buildEvent(context, newEvent, index);
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

// BUILD EVENT
// This returns a event card
Widget buildEvent(BuildContext context, Event eventInfo, int index) {
  // Determine Time Format
  String finalTimeString = eventInfo.date.toIso8601String().substring(0, 10);

  // Event Card
  // this card is what styles the display of events
  return Column(
    children: [
      // grey line of separation
      Divider(
        color: Colors.grey.shade700,
      ),
      // this card hold the data relevant to the event
      ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 8.0,
        ),
        // Event Name
        title: Text(
          eventInfo.name,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        // Time, Room
        subtitle: Text(
          finalTimeString,
          style: const TextStyle(fontSize: 16),
        ),
        // Edit Event Button
        trailing: IconButton(
          color: Colors.redAccent,
          icon: const Icon(Icons.close),
          onPressed: () => {deleteEvent(eventInfo)},
        ),

        textColor: Colors.grey,
        tileColor: const Color(0xFF333333),
      ),
    ],
  );
}

// DELETE EVENT
void deleteEvent(Event eventInfo) {
  eventInfo.delete();
}
