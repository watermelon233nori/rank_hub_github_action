import 'dart:isolate';

import 'package:opencv_core/opencv.dart' as cv;

class RecognitionUtils {
  void matchCoverWithIsolate(IsolateData data) async {
    SendPort sendPort = data.sendPort;

    cv.FlannBasedMatcher flannBasedMatcher = cv.FlannBasedMatcher.empty();
    cv.Mat mat = cv.imread(data.imagePath);
    cv.SIFT sift = cv.SIFT.empty();
    final mask = cv.Mat.zeros(mat.rows, mat.cols, cv.MatType.CV_8UC1);
    mask.setTo(cv.Scalar.white);

    cv.Mat queryMat = sift.detectAndCompute(mat, mask).$2;

    List<MatchResult> results = [];

    for (FeatureData featureData in data.futureData) {
      cv.Mat trainMat = cv.Mat.from2DList(
        featureData.descriptors,
        cv.MatType.CV_32FC1,
      );

      cv.VecVecDMatch knnMatches =
          await flannBasedMatcher.knnMatchAsync(queryMat, trainMat, 2);

      double distanceSum = 0.0;
      int goodMatchesCount = 0;

      for (var matchPair in knnMatches) {
        if (matchPair.length >= 2) {
          var d1 = matchPair[0].distance;
          var d2 = matchPair[1].distance;

          // 筛选距离较小的特征点
          if (d1 < 0.7 * d2) {
            distanceSum += d1;
            goodMatchesCount++;
          }
        }
      }

      // 如果有有效匹配点，计算平均距离
      if (goodMatchesCount > 0) {
        double avgDistance = distanceSum / goodMatchesCount;
        results.add(MatchResult(featureData.id, avgDistance));
      }

      trainMat.dispose();
    }

    queryMat.dispose();
    sendPort.send(results);
  }
}

class MatchResult {
  final int id;
  final double avgDistance;

  MatchResult(this.id, this.avgDistance);
}

class IsolateData {
  final SendPort sendPort;
  final String imagePath;
  final List<FeatureData> futureData;

  IsolateData(this.sendPort, this.imagePath, this.futureData);
}

class FeatureData {
  final int id;
  final List<List<num>> descriptors;

  FeatureData(this.id, this.descriptors);
}
