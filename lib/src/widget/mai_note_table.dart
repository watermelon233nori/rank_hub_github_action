import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_notes.dart';

class MaiNoteTable extends StatelessWidget {
  final SongNotes notes;

  const MaiNoteTable({super.key, required this.notes});

  // 补正总物量计算
  double calculateTotalWeight() {
    return notes.tap.toDouble() +
        notes.touch.toDouble() +
        2 * notes.hold.toDouble() +
        3 * notes.slide.toDouble() +
        5 * notes.breakCount.toDouble();
  }

  // 转置表格数据
  Map<String, Map<String, String>> calculateTransposedResults() {
    final totalWeight = calculateTotalWeight();
    final x = 1 / totalWeight;
    final y = notes.breakCount > 0 ? 1 / notes.breakCount : 0.0;

    // 定义每种 Note 的公式
    final Map<String, Map<String, String>> results = {
      "TAP": {
        "数量": notes.tap.toString(),
        "CRITICAL": notes.tap == 0 ? "-" : "${(x * 100).toStringAsFixed(4)}%",
        "PERFECT": notes.tap == 0 ? "-" : "${(x * 100).toStringAsFixed(4)}%",
        "GREAT": notes.tap == 0 ? "-" : "${(0.8 * x * 100).toStringAsFixed(4)}%",
        "GOOD": notes.tap == 0 ? "-" : "${(0.5 * x * 100).toStringAsFixed(4)}%",
        "MISS": notes.tap == 0 ? "-" : "0.0000%",
      },
      "HOLD": {
        "数量": notes.hold.toString(),
        "CRITICAL": notes.hold == 0 ? "-" : "${(2 * x * 100).toStringAsFixed(4)}%",
        "PERFECT": notes.hold == 0 ? "-" : "${(2 * x * 100).toStringAsFixed(4)}%",
        "GREAT": notes.hold == 0 ? "-" : "${(1.6 * x * 100).toStringAsFixed(4)}%",
        "GOOD": notes.hold == 0 ? "-" : "${(x * 100).toStringAsFixed(4)}%",
        "MISS": notes.hold == 0 ? "-" : "0.0000%",
      },
      "SLIDE": {
        "数量": notes.slide.toString(),
        "CRITICAL": notes.slide == 0 ? "-" : "${(3 * x * 100).toStringAsFixed(4)}%",
        "PERFECT": notes.slide == 0 ? "-" : "${(3 * x * 100).toStringAsFixed(4)}%",
        "GREAT": notes.slide == 0 ? "-" : "${(2.4 * x * 100).toStringAsFixed(4)}%",
        "GOOD": notes.slide == 0 ? "-" : "${(2 * x * 100).toStringAsFixed(4)}%",
        "MISS": notes.slide == 0 ? "-" : "0.0000%",
      },
      "TOUCH": {
        "数量": notes.touch.toString(),
        "CRITICAL": notes.touch == 0 ? "-" : "${(x * 100).toStringAsFixed(4)}%",
        "PERFECT": notes.touch == 0 ? "-" : "${(x * 100).toStringAsFixed(4)}%",
        "GREAT": notes.touch == 0 ? "-" : "${(0.8 * x * 100).toStringAsFixed(4)}%",
        "GOOD": notes.touch == 0 ? "-" : "${(x * 100).toStringAsFixed(4)}%",
        "MISS": notes.touch == 0 ? "-" : "0.0000%",
      },
      "BREAK": {
        "数量": notes.breakCount.toString(),
        "CRITICAL": "${(5 * x * 100 + y).toStringAsFixed(4)}%",
        "PERFECT":
            "${(5 * x * 100 + 0.75 * y).toStringAsFixed(4)}%\n${(5 * x * 100 + 0.5 * y).toStringAsFixed(4)}%",
        "GREAT":
            "${(4 * x * 100 + 0.4 * y).toStringAsFixed(4)}%\n${(3 * x * 100 + 0.4 * y).toStringAsFixed(4)}%\n${(2.5 * x * 100 + 0.4 * y).toStringAsFixed(4)}%",
        "GOOD": "${(2 * x * 100 + 0.3 * y).toStringAsFixed(4)}%",
        "MISS": "0.0000%",
      },
    };

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final results = calculateTransposedResults();

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowMaxHeight: 56,
          columns: [
            const DataColumn(label: Text('类型')),
            ...["数量","CRITICAL", "PERFECT", "GREAT", "GOOD", "MISS"]
                .map((type) => DataColumn(label: Text(type))),
          ],
          rows: results.entries.map((entry) {
            final noteType = entry.key;
            final values = entry.value;

            return DataRow(cells: [
              DataCell(Text(noteType)),
              ...["数量","CRITICAL", "PERFECT", "GREAT", "GOOD", "MISS"]
                  .map((type) => DataCell(Text(values[type]!))),
            ]);
          }).toList(),
        ),
      );
  }
}
