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
  String get promoted => 'เธอกลายเป็นเจ้าหญิงแล้ว!';

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
  String get hallFamous => 'เกมที่มีชื่อเสียง';

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
}
