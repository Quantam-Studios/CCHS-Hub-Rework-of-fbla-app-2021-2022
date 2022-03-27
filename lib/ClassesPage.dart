// General
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
// ignore: file_names
import 'package:cchs_hub/model/class.dart';
// Popups
import 'package:rflutter_alert/rflutter_alert.dart';
// Hive DataBase
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';
// Time Management
import 'time_management.dart';

// The classes page
class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  ClassList createState() => ClassList();
}

// The State Management of the ClassList Section
class ClassList extends State<ClassesPage> {
  @override
  void initState() {
    // test
    // clear input field controllers
    classAddController.text = "";
    classRoomAddController.text = "";
    // general initialization (flutter method)
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    classAddController.text = "";
    classRoomAddController.text = "";
    // Get rid of boxes needed for this page
    Hive.box('classes').close();
    // general app (flutter method)
    super.dispose();
  }

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
                    // CLEAR CLASSES BUTTON
                    // button that deletes all classes
                    TextButton(
                      onPressed: () => {
                        Boxes.getClasses().clear(),
                        Boxes.getClasses().compact()
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.redAccent.shade200),
                      child: Row(
                        children: const [
                          Text(
                            "Clear All",
                            style: TextStyle(
                              color: Colors.redAccent,
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
            // IMPORTANT: "() => {}" is needed to ensure the popup works
            // -as intended and can't open unexpectedly
            onPressed: () => {
              // ensure that no more than 7 classes can be added.
              if (Boxes.getClasses().length < 7)
                // if < 7 then allow for a new class to be made
                {_addClass(context)}
              else
                // if there are already 7 classes then tell the user
                {
                  _tooManyClasses(context),
                }
            },
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
        "Press the + to add a class.",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  } else {
    // if so then display all classes
    // Update time offset see "TIME OFFSET" seciton for explanation
    if (Boxes.getClasses().length < 7) {
      offset = 1;
    } else {
      offset = 0;
    }
    return Column(
      children: [
        // this dynamically creates a new card (ListTile) for each class
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allClasses.length,
          itemBuilder: (BuildContext context, int index) {
            final newClass = allClasses[index];
            return buildClass(context, newClass, index);
          },
        ),
      ],
    );
  }
}

// TIME OFFSET
// this regulates class time display of with and without early bird
// if the value is 1 then the class times will start at 1st Hour
// if the value is 0 then the class times will start at early bird hour
int offset = 1;

// BUILD CLASS
// This returns a class card
Widget buildClass(BuildContext context, Class classInfo, int index) {
  // Update the time of the class dynamically
  classInfo.time = classTimes[index + offset];
  // Save the time to the existing class
  classInfo.save();
  // Class Card
  // this card is what styles the display of classes
  return Column(
    children: [
      // grey line of separation
      Divider(
        color: Colors.grey.shade700,
      ),
      // this card hold the data relevant to the class
      ListTile(
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
          classTimes[index + offset] + "  " + classInfo.room,
          style: const TextStyle(fontSize: 16),
        ),
        // Edit Class Button
        trailing: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () => {_editClass(context, classInfo)},
        ),
        textColor: Colors.grey,
        tileColor: const Color(0xFF333333),
      ),
    ],
  );
}

// CONTROLLERS FOR TEXTFIELDS
// Class Name Controller
final classAddController = TextEditingController(text: '');
// Room Controller
final classRoomAddController = TextEditingController(text: '');

// ADD CLASS POPUP
// This is the pop up for editing classes.
// function called draws a pop up
_addClass(context) {
  // Set Defualt Text TO Blank: ''
  classAddController.text = '';
  classRoomAddController.text = '';

  // Actual pop up object
  Alert(
      style: const AlertStyle(
        backgroundColor: Color(0xff3b3b3b),
        titleStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      title: "Add Class",
      content: Column(
        children: <Widget>[
          // Class name input field
          TextField(
            controller: classAddController,
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
            controller: classRoomAddController,
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
            addClass(classAddController.value.text,
                classRoomAddController.value.text)
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
Future addClass(String name, String room) async {
  // Create Class() object
  final newClass = Class()
    ..name = name
    ..room = room
    ..time = "";

  // Transfer object types to hive readable
  // Add new class
  // Save to local storage
  final box = Boxes.getClasses();
  box.add(newClass);
}

// MAXIMUM CLASS COUNT REACHED SNACKBAR
// this snackbar will be displayed when a user tries to add another class
// -when the maximum amount of classes (7) has been reached
_tooManyClasses(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text(
      'You can only have 7 classes in a day!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.0),
    ),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(left: 45, right: 45, bottom: 15, top: 15),
  ));
}

// CONTROLLERS FOR TEXTFIELDS
// Class Name Controller
final classEditController = TextEditingController(text: '');
// Room Controller
final classRoomEditController = TextEditingController(text: '');

// EDIT CLASS POPUP
// this displays when the user has slected to edit a class
// -that has already been made
_editClass(context, Class classInfo) {
  // Set Initial Values
  classEditController.text = classInfo.name;
  classRoomEditController.text = classInfo.room;
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
            editClass(classInfo, classEditController.text,
                classRoomEditController.text)
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        )
      ]).show();
}

// EDIT CLASS
// this makes the changes that are chosen in the _editClass() method
void editClass(
  Class classInfo,
  String name,
  String room,
) {
  classInfo.name = name;
  classInfo.room = room;

  // Update values of the existing class
  classInfo.save();
}
