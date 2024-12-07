import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_notes.dart';

class MaiNoteTable extends StatelessWidget {
  final SongNotes notes;
  final int calculateMode;

  final Map<String, Color> typeColors = {
    "CRITICAL": Colors.yellow,
    "PERFECT": Colors.orange,
    "GREAT": Colors.purpleAccent,
    "GOOD": Colors.green,
    "MISS": Colors.grey,
  };

  MaiNoteTable({super.key, required this.notes, required this.calculateMode});

  // 补正总物量计算
  double calculateTotalWeight() {
    return notes.tap.toDouble() +
        notes.touch.toDouble() +
        2 * notes.hold.toDouble() +
        3 * notes.slide.toDouble() +
        5 * notes.breakCount.toDouble();
  }

  Map<String, Map<String, String>> calculateResults() {
    final totalWeight = calculateTotalWeight();
    final x = 1 / totalWeight;
    final y = notes.breakCount > 0 ? 1 / notes.breakCount : 0.0;

    Map<String, Map<String, String>> generateResults(
        SongNotes notes, double x, double y, int mode) {
      Map<String, String> generateEntry(
          int count, double criticalFactor, double perfectFactor,
          [double? greatFactor, double? goodFactor]) {
        double criticalScore = criticalFactor * x * 100;
        double perfectScore = perfectFactor * x * 100;

        String calculate(double factor) {
          double value = factor * x * 100;
          if (mode == 1) {
            value -= criticalScore;
          } else if (mode == 2) {
            value -= perfectScore;
          }
          return value.toStringAsFixed(4);
        }

        return {
          "数量": count.toString(),
          "CRITICAL": count == 0 ? "-" : "${calculate(criticalFactor)}%",
          "PERFECT": count == 0 ? "-" : "${calculate(perfectFactor)}%",
          "GREAT": count == 0
              ? "-"
              : "${calculate(greatFactor ?? perfectFactor * 0.8)}%",
          "GOOD": count == 0
              ? "-"
              : "${calculate(goodFactor ?? perfectFactor * 0.5)}%",
          "MISS": count == 0 ? "-" : "${calculate(0)}%",
        };
      }

      String calculateBreak(double baseFactor, double additionalFactor,
          {double? perfectBase}) {
        double criticalScore = 5 * x * 100 + y;
        double perfectScore = (perfectBase ?? 5) * x * 100 + 0.75 * y;
        double value = baseFactor * x * 100 + additionalFactor * y;

        if (mode == 1) {
          value -= criticalScore;
        } else if (mode == 2) {
          value -= perfectScore;
        }
        return value.toStringAsFixed(4);
      }

      return {
        "TAP": generateEntry(notes.tap, 1, 1, 0.8, 0.5),
        "HOLD": generateEntry(notes.hold, 2, 2, 1.6, 1),
        "SLIDE": generateEntry(notes.slide, 3, 3, 2.4, 2),
        "TOUCH": generateEntry(notes.touch, 1, 1, 0.8, 1),
        "BREAK": {
          "数量": notes.breakCount.toString(),
          "CRITICAL": "${calculateBreak(5, 1)}%",
          "PERFECT": "${calculateBreak(5, 0.75)}%\n${calculateBreak(5, 0.5)}%",
          "GREAT":
              "${calculateBreak(4, 0.4)}%\n${calculateBreak(3, 0.4)}%\n${calculateBreak(2.5, 0.4)}%",
          "GOOD": "${calculateBreak(2, 0.3)}%",
          "MISS": "${calculateBreak(0, 0)}%",
        },
      };
    }

    return generateResults(notes, x, y, calculateMode);
  }

  @override
  Widget build(BuildContext context) {
    final results = calculateResults();

    return SizedBox(
      height: 600,
      width: double.infinity,
      child: DataTable2(
        columnSpacing: 12,
        minWidth: 720,
        dataRowHeight: 56,
        fixedLeftColumns: 1,
        isHorizontalScrollBarVisible: false,
        isVerticalScrollBarVisible: false,
        headingRowHeight: 56,
        columns: [
          const DataColumn(
            label: Text(
              '类型',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...["数量", "CRITICAL", "PERFECT", "GREAT", "GOOD", "MISS"]
              .map((type) => DataColumn(
                    label: Text(
                      type,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: typeColors[type]),
                    ),
                  )),
        ],
        rows: results.entries.map((entry) {
          final noteType = entry.key;
          final values = entry.value;

          return DataRow(cells: [
            DataCell(Text(
              noteType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
            ...["数量", "CRITICAL", "PERFECT", "GREAT", "GOOD", "MISS"]
                .map((type) => DataCell(Text(values[type]!))),
          ]);
        }).toList(),
      ),
    );
  }
}
