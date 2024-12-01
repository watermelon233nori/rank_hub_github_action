import 'dart:collection';

import 'package:flutter/material.dart';

abstract class DataSourceProvider<R, P, S> {
  Widget buildOverviewCard();

  Widget buildRecordCard(R recordData);

  Widget buildRecordList();

  Widget buildSongCard(S songData);
  
  Widget buildSongList();

  Widget buildRankedRecordList();

  Widget buildSongDetailScreen(S songData);

  Widget buildPlayerDetailScreen(P playerData);

  Widget buildAddPlayerScreen();
  
  Widget buildProviderIcon();

  String getProviderName();

  String getProviderLoacation();

  String getProviderGameName();

  Future<List<S>> getAllSongs({bool forceRefresh = false});

  Future<List<S>> searchSongs(String query);

  Future<P> getPlayerDetail();

  Future<S> getSongDetail();

  Future<List<R>> getRecords({bool forceRefresh = false});

  Future<Map<String,List<R>>> getRankedRecords();

  Future<P> addPlayer(String? token);

  Future<void> deletePlayer();

  Future<dynamic>? updateRecord() {
    return null;
  }

  Future<LinkedHashMap<DateTime, num>>? getRankTrend(Duration? duration) {
    return null;
  }

  Future<LinkedHashMap<DateTime, num>>? getRecordTrend(Duration? duration) {
    return null;
  }
}