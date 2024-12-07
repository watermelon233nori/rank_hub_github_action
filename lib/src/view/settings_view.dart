import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/viewmodel/settings_vm.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Consumer<SettingsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('设置(施工中)'),
            ),
            body: ListView(
              children: [
                // 深色模式切换
                SwitchListTile(
                  title: const Text('深色模式'),
                  value: viewModel.settings.isDarkMode,
                  onChanged: viewModel.toggleDarkMode,
                ),

                // 主题色选择
                ListTile(
                  title: const Text('主题色'),
                  trailing: DropdownButton<String>(
                    value: viewModel.settings.themeColor,
                    items: ['Blue', 'Red', 'Green', 'Purple']
                        .map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            ))
                        .toList(),
                    onChanged: (value) => viewModel.updateThemeColor(value!),
                  ),
                ),

                // 语言选择
                ListTile(
                  title: const Text('语言'),
                  trailing: DropdownButton<String>(
                    value: viewModel.settings.language,
                    items: ['English', 'Chinese', 'Japanese']
                        .map((lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ))
                        .toList(),
                    onChanged: (value) => viewModel.updateLanguage(value!),
                  ),
                ),

                // 玩家数据缓存时间
                ListTile(
                  title: const Text('玩家数据缓存时间'),
                  trailing: Text(
                      '${viewModel.settings.playerDataCacheDuration.inHours} hours'),
                  onTap: () {
                    showCupertinoTimerPicker(
                      context,
                      initialDuration:
                          viewModel.settings.playerDataCacheDuration,
                      onConfirm: viewModel.updatePlayerCacheDuration,
                    );
                  },
                ),

                // 游戏数据缓存时间
                ListTile(
                  title: const Text('游戏数据缓存时间'),
                  trailing: Text(
                      '${viewModel.settings.gameDataCacheDuration.inHours} hours'),
                  onTap: () {
                    showCupertinoTimerPicker(
                      context,
                      initialDuration: viewModel.settings.gameDataCacheDuration,
                      onConfirm: viewModel.updateGameCacheDuration,
                    );
                  },
                ),

                // 清除缓存
                ListTile(
                  title: const Text('清除数据缓存'),
                  onTap: () => showConfirmationDialog(
                    context,
                    title: '清除缓存',
                    content: '你确定要清除所有缓存吗，这将会从相关数据源重新拉取所有数据',
                    onConfirm: viewModel.clearCache,
                  ),
                ),

                // 导出玩家数据
                ListTile(
                  title: const Text('导出玩家数据'),
                  onTap: viewModel.exportPlayerData,
                ),

                // 导入玩家数据
                ListTile(
                  title: const Text('导入玩家数据'),
                  onTap: viewModel.importPlayerData,
                ),

                const Divider(),

                // 版本
                ListTile(
                  title: const Text('版本'),
                  subtitle: const Text('1.0.0'),
                ),

                // 隐私政策
                ListTile(
                  title: const Text('隐私政策'),
                  onTap: () {
                    // 跳转隐私政策页面
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // CupertinoTimerPicker
  void showCupertinoTimerPicker(
    BuildContext context, {
    required Duration initialDuration,
    required Function(Duration) onConfirm,
  }) {
    Duration selectedDuration = initialDuration; // 初始化为初始值

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(8),
        height: 300,
        child: Column(
          children: [
            // 确认按钮
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.pop(context); // 关闭底部弹窗
                  onConfirm(selectedDuration); // 调用回调函数
                },
              ),
            ),

            // CupertinoTimerPicker 本体
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: initialDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  selectedDuration = newDuration; // 更新选定的值
                },
              ),
            ),

            SizedBox(height: 24)
          ],
        ),
      ),
    );
  }

  // 确认对话框
  void showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Function() onConfirm,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(title),
        message: Text(content),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); // 关闭弹窗
              onConfirm(); // 执行确认操作
            },
            isDestructiveAction: true,
            child: const Text('确定'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context), // 关闭弹窗
          child: const Text('取消'),
        ),
      ),
    );
  }
}
