// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Vương quốc Cờ vua';

  @override
  String get mapTitle => 'Vương quốc';

  @override
  String get comingSoon => 'Sắp có';

  @override
  String get locked => 'Đã khóa';

  @override
  String get start => 'Chơi nào!';

  @override
  String get again => 'Lần nữa';

  @override
  String get next => 'Tiếp';

  @override
  String get back => 'Quay lại';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get wellDone => 'Giỏi lắm!';

  @override
  String get lessonDone => 'Xong bài học!';

  @override
  String get taskWon => 'Hoan hô!';

  @override
  String get tryAgain => 'Mình thử lại nhé!';

  @override
  String get botWon => 'Rô-bốt nhỏ thắng rồi. Mình chơi lại nhé!';

  @override
  String get promoted => 'Bạn ấy hóa thành công chúa!';

  @override
  String get lavaWarning => 'Ui, dung nham!';

  @override
  String tapTarget(String target) {
    return 'Chạm vào: $target';
  }

  @override
  String street(String name) {
    return 'phố $name';
  }

  @override
  String house(String name) {
    return 'hàng $name';
  }

  @override
  String room(String name) {
    return 'phòng $name';
  }

  @override
  String get dragHint => 'Kéo một quân cờ lên bàn cờ';

  @override
  String get armies => 'Đội quân';

  @override
  String get myArmy => 'Đội quân của em';

  @override
  String get rivalArmy => 'Đối thủ';

  @override
  String get battleDemo => 'Trận đánh thử';

  @override
  String taskOf(int n, int total) {
    return 'Nhiệm vụ $n/$total';
  }

  @override
  String get opponentThinking => 'Rô-bốt nhỏ đang suy nghĩ…';
}
