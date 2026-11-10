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
}
