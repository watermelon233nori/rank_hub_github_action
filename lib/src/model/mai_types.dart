enum LevelIndex {
  basic(0, 'BASIC'),         // BASIC
  advanced(1, 'ADVANCED'),   // ADVANCED
  expert(2, 'EXPERT'),       // EXPERT
  master(3, 'MASTER'),       // MASTER
  remaster(4, 'Re:MASTER');  // Re:MASTER

  final int value;
  final String label;
  const LevelIndex(this.value, this.label);

  static LevelIndex? fromValue(int value) {
    return LevelIndex.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid value for LevelIndex: $value'),
    );
  }
}

enum FCType {
  app("app", 'AP+'),    // AP+
  ap("ap", 'AP'),       // AP
  fcp("fcp", 'FC+'),    // FC+
  fc("fc", 'FC');       // FC

  final String value;
  final String label;
  const FCType(this.value, this.label);

  static FCType? fromValue(String value) {
    return FCType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid value for FCType: $value'),
    );
  }
}

enum FSType {
  fsdp("fsdp", 'FDX+'),   // FDX+
  fsd("fsd", 'FDX'),      // FDX
  fsp("fsp", 'FS+'),      // FS+
  fs("fs", 'FS'),         // FS
  sync("sync", 'SYNC');   // SYNC PLAY

  final String value;
  final String label;
  const FSType(this.value, this.label);

  static FSType? fromValue(String value) {
    return FSType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid value for FSType: $value'),
    );
  }
}

enum RateType {
  sssp("sssp", 'SSS+'),   // SSS+
  sss("sss", 'SSS'),      // SSS
  ssp("ssp", 'SS+'),      // SS+
  ss("ss", 'SS'),         // SS
  sp("sp", 'S+'),         // S+
  s("s", 'S'),            // S
  aaa("aaa", 'AAA'),      // AAA
  aa("aa", 'AA'),         // AA
  a("a", 'A'),            // A
  bbb("bbb", 'BBB'),      // BBB
  bb("bb", 'BB'),         // BB
  b("b", 'B'),            // B
  c("c", 'C'),            // C
  d("d", 'D');            // D

  final String value;
  final String label;
  const RateType(this.value, this.label);

  static RateType? fromValue(String value) {
    return RateType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid value for RateType: $value'),
    );
  }
}

enum SongType {
  standard("standard", 'SD'),   // 标准谱面
  dx("dx", 'DX'),               // DX 谱面
  utage("utage", 'U·TA·GE');    // 宴会场谱面

  final String value;
  final String label;
  const SongType(this.value, this.label);

  static SongType? fromValue(String value) {
    return SongType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid value for SongType: $value'),
    );
  }
}