import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_core/opencv.dart' as cv;
import 'package:rank_hub/src/model/maimai/mai_cover_feature.dart';

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
    await _processCameraFrame(xFile);
  }

  Future<void> _processCameraFrame(XFile xFile) async {
    try {
      cv.BFMatcher bfMatcher = cv.BFMatcher.create();
      final box = await Hive.openLazyBox<MaiCoverFeature>('mai_cn_cover_features');

      // 存储最优匹配信息
      double minDistance = double.infinity;
      int? bestMatchId;
      double maxDistanceThreshold = 200.0;

      cv.Mat mat = cv.imread(xFile.path);
      cv.SIFT sift = cv.SIFT.empty();
      final mask = cv.Mat.zeros(mat.rows, mat.cols, cv.MatType.CV_8UC1);
      mask.setTo(cv.Scalar.white); // 设置为全白

      cv.Mat queryMat = sift.detectAndCompute(mat, mask).$2;

      print(queryMat.type);
    

      // 遍历 Hive 数据库中的所有特征
      for (int id in box.keys) {
        MaiCoverFeature? maiCoverFeature = await box.get(id);
        if (maiCoverFeature == null) {
          continue;
        }
        cv.Mat trainMat = cv.Mat.from2DList(
          maiCoverFeature.descriptors,
          cv.MatType.CV_32FC1,
        );

        // 执行特征匹配
        cv.VecDMatch matches = await bfMatcher.matchAsync(queryMat, trainMat);

        List<cv.DMatch> goodMatches =
            matches.where((m) => m.distance < maxDistanceThreshold).toList();

        // 计算最小距离
        if (goodMatches.isNotEmpty) {
          double avgDistance =
              goodMatches.map((m) => m.distance).reduce((a, b) => a + b) /
                  goodMatches.length;
          if (avgDistance == 0.0) {
            continue;
          }
          if (avgDistance < minDistance) {
            minDistance = avgDistance;
            bestMatchId = maiCoverFeature.id;
          }
        }

        maiCoverFeature = null;
        // 释放 trainMat 的资源
        trainMat.dispose();
      }

      // 释放 queryMat 的资源
      queryMat.dispose();
      File(xFile.path).deleteSync();

      // 输出最匹配的图片 ID
      if (bestMatchId != null) {
        print("Best match ID: $bestMatchId with distance: $minDistance");
      } else {
        print("No matches found.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<cv.Mat> _convertCameraImageToMat(CameraImage image) async {
    // 将 YUV 数据转换为 RGB 格式
    try {
      final cv.Mat yuvMat = cv.Mat.create(
          rows: image.height, cols: image.width, type: cv.MatType.CV_8UC4);
      yuvMat.data.setAll(0, image.planes[0].bytes);

      return yuvMat;
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
