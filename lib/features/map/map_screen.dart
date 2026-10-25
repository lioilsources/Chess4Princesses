import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/lessons/curriculum.dart';
import '../../core/progress/progress.dart';
import '../../l10n/app_localizations.dart';

IconData moduleIcon(String key) => switch (key) {
  'castle' => Icons.castle_rounded,
  'pawn' => Icons.face_retouching_natural_rounded,
  'rook' => Icons.train_rounded,
  'bishop' => Icons.flutter_dash_rounded,
  'queen' => Icons.diamond_rounded,
  'knight' => Icons.bedroom_baby_rounded,
  'king' => Icons.emoji_people_rounded,
  'apple' => Icons.apple_rounded,
  'crown' => Icons.workspace_premium_rounded,
  'magic' => Icons.auto_fix_high_rounded,
  'map' => Icons.map_rounded,
  'fox' => Icons.pets_rounded,
  'trophy' => Icons.emoji_events_rounded,
  _ => Icons.star_rounded,
};

/// Island art: modules 1–6 show my army's character, the rest a sticker.
String moduleArt(String key, String armyId) => switch (key) {
  'pawn' || 'rook' || 'bishop' || 'queen' || 'knight' || 'king' => 'assets/armies/$armyId/sprites/$key.png',
  _ => 'assets/ui/modules/$key.png',
};

const _islandColors = [KidPalette.peach, KidPalette.mint, KidPalette.sky, KidPalette.lavender, KidPalette.lemon];

/// Kingdom map (PLAN §1.1): modules as islands along a winding path.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cur = ref.watch(curriculumProvider);
    final progress = ref.watch(progressProvider).value ?? const Progress();
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFDFF1FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                children: [
                  Expanded(child: BubbleText(l10n.appTitle, role: KidRole.title, size: 34, palette: KidPalette.peach)),
                  IconButton(iconSize: 36, tooltip: l10n.battleDemo, icon: const Icon(Icons.bolt_rounded), onPressed: () => context.push('/battle')),
                  IconButton(iconSize: 36, tooltip: l10n.armies, icon: const Icon(Icons.shield_rounded), onPressed: () => context.push('/army')),
                ],
              ),
            ),
            Expanded(
              child: switch (cur) {
                AsyncData(value: final c) => _Islands(curriculum: c, progress: progress, lang: lang, l10n: l10n),
                AsyncError(:final error) => Center(child: Text('$error')),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Islands extends StatelessWidget {
  const _Islands({required this.curriculum, required this.progress, required this.lang, required this.l10n});

  final Curriculum curriculum;
  final Progress progress;
  final String lang;
  final AppLocalizations l10n;

  static const rowHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final modules = curriculum.modules;
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        Offset centre(int i) => Offset(w * (i.isEven ? .3 : .7), rowHeight * i + rowHeight / 2);
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: SizedBox(
            height: rowHeight * modules.length,
            child: CustomPaint(
              painter: _PathPainter([for (var i = 0; i < modules.length; i++) centre(i)]),
              child: Stack(
                children: [
                  for (var i = 0; i < modules.length; i++)
                    Positioned(
                      left: centre(i).dx - 80,
                      top: centre(i).dy - 60,
                      width: 160,
                      child: _Island(
                        module: modules[i],
                        open: progress.isModuleOpen(curriculum, modules[i].number),
                        done: progress.isModuleDone(modules[i]),
                        stars: modules[i].lessonIds.fold(0, (s, id) => s + progress.starsOf(id)),
                        palette: _islandColors[i % _islandColors.length],
                        armyId: progress.myArmy,
                        lang: lang,
                        l10n: l10n,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Island extends StatelessWidget {
  const _Island({required this.module, required this.open, required this.done, required this.stars, required this.palette, required this.armyId, required this.lang, required this.l10n});

  final ModuleInfo module;
  final String armyId;
  final bool open;
  final bool done;
  final int stars;
  final KidPalette palette;
  final String lang;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final grey = !open;
    return GestureDetector(
      onTap: open ? () => context.push('/module/${module.number}') : null,
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: grey ? null : LinearGradient(colors: [palette.light, palette.mid], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              color: grey ? const Color(0xFFD6D6E0) : null,
              border: Border.all(color: grey ? const Color(0xFF9E9EAE) : palette.dark, width: 4),
              boxShadow: done ? [const BoxShadow(color: Color(0xFFFFD54F), blurRadius: 18, spreadRadius: 4)] : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ColorFiltered(
                  // Locked islands are greyed out, art included.
                  colorFilter: grey
                      ? const ColorFilter.matrix([.33, .33, .33, 0, 40, .33, .33, .33, 0, 40, .33, .33, .33, 0, 40, 0, 0, 0, .55, 0])
                      : const ColorFilter.mode(Color(0x00000000), BlendMode.dst),
                  child: Image.asset(
                    moduleArt(module.icon, armyId),
                    width: 72,
                    height: 72,
                    errorBuilder: (_, _, _) => Icon(moduleIcon(module.icon), size: 46, color: grey ? const Color(0xFF9E9EAE) : palette.dark),
                  ),
                ),
                if (!open)
                  Positioned(right: 6, bottom: 6, child: Icon(module.isAuthored ? Icons.lock_rounded : Icons.hourglass_top_rounded, size: 24, color: const Color(0xFF6E6E80))),
              ],
            ),
          ),
          const SizedBox(height: 4),
          BubbleText(module.title.of(lang), role: KidRole.title, size: 17, palette: grey ? KidPalette.sky : palette, maxLines: 1),
          if (open && stars > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107)), Text(' $stars / ${module.lessonIds.length * 3}')],
            )
          else if (!module.isAuthored)
            Text(l10n.comingSoon, style: const TextStyle(color: Color(0xFF6E6E80))),
        ],
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  _PathPainter(this.points);

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i];
      path.cubicTo(a.dx, (a.dy + b.dy) / 2, b.dx, (a.dy + b.dy) / 2, b.dx, b.dy);
    }
    final dash = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 34) {
        canvas.drawPath(m.extractPath(d, d + 16), dash);
      }
    }
  }

  @override
  bool shouldRepaint(_PathPainter old) => old.points != points;
}
