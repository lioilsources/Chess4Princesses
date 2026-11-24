// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kerajaan Catur';

  @override
  String get mapTitle => 'Kerajaan';

  @override
  String get comingSoon => 'Segera';

  @override
  String get locked => 'Terkunci';

  @override
  String get start => 'Main!';

  @override
  String get again => 'Lagi';

  @override
  String get next => 'Lanjut';

  @override
  String get back => 'Kembali';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get wellDone => 'Hebat!';

  @override
  String get lessonDone => 'Pelajaran selesai!';

  @override
  String get taskWon => 'Hore!';

  @override
  String get tryAgain => 'Ayo coba lagi!';

  @override
  String get botWon => 'Robot kecil menang. Ayo main lagi!';

  @override
  String get promoted => 'Dia menjadi ratu!';

  @override
  String get lavaWarning => 'Aduh, lava!';

  @override
  String tapTarget(String target) {
    return 'Ketuk: $target';
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
    return 'kamar $name';
  }

  @override
  String get dragHint => 'Seret bidak ke papan';

  @override
  String get armies => 'Pasukan';

  @override
  String get myArmy => 'Pasukanku';

  @override
  String get rivalArmy => 'Lawan';

  @override
  String get battleDemo => 'Pertempuran uji';

  @override
  String taskOf(int n, int total) {
    return 'Tugas $n dari $total';
  }

  @override
  String get opponentThinking => 'Robot kecil sedang berpikir…';

  @override
  String get hallTitle => 'Aula Kejayaan';

  @override
  String get hallGolden => 'Papan Emas';

  @override
  String get hallGoldenHint => '64 partai paling terkenal';

  @override
  String get hallMatches => 'Pertandingan memperebutkan mahkota';

  @override
  String get hallMatchesHint => 'Semua pertandingan kejuaraan dunia';

  @override
  String get hallWomen => 'Para juara wanita';

  @override
  String get hallWomenHint => 'Juara dunia wanita dan partai mereka';

  @override
  String get hallChallenge => 'Juara dan penantang';

  @override
  String hallChallengeHint(String year) {
    return 'Kemenangan terindah kedua pemain dalam pertandingan gelar $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n dari $total';
  }

  @override
  String get hallFideLine => 'Gelar FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partai cepat';

  @override
  String get replayCheck => 'Skak!';

  @override
  String get replayMate => 'Skakmat!';

  @override
  String get replayCastle => 'Raja bersembunyi di dalam kastil!';

  @override
  String get replaySacrifice => 'Pengorbanan yang berani!';

  @override
  String get replayEndMate => 'Skakmat! Pertempuran dimenangkan.';

  @override
  String get replayEndResign =>
      'Raja membungkuk dan menyerahkan mahkotanya. Pertempuran selesai!';

  @override
  String get replayEndDraw => 'Seri! Kedua raja berjabat tangan.';

  @override
  String get replayEndUnfinished => 'Pertempuran ini masih berlangsung.';

  @override
  String get replayPlay => 'Putar';

  @override
  String get replayPause => 'Jeda';

  @override
  String get replayNextBattle => 'Pertempuran berikutnya';

  @override
  String get replayChronicle => 'Kronik';

  @override
  String get replayStepBack => 'Langkah mundur';

  @override
  String get replayStepForward => 'Langkah maju';

  @override
  String replayMoveOf(int n, int total) {
    return 'Langkah $n dari $total';
  }

  @override
  String get liveTitle => 'Sedang dimainkan';

  @override
  String get liveSwitch => 'Permainan dari internet';

  @override
  String get liveSwitchHint =>
      'Turnamen langsung hanya diunduh saat tombol ini menyala.';

  @override
  String get liveNothing => 'Tidak ada yang sedang dimainkan sekarang.';

  @override
  String get liveError => 'Gagal memuat. Coba lagi nanti.';

  @override
  String get liveOffline =>
      'Tidak ada internet: menampilkan yang sudah diunduh.';

  @override
  String liveGame(int n) {
    return 'Permainan $n';
  }
}
