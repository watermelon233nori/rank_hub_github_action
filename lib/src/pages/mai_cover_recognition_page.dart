import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:rank_hub/src/model/maimai/mai_cover_feature.dart';
import 'package:rank_hub/src/utils/recognition_utils.dart';

class MaiCoverRecognitionPage extends StatefulWidget {
  const MaiCoverRecognitionPage({super.key});

  @override
  State<MaiCoverRecognitionPage> createState() =>
      _MaiCoverRecognitionPageState();
}

class _MaiCoverRecognitionPageState extends State<MaiCoverRecognitionPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0], // 使用第一个摄像头
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();

      // 开始实时数据流监听
      //_cameraController!.startImageStream(_processCameraFrame);
      setState(() {});
    }
  }

  Future<void> _capturePhoto() async {
    XFile xFile = await _cameraController!.takePicture();

    File imageFile = File(xFile.path);
    ui.Image image = await decodeImageFromList(await imageFile.readAsBytes());

    // 计算裁剪框在图像上的实际坐标
    const cropWidth = 300; // 裁剪框宽度
    const cropHeight = 300; // 裁剪框高度
    int imageWidth = image.width;
    int imageHeight = image.height;

    int cropX = (imageWidth - cropWidth) ~/ 2;
    int cropY = (imageHeight - cropHeight) ~/ 2;

    // 裁剪图像
    img.Image originalImage = img.decodeImage(await imageFile.readAsBytes())!;
    img.Image croppedImage = img.copyCrop(originalImage,
        x: cropX, y: cropY, width: cropWidth, height: cropHeight);

    // 覆盖原始文件
    imageFile.writeAsBytesSync(img.encodeJpg(croppedImage));

    await _processCameraFrame(xFile);
  }

  Future<void> _processCameraFrame(XFile xFile) async {
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final box =
          await Hive.openLazyBox<MaiCoverFeature>('mai_cn_cover_features');
      print(stopwatch.elapsedMilliseconds);

      List<int> keys = box.keys.cast<int>().toList();
      const int maxBatchSize = 200;

      List<MatchResult> allResults = [];

      print(stopwatch.elapsedMilliseconds);

      for (int i = 0; i < keys.length; i += maxBatchSize) {
        // 按批加载数据
        List<int> batchKeys = keys.skip(i).take(maxBatchSize).toList();
        List<FeatureData> featureDataList = [];

        for (int key in batchKeys) {
          MaiCoverFeature? feature = await box.get(key);
          if (feature != null) {
            featureDataList.add(FeatureData(key, feature.descriptors));
          }
        }

        print(stopwatch.elapsedMilliseconds);

        // 将数据分为 4 份
        int partitionSize = (featureDataList.length / 4).ceil();
        List<List<FeatureData>> partitions = List.generate(
          4,
          (i) => featureDataList
              .skip(i * partitionSize)
              .take(partitionSize)
              .toList(),
        );

        // 创建 Isolate 的消息通道
        List<ReceivePort> receivePorts = List.generate(4, (_) => ReceivePort());
        List<Future<List<MatchResult>>> futures = [];

        for (int j = 0; j < 4; j++) {
          Completer<List<MatchResult>> completer = Completer();
          receivePorts[j].listen((message) {
            if (message is List<MatchResult>) {
              completer.complete(message);
            }
          });

          futures.add(completer.future);

          // 启动 Isolate
          await Isolate.spawn(
            RecognitionUtils().matchCoverWithIsolate,
            IsolateData(
              receivePorts[j].sendPort,
              xFile.path,
              partitions[j],
            ),
          );
        }

        // 等待 Isolate 结果并聚合
        List<MatchResult> batchResults =
            (await Future.wait(futures)).expand((x) => x).toList();
        allResults.addAll(batchResults);

        // 释放资源
        for (var port in receivePorts) {
          port.close();
        }
      }

      // 按距离排序并选取前三个
      allResults.sort((a, b) => a.avgDistance.compareTo(b.avgDistance));
      List<MatchResult> topMatches = allResults.take(10).toList();

      // 输出结果
      for (var match in topMatches) {
        print("Match ID: ${match.id}, Distance: ${match.avgDistance}");
      }

      print(stopwatch.elapsed);
      stopwatch.stop();

      // 释放资源
      File(xFile.path).deleteSync();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    _isFlashOn = !_isFlashOn;
    await _cameraController!
        .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Selected image path: ${image.path}');
      // 在此处理选中的图片
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 调整摄像头预览为充满屏幕
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            Center(
              child: Transform.scale(
                scale: 1 /
                    (_cameraController!.value.aspectRatio *
                        MediaQuery.of(context).size.aspectRatio),
                child: CameraPreview(_cameraController!),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            Center(
              child: Transform.scale(
                scale: 1 /
                    (_cameraController!.value.aspectRatio *
                        MediaQuery.of(context).size.aspectRatio),
                child: Container(
                  width: 300, // 设置裁剪框宽度
                  height: 300, // 设置裁剪框高度
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),

          // 关闭按钮
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // 返回上一页面
                  },
                ),
              ),
            ),
          ),

          // 浮动操作栏
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 24, left: 32, right: 32), // 设置底部栏的间距
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20), // 设置圆角
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // 均匀分布元素
                    children: [
                      // 打开闪光灯
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: _toggleFlash,
                      ),
                      // 拍摄按钮
                      GestureDetector(
                        onTap: () {
                          _capturePhoto();
                        }, // 替换为拍摄方法
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red, // 按钮颜色
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      // 从相册选择图片
                      IconButton(
                        icon: Icon(Icons.photo_library, color: Colors.white),
                        onPressed: _pickImageFromGallery,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
