import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/src/pages/add_player_screen.dart';
import 'package:rank_hub/src/widget/player_card/mai_player_card.dart';

class DataSrcPage extends StatefulWidget {
  const DataSrcPage({super.key});

  @override
  State<DataSrcPage> createState() => _DataSrcPageState();
}

class _DataSrcPageState extends State<DataSrcPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('数据源'),
            automaticallyImplyLeading: false,
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.sync))],
            bottom: const TabBar(tabs: <Widget>[
              Tab(
                text: '玩家数据',
              ),
              Tab(
                text: '游戏数据',
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddPlayerScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          body: TabBarView(
            children: [
              MaiPlayerCard(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: ListView(
                  children: [
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: 'https://maimai.lxns.net/favicon.webp',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(
                            milliseconds: 500), // Fade-in duration
                        placeholder: (context, url) => Transform.scale(
                          scale: 0.4,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      title: Text('落雪咖啡屋'),
                      subtitle: Text('maimai.lxns.net'),
                      trailing: Switch(value: true, onChanged: (_) {}),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
