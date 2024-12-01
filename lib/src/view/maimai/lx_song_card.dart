import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';

class LxMaiSongCard extends StatelessWidget {
  final LxMaiProvider provider;
  final SongInfo songData;

  const LxMaiSongCard({super.key, required this.songData, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              child: CachedNetworkImage(
                imageUrl:
                    'https://assets2.lxns.net/maimai/jacket/${songData.id}.png',
                width: 56,
                height: 56,
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
            title: Text(songData.title),
            subtitle: Text(songData.artist),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => provider.buildSongDetailScreen(songData),
                ),
              );
            },
          ),
        );
  }
}