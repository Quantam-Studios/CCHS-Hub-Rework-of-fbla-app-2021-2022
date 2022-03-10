import 'package:flutter/material.dart';

class SocialsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _socialMediaCard(
              const Icon(
                Icons.golf_course,
                color: Colors.white,
                size: 50,
              ),
              "CCHS Instagram"),
          _socialMediaCard(
              const Icon(
                Icons.golf_course,
                color: Colors.white,
                size: 50,
              ),
              "CCHS Instagram"),
        ],
      ),
    );
  }
}

// Social Media Card
_socialMediaCard(
  Icon icon,
  String name,
) {
  return Card(
    margin: const EdgeInsets.only(
      top: 15,
      left: 15,
      bottom: 0,
      right: 15,
    ),
    color: const Color(0xFF333333),
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        debugPrint('Card tapped.');
      },
      child: SizedBox(
        child: Row(
          children: [
            // icon
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
            // label
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const Spacer(),
            // View ->
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text(
                    "View ",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
