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
  String get promoted => 'Dia menjadi putri!';

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
}
