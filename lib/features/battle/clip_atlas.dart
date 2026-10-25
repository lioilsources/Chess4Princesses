import 'dart:convert';

/// One clip's atlas JSON written by `tool/pack_sheet.py`
/// (`assets/armies/<army>/battle/<piece>/<clip>.json`, BATTLES_PLAN §2).
class ClipAtlas {
  const ClipAtlas({
    required this.clip,
    required this.image,
    required this.frames,
    required this.anchor,
    this.hitFrame,
    this.fx,
    this.sfx,
    this.exit,
    this.pair = false,
  });

  factory ClipAtlas.parse(String source) {
    final j = jsonDecode(source) as Map<String, dynamic>;
    final meta = j['meta'] as Map<String, dynamic>;
    final anchor = meta['anchor'] as List;
    return ClipAtlas(
      clip: meta['clip'] as String,
      image: meta['image'] as String,
      frames: [
        for (final f in j['frames'] as List)
          AtlasFrame(
            x: f['frame']['x'] as int,
            y: f['frame']['y'] as int,
            w: f['frame']['w'] as int,
            h: f['frame']['h'] as int,
            duration: (f['duration'] as num).toInt(),
          ),
      ],
      anchor: ((anchor[0] as num).toDouble(), (anchor[1] as num).toDouble()),
      hitFrame: meta['hit_frame'] as int?,
      fx: meta['fx'] as String?,
      sfx: meta['sfx'] as String?,
      exit: meta['exit'] as String?,
      pair: meta['pair'] as bool? ?? false,
    );
  }

  static const clips = ['idle', 'attack', 'defeat', 'victory'];
  static const fxKinds = {'sparkle', 'bonk', 'zap', 'splash'};
  static const exitKinds = {'fly_left', 'poof', 'sink'};

  final String clip;
  final String image;
  final List<AtlasFrame> frames;

  /// Feet position in a frame, 0..1 (all characters share one scale).
  final (double, double) anchor;
  final int? hitFrame;
  final String? fx;
  final String? sfx;
  final String? exit;

  /// A `battle_overrides` duel: one clip with both characters.
  final bool pair;

  /// Total length in seconds.
  double get seconds => frames.fold(0, (s, f) => s + f.duration) / 1000;

  /// Seconds into the clip when [hitFrame] starts.
  double? get hitSeconds {
    final h = hitFrame;
    if (h == null) return null;
    return frames.take(h).fold<int>(0, (s, f) => s + f.duration) / 1000;
  }
}

class AtlasFrame {
  const AtlasFrame({required this.x, required this.y, required this.w, required this.h, required this.duration});

  final int x, y, w, h;

  /// Milliseconds.
  final int duration;
}
