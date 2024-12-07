import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rank_hub/src/model/maimai/player_data.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/model/maimai/song_score.dart';
import 'package:rank_hub/src/provider/data_source_provider.dart';

class RecordListViewModel extends ChangeNotifier {
  final DataSourceProvider<SongScore, PlayerData, SongInfo> dataSourceProvider;
  final BuildContext buildContext;
  final FocusNode focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  late ScrollController scrollController;

  bool isVisible = true;
  String searchQuery = "";
  List<SongScore> scores = [];
  List<SongScore> filteredScores = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  RecordListViewModel(this.dataSourceProvider, this.buildContext) {
    scrollController = ScrollController();
    scrollController.addListener(_listenToScroll);
    searchController.addListener(() {
      searchQuery = searchController.text;
      filterSearchResults();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_listenToScroll);
    scrollController.dispose();
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    switch (scrollController.position.userScrollDirection) {
      case ScrollDirection.forward:
        showFab();
        break;
      case ScrollDirection.reverse:
        hideFab();
        break;
      case ScrollDirection.idle:
        break;
    }
  }

  void showFab() {
    if (!isVisible) {
      isVisible = true;
      _requestRebuild();
    }
  }

  void hideFab() {
    if (searchController.text.isNotEmpty || focusNode.hasFocus) {
      return;
    }
    if (isVisible) {
      isVisible = false;
      _requestRebuild();
    }
  }

  Future<void> fetchRecords({bool force = false}) async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    _requestRebuild();

    try {
      scores = await dataSourceProvider.getRecords(forceRefresh: force);
      filteredScores = scores;
      isLoading = false;
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = 'Failed to load songs: $e';
    }
    _requestRebuild();
  }

  Future<void> filterSearchResults() async {
    if (searchQuery.isEmpty) {
      filteredScores = scores;
    } else {
      List<SongInfo> preFiltered = await dataSourceProvider.searchSongs(searchQuery);

      filteredScores = scores
          .where((song) =>
              preFiltered.any((filteredSong) {
                return filteredSong.id == song.id;
                }))
          .toList();
    }
    _requestRebuild();
  }

  void _requestRebuild() {
    if (buildContext.mounted) {
      notifyListeners();
    }
  }
}
