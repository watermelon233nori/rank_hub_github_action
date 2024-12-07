import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_difficulty.dart';
import 'package:rank_hub/src/model/maimai/song_notes.dart';
import 'package:rank_hub/src/widget/mai_note_table.dart';
import 'package:rank_hub/src/widget/mai_rating_table.dart';

class LxMaiLevelView extends StatefulWidget {
  final SongDifficulty difficulty;
  final String songName;

  const LxMaiLevelView(
      {super.key, required this.difficulty, required this.songName});

  @override
  State<StatefulWidget> createState() => _LxMaiLevelViewState();
}

class _LxMaiLevelViewState extends State<LxMaiLevelView> {
  int noteTableShowMode = 0;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '物量统计',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  items: const [
                    DropdownMenuItem(value: 0, child: Text("0% +")),
                    DropdownMenuItem(value: 1, child: Text("101% -")),
                    DropdownMenuItem(value: 2, child: Text("100% -"))
                  ],
                  value: noteTableShowMode,
                  onChanged: (value) {
                    setState(() {
                      noteTableShowMode = value ?? 0;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 350, // 替换 Expanded，设置固定高度
              child: MaiNoteTable(
                  notes: widget.difficulty.notes as SongNotes,
                  calculateMode: noteTableShowMode),
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
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: Text('分数线计算')),),
            const SizedBox(height: 64),
            const Text(
              'DX Rating 对照表',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MaiRatingTable(level: widget.difficulty.levelValue),
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
