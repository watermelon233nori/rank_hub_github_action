import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rank_hub/src/pages/data_src_page.dart';
import 'package:rank_hub/src/pages/rank_page.dart';
import 'package:rank_hub/src/pages/wiki_page.dart';
import 'package:rank_hub/src/view/settings_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const _channel = MethodChannel('fun.meow0.rankhub.network');
  int _selectedIndex = 0; // 当前选中的导航索引
  late final PageController _pageController; // 延迟初始化 PageController

  Future<void> startTunnel() async {
    await _channel.invokeMethod('startTunnel');
  }

  Future<void> stopTunnel() async {
    await _channel.invokeMethod('stopTunnel');
  }

  // 底部导航项列表
  final List<NavigationDestination> _navItems = const [
    NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: '概览'),
    NavigationDestination(
        icon: Icon(Icons.insert_chart_outlined),
        selectedIcon: Icon(Icons.insert_chart),
        label: '成绩'),
    NavigationDestination(
        icon: Icon(Icons.book_outlined),
        selectedIcon: Icon(Icons.book),
        label: '百科'),
    NavigationDestination(
        icon: Icon(Icons.cloud_outlined),
        selectedIcon: Icon(Icons.cloud),
        label: '数据源'),
    NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: '设置'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _selectedIndex); // 初始化 PageController
  }

  @override
  void dispose() {
    _pageController.dispose(); // 销毁 PageController
    super.dispose();
  }

  // 导航项点击事件处理
  void _onNavItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
      ); // 平滑滚动到目标页面
    }
  }

  // 页面切换事件处理
  void _onPageChanged(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 页面列表
    final List<Widget> pages = [
      const Center(child:  Text("还没想好这部分要怎么写")),
      //Center(
      //  child: Column(
      //    children: [
      //      SizedBox(
      //        height: 64,
      //      ),
      //      ElevatedButton(onPressed: startTunnel, child: Text('启动')),
      //      ElevatedButton(onPressed: stopTunnel, child: Text('关闭')),
      //  ],
      //)),
      const RankPage(),
      const WikiPage(),
      const DataSrcPage(),
      SettingsPage(),
    ];
    // 设置系统界面样式
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: _navItems,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: pages,
      ),
    );
  }
}
