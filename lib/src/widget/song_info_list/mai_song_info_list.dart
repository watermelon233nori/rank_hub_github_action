import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';

class MaiSongInfoList extends StatelessWidget {
  final SongInfo song;
  final String version;
  const MaiSongInfoList({super.key, required this.song, required this.version});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('曲目 ID',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${song.id}'),
        ),
        ListTile(
          leading: const Icon(Icons.music_note),
          title:
              const Text('歌曲名', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(song.title),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title:
              const Text('艺术家', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(song.artist),
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title:
              const Text('分类', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(song.genre),
        ),
        ListTile(
          leading: const Icon(Icons.speed),
          title:
              const Text('BPM', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${song.bpm}'),
        ),
        ListTile(
          leading: const Icon(Icons.map),
          title: const Text('曲目出现的地图',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(song.map ?? "N/A"),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('曲目首次出现的版本',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(version),
        ),
        ListTile(
          leading: const Icon(Icons.copyright),
          title:
              const Text('版权', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(song.rights ?? "N/A"),
        ),
      ],
    );
  }
}
