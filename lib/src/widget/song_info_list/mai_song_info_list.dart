import 'package:admonitions/admonitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rank_hub/src/model/maimai/song_alias.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/services/lx_api_services.dart';

class MaiSongInfoList extends StatefulWidget {
  final SongInfo song;
  final String version;

  const MaiSongInfoList({super.key, required this.song, required this.version});

  @override
  _MaiSongInfoListState createState() => _MaiSongInfoListState();
}

class _MaiSongInfoListState extends State<MaiSongInfoList> {
  Future<SongAlias?>? _songAliasFuture;

  @override
  void initState() {
    super.initState();
    // 在初始化时缓存 Future
    _songAliasFuture = LxApiService.getSongAliasById(widget.song.id);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCopyableListTile({
      required Icon leading,
      required String title,
      required String subtitle,
    }) {
      return ListTile(
        leading: leading,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onLongPress: () {
          // 复制到剪贴板
          Clipboard.setData(ClipboardData(text: subtitle));
          // 震动反馈
          HapticFeedback.mediumImpact();
          // 显示 Snackbar 提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title "$subtitle" 已复制到粘贴板')),
          );
        },
      );
    }

    Widget buildCopyableChip(String alias) {
      return GestureDetector(
        onLongPress: () {
          // 复制到剪贴板
          Clipboard.setData(ClipboardData(text: alias));
          // 震动反馈
          HapticFeedback.mediumImpact();
          // 显示 Snackbar 提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('别名 "$alias" 已复制到粘贴板')),
          );
        },
        child: Chip(
          label: Text(alias),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.song.disabled == true)
            const Padding(
              padding: EdgeInsets.all(16),
              child: PastelAdmonition.caution(
                text: "该曲目已被下架",
                color: Colors.red,
              ),
            ),
          const SizedBox(height: 16),
          FutureBuilder<SongAlias?>(
            future: _songAliasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.sync),
                  title: Text('曲目别名',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('加载中...'),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final aliases = snapshot.data!.aliases;
                return ListTile(
                  leading: const Icon(Icons.label),
                  title: const Text('曲目别名',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: aliases
                        .map((alias) => buildCopyableChip(alias))
                        .toList(),
                  ),
                );
              } else {
                return const ListTile(
                  leading: Icon(Icons.label),
                  title: Text('曲目别名',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('无别名'),
                );
              }
            },
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.info),
            title: '曲目 ID',
            subtitle: '${widget.song.id}',
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.music_note),
            title: '歌曲名',
            subtitle: widget.song.title,
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.person),
            title: '艺术家',
            subtitle: widget.song.artist,
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.category),
            title: '分类',
            subtitle: widget.song.genre,
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.speed),
            title: 'BPM',
            subtitle: '${widget.song.bpm}',
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.map),
            title: '曲目出现的地图',
            subtitle: widget.song.map ?? "N/A",
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.history),
            title: '曲目首次出现的版本',
            subtitle: widget.version,
          ),
          buildCopyableListTile(
            leading: const Icon(Icons.copyright),
            title: '版权',
            subtitle: widget.song.rights ?? "N/A",
          ),
        ],
      ),
    );
  }
}
