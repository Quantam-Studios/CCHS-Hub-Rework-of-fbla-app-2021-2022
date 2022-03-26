import 'package:flutter/material.dart';

class ClassesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _classList(),
        ],
      ),
    );
  }
}

_classList() {
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
        _classItem("class", "time", "room"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room"),
        Divider(
          color: Colors.grey.shade700,
        ),
        _classItem("class", "time", "room"),
      ],
    ),
  );
}

// Class Card
// this card is what styles the display of classes
_classItem(String title, String time, String room) {
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
      onPressed: () => {},
    ),
    textColor: Colors.grey,
    tileColor: const Color(0xFF333333),
  );
}
