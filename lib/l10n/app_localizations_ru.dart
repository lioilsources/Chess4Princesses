// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Шахматное королевство';

  @override
  String get mapTitle => 'Королевство';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get locked => 'Закрыто';

  @override
  String get start => 'Играем!';

  @override
  String get again => 'Ещё раз';

  @override
  String get next => 'Дальше';

  @override
  String get back => 'Назад';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get wellDone => 'Молодец!';

  @override
  String get lessonDone => 'Урок пройден!';

  @override
  String get taskWon => 'Ура!';

  @override
  String get tryAgain => 'Попробуем ещё раз!';

  @override
  String get botWon => 'Роботёнок выиграл. Играем ещё раз!';

  @override
  String get promoted => 'Она стала принцессой!';

  @override
  String get lavaWarning => 'Ой, лава!';

  @override
  String tapTarget(String target) {
    return 'Нажми на: $target';
  }

  @override
  String street(String name) {
    return 'улицу $name';
  }

  @override
  String house(String name) {
    return 'ряд $name';
  }

  @override
  String room(String name) {
    return 'комнату $name';
  }

  @override
  String get dragHint => 'Перетащи фигурку на доску';

  @override
  String get armies => 'Армии';

  @override
  String get myArmy => 'Моя армия';

  @override
  String get rivalArmy => 'Соперник';

  @override
  String get battleDemo => 'Пробная битва';

  @override
  String taskOf(int n, int total) {
    return 'Задание $n из $total';
  }

  @override
  String get opponentThinking => 'Роботёнок думает…';

  @override
  String get hallTitle => 'Зал славы';

  @override
  String get hallFamous => 'Знаменитые партии';

  @override
  String get replayCheck => 'Шах!';

  @override
  String get replayMate => 'Мат!';

  @override
  String get replayCastle => 'Король спрятался в замке!';

  @override
  String get replaySacrifice => 'Смелая жертва!';

  @override
  String get replayEndMate => 'Мат! Битва выиграна.';

  @override
  String get replayEndResign =>
      'Король поклонился и отдал свою корону. Битва окончена!';

  @override
  String get replayEndDraw => 'Ничья! Два короля пожали друг другу руки.';

  @override
  String get replayEndUnfinished => 'Эта битва ещё идёт.';

  @override
  String get replayPlay => 'Играть';

  @override
  String get replayPause => 'Пауза';

  @override
  String get replayNextBattle => 'Следующая битва';

  @override
  String get replayChronicle => 'Хроника';

  @override
  String get replayStepBack => 'Ход назад';

  @override
  String get replayStepForward => 'Ход вперёд';

  @override
  String replayMoveOf(int n, int total) {
    return 'Ход $n из $total';
  }

  @override
  String get liveTitle => 'Играют сейчас';

  @override
  String get liveSwitch => 'Партии из интернета';

  @override
  String get liveSwitchHint =>
      'Турниры в прямом эфире загружаются, только пока переключатель включён.';

  @override
  String get liveNothing => 'Сейчас ничего не играется.';

  @override
  String get liveError => 'Не удалось загрузить. Попробуй позже.';

  @override
  String get liveOffline => 'Нет интернета: показываю то, что уже загружено.';

  @override
  String liveGame(int n) {
    return 'Партия $n';
  }
}
