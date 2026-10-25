import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'voice_lines.dart';

/// Plays pre-generated voice clips (PLAN M3). A sentence without a clip is
/// skipped silently, so new lessons work before their audio exists.
class Narrator {
  Narrator(this._clips);

  /// Reads the asset manifest once; clips are whatever is bundled.
  static Future<Narrator> load([AssetBundle? bundle]) async {
    final manifest = await AssetManifest.loadFromAssetBundle(bundle ?? rootBundle);
    return Narrator(manifest.listAssets().where((a) => a.startsWith('assets/voice/') && a.endsWith('.mp3')).toSet());
  }

  final Set<String> _clips;
  AudioPlayer? _player;
  List<String> _queue = const [];
  StreamSubscription<void>? _done;

  /// Parent setting later; off = silent app.
  bool enabled = true;

  bool has(String lang, String text) => _clips.contains(voiceAsset(lang, text));

  /// Stops whatever is playing and reads [texts] one after another.
  Future<void> say(String lang, List<String> texts) async {
    final assets = [
      for (final t in texts)
        if (t.trim().isNotEmpty && has(lang, t)) voiceAsset(lang, t),
    ];
    if (!enabled) return;
    _queue = assets;
    await _next(stopFirst: true);
  }

  Future<void> stop() => say('', const []);

  Future<void> _next({bool stopFirst = false}) async {
    try {
      final p = _player ??= _newPlayer();
      if (stopFirst) await p.stop();
      if (_queue.isEmpty) return;
      final asset = _queue.first;
      _queue = _queue.sublist(1);
      // AssetSource is relative to assets/.
      await p.play(AssetSource(asset.substring('assets/'.length)));
    } on Object catch (e) {
      // No audio plugin in widget tests, a busy audio session on device:
      // the lesson must go on without the voice.
      debugPrint('narrator: $e');
    }
  }

  AudioPlayer _newPlayer() {
    final p = AudioPlayer(playerId: 'narrator');
    _done = p.onPlayerComplete.listen((_) => _next());
    return p;
  }

  Future<void> dispose() async {
    await _done?.cancel();
    await _player?.dispose();
  }
}
