import 'dart:convert';

List<SongGenre> songGenreFromJson(String str) => List<SongGenre>.from(json.decode(str).map((x) => SongGenre.fromJson(x)));

String songGenreToJson(List<SongGenre> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SongGenre {
    int id;
    String title;
    String genre;

    SongGenre({
        required this.id,
        required this.title,
        required this.genre,
    });

    factory SongGenre.fromJson(Map<String, dynamic> json) => SongGenre(
        id: json["id"],
        title: json["title"],
        genre: json["genre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "genre": genre,
    };
}
