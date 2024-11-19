import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/services/lx_api_services.dart';

class AddLxMaiScreen extends StatefulWidget {
  const AddLxMaiScreen({super.key});

  @override
  State<AddLxMaiScreen> createState() => _AddLxMaiScreenState();
}

class _AddLxMaiScreenState extends State<AddLxMaiScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  bool _isLoading = false; // 是否正在加载
  bool _isSuccess = false; // 是否添加成功

  PlayerData? _playerData; // 玩家数据

  // 异步方法：添加玩家
  Future<void> _addPlayer() async {
    final apiKey = _textEditingController.text.trim();

    if (apiKey.isEmpty) {
      _showErrorDialog('请输入有效的 API 密钥');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 调用 API 服务
      final player = await LxApiService().addPlayer(apiKey);
      setState(() {
        _playerData = player;
        _isSuccess = true;
      });
    } on DioException catch (e) {
      // 根据响应码处理错误
      String errorMessage;
      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 401:
            errorMessage = '身份验证失败，请检查 API 密钥是否正确';
            break;
          case 500:
            errorMessage = '服务器内部错误，请稍后重试';
            break;
          default:
            errorMessage = '请求失败，错误码：${e.response?.statusCode}';
        }
      } else {
        // 网络问题或其他错误
        errorMessage = '无法连接到服务器，请检查网络';
      }
      _showErrorDialog(errorMessage);
    } on Exception catch (e) {
      // 根据异常类型判断是否是重复添加
      final errorMessage = e.toString().contains('该玩家已存在')
          ? '该玩家已存在，不能重复添加'
          : '添加失败：${e.toString()}';
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('发生未知错误：${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 显示错误提示对话框
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('错误'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo 显示
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: 'https://maimai.lxns.net/logo.webp',
                          ),
                        ),
                        const SizedBox(height: 32),
                        // 成功后切换为成功信息，否则显示标题
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isSuccess
                              ? Text(
                                  '玩家数据已添加：${_playerData?.name ?? ''}',
                                  key: ValueKey('successText'),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              : const Text(
                                  '登录 落雪查分器',
                                  key: ValueKey('titleText'),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        const SizedBox(height: 32),
                        // 如果成功，则隐藏输入框，显示完成按钮
                        if (!_isSuccess)
                          TextField(
                            enabled: !_isLoading,
                            controller: _textEditingController,
                            onTapOutside: (event) {
                              _focusNode.unfocus();
                            },
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) => {_addPlayer()},
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              labelText: '个人 API 密钥',
                              filled: true,
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .popUntil(ModalRoute.withName('/')),
                            child: const Text('完成'),
                          ),
                        const SizedBox(height: 32),
                        // 添加按钮或加载指示器
                        if (!_isSuccess)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _addPlayer,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Text('添加'),
                            ),
                          ),
                        const Spacer(),
                        // 底部说明文字
                        const Center(
                          child: Text(
                            '你的凭据将安全地保存在本地，仅用于向 maimai.lxns.net 验证身份，不会上传至其他服务器',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
