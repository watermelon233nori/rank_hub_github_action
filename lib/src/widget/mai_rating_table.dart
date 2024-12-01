import 'package:flutter/material.dart';

class MaiRatingTable extends StatelessWidget {
  MaiRatingTable({super.key, required this.level});

  final num level;

  final List<Map<String, dynamic>> ratingFactors = [
    {"achievements": 100.5, "rating": "SSS+", "factor": 0.224},
    {"achievements": 100.4999, "rating": "SSS", "factor": 0.222},
    {"achievements": 100.0, "rating": "SSS", "factor": 0.216},
    {"achievements": 99.9999, "rating": "SS+", "factor": 0.214},
    {"achievements": 99.5, "rating": "SS+", "factor": 0.211},
    {"achievements": 99.0, "rating": "SS", "factor": 0.208},
    {"achievements": 98.9999, "rating": "S+", "factor": 0.206},
    {"achievements": 98.0, "rating": "S+", "factor": 0.203},
    {"achievements": 97.0, "rating": "S", "factor": 0.2},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text("达成率", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("评级", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("DX Rating",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: ratingFactors
            .map(
              (data) => DataRow(
                cells: [
                  DataCell(Text("${data['achievements']}%")),
                  DataCell(Text(data['rating'])),
                  DataCell(Text((data['factor'] * level * data['achievements'])
                      .toStringAsFixed(0))),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
