import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rank_hub/src/model/song_genre_model.dart';
import 'package:rank_hub/src/widget/score_list/mai_score_list.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect_field/core/multi_select.dart';

class MaiRankPage extends StatefulWidget {
  const MaiRankPage({super.key});

  @override
  State<MaiRankPage> createState() => _MaiRankPageState();
}

class _MaiRankPageState extends State<MaiRankPage> {
  late ScrollController _controller;
  bool _isVisible = true;

  FloatingActionButtonLocation get _fabLocation => _isVisible
      ? FloatingActionButtonLocation.endContained
      : FloatingActionButtonLocation.endFloat;

  // 控制输入框的文本控制器
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // 存储搜索关键词
  String _searchQuery = "";

  void _listen() {
    switch (_controller.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        _show();
      case ScrollDirection.reverse:
        _hide();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _showFilterSheet(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    RangeValues sliderRange = RangeValues(1, 15);
    List<String> selectedCategories = [];
    List<String> selectedVersions = [];
    List<String> selectedDifficulties = [];

    // 定义选项列表
    List<Choice<SongGenre>> categories = [
      Choice<SongGenre>('1', '流行&动漫'),
      Choice<SongGenre>('2', 'niconico&VOCALOID™'),
      Choice<SongGenre>('3', '东方Project'),
      Choice<SongGenre>('4', '其他游戏'),
      Choice<SongGenre>('5', '舞萌'),
      Choice<SongGenre>('6', '中二节奏/音击'),
      Choice<SongGenre>('7', '宴会場')
    ];
    List<String> versions = [
      '舞萌 DX 2024',
      '舞萌 DX 2023',
      '舞萌 DX 2022',
      '舞萌 DX 2021',
      '舞萌 DX',
      'FiNALE',
      'MiLK PLUS',
      'MiLK',
      'MURASAKi PLUS',
      'MURASAKi',
      'PiNK PLUS',
      'PiNK',
      'ORANGE PLUS',
      'ORANGE',
      'GreeN PLUS',
      'GreeN',
      'maimai PLUS',
      'maimai'
    ];

    List<String> difficulties = [
      'BASIC',
      'ADVANCED',
      'EXPERT',
      'MASTER',
      'Re:MASTER',
      'U·TA·GE',
    ];

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true, // 允许底部表单在全屏展开时被键盘遮挡
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 16,
                  right: 16),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 搜索框：曲目名称
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(labelText: '曲目名称'),
                      ),

                      SizedBox(height: 10),

                      // 1-15 范围滑块
                      Text(
                          "定数选择: ${sliderRange.start.toStringAsFixed(1)} - ${sliderRange.end.toStringAsFixed(1)}"),
                      RangeSlider(
                        min: 1,
                        max: 15,
                        divisions: 140,
                        values: sliderRange,
                        labels: RangeLabels(
                          sliderRange.start.toStringAsFixed(1),
                          sliderRange.end.toStringAsFixed(1),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            sliderRange = values; // 使用 setState 更新滑块范围
                          });
                        },
                      ),

                      SizedBox(height: 10),

                      // 难度筛选 下拉框
                      MultiSelectDialogField(
                        items: difficulties
                            .map((difficulty) =>
                                MultiSelectItem<String>(difficulty, difficulty))
                            .toList(),
                        title: Text("选择难度"),
                        selectedColor: Colors.blue,
                        buttonText: Text("选择难度"),
                        onConfirm: (results) {
                          setState(() {
                            selectedDifficulties = List<String>.from(results);
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          items: selectedDifficulties
                              .map((difficulty) => MultiSelectItem<String>(
                                  difficulty, difficulty))
                              .toList(),
                          onTap: (value) {
                            setState(() {
                              selectedDifficulties.remove(value);
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 20),

                      // 乐曲分类筛选 多选框
                      MultiSelectField<SongGenre>(
                        title: (_) => Text('乐曲分类'),
                        data: () => categories,
                        onSelect: (selectedItems, _) {
                          setState(() {
                            selectedCategories = selectedItems
                                .map((item) => item.value)
                                .toList();
                          });
                        },
                      ),

                      SizedBox(height: 20),

                      // 版本筛选 多选框
                      MultiSelectDialogField(
                        items: versions
                            .map((version) =>
                                MultiSelectItem<String>(version, version))
                            .toList(),
                        title: Text("选择版本"),
                        selectedColor: Colors.blue,
                        buttonText: Text("选择版本"),
                        onConfirm: (results) {
                          setState(() {
                            selectedVersions = List<String>.from(results);
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          items: selectedVersions
                              .map((version) =>
                                  MultiSelectItem<String>(version, version))
                              .toList(),
                          onTap: (value) {
                            setState(() {
                              selectedVersions.remove(value);
                            });
                          },
                        ),
                      ),

                      // 完成、清空条件按钮
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // 完成操作
                              Navigator.pop(context);
                            },
                            child: Text('完成'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // 清空条件操作
                              setState(() {
                                searchController.clear();
                                sliderRange = RangeValues(1, 15); // 重置滑块范围
                                selectedDifficulties.clear();
                                selectedCategories.clear();
                                selectedVersions.clear();
                              });
                            },
                            child: Text('清空条件'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_listen);

    searchController.addListener(() {
      setState(() {
        _searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_listen);
    _controller.dispose();
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const TabBar(tabs: <Widget>[
              Tab(
                text: '所有成绩',
              ),
              Tab(
                text: 'B50',
              ),
            ]),
            title: TextButton(
              onPressed: () {
                // 按钮点击事件
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min, // 按钮大小自适应内容
                children: [
                  Text("QIANMO (舞萌 DX 2024)"),
                  SizedBox(width: 4), // 文本和图标之间的间距
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              const SizedBox(width: 8),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              SongCardList(
                searchQuery: _searchQuery,
                scrollController: _controller,
              ),
              const Center(
                child: Text("It's rainy here"),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showFilterSheet(context),
            tooltip: '高级筛选',
            elevation: _isVisible ? 0.0 : null,
            child: const Icon(Icons.filter_list),
          ),
          floatingActionButtonLocation: _fabLocation,
          bottomNavigationBar: _RankFliterBar(
              isElevated: true,
              isVisible: _isVisible,
              searchController: searchController,
              focusNode: focusNode),
        ));
  }
}

class _RankFliterBar extends StatelessWidget {
  const _RankFliterBar({
    required this.isElevated,
    required this.isVisible,
    required this.searchController,
    required this.focusNode
  });

  final bool isElevated;
  final bool isVisible;
  final TextEditingController searchController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isVisible ? 80.0 : 0,
      child: BottomAppBar(
        elevation: isElevated ? null : 0.0,
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: searchController,
              focusNode: focusNode,
              onTapOutside: (e) => {focusNode.unfocus()},
              decoration: const InputDecoration(
                filled: true,
                labelText: "搜索歌曲",
                hintText: "支持别名查找",
                prefixIcon: Icon(Icons.search),
              ),
            )),
            const SizedBox(width: 72),
          ],
        ),
      ),
    );
  }
}
