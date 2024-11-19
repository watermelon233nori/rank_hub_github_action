import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:hive/hive.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/model/maimai/song_alias.dart';
import 'package:rank_hub/src/model/maimai/song_genre.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/model/maimai/song_version.dart';
import 'package:rank_hub/src/utils/lx_common_utils.dart';
import 'package:uuid/uuid.dart';

class LxApiService {
  static const playerDataPath = '/user/maimai/player';
  static const playerScorePath = '/user/maimai/player/scores';
  static const songDataPath = '/maimai/song/list';
  static const songAliasPath = '/maimai/alias/list';

  final LxCommonUtils _lcu = LxCommonUtils();
  final fss.FlutterSecureStorage _secureStorage =
      const fss.FlutterSecureStorage();
  final String authorizationToken =
      'XPqAaOwxyJUaJM1LHrEdwW7Nu6VUpF1-Tu1OK9rcjeg=';

  static const scoreCacheDuration = Duration(hours: 1);
  static const dataCacheDuration = Duration(days: 1);

  Future<List<SongScore>> getRecordList({bool forceRefresh = false}) async {
    var scoreBox = await Hive.openBox<SongScore>('scoreBox');
    var cacheInfoBox = await Hive.openBox<DateTime>('cacheInfo');
    DateTime? lastCacheTime = cacheInfoBox.get('SongScoreCacheTime');

    if (!forceRefresh && _lcu.isCacheValid(lastCacheTime, scoreCacheDuration)) {
      List<SongScore> scores = scoreBox.values.toList();
      scores.sort((a, b) => b.dxRating!.compareTo(a.dxRating!));
      return scores;
    }

    try {
      final response =
          await _lcu.fetchData(playerScorePath, token: authorizationToken);
      final data = response['data'] ?? [];
      List<SongScore> scores =
          data.map<SongScore>((json) => SongScore.fromLxJson(json)).toList();

      await _lcu.saveToHive(
          scoreBox, scores, (score) => '${score.id}_${score.levelIndex}');
      await cacheInfoBox.put('SongScoreCacheTime', DateTime.now());

      return scores;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SongInfo>> getSongList({
    int? version,
    bool? notes,
    bool forceRefresh = false,
  }) async {
    var songBox = await Hive.openBox<SongInfo>('MaiCnSongs');
    var genreBox = await Hive.openBox<SongGenre>('MaiCnGenres');
    var versionBox = await Hive.openBox<SongVersion>('MaiCnVersions');
    var cacheInfoBox = await Hive.openBox<DateTime>('cacheInfoBox');

    DateTime? lastCacheTime = cacheInfoBox.get('MaiCnSongCacheTime');
    if (!forceRefresh && _lcu.isCacheValid(lastCacheTime, dataCacheDuration)) {
      List<SongInfo> songs = songBox.values.toList();
      songs.sort((a, b) => a.id.compareTo(b.id));
      return songs;
    }

    try {
      final data = await _lcu.fetchData(
        songDataPath,
        queryParameters: {
          'version': version,
          'notes': notes,
        },
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

      await _lcu.saveToHive(songBox, songs, (song) => song.id);
      await _lcu.saveToHive(genreBox, genres, (genre) => genre.id);
      await _lcu.saveToHive(versionBox, versions, (version) => version.id);

      await cacheInfoBox.put('MaiCnSongCacheTime', DateTime.now());

      return songs;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SongAlias>> getAliasList({bool forceRefresh = false}) async {
    var aliasBox = await Hive.openBox<SongAlias>('MaiCnAliasBox');
    var cacheInfoBox = await Hive.openBox<DateTime>('cacheInfoBox');

    DateTime? lastCacheTime = cacheInfoBox.get('MaiCnAliasCacheTime');
    if (!forceRefresh && _lcu.isCacheValid(lastCacheTime, dataCacheDuration)) {
      List<SongAlias> aliases = aliasBox.values.toList();
      aliases.sort((a, b) => a.songId.compareTo(b.songId));
      return aliases;
    }

    try {
      final data = await _lcu.fetchData(songAliasPath);

      final aliasData = data['aliases'] ?? [];
      List<SongAlias> aliases = aliasData
          .map<SongAlias>((json) => SongAlias.fromLxJson(json))
          .toList();

      await _lcu.saveToHive(aliasBox, aliases, (alias) => alias.songId);

      await cacheInfoBox.put('MaiCnAliasCacheTime', DateTime.now());

      return aliases;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getTitleByVerison(int version) async {
    var box = await Hive.openBox<SongVersion>('MaiCnVersions');
    List<SongVersion> versions = box.values.toList();
    versions.sort((a, b) => a.version.compareTo(b.version));

    for (int i = 0; i < versions.length - 1; i++) {
      if (versions.elementAt(i).version <= version &&
          versions.elementAt(i + 1).version > version) {
        return versions.elementAt(i).title;
      }
    }

    return versions.last.title;
  }

  Future<SongScore?> getRecordById(String id) async {
    var box = await Hive.openBox<SongScore>('scoreBox');

    return box.get(id);
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
      final data = await _lcu.fetchData(
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

      return newPlayerData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlayerData>> getAllPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>('playerData');

    return playerDataBox.values.toList();
  }
}
