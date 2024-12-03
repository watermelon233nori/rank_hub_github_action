import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/model/maimai/mai_cover_feature.dart';
import 'package:rank_hub/src/pages/mai_cover_recognition_page.dart';
import 'package:rank_hub/src/pages/mai_cover_recognition_setup.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/view/maimai/lx_song_list.dart';
import 'package:rank_hub/src/viewmodel/maimai/lx_wiki_page_vm.dart';

class WikiPage extends StatelessWidget {
  const WikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          LxMaiWikiPageViewModel(lxMaiProvider: LxMaiProvider(context: ctx))
            ..fetchSongs(),
      child: Consumer<LxMaiWikiPageViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("舞萌 DX"),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            body: viewModel.isLoading && viewModel.songs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : viewModel.hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Failed to load songs',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(viewModel.errorMessage),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                await viewModel.fetchSongs(force: true);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => viewModel.fetchSongs(force: true),
                        child: LxMaiSongList(
                          provider: LxMaiProvider(context: context),
                          controller: viewModel.scrollController,
                          songs: viewModel.filteredSongs,
                        ),
                      ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final box = await Hive.openLazyBox<MaiCoverFeature>(
                    'mai_cn_cover_features');
                if (box.isNotEmpty) {
                  await box.close();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const MaiCoverRecognitionPage()),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return const MaiCoverRecognitionSetup();
                      }),
                );
              },
              tooltip: '曲绘识别',
              elevation: viewModel.isVisible ? 0.0 : null,
              child: const Icon(Icons.center_focus_weak),
            ),
            floatingActionButtonLocation: viewModel.isVisible
                ? FloatingActionButtonLocation.endContained
                : FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: _SongFliterBar(
              isElevated: true,
              isVisible: viewModel.isVisible,
              searchController: viewModel.searchController,
              focusNode: viewModel.focusNode,
            ),
          );
        },
      ),
    );
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
