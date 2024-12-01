import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PlayerManager with ChangeNotifier {
  final Map<String, String> _playerDataSourceMap = {}; // 玩家ID -> 数据源名称
  String? _activePlayerId;

  static const _currentPlayerKey = 'currentPlayer';

  // 获取当前活动玩家ID
  String? get activePlayerId => _activePlayerId;

  // 获取所有玩家ID
  List<String> get allPlayers => _playerDataSourceMap.keys.toList();

  // 添加玩家并绑定数据源
  Future<void> addPlayer(String playerId, String dataSourceName) async {
    if (_playerDataSourceMap.containsKey(playerId)) {
      return; // 避免重复添加
    }

    _playerDataSourceMap[playerId] = dataSourceName;

    // 如果是第一个玩家，设置为活动玩家
    if (activePlayerId == null) {
      await switchActivePlayer(playerId);
    }

    notifyListeners();
  }

  // 删除玩家
  Future<void> removePlayer(String playerId) async {
    if (!_playerDataSourceMap.containsKey(playerId)) {
      return;
    }

    _playerDataSourceMap.remove(playerId);

    if (_activePlayerId == playerId) {
      _activePlayerId = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(playerId);

      if (_playerDataSourceMap.isNotEmpty) {
        await switchActivePlayer(_playerDataSourceMap.keys.first);
      }
    }

    notifyListeners();
  }

  // 切换活动玩家
  Future<void> switchActivePlayer(String playerId) async {
    if (_activePlayerId == playerId ||
        !_playerDataSourceMap.containsKey(playerId)) {
      return;
    }
    _activePlayerId = playerId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentPlayerKey, playerId);


    notifyListeners();
  }

  String? getDataSourceName({String? playerId}) {
    if (playerId != null) {
    return _playerDataSourceMap[playerId];
    } else {
      return _playerDataSourceMap[_activePlayerId];
    }
  }
}
