import 'package:flutter/material.dart';

class MaimaiCn extends StatelessWidget {
  final Map<String, dynamic> data = {
    "name": "ＱＩＡＮＭＯ",
    "rating": 14469,
    "friend_code": 305600065184384,
    "trophy": {
      "id": 358595,
      "name": "――――　　UNKNOWN　　――――　　UNKNOWN　　――――　　UNKNOWN",
      "color": "Normal"
    },
    "course_rank": 7,
    "class_rank": 1,
    "star": 254,
    "icon": {"id": 355501, "name": "御伽野ひめ", "genre": "MEGAREXちほー"},
    "name_plate": {"id": 406102, "name": "東北ずん子ちほー その2", "genre": "イベントちほー"},
    "frame": {"id": 406102, "name": "東北ずん子ちほー その2", "genre": "イベントちほー"},
    "upload_time": "2024-11-25T02:12:14Z"
  };

  MaimaiCn({super.key});

  @override
  Widget build(BuildContext context) {
    final String iconUrl =
        "https://assets2.lxns.net/maimai/icon/${data['icon']['id']}.png";
    final String courseRankUrl =
        "https://maimai.lxns.net/assets/maimai/course_rank/${data['course_rank']}.webp";
    final String classRankUrl =
        "https://maimai.lxns.net/assets/maimai/class_rank/${data['class_rank']}.webp";
    final String starIconUrl =
        "https://maimai.lxns.net/assets/maimai/icon_star.webp";

    return Card(
      margin: EdgeInsets.all(32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                iconUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // User details
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          "DX RATING: ${data['rating']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Ranks and stars
                  Row(
                    children: [
                      // Course rank
                      Image.network(courseRankUrl, width: 60, height: 60),
                      const SizedBox(width: 8),
                      // Class rank
                      Image.network(classRankUrl, width: 60, height: 60),
                      const SizedBox(width: 8),
                      // Star
                      Row(
                        children: [
                          Image.network(starIconUrl, width: 24, height: 24),
                          const SizedBox(width: 4),
                          Text(
                            "×${data['star']}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
