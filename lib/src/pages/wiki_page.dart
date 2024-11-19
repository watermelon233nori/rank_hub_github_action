import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rank_hub/src/model/maimai/song_alias.dart';
import 'package:rank_hub/src/model/maimai/song_info.dart';
import 'package:rank_hub/src/services/lx_api_services.dart';
import 'package:rank_hub/src/widget/mai_song_list.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  late ScrollController _controller;
  bool _isVisible = true;

  FloatingActionButtonLocation get _fabLocation => _isVisible
      ? FloatingActionButtonLocation.endContained
      : FloatingActionButtonLocation.endFloat;

  // 控制输入框的文本控制器
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void _listen() {
    switch (_controller.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        _show();
      case ScrollDirection.reverse:
        _hide();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() => _isVisible = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSongs();
    _controller = ScrollController();
    _controller.addListener(_listen);

    searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    songs.clear();
    filteredSongs.clear();
    _controller.removeListener(_listen);
    _controller.dispose();
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<SongInfo> songs = [];
  List<SongAlias> aliases = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  List<SongInfo> filteredSongs = [];

  Future<void> fetchSongs({bool froce = false}) async {
    if (hasError) {
      isLoading = true;
    }
    try {
      final fetchedSongData =
          await LxApiService().getSongList(forceRefresh: froce);
      final fetchedAliasData =
          await LxApiService().getAliasList(forceRefresh: froce);

      setState(() {
        songs = fetchedSongData;
        aliases = fetchedAliasData;
        filteredSongs = fetchedSongData;
        isLoading = false;
        hasError = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Failed to load songs: $e';
      });
      rethrow;
    }
  }

  List<SongInfo> searchSong(String query) {
    // Convert query to lowercase for case-insensitive search
    final lowerQuery = query.toLowerCase();

    // Create a map of song ID to alias list for fast lookup
    final aliasMap = <int, List<String>>{};
    for (var alias in aliases) {
      aliasMap[alias.songId] =
          alias.aliases.map((e) => e.toLowerCase()).toList();
    }

    // Filter the songs based on query matching
    return songs.where((song) {
      final songTitle = song.title.toLowerCase();
      final songArtist = song.artist.toLowerCase();
      final songIdString = song.id.toString();

      // Check if the song matches by id, title, or artist
      bool matches = songTitle.contains(lowerQuery) ||
          songArtist.contains(lowerQuery) ||
          songIdString.contains(lowerQuery);

      // Check if the song matches by alias
      final songAliases = aliasMap[song.id] ?? [];
      bool aliasMatches =
          songAliases.any((alias) => alias.contains(lowerQuery));

      return matches || aliasMatches;
    }).toList();
  }

  void _performSearch() {
    final query = searchController.text;
    if (query.isEmpty) {
      // Display all songs if query is empty
      setState(() {
        filteredSongs = songs;
      });
    } else {
      // Filter songs based on the search query
      setState(() {
        filteredSongs = searchSong(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextButton(
            onPressed: () {
              // 按钮点击事件
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min, // 按钮大小自适应内容
              children: [
                Text("舞萌 DX"),
                SizedBox(width: 4), // 文本和图标之间的间距
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            const SizedBox(width: 8),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Failed to load songs',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(errorMessage),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await fetchSongs(froce: true);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ))
                : songs.isEmpty
                    ? const Center(
                        child: Text(
                          'No songs found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          fetchSongs(froce: true);
                        },
                        child: MaiSongList(
                          songs: filteredSongs,
                          controller: _controller,
                        ),
                      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: '曲绘识别',
          elevation: _isVisible ? 0.0 : null,
          child: const Icon(Icons.center_focus_weak),
        ),
        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: _SongFliterBar(
            isElevated: true,
            isVisible: _isVisible,
            searchController: searchController,
            focusNode: focusNode));
  }
}

class _SongFliterBar extends StatelessWidget {
  const _SongFliterBar(
      {required this.isElevated,
      required this.isVisible,
      required this.searchController,
      required this.focusNode});

  final bool isElevated;
  final bool isVisible;
  final TextEditingController searchController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isVisible ? 80.0 : 0,
      child: BottomAppBar(
        elevation: isElevated ? null : 0.0,
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: searchController,
              focusNode: focusNode,
              onTapOutside: (e) => {focusNode.unfocus()},
              decoration: const InputDecoration(
                filled: true,
                labelText: "搜索歌曲",
                hintText: "支持 ID, 曲名, 艺术家, 别名 查找",
                prefixIcon: Icon(Icons.search),
              ),
            )),
            const SizedBox(width: 72),
          ],
        ),
      ),
    );
  }
}
