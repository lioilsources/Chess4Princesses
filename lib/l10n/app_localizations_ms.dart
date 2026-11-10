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
  String get promoted => 'Dia menjadi puteri!';

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
}
