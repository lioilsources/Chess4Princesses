// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Το Βασίλειο του Σκακιού';

  @override
  String get mapTitle => 'Βασίλειο';

  @override
  String get comingSoon => 'Σύντομα';

  @override
  String get locked => 'Κλειδωμένο';

  @override
  String get start => 'Παίζουμε!';

  @override
  String get again => 'Ξανά';

  @override
  String get next => 'Επόμενο';

  @override
  String get back => 'Πίσω';

  @override
  String get yes => 'Ναι';

  @override
  String get no => 'Όχι';

  @override
  String get wellDone => 'Μπράβο!';

  @override
  String get lessonDone => 'Το μάθημα τελείωσε!';

  @override
  String get taskWon => 'Ζήτω!';

  @override
  String get tryAgain => 'Ας δοκιμάσουμε ξανά!';

  @override
  String get botWon => 'Κέρδισε το ρομποτάκι. Παίζουμε ξανά!';

  @override
  String get promoted => 'Έγινε πριγκίπισσα!';

  @override
  String get lavaWarning => 'Άου, λάβα!';

  @override
  String tapTarget(String target) {
    return 'Πάτησε: $target';
  }

  @override
  String street(String name) {
    return 'τον δρόμο $name';
  }

  @override
  String house(String name) {
    return 'τη σειρά $name';
  }

  @override
  String room(String name) {
    return 'το δωμάτιο $name';
  }

  @override
  String get dragHint => 'Σύρε ένα κομμάτι στη σκακιέρα';

  @override
  String get armies => 'Στρατοί';

  @override
  String get myArmy => 'Ο στρατός μου';

  @override
  String get rivalArmy => 'Αντίπαλος';

  @override
  String get battleDemo => 'Δοκιμαστική μάχη';

  @override
  String taskOf(int n, int total) {
    return 'Αποστολή $n από $total';
  }

  @override
  String get opponentThinking => 'Το ρομποτάκι σκέφτεται…';
}
