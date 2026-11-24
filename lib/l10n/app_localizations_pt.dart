// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Reino do Xadrez';

  @override
  String get mapTitle => 'Reino';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get locked => 'Bloqueado';

  @override
  String get start => 'Vamos jogar!';

  @override
  String get again => 'De novo';

  @override
  String get next => 'Próximo';

  @override
  String get back => 'Voltar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get wellDone => 'Muito bem!';

  @override
  String get lessonDone => 'Lição concluída!';

  @override
  String get taskWon => 'Viva!';

  @override
  String get tryAgain => 'Vamos tentar de novo!';

  @override
  String get botWon => 'O robozinho ganhou. Vamos jogar de novo!';

  @override
  String get promoted => 'Ela virou rainha!';

  @override
  String get lavaWarning => 'Ai, lava!';

  @override
  String tapTarget(String target) {
    return 'Toque: $target';
  }

  @override
  String street(String name) {
    return 'a rua $name';
  }

  @override
  String house(String name) {
    return 'a fileira $name';
  }

  @override
  String room(String name) {
    return 'o quarto $name';
  }

  @override
  String get dragHint => 'Arraste uma peça para o tabuleiro';

  @override
  String get armies => 'Exércitos';

  @override
  String get myArmy => 'Meu exército';

  @override
  String get rivalArmy => 'Adversário';

  @override
  String get battleDemo => 'Batalha de teste';

  @override
  String taskOf(int n, int total) {
    return 'Tarefa $n de $total';
  }

  @override
  String get opponentThinking => 'O robozinho está pensando…';

  @override
  String get hallTitle => 'Salão da Fama';

  @override
  String get hallGolden => 'O tabuleiro de ouro';

  @override
  String get hallGoldenHint => 'As 64 partidas mais famosas';

  @override
  String get hallMatches => 'Duelos pela coroa';

  @override
  String get hallMatchesHint => 'Todos os matches do campeonato do mundo';

  @override
  String get hallWomen => 'Campeãs';

  @override
  String get hallWomenHint => 'As campeãs do mundo e as suas partidas';

  @override
  String get hallChallenge => 'Campeão e desafiante';

  @override
  String hallChallengeHint(String year) {
    return 'As vitórias mais bonitas dos dois jogadores do match pelo título $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n de $total';
  }

  @override
  String get hallFideLine => 'Título FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partida rápida';

  @override
  String get replayCheck => 'Xeque!';

  @override
  String get replayMate => 'Xeque-mate!';

  @override
  String get replayCastle => 'O rei se escondeu no castelo!';

  @override
  String get replaySacrifice => 'Um sacrifício corajoso!';

  @override
  String get replayEndMate => 'Xeque-mate! A batalha foi vencida.';

  @override
  String get replayEndResign =>
      'O rei se curvou e entregou a coroa. A batalha acabou!';

  @override
  String get replayEndDraw => 'Empate! Os dois reis se cumprimentam.';

  @override
  String get replayEndUnfinished => 'Esta batalha ainda continua.';

  @override
  String get replayPlay => 'Reproduzir';

  @override
  String get replayPause => 'Pausar';

  @override
  String get replayNextBattle => 'Próxima batalha';

  @override
  String get replayChronicle => 'Crônica';

  @override
  String get replayStepBack => 'Jogada para trás';

  @override
  String get replayStepForward => 'Jogada para a frente';

  @override
  String replayMoveOf(int n, int total) {
    return 'Jogada $n de $total';
  }

  @override
  String get liveTitle => 'A jogar agora';

  @override
  String get liveSwitch => 'Partidas da internet';

  @override
  String get liveSwitchHint =>
      'Os torneios ao vivo só são baixados enquanto isto estiver ligado.';

  @override
  String get liveNothing => 'Agora não está a ser jogado nada.';

  @override
  String get liveError =>
      'Não foi possível carregar. Tenta de novo mais tarde.';

  @override
  String get liveOffline => 'Sem internet: mostrando o que já foi baixado.';

  @override
  String liveGame(int n) {
    return 'Partida $n';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Reino do Xadrez';

  @override
  String get mapTitle => 'Reino';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get locked => 'Bloqueado';

  @override
  String get start => 'Vamos jogar!';

  @override
  String get again => 'De novo';

  @override
  String get next => 'Próximo';

  @override
  String get back => 'Voltar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get wellDone => 'Muito bem!';

  @override
  String get lessonDone => 'Lição concluída!';

  @override
  String get taskWon => 'Viva!';

  @override
  String get tryAgain => 'Vamos tentar de novo!';

  @override
  String get botWon => 'O robozinho ganhou. Vamos jogar de novo!';

  @override
  String get promoted => 'Ela virou rainha!';

  @override
  String get lavaWarning => 'Ai, lava!';

  @override
  String tapTarget(String target) {
    return 'Toque: $target';
  }

  @override
  String street(String name) {
    return 'a rua $name';
  }

  @override
  String house(String name) {
    return 'a fileira $name';
  }

  @override
  String room(String name) {
    return 'o quarto $name';
  }

  @override
  String get dragHint => 'Arraste uma peça para o tabuleiro';

  @override
  String get armies => 'Exércitos';

  @override
  String get myArmy => 'Meu exército';

  @override
  String get rivalArmy => 'Adversário';

  @override
  String get battleDemo => 'Batalha de teste';

  @override
  String taskOf(int n, int total) {
    return 'Tarefa $n de $total';
  }

  @override
  String get opponentThinking => 'O robozinho está pensando…';

  @override
  String get hallTitle => 'Salão da Fama';

  @override
  String get hallGolden => 'O tabuleiro de ouro';

  @override
  String get hallGoldenHint => 'As 64 partidas mais famosas';

  @override
  String get hallMatches => 'Duelos pela coroa';

  @override
  String get hallMatchesHint => 'Todos os matches do campeonato mundial';

  @override
  String get hallWomen => 'Campeãs';

  @override
  String get hallWomenHint => 'As campeãs mundiais e suas partidas';

  @override
  String get hallChallenge => 'Campeão e desafiante';

  @override
  String hallChallengeHint(String year) {
    return 'As vitórias mais bonitas dos dois jogadores do match pelo título $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n de $total';
  }

  @override
  String get hallFideLine => 'Título FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partida rápida';

  @override
  String get replayCheck => 'Xeque!';

  @override
  String get replayMate => 'Xeque-mate!';

  @override
  String get replayCastle => 'O rei se escondeu no castelo!';

  @override
  String get replaySacrifice => 'Um sacrifício corajoso!';

  @override
  String get replayEndMate => 'Xeque-mate! A batalha foi vencida.';

  @override
  String get replayEndResign =>
      'O rei se curvou e entregou a coroa. A batalha acabou!';

  @override
  String get replayEndDraw => 'Empate! Os dois reis se cumprimentam.';

  @override
  String get replayEndUnfinished => 'Esta batalha ainda continua.';

  @override
  String get replayPlay => 'Reproduzir';

  @override
  String get replayPause => 'Pausar';

  @override
  String get replayNextBattle => 'Próxima batalha';

  @override
  String get replayChronicle => 'Crônica';

  @override
  String get replayStepBack => 'Jogada para trás';

  @override
  String get replayStepForward => 'Jogada para a frente';

  @override
  String replayMoveOf(int n, int total) {
    return 'Jogada $n de $total';
  }

  @override
  String get liveTitle => 'Jogando agora';

  @override
  String get liveSwitch => 'Partidas da internet';

  @override
  String get liveSwitchHint =>
      'Os torneios ao vivo só são baixados enquanto isto estiver ligado.';

  @override
  String get liveNothing => 'Ninguém está jogando agora.';

  @override
  String get liveError =>
      'Não foi possível carregar. Tente de novo mais tarde.';

  @override
  String get liveOffline => 'Sem internet: mostrando o que já foi baixado.';

  @override
  String liveGame(int n) {
    return 'Partida $n';
  }
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get appTitle => 'Reino do Xadrez';

  @override
  String get mapTitle => 'Reino';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get locked => 'Bloqueado';

  @override
  String get start => 'Vamos jogar!';

  @override
  String get again => 'Outra vez';

  @override
  String get next => 'Seguinte';

  @override
  String get back => 'Voltar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get wellDone => 'Muito bem!';

  @override
  String get lessonDone => 'Lição concluída!';

  @override
  String get taskWon => 'Viva!';

  @override
  String get tryAgain => 'Vamos tentar outra vez!';

  @override
  String get botWon => 'O robozinho ganhou. Vamos jogar outra vez!';

  @override
  String get promoted => 'Ela transformou-se em rainha!';

  @override
  String get lavaWarning => 'Ai, lava!';

  @override
  String tapTarget(String target) {
    return 'Toca: $target';
  }

  @override
  String street(String name) {
    return 'a rua $name';
  }

  @override
  String house(String name) {
    return 'a fila $name';
  }

  @override
  String room(String name) {
    return 'o quarto $name';
  }

  @override
  String get dragHint => 'Arrasta uma peça para o tabuleiro';

  @override
  String get armies => 'Exércitos';

  @override
  String get myArmy => 'O meu exército';

  @override
  String get rivalArmy => 'Adversário';

  @override
  String get battleDemo => 'Batalha de teste';

  @override
  String taskOf(int n, int total) {
    return 'Tarefa $n de $total';
  }

  @override
  String get opponentThinking => 'O robozinho está a pensar…';

  @override
  String get hallTitle => 'Salão da Fama';

  @override
  String get hallGolden => 'O tabuleiro de ouro';

  @override
  String get hallGoldenHint => 'As 64 partidas mais famosas';

  @override
  String get hallMatches => 'Duelos pela coroa';

  @override
  String get hallMatchesHint => 'Todos os matches do campeonato do mundo';

  @override
  String get hallWomen => 'Campeãs';

  @override
  String get hallWomenHint => 'As campeãs do mundo e as suas partidas';

  @override
  String get hallChallenge => 'Campeão e desafiante';

  @override
  String hallChallengeHint(String year) {
    return 'As vitórias mais bonitas dos dois jogadores do match pelo título $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n de $total';
  }

  @override
  String get hallFideLine => 'Título FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partida rápida';

  @override
  String get replayCheck => 'Xeque!';

  @override
  String get replayMate => 'Xeque-mate!';

  @override
  String get replayCastle => 'O rei escondeu-se no castelo!';

  @override
  String get replaySacrifice => 'Um sacrifício corajoso!';

  @override
  String get replayEndMate => 'Xeque-mate! A batalha está ganha.';

  @override
  String get replayEndResign =>
      'O rei curvou-se e entregou a coroa. A batalha acabou!';

  @override
  String get replayEndDraw => 'Empate! Os dois reis apertam as mãos.';

  @override
  String get replayEndUnfinished => 'Esta batalha ainda continua.';

  @override
  String get replayPlay => 'Reproduzir';

  @override
  String get replayPause => 'Pausa';

  @override
  String get replayNextBattle => 'Próxima batalha';

  @override
  String get replayChronicle => 'Crónica';

  @override
  String get replayStepBack => 'Jogada atrás';

  @override
  String get replayStepForward => 'Jogada à frente';

  @override
  String replayMoveOf(int n, int total) {
    return 'Jogada $n de $total';
  }

  @override
  String get liveTitle => 'A jogar agora';

  @override
  String get liveSwitch => 'Partidas da internet';

  @override
  String get liveSwitchHint =>
      'Os torneios em direto só são descarregados enquanto isto estiver ligado.';

  @override
  String get liveNothing => 'Neste momento não está a ser jogado nada.';

  @override
  String get liveError =>
      'Não foi possível carregar. Tenta de novo mais tarde.';

  @override
  String get liveOffline =>
      'Sem internet: a mostrar o que já foi descarregado.';

  @override
  String liveGame(int n) {
    return 'Partida $n';
  }
}
