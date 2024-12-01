import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_hub/src/view/maimai/lx_mai_record_card.dart';
import 'package:rank_hub/src/provider/lx_mai_provider.dart';
import 'package:rank_hub/src/viewmodel/maimai/lx_record_list_vm.dart';

class LxMaiRecordList extends StatelessWidget {
  final String searchQuery;
  final ScrollController scrollController;

  const LxMaiRecordList({
    super.key,
    required this.searchQuery,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (ctx) =>
            RecordListViewModel(LxMaiProvider(context: ctx))..fetchRecords(),
        child: Consumer<RecordListViewModel>(
          builder: (context, viewModel, child) {
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
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchRecords(force: true),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            viewModel.filterSearchResults(searchQuery);

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
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
      ),
    );
  }
}
