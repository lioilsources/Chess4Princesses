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
  String get promoted => 'Έγινε βασίλισσα!';

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

  @override
  String get hallTitle => 'Αίθουσα Δόξας';

  @override
  String get hallGolden => 'Η χρυσή σκακιέρα';

  @override
  String get hallGoldenHint => 'Οι 64 πιο διάσημες παρτίδες';

  @override
  String get hallMatches => 'Αγώνες για το στέμμα';

  @override
  String get hallMatchesHint => 'Όλοι οι αγώνες για τον παγκόσμιο τίτλο';

  @override
  String get hallWomen => 'Πρωταθλήτριες';

  @override
  String get hallWomenHint =>
      'Οι παγκόσμιες πρωταθλήτριες και οι παρτίδες τους';

  @override
  String get hallChallenge => 'Πρωταθλητής και διεκδικητής';

  @override
  String hallChallengeHint(String year) {
    return 'Οι ωραιότερες νίκες και των δύο παικτών του αγώνα για τον τίτλο $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n από $total';
  }

  @override
  String get hallFideLine => 'Τίτλος FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Γρήγορη παρτίδα';

  @override
  String get replayCheck => 'Σαχ!';

  @override
  String get replayMate => 'Ματ!';

  @override
  String get replayCastle => 'Ο βασιλιάς κρύφτηκε στο κάστρο!';

  @override
  String get replaySacrifice => 'Μια γενναία θυσία!';

  @override
  String get replayEndMate => 'Ματ! Η μάχη κερδήθηκε.';

  @override
  String get replayEndResign =>
      'Ο βασιλιάς υποκλίθηκε και παρέδωσε το στέμμα του. Η μάχη τελείωσε!';

  @override
  String get replayEndDraw => 'Ισοπαλία! Οι δύο βασιλιάδες δίνουν τα χέρια.';

  @override
  String get replayEndUnfinished => 'Αυτή η μάχη συνεχίζεται ακόμα.';

  @override
  String get replayPlay => 'Αναπαραγωγή';

  @override
  String get replayPause => 'Παύση';

  @override
  String get replayNextBattle => 'Επόμενη μάχη';

  @override
  String get replayChronicle => 'Χρονικό';

  @override
  String get replayStepBack => 'Κίνηση πίσω';

  @override
  String get replayStepForward => 'Κίνηση μπροστά';

  @override
  String replayMoveOf(int n, int total) {
    return 'Κίνηση $n από $total';
  }

  @override
  String get liveTitle => 'Παίζεται τώρα';

  @override
  String get liveSwitch => 'Παρτίδες από το διαδίκτυο';

  @override
  String get liveSwitchHint =>
      'Τα ζωντανά τουρνουά κατεβαίνουν μόνο όσο ο διακόπτης είναι ενεργός.';

  @override
  String get liveNothing => 'Τώρα δεν παίζεται τίποτα.';

  @override
  String get liveError => 'Δεν φορτώθηκε. Δοκίμασε ξανά αργότερα.';

  @override
  String get liveOffline => 'Χωρίς διαδίκτυο: δείχνω ό,τι έχει ήδη κατέβει.';

  @override
  String liveGame(int n) {
    return 'Παρτίδα $n';
  }
}
