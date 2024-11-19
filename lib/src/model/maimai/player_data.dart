import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/collection.dart';

part 'player_data.g.dart';

@HiveType(typeId: 21)
class PlayerData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int rating;

  @HiveField(2)
  int friendCode;

  @HiveField(3)
  Collection? trophy;

  @HiveField(4)
  String? trophyName;

  @HiveField(5)
  int courseRank;

  @HiveField(6)
  int classRank;

  @HiveField(7)
  int star;

  @HiveField(8)
  Collection? icon;

  @HiveField(9)
  Collection? namePlate;

  @HiveField(10)
  Collection? frame;

  @HiveField(11)
  String uploadTime;

  @HiveField(12)
  String uuid;

  PlayerData({
    required this.name,
    required this.rating,
    required this.friendCode,
    this.trophy,
    this.trophyName,
    required this.courseRank,
    required this.classRank,
    required this.star,
    this.icon,
    this.namePlate,
    this.frame,
    required this.uploadTime,
    required this.uuid
  });

  factory PlayerData.fromLxJson(Map<String, dynamic> json, uuid) {
    return PlayerData(
      uuid: uuid,
      name: json['name'],
      rating: json['rating'],
      friendCode: json['friend_code'],
      trophy: json['trophy'] != null ? Collection.fromLxJson(json['trophy']) : null,
      trophyName: json['trophy_name'],
      courseRank: json['course_rank'],
      classRank: json['class_rank'],
      star: json['star'],
      icon: json['icon'] != null ? Collection.fromLxJson(json['icon']) : null,
      namePlate: json['name_plate'] != null ? Collection.fromLxJson(json['name_plate']) : null,
      frame: json['frame'] != null ? Collection.fromLxJson(json['frame']) : null,
      uploadTime: json['upload_time'],
    );
  }
}