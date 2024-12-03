import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:opencv_core/opencv.dart' as cv;
import 'package:path_provider/path_provider.dart';
import 'package:rank_hub/src/model/maimai/mai_cover_feature.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';

class MaiCoverRecognitionSetup extends StatefulWidget {
  const MaiCoverRecognitionSetup({super.key});

  @override
  State<MaiCoverRecognitionSetup> createState() =>
      _MaiCoverRecognitionSetupState();
}

class _MaiCoverRecognitionSetupState extends State<MaiCoverRecognitionSetup> {
  ScrollController controller = ScrollController();
  bool loading = true;
  List<SongInfo> songs = [];
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    logs.add("Fetching song list from maimai.lxns.net ...");
    LxMaiProvider(context: context)
        .getAllSongs(forceRefresh: true)
        .then((list) => {
              setState(() {
                songs = list;
                logs.add(
                    "Song list fetched successfully, total: ${songs.length}.");
                logs.add("MCR Initializer ready.");
                loading = false;
              })
            });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void log(String message) {
    setState(() {
      logs.add('[LOG] $message');
    });
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  Future<void> initMCR(List<SongInfo> songs) async {
    final box = await Hive.lazyBox<MaiCoverFeature>('mai_cn_cover_features');
    setState(() {
      loading = true;
    });

    final dio = Dio();
    log("Downloading song covers...");
    final tempDir = await getTemporaryDirectory();

    // 记录下载开始时间
    final startTime = DateTime.now();
    int totalDownloadedSize = 0; // 用于记录总下载大小

    for (SongInfo songInfo in songs) {
      if (songInfo.id >= 10000) {
        continue;
      }

      final tempPath = '${tempDir.path}/${songInfo.id}.png';
      final file = File(tempPath);
      if(await file.exists()) {
        continue;
      }

      try {
        // 下载并记录文件大小
        final response = await dio.download(
          'https://assets2.lxns.net/maimai/jacket/${songInfo.id}.png',
          tempPath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                logs[logs.length - 1] =
                    'Downloading ${songInfo.id}.png: ${(received / total * 100).toStringAsFixed(1)}%';
              });
            }
          },
        );

        // 检查下载是否成功
        if (response.statusCode == 200) {
          final file = File(tempPath);
          if (await file.exists()) {
            final fileSize = await file.length();
            totalDownloadedSize += fileSize;
            setState(() {
              logs[logs.length - 1] =
                  'Downloaded ${songInfo.id}.png (${fileSize / 1024} KB)';
            });
          }
        }
      } catch (e) {
        log('Failed to download ${songInfo.id}.png: $e');
        log("");
      }
    }

    // 记录下载结束时间
    final endTime = DateTime.now();
    final elapsed = endTime.difference(startTime);

    // 输出总耗时和总下载大小
    log("Song covers downloaded.");
    log("Total time: ${elapsed.inSeconds}s");
    log("Total size: ${(totalDownloadedSize / (1024 * 1024)).toStringAsFixed(2)} MB");

    log("Processing images with OpenCV ORB...");

    for (SongInfo songInfo in songs) {
      if (songInfo.id >= 10000) {
        continue;
      }

      final imagePath = '${tempDir.path}/${songInfo.id}.png';

      // 检查图片是否存在
      if (!File(imagePath).existsSync()) {
        log('Image not found: $imagePath');
        continue;
      }

      try {
        // 加载图片并创建全白掩膜
        final mat = cv.imread(imagePath);
        final mask = cv.Mat.zeros(mat.rows, mat.cols, cv.MatType.CV_8UC1);
        mask.setTo(cv.Scalar.white); // 设置为全白

        // ORB 特征提取
        final sift = cv.SIFT.empty();
        final keypoints = <List<double>>[];
        final descriptors = <List<num>>[];

        // 提取特征点和描述符
        final result = sift.detectAndCompute(mat, mask);
        for (final kp in result.$1) {
          keypoints.add([kp.x, kp.y, kp.size, kp.angle]);
        }
        result.$2.forEachRow(
          (row, values) {
            descriptors.add(values);
          },
        );

        // 保存到 Hive
        final featureData = MaiCoverFeature(
          id: songInfo.id,
          keypoints: keypoints,
          descriptors: descriptors,
        );
        await box.put(songInfo.id, featureData);
        log('Saved features for song: ${songInfo.id}');
      } catch (e) {
        log('Failed to process song ${songInfo.id}: $e');
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(
              child: Icon(
                Icons.center_focus_weak,
                size: 128,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Center(
              child: Text(
                '曲绘识别',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Center(
              child: Text(
                '本功能可以使用摄像头快速查找匹配的乐曲\n首次使用时需要初始化该功能',
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 256,
              child: ListView.builder(
                controller: controller,
                itemCount: logs.length,
                itemBuilder: (context, index) => Text(
                  logs[index],
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: CupertinoButton(
                onPressed: loading
                    ? null
                    : () {
                        initMCR(songs);
                      },
                child: loading
                    ? CupertinoActivityIndicator()
                    : Text(
                        '初始化 MCR',
                        style: TextStyle(color: Colors.white),
                      ),
                color: CupertinoColors.systemBlue,
              ),
            ),
            const SizedBox(
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
