import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rank_hub/src/model/maimai/song_alias.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';

class LxMaiWikiPageViewModel extends ChangeNotifier {
  final LxMaiProvider lxMaiProvider;
  final BuildContext buildContext;

  List<SongInfo> _songs = [];
  List<SongAlias> _aliases = [];
  List<SongInfo> _filteredSongs = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  late ScrollController scrollController;
  bool isVisible = true;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  LxMaiWikiPageViewModel(this.buildContext, {required this.lxMaiProvider}) {
    scrollController = ScrollController();
    scrollController.addListener(_listenToScroll);
    searchController.addListener(() {
      searchQuery = searchController.text;
      _requestRebuild();
    });
    searchController.addListener(() {
      searchQuery = searchController.text;
      filterSongs(searchQuery);
    });
  }

  List<SongInfo> get songs => _songs;
  List<SongInfo> get filteredSongs => _filteredSongs;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

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

  @override
  void dispose() {
    focusNode.unfocus();
    scrollController.removeListener(_listenToScroll);
    scrollController.dispose();
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> fetchSongs({bool force = false}) async {
    _setLoading(true);
    try {
      final fetchedSongData =
          await lxMaiProvider.getAllSongs(forceRefresh: force);
      final fetchedAliasData =
          await lxMaiProvider.lxApiService.getAliasList(forceRefresh: force);

      _songs = fetchedSongData;
      _aliases = fetchedAliasData;
      _filteredSongs = List.from(_songs);
      _setErrorState(false, '');
    } catch (e) {
      _setErrorState(true, 'Failed to load songs: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void filterSongs(String query) {
    if (query.isEmpty) {
      _filteredSongs = List.from(_songs);
    } else {
      final lowerQuery = query.toLowerCase();
      final aliasMap = {
        for (var alias in _aliases) alias.songId: alias.aliases
      };

      _filteredSongs = _songs.where((song) {
        final matchesId = song.id.toString().contains(lowerQuery);
        final matchesTitle = song.title.toLowerCase().contains(lowerQuery);
        final matchesArtist = song.artist.toLowerCase().contains(lowerQuery);
        final matchesAlias = aliasMap[song.id]
                ?.any((alias) => alias.toLowerCase().contains(lowerQuery)) ??
            false;

        return matchesId || matchesTitle || matchesArtist || matchesAlias;
      }).toList();
    }
    _requestRebuild();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _requestRebuild();
  }

  void _setErrorState(bool hasError, String message) {
    _hasError = hasError;
    _errorMessage = message;
    _requestRebuild();
  }

  void _requestRebuild() {
    if (buildContext.mounted) {
      notifyListeners();
    }
  }
}
