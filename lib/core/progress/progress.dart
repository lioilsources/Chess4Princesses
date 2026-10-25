import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../lessons/curriculum.dart';

/// What the child has done. Kept small and JSON-serialisable; a drift/isar
/// store can replace [ProgressStore] once the skill heatmap needs queries.
class Progress {
  const Progress({this.lessonStars = const {}, this.skills = const {}, this.unlocked = const {}, this.myArmy = 'fairies', this.rivalArmy = 'witches'});

  factory Progress.fromJson(Map<String, dynamic> j) => Progress(
    lessonStars: Map<String, int>.from(j['lessonStars'] as Map? ?? {}),
    skills: Map<String, int>.from(j['skills'] as Map? ?? {}),
    unlocked: Set<String>.from(j['unlocked'] as List? ?? const []),
    myArmy: j['myArmy'] as String? ?? 'fairies',
    rivalArmy: j['rivalArmy'] as String? ?? 'witches',
  );

  /// Best stars per lesson id (1..3).
  final Map<String, int> lessonStars;

  /// Skill → times practised successfully (parent heatmap, PLAN §1.6).
  final Map<String, int> skills;

  /// Characters / costumes unlocked by lesson rewards.
  final Set<String> unlocked;

  final String myArmy;
  final String rivalArmy;

  Map<String, dynamic> toJson() => {
    'lessonStars': lessonStars,
    'skills': skills,
    'unlocked': unlocked.toList(),
    'myArmy': myArmy,
    'rivalArmy': rivalArmy,
  };

  int starsOf(String lessonId) => lessonStars[lessonId] ?? 0;

  bool isModuleDone(ModuleInfo m) => m.isAuthored && m.lessonIds.every((id) => starsOf(id) > 0);

  /// Module 0 is always open; each next one opens when the previous is done.
  bool isModuleOpen(Curriculum c, int number) {
    final i = c.modules.indexWhere((m) => m.number == number);
    if (i < 0 || !c.modules[i].isAuthored) return false;
    return i == 0 || isModuleDone(c.modules[i - 1]);
  }

  /// Lessons inside a module open one after another.
  bool isLessonOpen(ModuleInfo m, String lessonId) {
    final i = m.lessonIds.indexOf(lessonId);
    return i <= 0 || starsOf(m.lessonIds[i - 1]) > 0;
  }

  Progress withLesson(String id, int stars, {List<String> skills = const [], String? unlock}) => Progress(
    lessonStars: {...lessonStars, id: stars > starsOf(id) ? stars : starsOf(id)},
    skills: {...this.skills, for (final s in skills) s: (this.skills[s] ?? 0) + 1},
    unlocked: {...unlocked, ?unlock},
    myArmy: myArmy,
    rivalArmy: rivalArmy,
  );

  Progress withArmies({String? mine, String? rival}) => Progress(
    lessonStars: lessonStars,
    skills: skills,
    unlocked: unlocked,
    myArmy: mine ?? myArmy,
    rivalArmy: rival ?? rivalArmy,
  );
}

class ProgressStore {
  static const _key = 'progress_v1';

  Future<Progress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const Progress();
    try {
      return Progress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return const Progress();
    }
  }

  Future<void> save(Progress p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(p.toJson()));
  }
}
