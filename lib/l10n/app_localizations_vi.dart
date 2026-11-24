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
  String get promoted => 'Bạn ấy hóa thành nữ hoàng!';

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
  String get hallGolden => 'Bàn cờ vàng';

  @override
  String get hallGoldenHint => '64 ván cờ nổi tiếng nhất';

  @override
  String get hallMatches => 'Những trận tranh vương miện';

  @override
  String get hallMatchesHint => 'Mọi trận tranh chức vô địch thế giới';

  @override
  String get hallWomen => 'Nữ vô địch';

  @override
  String get hallWomenHint => 'Các nữ vô địch thế giới và ván cờ của họ';

  @override
  String get hallChallenge => 'Nhà vô địch và người thách đấu';

  @override
  String hallChallengeHint(String year) {
    return 'Những chiến thắng đẹp nhất của hai kỳ thủ trận tranh ngôi $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n/$total';
  }

  @override
  String get hallFideLine => 'Danh hiệu FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Ván cờ nhanh';

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

  @override
  String get liveTitle => 'Đang chơi';

  @override
  String get liveSwitch => 'Ván cờ từ internet';

  @override
  String get liveSwitchHint =>
      'Giải đấu trực tiếp chỉ được tải về khi công tắc này đang bật.';

  @override
  String get liveNothing => 'Hiện chưa có ván nào đang chơi.';

  @override
  String get liveError => 'Không tải được. Hãy thử lại sau nhé.';

  @override
  String get liveOffline => 'Không có internet: đang hiện những gì đã tải về.';

  @override
  String liveGame(int n) {
    return 'Ván $n';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsBattles => 'Trận đấu khi ăn quân';

  @override
  String get settingsBattlesHint =>
      'Tắt: quân bị ăn chỉ biến mất trong làn khói.';

  @override
  String get settingsClassic => 'Quân cờ vua cổ điển';

  @override
  String get settingsClassicHint =>
      'Trong ván cờ, thay cho các nhân vật của đội quân. Khi đó không hiện trận đấu.';

  @override
  String get liveBadge => 'Trực tiếp';

  @override
  String get liveSkip => 'Bỏ qua';

  @override
  String get liveTryOwn => 'Mình tự thử';

  @override
  String get liveAdviser => 'Quân sư';

  @override
  String get liveBackToGame => 'Quay lại ván cờ';

  @override
  String get liveNewMove => 'Nước đi mới!';

  @override
  String liveNewMoves(int n) {
    return 'Nước đi mới: $n';
  }

  @override
  String get liveTimeTrouble => 'Sắp hết giờ!';

  @override
  String get liveAdviserThinking => 'Quân sư vẫn đang suy nghĩ.';

  @override
  String get liveAdviserContinue => 'Mình tự đi tiếp';

  @override
  String get liveAhead => 'Ai đang dẫn';

  @override
  String get liveClockApprox => 'Thời gian là ước tính';

  @override
  String get liveReset => 'Từ đầu';

  @override
  String liveStartsAt(String time) {
    return 'Bắt đầu lúc $time';
  }

  @override
  String liveDepth(int n) {
    return 'độ sâu $n';
  }
}
