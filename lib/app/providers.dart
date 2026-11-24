import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/armies/army.dart';
import '../core/lessons/curriculum.dart';
import '../core/lessons/lesson.dart';
import '../core/audio/sounds.dart';
import '../core/progress/progress.dart';
import '../core/settings/settings.dart';
import '../core/voice/narrator.dart';

final curriculumProvider = FutureProvider<Curriculum>(
  (ref) async => Curriculum.fromYaml(await rootBundle.loadString('assets/lessons/index.yaml')),
);

final lessonProvider = FutureProvider.family<Lesson, String>(
  (ref, id) async => Lesson.fromYaml(await rootBundle.loadString(Curriculum.lessonAsset(id))),
);

final armiesProvider = FutureProvider<Map<String, Army>>((ref) async {
  return {
    for (final id in Army.baseIds) id: Army.parse(await rootBundle.loadString(Army.manifestAsset(id))),
  };
});

/// Voice-over player; resolves once the asset manifest is read.
final narratorProvider = FutureProvider<Narrator>((ref) async {
  final n = await Narrator.load();
  ref.onDispose(n.dispose);
  return n;
});

final soundsProvider = Provider<Sounds>((ref) {
  final s = Sounds();
  ref.onDispose(s.dispose);
  return s;
});

final progressStoreProvider = Provider((ref) => ProgressStore());

final progressProvider = AsyncNotifierProvider<ProgressNotifier, Progress>(ProgressNotifier.new);

class ProgressNotifier extends AsyncNotifier<Progress> {
  @override
  Future<Progress> build() => ref.read(progressStoreProvider).load();

  Future<void> _set(Progress p) async {
    state = AsyncData(p);
    await ref.read(progressStoreProvider).save(p);
  }

  Future<void> completeLesson(Lesson lesson, int stars) async {
    final p = state.value ?? const Progress();
    await _set(p.withLesson(lesson.id, stars, skills: lesson.skills, unlock: lesson.reward.unlock));
  }

  Future<void> chooseArmies({String? mine, String? rival}) async {
    final p = state.value ?? const Progress();
    await _set(p.withArmies(mine: mine, rival: rival));
  }

  Future<void> watchGame(String id) async {
    final p = state.value ?? const Progress();
    if (p.gamesWatched.contains(id)) return;
    await _set(p.withGameWatched(id));
  }
}

/// The two armies currently on the board (mine, rival).
final boardArmiesProvider = FutureProvider<(Army, Army)>((ref) async {
  final armies = await ref.watch(armiesProvider.future);
  final p = await ref.watch(progressProvider.future);
  return (armies[p.myArmy] ?? armies.values.first, armies[p.rivalArmy] ?? armies.values.last);
});

final settingsStoreProvider = Provider((ref) => SettingsStore());

/// Parent settings; [Settings] defaults until loaded.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  Future<Settings> build() => ref.read(settingsStoreProvider).load();

  Future<void> change(Settings Function(Settings) edit) async {
    final next = edit(state.value ?? const Settings());
    state = AsyncData(next);
    await ref.read(settingsStoreProvider).save(next);
  }
}
