import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/provider/data_source_provider.dart';

class RecordListViewModel extends ChangeNotifier {
  final DataSourceProvider<SongScore, PlayerData, SongInfo> dataSourceProvider;
  
  List<SongScore> scores = [];
  List<SongScore> filteredScores = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  RecordListViewModel(this.dataSourceProvider);

  Future<void> fetchRecords({bool force = false}) async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();

    try {
      scores = await dataSourceProvider.getRecords(forceRefresh: force);
      filteredScores = scores;
      isLoading = false;
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = 'Failed to load songs: $e';
    }
    notifyListeners();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredScores = scores;
    } else {
      filteredScores = scores
          .where((song) => song.songName!
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }
}
