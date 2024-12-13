import 'package:flutter/material.dart';

class MaiCalculate extends StatelessWidget {
  const MaiCalculate({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child:  Scaffold(
      appBar: AppBar(
        title: Text('计算工具'),
        bottom: TabBar(tabs: [
          Tab(text: '分数线计算',)
        ]),
      ),
      body: TabBarView(children: [
        
      ]),
    ));
  }
}