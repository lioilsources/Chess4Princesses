// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Satranç Krallığı';

  @override
  String get mapTitle => 'Krallık';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get locked => 'Kilitli';

  @override
  String get start => 'Oynayalım!';

  @override
  String get again => 'Yeniden';

  @override
  String get next => 'İleri';

  @override
  String get back => 'Geri';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get wellDone => 'Aferin!';

  @override
  String get lessonDone => 'Ders tamam!';

  @override
  String get taskWon => 'Yaşasın!';

  @override
  String get tryAgain => 'Bir daha deneyelim!';

  @override
  String get botWon => 'Küçük robot kazandı. Yeniden oynayalım!';

  @override
  String get promoted => 'Prensese dönüştü!';

  @override
  String get lavaWarning => 'Ay, lav!';

  @override
  String tapTarget(String target) {
    return 'Dokun: $target';
  }

  @override
  String street(String name) {
    return '$name sokağı';
  }

  @override
  String house(String name) {
    return '$name. sıra';
  }

  @override
  String room(String name) {
    return '$name odası';
  }

  @override
  String get dragHint => 'Bir taşı tahtaya sürükle';

  @override
  String get armies => 'Ordular';

  @override
  String get myArmy => 'Ordum';

  @override
  String get rivalArmy => 'Rakip';

  @override
  String get battleDemo => 'Deneme savaşı';

  @override
  String taskOf(int n, int total) {
    return 'Görev $n / $total';
  }

  @override
  String get opponentThinking => 'Küçük robot düşünüyor…';
}
