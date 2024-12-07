import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';

class MaiRankViewModel extends ChangeNotifier {
  late ScrollController scrollController;
  late PlayerData playerData;

  bool isLoading = false;
  String playerName = "";
  int playerRating = 0;
  int currentVerRating = 0;
  int pastVerRating = 0;
  List<SongScore> b15Records = [];
  List<SongScore> b35Records = [];

  final BuildContext context;

  MaiRankViewModel(this.context);

  ShaderMask getShaderMaskByRating(int rating, Widget child) {
    Gradient gradient;

    if (rating < 0) {
      gradient = const LinearGradient(colors: [Colors.grey, Colors.grey]);
    } else if (rating <= 999) {
      gradient = const LinearGradient(colors: [Colors.white, Colors.white]);
    } else if (rating <= 1999) {
      gradient = const LinearGradient(colors: [Colors.blue, Colors.blueAccent]);
    } else if (rating <= 3999) {
      gradient =
          const LinearGradient(colors: [Colors.green, Colors.lightGreen]);
    } else if (rating <= 6999) {
      gradient = const LinearGradient(colors: [Colors.yellow, Colors.orange]);
    } else if (rating <= 9999) {
      gradient = const LinearGradient(colors: [Colors.red, Colors.redAccent]);
    } else if (rating <= 11999) {
      gradient =
          const LinearGradient(colors: [Colors.purple, Colors.deepPurple]);
    } else if (rating <= 12999) {
      gradient = const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFFB87333)]); // 铜色渐变
    } else if (rating <= 13999) {
      gradient =
          const LinearGradient(colors: [Colors.grey, Colors.blueGrey]); // 银色渐变
    } else if (rating <= 14499) {
      gradient = const LinearGradient(
          colors: [Colors.amber, Colors.orangeAccent]); // 金色渐变
    } else if (rating <= 14999) {
      gradient = const LinearGradient(colors: [
        Color.fromARGB(255, 252, 208, 122),
        Color.fromARGB(255, 252, 255, 160)
      ]); // 白金渐变
    } else {
      gradient = const LinearGradient(colors: [
        Color.fromARGB(255, 56, 255, 219),
        Color.fromARGB(255, 76, 124, 255),
        Color.fromARGB(255, 244, 92, 255)
      ]); // 彩虹色渐变
    }

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }

  Future<void> initialize() async {
    try {
      await getPlayerName();
      await getPlayerRating();
      await initB50();
      await getB15Rating();
      await getB35Rating();
      await getPlayerData();
    } catch (e) {
      // 处理初始化错误
      debugPrint("Initialization error: $e");
    } finally {
      isLoading = false; // 初始化完成
      _requestRebuild();
    }
  }

  Future<void> getPlayerData() async {
    playerData =
        await LxMaiProvider(context: context).lxApiService.getPlayerData();
  }

  Future<void> initB50() async {
    b15Records =
        await LxMaiProvider(context: context).lxApiService.getB15Records();
    b35Records =
        await LxMaiProvider(context: context).lxApiService.getB35Records();

    _requestRebuild();
  }

  Future<void> getB15Rating() async {
    int rating = 0;
    for (SongScore record in b15Records) {
      rating += record.dxRating!.truncate();
    }
    currentVerRating = rating;
  }

  Future<void> getB35Rating() async {
    int rating = 0;
    for (SongScore record in b35Records) {
      rating += record.dxRating!.truncate();
    }
    pastVerRating = rating;
  }

  Future<void> getPlayerName() async {
    playerName =
        (await LxMaiProvider(context: context).lxApiService.getPlayerData())
            .name;

    _requestRebuild();
  }

  Future<void> getPlayerRating() async {
    playerRating =
        (await LxMaiProvider(context: context).lxApiService.getPlayerData())
            .rating;

    _requestRebuild();
  }

  void _requestRebuild() {
    if (context.mounted) {
      notifyListeners();
    }
  }
}
