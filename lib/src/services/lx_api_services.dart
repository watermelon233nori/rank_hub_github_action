import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/model/maimai/song_alias.dart';
import 'package:rank_hub/src/model/maimai/song_genre.dart';
import 'package:rank_hub/src/model/maimai/song_version.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/utils/lx_common_utils.dart';
import 'package:rank_hub/src/provider/player_manager.dart';
import 'package:uuid/uuid.dart';

class LxApiService {
  static const playerDataPath = '/user/maimai/player';
  static const playerScorePath = '/user/maimai/player/scores';
  static const songDataPath = '/maimai/song/list';
  static const songAliasPath = '/maimai/alias/list';

  final fss.FlutterSecureStorage _secureStorage =
      const fss.FlutterSecureStorage();
  final PlayerManager _playerManager;
  final LxMaiProvider _lxMaiProvider;

  static const scoreCacheDuration = Duration(hours: 1);
  static const dataCacheDuration = Duration(days: 1);

  LxApiService(this._playerManager, this._lxMaiProvider);

  // 获取当前玩家的 UUID
  String get _currentUuid {
    final uuid = _playerManager.activePlayerId;
    if (uuid == null) throw Exception('当前未选择玩家');
    return uuid;
  }

  // 获取当前玩家的 Token
  Future<String> _getCurrentToken() async {
    final uuid = _currentUuid;
    final token = await _secureStorage.read(key: 'token_$uuid');
    if (token == null) throw Exception('玩家 Token 不存在，请重新登录');
    return token;
  }

  // 获取当前玩家专属的 Box 名称
  String get _currentPlayerBoxName => 'scoreBox_$_currentUuid';

  // 获取当前玩家的 Record 列表
  Future<List<SongScore>> getRecordList({bool forceRefresh = false}) async {
    final scoreBox = await Hive.openBox<SongScore>(_currentPlayerBoxName);
    final playerDataBox = await Hive.openBox<PlayerData>('playerData');
    final cacheInfoBox = await Hive.openBox<DateTime>('cacheInfo');
    final lastCacheTime = cacheInfoBox.get('SongScoreCacheTime_$_currentUuid');

    if (!forceRefresh &&
        LxCommonUtils.isCacheValid(lastCacheTime, scoreCacheDuration)) {
      List<SongScore> scores = scoreBox.values.toList();
      scores.sort((a, b) => b.dxRating!.compareTo(a.dxRating!));
      return scores;
    }

    try {
      final data = await LxCommonUtils.fetchData(
        playerDataPath,
        token: await _getCurrentToken(),
      );

      final playerData = PlayerData.fromLxJson(data['data'], _currentUuid);
      await playerDataBox.put(_currentUuid, playerData);
    } catch(e) {
      rethrow;
    }

    try {
      final token = await _getCurrentToken();
      final response =
          await LxCommonUtils.fetchData(playerScorePath, token: token);
      final data = response['data'] ?? [];
      List<SongScore> scores =
          data.map<SongScore>((json) => SongScore.fromLxJson(json)).toList();

      await LxCommonUtils.saveToHive(scoreBox, scores,
          (score) => '${score.id}_${score.type}_${score.levelIndex}');
      await cacheInfoBox.put(
          'SongScoreCacheTime_$_currentUuid', DateTime.now());

      return scores;
    } catch (e) {
      rethrow;
    }
  }

  // 获取当前玩家的单条 Record
  Future<SongScore?> getRecordById(String id) async {
    final scoreBox = await Hive.openBox<SongScore>(_currentPlayerBoxName);
    return scoreBox.get(id);
  }

  // 获取公用的歌曲列表（不依赖于玩家）
  Future<List<SongInfo>> getSongList(
      {int? version, bool? notes, bool forceRefresh = false}) async {
    final songBox = await Hive.openBox<SongInfo>('MaiCnSongs');
    final genreBox = await Hive.openBox<SongGenre>('MaiCnGenres');
    final versionBox = await Hive.openBox<SongVersion>('MaiCnVersions');
    final cacheInfoBox = await Hive.openBox<DateTime>('cacheInfoBox');

    final lastCacheTime = cacheInfoBox.get('MaiCnSongCacheTime');
    if (!forceRefresh &&
        LxCommonUtils.isCacheValid(lastCacheTime, dataCacheDuration)) {
      List<SongInfo> songs = songBox.values.toList();
      songs.sort((a, b) => a.id.compareTo(b.id));
      return songs;
    }

    try {
      final data = await LxCommonUtils.fetchData(
        songDataPath,
        queryParameters: {'version': version, 'notes': notes},
      );

      final songData = data['songs'] ?? [];
      final genresData = data['genres'] ?? [];
      final versionData = data['versions'] ?? [];

      List<SongInfo> songs =
          songData.map<SongInfo>((json) => SongInfo.fromLxJson(json)).toList();
      List<SongGenre> genres = genresData
          .map<SongGenre>((json) => SongGenre.fromLxJson(json))
          .toList();
      List<SongVersion> versions = versionData
          .map<SongVersion>((json) => SongVersion.fromLxJson(json))
          .toList();

      await LxCommonUtils.saveToHive(songBox, songs, (song) => song.id);
      await LxCommonUtils.saveToHive(genreBox, genres, (genre) => genre.id);
      await LxCommonUtils.saveToHive(
          versionBox, versions, (version) => version.id);
      await cacheInfoBox.put('MaiCnSongCacheTime', DateTime.now());

      return songs;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveToken(String uuid, String token) async {
    await _secureStorage.write(key: 'token_$uuid', value: token);
  }

  Future<String?> getToken(String uuid) async {
    return await _secureStorage.read(key: 'token_$uuid');
  }

  Future<PlayerData> addPlayer(String token) async {
    final playerDataBox = await Hive.openBox<PlayerData>('playerData');
    final uuid = const Uuid().v4();

    try {
      // 拉取数据
      final data = await LxCommonUtils.fetchData(
        playerDataPath,
        token: token,
      );

      final newPlayerData = PlayerData.fromLxJson(data['data'], uuid);

      // 根据 friend_code 检测是否重复
      final isDuplicate = playerDataBox.values.any(
        (player) => player.friendCode == newPlayerData.friendCode,
      );

      if (isDuplicate) {
        throw Exception('该玩家已存在');
      }

      // 保存玩家数据
      await playerDataBox.put(uuid, newPlayerData);
      await saveToken(uuid, token);

      _playerManager.addPlayer(uuid, _lxMaiProvider.getProviderName());

      return newPlayerData;
    } catch (e) {
      rethrow;
    }
  }

  Future<PlayerData> getPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>('playerData');
    return playerDataBox.get(_currentUuid)!;
  }

  Future<List<PlayerData>> getAllPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>('playerData');

    return playerDataBox.values.toList();
  }

  Future<List<String>> getAllPlayerUUID() async {
    final playerDataBox = await Hive.openBox<PlayerData>('playerData');

    return playerDataBox.keys.map((key) => key as String).toList();
  }

  // 获取公用的别名列表（不依赖于玩家）
  Future<List<SongAlias>> getAliasList({bool forceRefresh = false}) async {
    final aliasBox = await Hive.openBox<SongAlias>('MaiCnAliasBox');
    final cacheInfoBox = await Hive.openBox<DateTime>('cacheInfoBox');

    final lastCacheTime = cacheInfoBox.get('MaiCnAliasCacheTime');
    if (!forceRefresh &&
        LxCommonUtils.isCacheValid(lastCacheTime, dataCacheDuration)) {
      List<SongAlias> aliases = aliasBox.values.toList();
      aliases.sort((a, b) => a.songId.compareTo(b.songId));
      return aliases;
    }

    try {
      final data = await LxCommonUtils.fetchData(songAliasPath);

      final aliasData = data['aliases'] ?? [];
      List<SongAlias> aliases = aliasData
          .map<SongAlias>((json) => SongAlias.fromLxJson(json))
          .toList();

      await LxCommonUtils.saveToHive(
          aliasBox, aliases, (alias) => alias.songId);
      await cacheInfoBox.put('MaiCnAliasCacheTime', DateTime.now());

      return aliases;
    } catch (e) {
      rethrow;
    }
  }

  // 获取歌曲版本名称（不依赖于玩家）
  Future<String> getTitleByVersion(int version) async {
    final box = await Hive.openBox<SongVersion>('MaiCnVersions');
    List<SongVersion> versions = box.values.toList();
    versions.sort((a, b) => a.version.compareTo(b.version));

    for (int i = 0; i < versions.length - 1; i++) {
      if (versions[i].version <= version && versions[i + 1].version > version) {
        return versions[i].title;
      }
    }

    return versions.last.title;
  }

  Future<bool> isCurrentVersion(int version) async {
    final box = await Hive.openBox<SongVersion>('MaiCnVersions');
    List<SongVersion> versions = box.values.toList();
    versions.sort((a, b) => a.version.compareTo(b.version));

    for (int i = 0; i < versions.length - 1; i++) {
      if (versions[i].version <= version && versions[i + 1].version > version) {
        return false;
      }
    }

    return true;
  }

  Future<List<SongScore>> getB15Records() async {
    List<SongScore> allRecords = await getRecordList();
    final songBox = await Hive.openBox<SongInfo>('MaiCnSongs');

    List<SongScore> currentVersionRecords = [];
    for (var record in allRecords) {
      final songInfo = songBox.get(record.id);
      if (await isCurrentVersion(songInfo!.version)) {
        currentVersionRecords.add(record);
      }
      if (currentVersionRecords.length == 15) {
        break;
      }
    }

    currentVersionRecords
        .sort((a, b) => b.dxRating!.compareTo(a.dxRating!));
    return currentVersionRecords;
  }

  Future<List<SongScore>> getB35Records() async {
    List<SongScore> allRecords = await getRecordList();
    final songBox = await Hive.openBox<SongInfo>('MaiCnSongs');

    List<SongScore> pastVersionRecords = [];
    for (var record in allRecords) {
      final songInfo = songBox.get(record.id);
      if (!(await isCurrentVersion(songInfo!.version))) {
        pastVersionRecords.add(record);
      }

      if (pastVersionRecords.length == 35) {
        break;
      }
    }

    pastVersionRecords
        .sort((a, b) => b.dxRating!.compareTo(a.dxRating!));
    return pastVersionRecords;
  }

  static Future<SongInfo> getSongDataById(int id) async {
    final data = await LxCommonUtils.fetchData("/maimai/song/$id");
    return SongInfo.fromLxJson(data);
  }
}
