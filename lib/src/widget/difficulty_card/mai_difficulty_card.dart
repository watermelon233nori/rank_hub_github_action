import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/song_difficulty.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';

class MaiDifficultyCard extends StatefulWidget {
  final SongDifficulty songDifficulty;
  final int songId;

  const MaiDifficultyCard(
      {super.key, required this.songDifficulty, required this.songId});

  @override
  State<MaiDifficultyCard> createState() => _MaiDifficultyCardState();
}

class _MaiDifficultyCardState extends State<MaiDifficultyCard> {
  String version = '';
  SongScore? songScore;

  @override
  void initState() {
    super.initState();
    getVersion();
    getSocre();
  }

  Future<void> getVersion() async {
    var a = await LxMaiProvider(context: context)
        .lxApiService
        .getTitleByVersion(widget.songDifficulty.version);
    setState(() {
      version = a;
    });
  }

  Future<void> getSocre() async {
    try {
      var a = await LxMaiProvider(context: context).lxApiService.getRecordById(
          '${widget.songId}_${widget.songDifficulty.type}_${widget.songDifficulty.difficulty}');
      setState(() {
        songScore = a;
      });
    } catch (_) {}
  }

  Color _getCardBgColor() {
    switch (widget.songDifficulty.difficulty) {
      case 0:
        return Colors.green.shade600;
      case 1:
        return Colors.yellow.shade800;
      case 2:
        return Colors.red.shade600;
      case 3:
        return Colors.purple.shade600;
      case 4:
        return Colors.purple.shade300;

      default:
        return Colors.blue.shade600;
    }
  }

  Color _getCardBorderColor() {
    switch (widget.songDifficulty.difficulty) {
      case 0:
        return Colors.green.shade900;
      case 1:
        return Colors.yellow.shade900;
      case 2:
        return Colors.red.shade900;
      case 3:
        return Colors.purple.shade900;
      case 4:
        return Colors.purple.shade600;

      default:
        return Colors.blue.shade900;
    }
  }

  // Method to get the type chip color (Standard = Blue, DX = Orange)
  MaterialColor _getTypeColor(String type) {
    if (type == 'standard') {
      return Colors.blue; // Standard - Blue
    } else if (type == 'dx') {
      return Colors.orange; // DX - Orange
    } else if (type == 'utage') {
      return Colors.purple;
    } else {
      return Colors.grey; // Default color
    }
  }

  MaterialColor _getFsColor(String? fs) {
    if (fs == 'sync') {
      return Colors.lightBlue;
    } else if (fs == 'fs' || fs == 'fsp') {
      return Colors.blue;
    } else if (fs == 'fsd' || fs == 'fsdp') {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  String _getFsText(String? fs) {
    switch (fs) {
      case 'sync':
        return 'SYNC';
      case 'fs':
        return 'FS';
      case 'fsp':
        return 'FS+';
      case 'fsd':
        return 'FSD';
      case 'fsdp':
        return 'FSD+';
      default:
        return '';
    }
  }

  MaterialColor _getFcColor(String? fc) {
    if (fc == 'fc' || fc == 'fcp') {
      return Colors.green;
    } else if (fc == 'ap' || fc == 'app') {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  String _getFcText(String? fc) {
    switch (fc) {
      case 'fc':
        return 'FC';
      case 'fcp':
        return 'FC+';
      case 'ap':
        return 'AP';
      case 'app':
        return 'AP+';
      default:
        return '';
    }
  }

  List<String> _splitAchievements() {
    if (songScore == null) {
      return [];
    } else {
      return songScore!.achievements.toStringAsFixed(4).split('.');
    }
  }

  List<String> _splitLevelValue() {
    return widget.songDifficulty.levelValue.toStringAsFixed(1).split('.');
  }

  // Map level index to its corresponding prefix
  final levelPrefixes = [
    "BASIC", // 0
    "ADVANCED", // 1
    "EXPERT", // 2
    "MASTER", // 3
    "Re:MASTER", // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 设置圆角
            side: BorderSide(
              color: _getCardBorderColor(), // 边框颜色
              width: 4, // 边框宽度
            )),
        color: _getCardBgColor(),
        child: IntrinsicHeight(
            child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(levelPrefixes[widget.songDifficulty.difficulty],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                  const SizedBox(
                    width: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _splitLevelValue()[0],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '.${_splitLevelValue()[1]}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (widget.songDifficulty.levelValue % 1 >= 0.6)
                    Transform.translate(
                      offset: Offset(4, -8),
                      child: const Text(
                        '+',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  const Spacer(),
                  Chip(
                    side: BorderSide(
                        width: 2,
                        color:
                            _getTypeColor(widget.songDifficulty.type).shade700),
                    label: Text(
                      widget.songDifficulty.type == 'standard' ? '标准' : 'DX',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getTypeColor(widget.songDifficulty.type),
                  ),
                ],
              ),
              const Opacity(opacity: 0.6, child: Divider()),
              if (songScore != null)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '达成率',
                          style: TextStyle(fontSize: 12),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _splitAchievements()[0],
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '.${_splitAchievements()[1]}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    if (_getFcText(songScore!.fc).isNotEmpty)
                      Chip(
                        side: BorderSide(
                            width: 2,
                            color: _getFcColor(songScore!.fc).shade700),
                        label: Text(
                          _getFcText(songScore!.fc),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getFcColor(songScore!.fc),
                      ),
                    if (_getFsText(songScore!.fs).isNotEmpty)
                      const SizedBox(width: 8),
                    if (_getFsText(songScore!.fs).isNotEmpty)
                      Chip(
                        side: BorderSide(
                            width: 2,
                            color: _getFsColor(songScore!.fs).shade700),
                        label: Text(
                          _getFsText(songScore!.fs),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getFsColor(songScore!.fs),
                      ),
                  ],
                ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  Row(
                    children: [
                      const Text('谱师: '),
                      Expanded(
                        child: Text(
                          widget.songDifficulty.noteDesigner,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('版本: '),
                          Text(
                            version,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
