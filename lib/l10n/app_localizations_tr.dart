// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Satranç Krallığı';

  @override
  String get mapTitle => 'Krallık';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get locked => 'Kilitli';

  @override
  String get start => 'Oynayalım!';

  @override
  String get again => 'Yeniden';

  @override
  String get next => 'İleri';

  @override
  String get back => 'Geri';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get wellDone => 'Aferin!';

  @override
  String get lessonDone => 'Ders tamam!';

  @override
  String get taskWon => 'Yaşasın!';

  @override
  String get tryAgain => 'Bir daha deneyelim!';

  @override
  String get botWon => 'Küçük robot kazandı. Yeniden oynayalım!';

  @override
  String get promoted => 'Kraliçeye dönüştü!';

  @override
  String get lavaWarning => 'Ay, lav!';

  @override
  String tapTarget(String target) {
    return 'Dokun: $target';
  }

  @override
  String street(String name) {
    return '$name sokağı';
  }

  @override
  String house(String name) {
    return '$name. sıra';
  }

  @override
  String room(String name) {
    return '$name odası';
  }

  @override
  String get dragHint => 'Bir taşı tahtaya sürükle';

  @override
  String get armies => 'Ordular';

  @override
  String get myArmy => 'Ordum';

  @override
  String get rivalArmy => 'Rakip';

  @override
  String get battleDemo => 'Deneme savaşı';

  @override
  String taskOf(int n, int total) {
    return 'Görev $n / $total';
  }

  @override
  String get opponentThinking => 'Küçük robot düşünüyor…';

  @override
  String get hallTitle => 'Şöhret Salonu';

  @override
  String get hallGolden => 'Altın Tahta';

  @override
  String get hallGoldenHint => 'En ünlü 64 oyun';

  @override
  String get hallMatches => 'Taç için maçlar';

  @override
  String get hallMatchesHint => 'Tüm dünya şampiyonluğu maçları';

  @override
  String get hallWomen => 'Şampiyon kadınlar';

  @override
  String get hallWomenHint => 'Kadın dünya şampiyonları ve oyunları';

  @override
  String get hallChallenge => 'Şampiyon ve rakibi';

  @override
  String hallChallengeHint(String year) {
    return '$year unvan maçındaki iki oyuncunun en güzel galibiyetleri';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n/$total';
  }

  @override
  String get hallFideLine => 'FIDE unvanı 1993–2006';

  @override
  String get hallTiebreak => 'Hızlı oyun';

  @override
  String get replayCheck => 'Şah!';

  @override
  String get replayMate => 'Mat!';

  @override
  String get replayCastle => 'Kral kaleye saklandı!';

  @override
  String get replaySacrifice => 'Cesur bir fedakârlık!';

  @override
  String get replayEndMate => 'Mat! Savaş kazanıldı.';

  @override
  String get replayEndResign =>
      'Kral eğildi ve tacını teslim etti. Savaş bitti!';

  @override
  String get replayEndDraw => 'Berabere! İki kral el sıkıştı.';

  @override
  String get replayEndUnfinished => 'Bu savaş hâlâ sürüyor.';

  @override
  String get replayPlay => 'Oynat';

  @override
  String get replayPause => 'Duraklat';

  @override
  String get replayNextBattle => 'Sonraki savaş';

  @override
  String get replayChronicle => 'Kronik';

  @override
  String get replayStepBack => 'Hamle geri';

  @override
  String get replayStepForward => 'Hamle ileri';

  @override
  String replayMoveOf(int n, int total) {
    return 'Hamle $n / $total';
  }

  @override
  String get liveTitle => 'Şu an oynanıyor';

  @override
  String get liveSwitch => 'İnternetten oyunlar';

  @override
  String get liveSwitchHint =>
      'Canlı turnuvalar yalnızca bu açıkken indirilir.';

  @override
  String get liveNothing => 'Şu an hiçbir şey oynanmıyor.';

  @override
  String get liveError => 'Yüklenemedi. Daha sonra tekrar dene.';

  @override
  String get liveOffline =>
      'İnternet yok: daha önce indirilenleri gösteriyorum.';

  @override
  String liveGame(int n) {
    return 'Oyun $n';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsBattles => 'Taş alırken savaş';

  @override
  String get settingsBattlesHint =>
      'Kapalı: alınan taş yalnızca bir bulutta kaybolur.';

  @override
  String get settingsClassic => 'Klasik satranç taşları';

  @override
  String get settingsClassicHint =>
      'Oyunlarda ordu karakterlerinin yerine. O zaman savaşlar gösterilmez.';

  @override
  String get liveBadge => 'Canlı';

  @override
  String get liveSkip => 'Atla';

  @override
  String get liveTryOwn => 'Kendim deneyeceğim';

  @override
  String get liveAdviser => 'Danışman';

  @override
  String get liveBackToGame => 'Oyuna dön';

  @override
  String get liveNewMove => 'Yeni hamle!';

  @override
  String liveNewMoves(int n) {
    return 'Yeni hamleler: $n';
  }

  @override
  String get liveTimeTrouble => 'Süre bitiyor!';

  @override
  String get liveAdviserThinking => 'Danışman hâlâ düşünüyor.';

  @override
  String get liveAdviserContinue => 'Kendim devam edeceğim';

  @override
  String get liveAhead => 'Kim önde';

  @override
  String get liveClockApprox => 'Süre yaklaşıktır';

  @override
  String get liveReset => 'Baştan';

  @override
  String liveStartsAt(String time) {
    return 'Başlangıç $time';
  }

  @override
  String liveDepth(int n) {
    return 'derinlik $n';
  }
}
