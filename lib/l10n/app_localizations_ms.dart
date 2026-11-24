// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Kerajaan Catur';

  @override
  String get mapTitle => 'Kerajaan';

  @override
  String get comingSoon => 'Akan datang';

  @override
  String get locked => 'Dikunci';

  @override
  String get start => 'Jom main!';

  @override
  String get again => 'Sekali lagi';

  @override
  String get next => 'Seterusnya';

  @override
  String get back => 'Kembali';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get wellDone => 'Syabas!';

  @override
  String get lessonDone => 'Pelajaran selesai!';

  @override
  String get taskWon => 'Hore!';

  @override
  String get tryAgain => 'Jom cuba lagi!';

  @override
  String get botWon => 'Robot kecil menang. Jom main lagi!';

  @override
  String get promoted => 'Dia menjadi ratu!';

  @override
  String get lavaWarning => 'Aduh, lava!';

  @override
  String tapTarget(String target) {
    return 'Sentuh: $target';
  }

  @override
  String street(String name) {
    return 'jalan $name';
  }

  @override
  String house(String name) {
    return 'baris $name';
  }

  @override
  String room(String name) {
    return 'bilik $name';
  }

  @override
  String get dragHint => 'Seret buah catur ke papan';

  @override
  String get armies => 'Tentera';

  @override
  String get myArmy => 'Tentera saya';

  @override
  String get rivalArmy => 'Lawan';

  @override
  String get battleDemo => 'Pertempuran percubaan';

  @override
  String taskOf(int n, int total) {
    return 'Tugasan $n daripada $total';
  }

  @override
  String get opponentThinking => 'Robot kecil sedang berfikir…';

  @override
  String get hallTitle => 'Dewan Kemasyhuran';

  @override
  String get hallGolden => 'Papan Emas';

  @override
  String get hallGoldenHint => '64 permainan paling terkenal';

  @override
  String get hallMatches => 'Perlawanan merebut mahkota';

  @override
  String get hallMatchesHint => 'Semua perlawanan kejohanan dunia';

  @override
  String get hallWomen => 'Juara wanita';

  @override
  String get hallWomenHint => 'Juara dunia wanita dan permainan mereka';

  @override
  String get hallChallenge => 'Juara dan pencabar';

  @override
  String hallChallengeHint(String year) {
    return 'Kemenangan terindah kedua-dua pemain perlawanan gelaran $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n daripada $total';
  }

  @override
  String get hallFideLine => 'Gelaran FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Permainan pantas';

  @override
  String get replayCheck => 'Syak!';

  @override
  String get replayMate => 'Syak mat!';

  @override
  String get replayCastle => 'Raja bersembunyi di dalam kubu!';

  @override
  String get replaySacrifice => 'Pengorbanan yang berani!';

  @override
  String get replayEndMate => 'Syak mat! Pertempuran dimenangi.';

  @override
  String get replayEndResign =>
      'Raja tunduk dan menyerahkan mahkotanya. Pertempuran tamat!';

  @override
  String get replayEndDraw => 'Seri! Kedua-dua raja berjabat tangan.';

  @override
  String get replayEndUnfinished => 'Pertempuran ini masih berterusan.';

  @override
  String get replayPlay => 'Main';

  @override
  String get replayPause => 'Jeda';

  @override
  String get replayNextBattle => 'Pertempuran seterusnya';

  @override
  String get replayChronicle => 'Kronik';

  @override
  String get replayStepBack => 'Langkah ke belakang';

  @override
  String get replayStepForward => 'Langkah ke hadapan';

  @override
  String replayMoveOf(int n, int total) {
    return 'Langkah $n daripada $total';
  }

  @override
  String get liveTitle => 'Sedang dimainkan';

  @override
  String get liveSwitch => 'Permainan dari internet';

  @override
  String get liveSwitchHint =>
      'Kejohanan langsung hanya dimuat turun semasa suis ini dihidupkan.';

  @override
  String get liveNothing => 'Tiada yang sedang dimainkan sekarang.';

  @override
  String get liveError => 'Tidak dapat dimuatkan. Cuba lagi nanti.';

  @override
  String get liveOffline =>
      'Tiada internet: menunjukkan yang sudah dimuat turun.';

  @override
  String liveGame(int n) {
    return 'Permainan $n';
  }

  @override
  String get settingsTitle => 'Tetapan';

  @override
  String get settingsBattles => 'Pertempuran semasa menangkap';

  @override
  String get settingsBattlesHint =>
      'Mati: buah yang ditangkap hanya hilang dalam awan.';

  @override
  String get settingsClassic => 'Buah catur klasik';

  @override
  String get settingsClassicHint =>
      'Dalam permainan, menggantikan watak tentera. Pertempuran tidak dipaparkan.';

  @override
  String get liveBadge => 'Langsung';

  @override
  String get liveSkip => 'Langkau';

  @override
  String get liveTryOwn => 'Saya cuba sendiri';

  @override
  String get liveAdviser => 'Penasihat';

  @override
  String get liveBackToGame => 'Kembali ke permainan';

  @override
  String get liveNewMove => 'Langkah baharu!';

  @override
  String liveNewMoves(int n) {
    return 'Langkah baharu: $n';
  }

  @override
  String get liveTimeTrouble => 'Masa hampir habis!';

  @override
  String get liveAdviserThinking => 'Penasihat masih berfikir.';

  @override
  String get liveAdviserContinue => 'Saya teruskan sendiri';

  @override
  String get liveAhead => 'Siapa mendahului';

  @override
  String get liveClockApprox => 'Masa ini anggaran';

  @override
  String get liveReset => 'Dari awal';

  @override
  String liveStartsAt(String time) {
    return 'Bermula pada $time';
  }

  @override
  String liveDepth(int n) {
    return 'kedalaman $n';
  }
}
