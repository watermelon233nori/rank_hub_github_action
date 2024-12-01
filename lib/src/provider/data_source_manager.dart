import 'package:flutter/foundation.dart';
import 'package:rank_hub/src/provider/data_source_provider.dart';

class DataSourceManager with ChangeNotifier {
  DataSourceManager({List<DataSourceProvider>? initialDataSources}) {
    // 如果有初始数据源，注册并设置默认活动数据源
    if (initialDataSources != null) {
      for (var provider in initialDataSources) {
        registerDataSource(provider, setActiveIfNone: true);
      }
    }
  }

  final Map<String, DataSourceProvider> _dataSources = {};
  DataSourceProvider? _activeDataSource;

  // 获取当前活动数据源
  DataSourceProvider? get activeDataSource => _activeDataSource;

  // 获取所有数据源
  List<DataSourceProvider> get allDataSources => _dataSources.values.toList();

  // 注册数据源
  void registerDataSource(DataSourceProvider provider,
      {bool setActiveIfNone = false}) {
    if (_dataSources.containsKey(provider.getProviderName())) {
      return; // 避免重复注册
    }

    _dataSources[provider.getProviderName()] = provider;

    // 如果没有活动数据源，则将其设置为活动数据源
    if (_activeDataSource == null || setActiveIfNone) {
      _activeDataSource = provider;
    }

    notifyListeners();
  }

  // 删除数据源
  void unregisterDataSource(String providerName) {
    _dataSources.remove(providerName);

    // 如果当前活动数据源被删除，选择下一个数据源或清空
    if (_activeDataSource?.getProviderName() == providerName) {
      _activeDataSource =
          _dataSources.values.isNotEmpty ? _dataSources.values.first : null;
    }

    notifyListeners();
  }

  // 设置当前活动数据源
  void setActiveDataSource(String providerName) {
    if (_dataSources.containsKey(providerName)) {
      _activeDataSource = _dataSources[providerName];
      notifyListeners();
    }
  }

  // 检查是否已注册某个数据源
  bool isRegistered(String providerName) {
    return _dataSources.containsKey(providerName);
  }

  DataSourceProvider? getDataSource(String providerName) {
    return _dataSources[providerName];
  }
}
