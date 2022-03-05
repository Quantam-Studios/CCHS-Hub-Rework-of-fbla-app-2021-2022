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
          _topContainer(),
        ],
      ),
    );
  }
}

_topContainer() {
  return Container(
    child: Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Current Class',
              style: TextStyle(fontSize: 25),
            ),
            Row(
              children: [
                Text(
                  'AP Biology',
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  ' D203',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
