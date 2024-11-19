import 'package:flutter/material.dart';

abstract class ScoreCard extends StatelessWidget {
  final Map<String, dynamic> scoreData;

  const ScoreCard({super.key, required this.scoreData});
}