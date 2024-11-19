import 'package:hive/hive.dart';

part 'collection.g.dart';

@HiveType(typeId: 22)
class Collection extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? color;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? genre;

  Collection({
    required this.id,
    required this.name,
    this.color,
    this.description,
    this.genre,
  });

  factory Collection.fromLxJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      description: json['description'],
      genre: json['genre'],
    );
  }
}