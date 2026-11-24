// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Royaume des échecs';

  @override
  String get mapTitle => 'Royaume';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get locked => 'Verrouillé';

  @override
  String get start => 'On joue !';

  @override
  String get again => 'Encore';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get wellDone => 'Bravo !';

  @override
  String get lessonDone => 'Leçon terminée !';

  @override
  String get taskWon => 'Hourra !';

  @override
  String get tryAgain => 'On réessaie !';

  @override
  String get botWon => 'Le petit robot a gagné. On rejoue !';

  @override
  String get promoted => 'Elle devient reine !';

  @override
  String get lavaWarning => 'Aïe, la lave !';

  @override
  String tapTarget(String target) {
    return 'Touche : $target';
  }

  @override
  String street(String name) {
    return 'la rue $name';
  }

  @override
  String house(String name) {
    return 'la rangée $name';
  }

  @override
  String room(String name) {
    return 'la chambre $name';
  }

  @override
  String get dragHint => 'Fais glisser une pièce sur l\'échiquier';

  @override
  String get armies => 'Armées';

  @override
  String get myArmy => 'Mon armée';

  @override
  String get rivalArmy => 'Adversaire';

  @override
  String get battleDemo => 'Bataille d\'essai';

  @override
  String taskOf(int n, int total) {
    return 'Tâche $n sur $total';
  }

  @override
  String get opponentThinking => 'Le petit robot réfléchit…';

  @override
  String get hallTitle => 'Salle des légendes';

  @override
  String get hallGolden => 'L\'échiquier d\'or';

  @override
  String get hallGoldenHint => 'Les 64 parties les plus célèbres';

  @override
  String get hallMatches => 'Matchs pour la couronne';

  @override
  String get hallMatchesHint => 'Tous les matchs du championnat du monde';

  @override
  String get hallWomen => 'Championnes';

  @override
  String get hallWomenHint => 'Les championnes du monde et leurs parties';

  @override
  String get hallChallenge => 'Champion et challenger';

  @override
  String hallChallengeHint(String year) {
    return 'Les plus belles victoires des deux joueurs du match pour le titre $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n sur $total';
  }

  @override
  String get hallFideLine => 'Titre FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partie rapide';

  @override
  String get replayCheck => 'Échec !';

  @override
  String get replayMate => 'Échec et mat !';

  @override
  String get replayCastle => 'Le roi se cache dans son château !';

  @override
  String get replaySacrifice => 'Un courageux sacrifice !';

  @override
  String get replayEndMate => 'Échec et mat ! La bataille est gagnée.';

  @override
  String get replayEndResign =>
      'Le roi fait une révérence et rend sa couronne. La bataille est finie !';

  @override
  String get replayEndDraw => 'Match nul ! Les deux rois se serrent la main.';

  @override
  String get replayEndUnfinished => 'Cette bataille continue encore.';

  @override
  String get replayPlay => 'Jouer';

  @override
  String get replayPause => 'Pause';

  @override
  String get replayNextBattle => 'Bataille suivante';

  @override
  String get replayChronicle => 'Chronique';

  @override
  String get replayStepBack => 'Coup précédent';

  @override
  String get replayStepForward => 'Coup suivant';

  @override
  String replayMoveOf(int n, int total) {
    return 'Coup $n sur $total';
  }

  @override
  String get liveTitle => 'En cours maintenant';

  @override
  String get liveSwitch => 'Parties d’internet';

  @override
  String get liveSwitchHint =>
      'Les tournois en direct ne sont téléchargés que lorsque ce réglage est activé.';

  @override
  String get liveNothing => 'Rien ne se joue en ce moment.';

  @override
  String get liveError => 'Impossible de charger. Réessaie plus tard.';

  @override
  String get liveOffline =>
      'Pas d’internet : je montre ce qui est déjà téléchargé.';

  @override
  String liveGame(int n) {
    return 'Partie $n';
  }
}
