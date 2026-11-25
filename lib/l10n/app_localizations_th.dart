// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'อาณาจักรหมากรุก';

  @override
  String get mapTitle => 'อาณาจักร';

  @override
  String get comingSoon => 'เร็ว ๆ นี้';

  @override
  String get locked => 'ล็อกอยู่';

  @override
  String get start => 'เล่นเลย!';

  @override
  String get again => 'อีกครั้ง';

  @override
  String get next => 'ต่อไป';

  @override
  String get back => 'กลับ';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

  @override
  String get wellDone => 'เยี่ยมมาก!';

  @override
  String get lessonDone => 'จบบทเรียนแล้ว!';

  @override
  String get taskWon => 'เย้!';

  @override
  String get tryAgain => 'ลองอีกครั้งนะ!';

  @override
  String get botWon => 'หุ่นยนต์ชนะ เล่นอีกรอบกัน!';

  @override
  String get promoted => 'เธอกลายเป็นราชินีแล้ว!';

  @override
  String get lavaWarning => 'โอ๊ย ลาวา!';

  @override
  String tapTarget(String target) {
    return 'แตะที่: $target';
  }

  @override
  String street(String name) {
    return 'ถนน $name';
  }

  @override
  String house(String name) {
    return 'แถว $name';
  }

  @override
  String room(String name) {
    return 'ห้อง $name';
  }

  @override
  String get dragHint => 'ลากตัวหมากไปวางบนกระดาน';

  @override
  String get armies => 'กองทัพ';

  @override
  String get myArmy => 'กองทัพของฉัน';

  @override
  String get rivalArmy => 'คู่ต่อสู้';

  @override
  String get battleDemo => 'การต่อสู้ทดลอง';

  @override
  String taskOf(int n, int total) {
    return 'ภารกิจ $n จาก $total';
  }

  @override
  String get opponentThinking => 'หุ่นยนต์กำลังคิด…';

  @override
  String get hallTitle => 'หอเกียรติยศ';

  @override
  String get hallGolden => 'กระดานทองคำ';

  @override
  String get hallGoldenHint => '64 เกมที่โด่งดังที่สุด';

  @override
  String get hallMatches => 'ศึกชิงมงกุฎ';

  @override
  String get hallMatchesHint => 'ทุกแมตช์ชิงแชมป์โลก';

  @override
  String get hallWomen => 'แชมป์หญิง';

  @override
  String get hallWomenHint => 'แชมป์โลกหญิงและเกมของพวกเธอ';

  @override
  String get hallChallenge => 'แชมป์และผู้ท้าชิง';

  @override
  String hallChallengeHint(String year) {
    return 'ชัยชนะที่สวยที่สุดของผู้เล่นทั้งสองในแมตช์ชิงแชมป์ $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n จาก $total';
  }

  @override
  String get hallFideLine => 'ตำแหน่ง FIDE 1993–2006';

  @override
  String get hallTiebreak => 'เกมเร็ว';

  @override
  String get replayCheck => 'รุก!';

  @override
  String get replayMate => 'รุกฆาต!';

  @override
  String get replayCastle => 'ราชาไปซ่อนในปราสาท!';

  @override
  String get replaySacrifice => 'การเสียสละที่กล้าหาญ!';

  @override
  String get replayEndMate => 'รุกฆาต! ชนะการต่อสู้แล้ว';

  @override
  String get replayEndResign => 'ราชาโค้งคำนับและส่งมอบมงกุฎ การต่อสู้จบแล้ว!';

  @override
  String get replayEndDraw => 'เสมอ! ราชาทั้งสองจับมือกัน';

  @override
  String get replayEndUnfinished => 'การต่อสู้นี้ยังดำเนินอยู่';

  @override
  String get replayPlay => 'เล่น';

  @override
  String get replayPause => 'หยุดชั่วคราว';

  @override
  String get replayNextBattle => 'การต่อสู้ถัดไป';

  @override
  String get replayChronicle => 'บันทึก';

  @override
  String get replayStepBack => 'ถอยหลังหนึ่งตา';

  @override
  String get replayStepForward => 'เดินหน้าหนึ่งตา';

  @override
  String replayMoveOf(int n, int total) {
    return 'ตาที่ $n จาก $total';
  }

  @override
  String get liveTitle => 'กำลังเล่นอยู่ตอนนี้';

  @override
  String get liveSwitch => 'เกมจากอินเทอร์เน็ต';

  @override
  String get liveSwitchHint =>
      'ระบบจะดาวน์โหลดทัวร์นาเมนต์สดเฉพาะตอนที่เปิดสวิตช์นี้เท่านั้น';

  @override
  String get liveNothing => 'ตอนนี้ยังไม่มีใครเล่นอยู่';

  @override
  String get liveError => 'โหลดไม่สำเร็จ ลองใหม่ภายหลังนะ';

  @override
  String get liveOffline => 'ไม่มีอินเทอร์เน็ต: แสดงสิ่งที่ดาวน์โหลดไว้แล้ว';

  @override
  String liveGame(int n) {
    return 'เกมที่ $n';
  }

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsBattles => 'การต่อสู้เมื่อกินหมาก';

  @override
  String get settingsBattlesHint =>
      'ปิด: หมากที่ถูกกินจะหายไปในก้อนเมฆเท่านั้น';

  @override
  String get settingsClassic => 'หมากรุกแบบคลาสสิก';

  @override
  String get settingsClassicHint => 'ในเกมแทนตัวละครของกองทัพ';

  @override
  String get liveBadge => 'สด';

  @override
  String get liveSkip => 'ข้าม';

  @override
  String get liveTryOwn => 'ฉันจะลองเอง';

  @override
  String get liveAdviser => 'ที่ปรึกษา';

  @override
  String get liveBackToGame => 'กลับไปที่เกม';

  @override
  String get liveNewMove => 'ตาเดินใหม่!';

  @override
  String liveNewMoves(int n) {
    return 'ตาเดินใหม่: $n';
  }

  @override
  String get liveTimeTrouble => 'เวลาใกล้หมดแล้ว!';

  @override
  String get liveAdviserThinking => 'ที่ปรึกษายังคิดอยู่';

  @override
  String get liveAdviserContinue => 'ฉันจะเล่นต่อเอง';

  @override
  String get liveAhead => 'ใครนำอยู่';

  @override
  String get liveClockApprox => 'เวลาเป็นค่าประมาณ';

  @override
  String get liveReset => 'ตั้งแต่ต้น';

  @override
  String liveStartsAt(String time) {
    return 'เริ่มเวลา $time';
  }

  @override
  String liveDepth(int n) {
    return 'ความลึก $n';
  }
}
