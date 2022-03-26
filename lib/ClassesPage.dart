import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:rflutter_alert/rflutter_alert.dart';

class ClassesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _classList(context),
        ],
      ),
    );
  }
}

// Class Name Controller
final classEditController = TextEditingController(text: '');
// Room Controller
final classRoomEditController = TextEditingController(text: '');

_classList(BuildContext context) {
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
              "Your Classes",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            const Spacer(),
            // Change Semester Button
            // button that switches the active semester
            TextButton(
              onPressed: () => {},
              style: TextButton.styleFrom(primary: Colors.grey),
              child: Row(
                children: const [
                  Text(
                    "Semester 1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // Class List
        // list of all classes and relevant info
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room", context),
      ],
    ),
  );
}

// Class Card
// this card is what styles the display of classes
_classItem(String title, String time, String room, BuildContext context) {
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
      time + "  " + room,
      style: const TextStyle(fontSize: 16),
    ),
    trailing: IconButton(
      color: Colors.white,
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () => {_editClass(context, 0, 1)},
    ),
    textColor: Colors.grey,
    tileColor: const Color(0xFF333333),
  );
}

// This is the pop up for editing classes.
// function called draws a pop up
_editClass(context, int index, int semester) {
  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Edit Class",
      content: Column(
        children: <Widget>[
          // Class name input field
          TextField(
            controller: classEditController,
            // limit the string size to a maximum of 20
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.format_list_bulleted_rounded,
                color: Colors.white,
              ),
              labelText: 'Class',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          // room input field
          TextField(
            controller: classRoomEditController,
            // limit the string size to a maximum of 4
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.meeting_room_outlined,
                color: Colors.white,
              ),
              labelText: 'Room',
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
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}
