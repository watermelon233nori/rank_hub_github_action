import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/provider/data_source_manager.dart';
import 'package:rank_hub/src/provider/data_source_provider.dart';
import 'package:rank_hub/src/provider/player_manager.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  @override
  Widget build(BuildContext context) {
    final DataSourceManager dataSourceManager = Provider.of<DataSourceManager>(context, listen: true);
    final PlayerManager playerManager = Provider.of<PlayerManager>(context, listen: true);

    if (playerManager.activePlayerId == null || playerManager.getDataSourceName() == null) {
      return const Scaffold(body: Center(child: Text('没有数据'),),);
    }

    DataSourceProvider dataSourceProvider = dataSourceManager.getDataSource(playerManager.getDataSourceName()!)!;

    return dataSourceProvider.buildRecordList();
  }
}