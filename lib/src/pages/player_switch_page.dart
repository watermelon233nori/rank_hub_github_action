import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/provider/player_manager.dart';

class PlayerSwitchPage extends StatefulWidget {
  const PlayerSwitchPage({super.key});

  @override
  State<PlayerSwitchPage> createState() => _PlayerSwitchPageState();
}

class _PlayerSwitchPageState extends State<PlayerSwitchPage> {
  late Future<List<PlayerData>> _lxMaiPlayerDataFuture;

  @override
  void initState() {
    super.initState();
    // 使用 LxApiServices 的 getAllPlayerData 获取玩家数据
    _lxMaiPlayerDataFuture =
        LxMaiProvider(context: context).lxApiService.getAllPlayerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Center(
              child: Text(
                '选择玩家',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Center(
              child: Text('选择你想要查看的玩家'),
            ),
            const SizedBox(height: 64),
            const Text('落雪 maimai DX 查分器'),
            const SizedBox(
              height: 8,
            ),
            FutureBuilder<List<PlayerData>>(
                future: _lxMaiPlayerDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('加载失败：${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('暂无玩家数据'));
                  }

                  final PlayerManager playerManager =
                      Provider.of<PlayerManager>(context, listen: true);

                  final players = snapshot.data!;
                  List<Widget> list = [];
                  for (PlayerData player in players) {
                    list.add(RadioListTile(
                      groupValue: playerManager.activePlayerId,
                      value: player.uuid,
                      onChanged: (value) {
                        playerManager.switchActivePlayer(value!);
                        Navigator.pop(context);
                      },
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(player.name), // 玩家姓名
                      subtitle: Text(player.uuid),
                    ));
                  }
                  return Column(
                    children: list,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
