import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/provider/data_source_manager.dart';
import 'package:rank_hub/src/provider/data_source_provider.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataSourceManager>(builder: (ctx, dataSouceManager, child) {
      DataSourceProvider? provider = dataSouceManager.activeDataSource;
      if (provider == null) {
        return const Scaffold(body: Center(child: Text('没有数据'),));
      } else {
        return provider.buildSongList();
      }
    });
  }
}

