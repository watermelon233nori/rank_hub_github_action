import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/pages/mai/song_detail_screen.dart';

class MaiSongList extends StatelessWidget {
  final List<SongInfo> songs;
  final ScrollController controller;

  const MaiSongList({super.key, required this.songs, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              child: CachedNetworkImage(
                imageUrl:
                    'https://assets2.lxns.net/maimai/jacket/${song.id}.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                fadeInDuration:
                    const Duration(milliseconds: 500), // Fade-in duration
                placeholder: (context, url) => Transform.scale(
                  scale: 0.4,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SongDetailScreen(song: song),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
