import 'dart:collection';

import 'package:flutter/material.dart';

abstract class AbstractProvider {
  Widget buildOverviewCard();

  Widget buildRecordCard();

  Widget buildRecordList();

  Widget buildSongCard();
  
  Widget buildSongList();

  Widget buildRankedRecordList();

  Widget buildSongDetailScreen();

  Widget buildPlayerDetailScreen();

  Widget buildAddPlayerScreen();
  
  Widget buildProviderIcon();

  String getProviderName();

  String getProviderLoacation();

  String getProviderGameName();

  Future<List<dynamic>> getAllSongs();

  Future<dynamic> getPlayerDetail();

  Future<dynamic> getSongDetail();

  Future<List<dynamic>> getRecords();

  Future<Map<String,List<dynamic>>> getRankedRecords();

  Future<void> addPlayer();

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