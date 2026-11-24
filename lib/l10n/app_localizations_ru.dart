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
  String get promoted => 'Она стала королевой!';

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
  String get hallGolden => 'Золотая доска';

  @override
  String get hallGoldenHint => '64 самые знаменитые партии';

  @override
  String get hallMatches => 'Матчи за корону';

  @override
  String get hallMatchesHint => 'Все матчи за звание чемпиона мира';

  @override
  String get hallWomen => 'Чемпионки';

  @override
  String get hallWomenHint => 'Чемпионки мира и их партии';

  @override
  String get hallChallenge => 'Чемпион и претендент';

  @override
  String hallChallengeHint(String year) {
    return 'Самые красивые победы обоих участников матча за титул $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n из $total';
  }

  @override
  String get hallFideLine => 'Титул ФИДЕ 1993–2006';

  @override
  String get hallTiebreak => 'Быстрая партия';

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

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsBattles => 'Битвы при взятии';

  @override
  String get settingsBattlesHint =>
      'Выключено: взятая фигура просто исчезает в облачке.';

  @override
  String get settingsClassic => 'Классические шахматные фигуры';

  @override
  String get settingsClassicHint =>
      'В партиях вместо персонажей армий. Тогда битвы не показываются.';

  @override
  String get liveBadge => 'Прямой эфир';

  @override
  String get liveSkip => 'Пропустить';

  @override
  String get liveTryOwn => 'Попробую сам';

  @override
  String get liveAdviser => 'Советник';

  @override
  String get liveBackToGame => 'Назад к партии';

  @override
  String get liveNewMove => 'Новый ход!';

  @override
  String liveNewMoves(int n) {
    return 'Новые ходы: $n';
  }

  @override
  String get liveTimeTrouble => 'Время заканчивается!';

  @override
  String get liveAdviserThinking => 'Советник ещё думает.';

  @override
  String get liveAdviserContinue => 'Продолжу сам';

  @override
  String get liveAhead => 'Кто ведёт';

  @override
  String get liveClockApprox => 'Время примерное';

  @override
  String get liveReset => 'С начала';

  @override
  String liveStartsAt(String time) {
    return 'Начало в $time';
  }

  @override
  String liveDepth(int n) {
    return 'глубина $n';
  }
}
