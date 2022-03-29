// Hive
import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 1)
class Event extends HiveObject {
  // Event Name
  @HiveField(0)
  late String name;

  // Date
  @HiveField(1)
  late DateTime date;
}
