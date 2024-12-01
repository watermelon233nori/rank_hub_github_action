import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/view/maimai/lx_song_card.dart';

class LxMaiSongList extends StatelessWidget {
  final LxMaiProvider provider;
  final List<SongInfo> songs;
  final ScrollController controller;

  const LxMaiSongList({super.key, required this.songs, required this.controller, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return LxMaiSongCard(songData: song, provider: provider);
      },
    );
  }
}
