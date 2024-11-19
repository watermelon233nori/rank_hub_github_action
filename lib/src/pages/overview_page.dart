import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rank_hub/src/widget/overview_card/arcaea.dart';
import 'package:rank_hub/src/widget/overview_card/chuni_cn.dart';
import 'package:rank_hub/src/widget/overview_card/maimai_cn.dart';
import 'package:rank_hub/src/widget/overview_card/phigros.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  bool _refreshing = false;

  Future<void> refreshData() async {
    setState(() {
      _refreshing = true;
    });
    await Future.delayed(const Duration(seconds: 3)); // 模拟耗时操作
    setState(() {
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: refreshData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 76,
                automaticallyImplyLeading: false,
                expandedHeight: 150,
                floating: false,
                pinned: true,
                snap: false,
                leadingWidth: 0,
                titleSpacing: 0,
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                  const SizedBox(width: 8),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: const FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(24),
                  title: Text('概览'),
                  collapseMode: CollapseMode.pin,
                ),
              ),
              SliverFixedExtentList(
                  delegate: SliverChildListDelegate([
                    const MaimaiCn(),
                    const ChuniCn(),
                    const Phigros(),
                    const Arcaea()
                  ]),
                  itemExtent: 212)
            ],
          )),
      floatingActionButton: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        child: _refreshing
            ? FloatingActionButton.extended(
                onPressed: null,
                label: AnimatedOpacity(
                  opacity: _refreshing ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: const Text('正在刷新数据... 63%'),
                ),
                icon: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ))
            : FloatingActionButton(
                tooltip: '添加卡片',
                onPressed: null,
                child: Icon(Icons.add),
              ),
      ),
    );
  }
}
