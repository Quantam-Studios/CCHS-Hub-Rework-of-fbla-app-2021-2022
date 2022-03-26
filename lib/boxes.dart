import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/class.dart';

class Boxes {
  static Box<Class> getClasses() => Hive.box<Class>('classes');
}
