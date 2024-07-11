import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 1)
class Contact {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  Contact({required this.name, required this.phone});
}