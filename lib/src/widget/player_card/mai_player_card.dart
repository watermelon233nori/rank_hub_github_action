import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart'; // 引入玩家数据模型

class MaiPlayerCard extends StatefulWidget {
  const MaiPlayerCard({super.key});

  @override
  State<MaiPlayerCard> createState() => _MaiPlayerCardState();
}

class _MaiPlayerCardState extends State<MaiPlayerCard> {
  late Future<List<PlayerData>> _playerDataFuture;

  @override
  void initState() {
    super.initState();
    // 使用 LxApiServices 的 getAllPlayerData 获取玩家数据
    _playerDataFuture = LxMaiProvider(context: context).lxApiService.getAllPlayerData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: FutureBuilder<List<PlayerData>>(
        future: _playerDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败：${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('暂无玩家数据'));
          }

          final players = snapshot.data!;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Card(
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    // 背景容器，显示牌面图和渐变效果
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          tileMode: TileMode.clamp,
                        ).createShader(bounds),
                        blendMode: BlendMode.srcOver,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://assets.lxns.net/maimai/plate/${player.namePlate?.id}.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 玩家信息 (头像和文字)
                    ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://assets.lxns.net/maimai/icon/${player.icon?.id}.png',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 500),
                          placeholder: (context, url) => Transform.scale(
                            scale: 0.4,
                            child: const CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ),
                      title: Text(player.name), // 玩家姓名
                      subtitle: const Text('舞萌 DX'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
