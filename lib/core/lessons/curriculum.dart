import 'package:yaml/yaml.dart';

import 'lesson.dart';

/// `assets/lessons/index.yaml` — the kingdom map: modules as islands.
class Curriculum {
  Curriculum(this.modules);

  factory Curriculum.fromYaml(String source) {
    final y = loadYaml(source) as Map;
    return Curriculum([
      for (final m in y['modules'] as List)
        ModuleInfo(
          number: m['module'] as int,
          title: LocalizedText.parse(m['title']),
          icon: '${m['icon'] ?? 'castle'}',
          lessonIds: [for (final l in (m['lessons'] as List? ?? const [])) '$l'],
          unlock: m['unlock'] as String?,
        ),
    ]);
  }

  final List<ModuleInfo> modules;

  /// Asset path of a lesson: `assets/lessons/m01/m01_l03.yaml`.
  static String lessonAsset(String id) => 'assets/lessons/${id.split('_').first}/$id.yaml';
}

class ModuleInfo {
  const ModuleInfo({required this.number, required this.title, required this.icon, required this.lessonIds, this.unlock});

  final int number;
  final LocalizedText title;
  final String icon;

  /// Empty for modules not yet authored ("brzy").
  final List<String> lessonIds;

  /// Character granted after the module tournament (LESSONS: e.g. `queen`).
  final String? unlock;

  bool get isAuthored => lessonIds.isNotEmpty;
}
