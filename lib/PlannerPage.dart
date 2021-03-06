// General
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
// Calendar
import 'package:table_calendar/table_calendar.dart';
// Popups
import 'package:rflutter_alert/rflutter_alert.dart';
// Events
import 'model/event.dart';
// Hive DataBase
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  PlannerPageContent createState() => PlannerPageContent();
}

// calendar initialization
CalendarFormat _calendarFormat = CalendarFormat.month;
DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();

@override
class PlannerPageContent extends State {
  @override
  void initState() {
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  CALENDAR
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                side: BorderSide(color: Color(0xff333333), width: 2.0),
              ),
              color: const Color(0xff121212),
              margin: const EdgeInsets.only(
                  top: 78, bottom: 0, left: 15, right: 15),
              // Calendar widget
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2021),
                lastDay: DateTime(2023),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },

                // Calendar Header Styling
                headerStyle: const HeaderStyle(
                  titleTextStyle:
                      TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: BoxDecoration(
                      color: Color(0xff333333),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  formatButtonShowsNext: false,
                  formatButtonTextStyle:
                      TextStyle(color: Colors.white, fontSize: 16.0),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.blue,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                // Calendar Days Styling
                daysOfWeekStyle: const DaysOfWeekStyle(
                  // Weekend days color (Sat,Sun)
                  weekendStyle: TextStyle(color: Color(0xff82B7FF)),
                ),
                // Calendar Dates styling
                calendarStyle: CalendarStyle(
                  // Weekend dates color (Sat & Sun Column)
                  weekendTextStyle: const TextStyle(color: Color(0xff82B7FF)),
                  // highlighted color for today
                  // get rid of all decoration for the current day
                  todayDecoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.0),
                  ),
                  // highlighted color for selected day
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  withinRangeTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            // BELOW THE CALENDAR
            _eventList(context),
          ],
        ),
      ),
    );
  }
}

//EVENT LIST
_eventList(BuildContext context) {
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
              "All Events",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            const Spacer(),
            // ADD MORE BUTTON
            // button that brings the user to the planner page allowing them to add more
            TextButton(
              onPressed: () => {
                // If the user has not selected a date then let them know
                // (this is done with a snackbar message)
                if (_selectedDay == null)
                  {
                    _noDateSlected(context),
                  }
                else
                  {
                    // Display event pop up other wise
                    _addEvent(context)
                  }
              },
              style: TextButton.styleFrom(primary: Colors.blueAccent),
              child: Row(
                children: const [
                  Text(
                    "Add ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                    ),
                  ),
                  Icon(Icons.add, color: Colors.blue)
                ],
              ),
            )
          ],
        ),
        // EVENT LIST ITEMS
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

// BUILD EVENTS
// Contruction of the event list happens here
Widget buildEvents(List<Event> allEvents) {
  // Check if any events exist
  if (allEvents.isEmpty) {
    // if not then tell the user
    return const Center(
      child: Text(
        "Press the + to add an event.",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
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
            final newEvent = allEvents[index];
            return buildEvent(context, newEvent, index);
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () => {_editEvent(context, eventInfo)},
            ),
            IconButton(
              color: Colors.redAccent,
              icon: const Icon(Icons.close),
              onPressed: () => {deleteEvent(eventInfo)},
            ),
          ],
        ),
        textColor: Colors.grey,
        tileColor: const Color(0xFF333333),
      ),
    ],
  );
}

// CONTROLLERS FOR TEXTFIELDS
// Event Name Controller
final eventEditController = TextEditingController(text: '');

// EDIT EVENT POPUP
// this displays when the user has slected to edit a event
// -that has already been made
_editEvent(context, Event eventInfo) {
  // Set Initial Values
  eventEditController.text = eventInfo.name;
  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Edit Event",
      content: Column(
        children: <Widget>[
          // Event name input field
          TextField(
            controller: eventEditController,
            // limit the string size to a maximum of 30
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
              ),
              labelText: 'Event',
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
            // save the event to the device
            editEvent(eventInfo, eventEditController.text)
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// EDIT EVENT
// this makes the changes that are chosen in the _editEvent() method
void editEvent(
  Event eventInfo,
  String name,
) {
  eventInfo.name = name;

  // Update values of the existing event
  eventInfo.save();
}

// DELETE EVENT
void deleteEvent(Event eventInfo) {
  eventInfo.delete();
}

// CONTROLLERS FOR TEXTFIELDS
// Event Name Controller
final eventAddController = TextEditingController(text: '');

// ADD EVENT POPUP
// function called draws a pop up
_addEvent(context) {
  // Set Defualt Text To Blank: ''
  eventAddController.text = '';
  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Add Event",
      content: Column(
        children: <Widget>[
          // Event name input field
          TextField(
            controller: eventAddController,
            // limit the string size to a maximum of 30
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
              ),
              labelText: 'Event',
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
            // save the event to the device
            if (eventAddController.text != '')
              {addEvent(eventAddController.text, _selectedDay)}
            else
              {addEvent('Event', _selectedDay)}
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// ADD EVENT (HIVE)
// this function saves the newly created event to the systems local storage with hive
Future addEvent(String name, DateTime date) async {
  // Create Evet() object
  final newEvent = Event()
    ..name = name
    ..date = date;

  // Transfer object types to hive readable
  // Add new event
  // Save to local storage
  final box = Boxes.getEvents();
  box.add(newEvent);
}

// NO DATE SELECTED SNACKBAR
// this snackbar will be displayed when a user tries to add an event
// -without having selected a date
_noDateSlected(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text(
      'Select a date first!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.0),
    ),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)),
  ));
}
