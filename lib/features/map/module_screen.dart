import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/progress/progress.dart';
import 'map_screen.dart';

/// One island: its lessons as big tiles, opened one after another.
class ModuleScreen extends ConsumerWidget {
  const ModuleScreen({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(curriculumProvider).value;
    final progress = ref.watch(progressProvider).value ?? const Progress();
    final lang = Localizations.localeOf(context).languageCode;
    final module = cur?.modules.where((m) => m.number == number).firstOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E6),
      body: SafeArea(
        child: module == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Row(
                    children: [
                      IconButton(iconSize: 36, icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                      Icon(moduleIcon(module.icon), size: 40, color: KidPalette.peach.dark),
                      const SizedBox(width: 8),
                      Expanded(child: BubbleText(module.title.of(lang), role: KidRole.title, size: 30, palette: KidPalette.peach)),
                    ],
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        for (final (i, id) in module.lessonIds.indexed)
                          _LessonTile(
                            index: i + 1,
                            lessonId: id,
                            open: progress.isLessonOpen(module, id),
                            stars: progress.starsOf(id),
                            lang: lang,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LessonTile extends ConsumerWidget {
  const _LessonTile({required this.index, required this.lessonId, required this.open, required this.stars, required this.lang});

  final int index;
  final String lessonId;
  final bool open;
  final int stars;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(lessonProvider(lessonId)).value?.title.of(lang) ?? '';
    final palette = open ? KidPalette.mint : KidPalette.sky;
    return GestureDetector(
      onTap: open ? () => context.push('/lesson/$lessonId') : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: open ? Colors.white : const Color(0xFFE8E8EE),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: open ? palette.mid : const Color(0xFFBDBDC8), width: 4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (open)
              BubbleText('$index', role: KidRole.number, size: 52, palette: palette)
            else
              const Icon(Icons.lock_rounded, size: 52, color: Color(0xFF9E9EAE)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center, maxLines: 2, style: KidTheme.of(context).style(KidRole.body).copyWith(fontSize: 16)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++) Icon(Icons.star_rounded, size: 26, color: i < stars ? const Color(0xFFFFC107) : const Color(0xFFE0D6E8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
