// General
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
// ignore: file_names
import 'package:cchs_hub/model/class.dart';
// Popups
import 'package:rflutter_alert/rflutter_alert.dart';
// Hive
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';

// The classes page
class ClassesPage extends StatefulWidget {
  @override
  ClassList createState() => ClassList();
}

// The State Management of the ClassList Section
class ClassList extends State<ClassesPage> {
  @override
  Widget build(BuildContext context) => ListView(
        children: [
          Container(
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
                ValueListenableBuilder<Box<Class>>(
                    valueListenable: Boxes.getClasses().listenable(),
                    builder: (context, box, _) {
                      final newClasses = box.values.toList().cast<Class>();
                      return buildClasses(newClasses);
                    }),
              ],
            ),
          ),
          // ADD CLASS BUTTON
          // This Button Adds A New Class
          FloatingActionButton(
            // displays the _addClass popup
            onPressed: _addClass(context, 0, 0),
            tooltip: 'Add Class',
            child: const Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
        ],
      );
}

// BUILD CLASSES
// Contruction of the class list happens here
Widget buildClasses(List<Class> allClasses) {
  // Check if any classes exist
  if (allClasses.isEmpty) {
    // if not then tell the user
    return const Center(
      child: Text(
        "No Classes Yet!",
        style: TextStyle(color: Colors.white),
      ),
    );
  } else {
    // if so then display all classes
    return Column(
      children: [
        // this dynamically creates a new card (ListTile) for each class
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allClasses.length,
          itemBuilder: (BuildContext context, int index) {
            final newClass = allClasses[index];
            return buildClass(context, newClass);
          },
        ),
      ],
    );
  }
}

// BUILD CLASS
// This returns a class card
Widget buildClass(BuildContext context, Class classInfo) {
  // Class Card
  // this card is what styles the display of classes
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 0.0,
      horizontal: 8.0,
    ),
    // Class Name
    title: Text(
      classInfo.name,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    // Time, Room
    subtitle: Text(
      classInfo.time + "  " + classInfo.room,
      style: const TextStyle(fontSize: 16),
    ),
    // Edit Class Button
    trailing: IconButton(
      color: Colors.white,
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () => {
        //_editClass(context, 0, 1)
      },
    ),
    textColor: Colors.grey,
    tileColor: const Color(0xFF333333),
  );
}

// CONTROLLERS FOR TEXTFIELDS
// Class Name Controller
final classEditController = TextEditingController(text: '');
// Room Controller
final classRoomEditController = TextEditingController(text: '');

// ADD CLASS POPUP
// This is the pop up for editing classes.
// function called draws a pop up
_addClass(context, int index, int semester) {
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
            // save the class to the device
            addClass(classEditController.value.text,
                classRoomEditController.value.text, "time")
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// ADD CLASS (HIVE)
// this function saves the newly created class to the systems local storage with hive
Future addClass(String name, String room, String time) async {
  // Create Class() object
  final newClass = Class()
    ..name = name
    ..room = room
    ..time = "time";

  // Transfer object types to hive readable
  // Add new class
  // Save to local storage
  final box = Boxes.getClasses();
  box.add(newClass);
}
