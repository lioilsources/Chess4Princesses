// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Шахове королівство';

  @override
  String get mapTitle => 'Королівство';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get locked => 'Зачинено';

  @override
  String get start => 'Граємо!';

  @override
  String get again => 'Ще раз';

  @override
  String get next => 'Далі';

  @override
  String get back => 'Назад';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get wellDone => 'Чудово!';

  @override
  String get lessonDone => 'Урок пройдено!';

  @override
  String get taskWon => 'Ура!';

  @override
  String get tryAgain => 'Спробуймо ще раз!';

  @override
  String get botWon => 'Роботик виграв. Граємо ще раз!';

  @override
  String get promoted => 'Вона стала принцесою!';

  @override
  String get lavaWarning => 'Ой, лава!';

  @override
  String tapTarget(String target) {
    return 'Торкнися: $target';
  }

  @override
  String street(String name) {
    return 'вулиці $name';
  }

  @override
  String house(String name) {
    return 'ряду $name';
  }

  @override
  String room(String name) {
    return 'кімнати $name';
  }

  @override
  String get dragHint => 'Перетягни фігурку на дошку';

  @override
  String get armies => 'Армії';

  @override
  String get myArmy => 'Моя армія';

  @override
  String get rivalArmy => 'Суперник';

  @override
  String get battleDemo => 'Пробна битва';

  @override
  String taskOf(int n, int total) {
    return 'Завдання $n з $total';
  }

  @override
  String get opponentThinking => 'Роботик думає…';
}
