import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/view/maimai/lx_mai_record_card.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/viewmodel/maimai/lx_record_list_vm.dart';

class LxMaiRecordList extends StatelessWidget {
  const LxMaiRecordList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => RecordListViewModel(LxMaiProvider(context: ctx), context)
        ..fetchRecords(),
      child: Consumer<RecordListViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Builder(
              builder: (ctx) {
                if (viewModel.isLoading && viewModel.scores.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Failed to load records',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.errorMessage,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                viewModel.fetchRecords(force: true),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (viewModel.filteredScores.isEmpty) {
                  return const Center(
                    child: Text(
                      'No records found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => viewModel.fetchRecords(force: true),
                  child: GridView.builder(
                    controller: viewModel.scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 600, // 每个项目的最大宽度
                      crossAxisSpacing: 16, // 网格之间的横向间距
                      mainAxisSpacing: 16, // 网格之间的纵向间距
                      childAspectRatio: 1.8,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.filteredScores.length,
                    itemBuilder: (context, index) {
                      return LxMaiRecordCard(
                        recordData: viewModel.filteredScores[index],
                      );
                    },
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showFilterSheet(context),
              tooltip: '高级筛选',
              elevation: viewModel.isVisible ? 0.0 : null,
              child: const Icon(Icons.filter_list),
            ),
            floatingActionButtonLocation: viewModel.isVisible
                ? FloatingActionButtonLocation.endContained
                : FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: _RankFilterBar(
              isVisible: viewModel.isVisible,
              searchController: viewModel.searchController,
              focusNode: viewModel.focusNode,
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {}
}

class _RankFilterBar extends StatelessWidget {
  final bool isVisible;
  final TextEditingController searchController;
  final FocusNode focusNode;

  const _RankFilterBar({
    required this.isVisible,
    required this.searchController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isVisible ? 80.0 : 0,
      child: BottomAppBar(
        child: Row(
          children: [
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
              ),
            ),
            const SizedBox(width: 72),
          ],
        ),
      ),
    );
  }
}
