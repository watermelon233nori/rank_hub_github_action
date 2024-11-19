import 'package:flutter/material.dart';

abstract class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key});

  Widget buildPlayerName();

  Widget buildCardBackground();

  Widget buildPlayerAvatar();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}