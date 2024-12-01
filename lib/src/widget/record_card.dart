import 'package:flutter/material.dart';

abstract class RecordCard<R> extends StatelessWidget {
  final R recordData;

  const RecordCard({super.key, required this.recordData});
}