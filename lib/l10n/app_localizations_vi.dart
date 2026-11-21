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

  @override
  String get hallTitle => 'Phòng vinh danh';

  @override
  String get hallFamous => 'Ván cờ nổi tiếng';

  @override
  String get replayCheck => 'Chiếu!';

  @override
  String get replayMate => 'Chiếu bí!';

  @override
  String get replayCastle => 'Nhà vua trốn vào lâu đài!';

  @override
  String get replaySacrifice => 'Một sự hy sinh dũng cảm!';

  @override
  String get replayEndMate => 'Chiếu bí! Trận đánh đã thắng.';

  @override
  String get replayEndResign =>
      'Nhà vua cúi chào và trao vương miện. Trận đánh kết thúc!';

  @override
  String get replayEndDraw => 'Hòa! Hai nhà vua bắt tay nhau.';

  @override
  String get replayEndUnfinished => 'Trận đánh này vẫn đang diễn ra.';

  @override
  String get replayPlay => 'Phát';

  @override
  String get replayPause => 'Tạm dừng';

  @override
  String get replayNextBattle => 'Trận tiếp theo';

  @override
  String get replayChronicle => 'Biên niên sử';

  @override
  String get replayStepBack => 'Lùi một nước';

  @override
  String get replayStepForward => 'Tiến một nước';

  @override
  String replayMoveOf(int n, int total) {
    return 'Nước $n trên $total';
  }
}
