import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_difficulty.dart';
import 'package:rank_hub/src/model/maimai/song_notes.dart';
import 'package:rank_hub/src/widget/mai_note_table.dart';
import 'package:rank_hub/src/widget/mai_rating_table.dart';

class LxMaiLevelView extends StatelessWidget {
  final SongDifficulty difficulty;
  final String songName;

  const LxMaiLevelView({super.key, required this.difficulty, required this.songName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('谱面详情'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              '物量统计',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 350, // 替换 Expanded，设置固定高度
              child: MaiNoteTable(notes: difficulty.notes as SongNotes),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_left, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  "左右滑动查看更多内容",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_right, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 64),
            const Text(
              'DX Rating 对照表',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MaiRatingTable(level: difficulty.levelValue),
            const SizedBox(height: 64),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "仅供参考，请以游戏内实际数据为准",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
