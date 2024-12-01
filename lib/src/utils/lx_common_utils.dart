import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class LxCommonUtils {
  static const baseUrl = 'https://maimai.lxns.net/api/v0';

  static final Dio _dio = Dio();

  /// 验证缓存是否有效
  static bool isCacheValid(DateTime? lastCacheTime, Duration duration) {
    return lastCacheTime != null &&
        DateTime.now().difference(lastCacheTime) < duration;
  }

  /// 处理网络请求并返回数据
  static Future<dynamic> fetchData(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      final headers = token != null
          ? {
              'X-User-Token': token,
            }
          : null;

      final response = await _dio.get(
        baseUrl + endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 持久化数据到 Hive
  static Future<void> saveToHive<T>(
      Box<T> box, List<T> data, dynamic Function(T) keyMapper) async {
    await box.clear();
    for (var item in data) {
      await box.put(keyMapper(item), item);
    }
  }
}
