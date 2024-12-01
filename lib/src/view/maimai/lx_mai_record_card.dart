import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/widget/record_card.dart';

class LxMaiRecordCard extends RecordCard<SongScore> {

  const LxMaiRecordCard({super.key, required super.recordData});

  // Method to get level index color based on the level index
  Color _getLevelColor(int levelIndex) {
    switch (levelIndex) {
      case 0:
        return Colors.green; // BASIC
      case 1:
        return const Color.fromARGB(255, 215, 161, 0); // ADVANCED
      case 2:
        return Colors.red; // EXPERT
      case 3:
        return Colors.purple; // MASTER
      case 4:
        return const Color.fromARGB(255, 236, 130, 255); // Re:MASTER
      default:
        return Colors.grey; // Default color
    }
  }

  // Method to get the type chip color (Standard = Blue, DX = Orange)
  Color _getTypeColor(String type) {
    if (type == 'standard') {
      return Colors.blue; // Standard - Blue
    } else if (type == 'dx') {
      return Colors.orange; // DX - Orange
    } else {
      return Colors.grey; // Default color
    }
  }

  Color _getFsColor(String? fs) {
    if (fs == 'sync') {
      return Colors.blueAccent;
    } else if (fs == 'fs' || fs == 'fsp') {
      return Colors.blue;
    } else if (fs == 'fsd' || fs == 'fsdp') {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  String _getFsText(String? fs) {
    switch (fs) {
      case 'sync':
        return 'SYNC';
      case 'fs':
        return 'FS';
      case 'fsp':
        return 'FS+';
      case 'fsd':
        return 'FSD';
      case 'fsdp':
        return 'FSD+';
      default:
        return '';
    }
  }

  Color _getFcColor(String? fc) {
    if (fc == 'fc' || fc == 'fcp') {
      return Colors.green;
    } else if (fc == 'ap' || fc == 'app') {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  String _getFcText(String? fc) {
    switch (fc) {
      case 'fc':
        return 'FC';
      case 'fcp':
        return 'FC+';
      case 'ap':
        return 'AP';
      case 'app':
        return 'AP+';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split achievements into integer and decimal parts
    final achievementsParts =
        recordData.achievements.toStringAsFixed(4).split('.');
    final intPart = achievementsParts[0];
    final decimalPart = achievementsParts[1];

    // Map level index to its corresponding prefix
    final levelPrefixes = [
      "BASIC", // 0
      "ADVANCED", // 1
      "EXPERT", // 2
      "MASTER", // 3
      "Re:MASTER", // 4
    ];

    final levelPrefix = levelPrefixes[recordData.levelIndex];

    final imageUrl =
        "https://assets2.lxns.net/maimai/jacket/${recordData.id}.png";

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Opacity(
                    opacity: 0.4,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(
                          milliseconds: 500), // Adjust duration as needed
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recordData.songName!,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow
                              .ellipsis, // Ensures long song names don't overflow
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Song Title and Level displayed on the same row
                  Row(
                    children: [
                      Chip(
                        side: const BorderSide(width: 0),
                        label: Text(
                          "$levelPrefix ${recordData.level}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getLevelColor(recordData.levelIndex),
                      ),
                      const SizedBox(width: 8),
                      // Song Name
                      // Type Chip (Standard or DX)
                      Chip(
                        side: const BorderSide(width: 0),
                        label: Text(
                          recordData.type == 'standard' ? '标准' : 'DX',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getTypeColor(recordData.type),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Achievements with integer and decimal parts
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: intPart, // Integer part of achievements
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '.$decimalPart%', // Decimal part of achievements
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (_getFcText(recordData.fc).isNotEmpty)
                        Chip(
                          side: const BorderSide(width: 0),
                          label: Text(
                            _getFcText(recordData.fc),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getFcColor(recordData.fc),
                        ),
                      const SizedBox(width: 8),
                      if (_getFsText(recordData.fs).isNotEmpty)
                        Chip(
                          side: const BorderSide(width: 0),
                          label: Text(
                            _getFsText(recordData.fs),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getFsColor(recordData.fs),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("DX Score: ${recordData.dxScore}"),
                      Text("Rating: ${recordData.dxRating!.toStringAsFixed(0)}"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
