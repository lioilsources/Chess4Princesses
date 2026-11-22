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
  String get hallFamous => 'Permainan terkenal';

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
}
