import 'dart:math';

import 'package:cute_kid_fonts_flame/cute_kid_fonts_flame.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import '../../core/armies/army.dart';
import '../../core/chess/types.dart';
import '../board/piece_glyph.dart';
import 'battle_director.dart';

/// Who fights whom. Built by the board when a capture happens.
class BattleRequest {
  const BattleRequest({required this.attackerArmy, required this.attacker, required this.defenderArmy, required this.defender, this.lang = 'cs'});

  final Army attackerArmy;
  final PieceType attacker;
  final Army defenderArmy;
  final PieceType defender;
  final String lang;
}

/// Full-screen battle overlay (BATTLES_PLAN §3). B1: placeholder fighters
/// (army-coloured blobs with the piece glyph) animated by effects; sprite
/// atlases plug in at B2 behind the same [BattleDirector] events.
class BattleGame extends FlameGame with TapCallbacks {
  BattleGame(this.request, {required this.onFinished})
    : super(camera: CameraComponent.withFixedResolution(width: 600, height: 900));

  final BattleRequest request;
  final void Function() onFinished;
  final director = BattleDirector();
  final _rnd = Random();

  late final PlaceholderFighter _attacker;
  late final PlaceholderFighter _defender;
  late final SpeechBubble _bubble;
  bool _finished = false;

  static const _left = -150.0;
  static const _right = 150.0;
  static const _ground = 120.0;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    camera.backdrop.add(ArenaBackground(Color(request.attackerArmy.primary), Color(request.defenderArmy.primary)));
    _attacker = PlaceholderFighter(army: request.attackerArmy, type: request.attacker, facingRight: true)
      ..position = Vector2(-460, _ground);
    _defender = PlaceholderFighter(army: request.defenderArmy, type: request.defender, facingRight: false)
      ..position = Vector2(460, _ground);
    _bubble = SpeechBubble()..position = Vector2(0, -230);
    world.addAll([_attacker, _defender, _bubble]);

    final enter = EffectController(duration: BattleDirector.enterTime, curve: Curves.easeOutBack);
    _attacker.add(MoveEffect.to(Vector2(_left, _ground), enter));
    _defender.add(MoveEffect.to(Vector2(_right, _ground), EffectController(duration: BattleDirector.enterTime, curve: Curves.easeOutBack)));
  }

  String _line(Army army, PieceType t, String key) => army[t].lines[key]?.of(request.lang) ?? '';

  @override
  void update(double dt) {
    super.update(dt);
    for (final e in director.update(dt)) {
      switch (e) {
        case BattleEvent.phase:
          _onPhase(director.phase);
        case BattleEvent.hit:
          _onHit();
      }
    }
  }

  void _onPhase(BattlePhase p) {
    final t = director.timing;
    switch (p) {
      case BattlePhase.idle:
        _attacker.idle();
        _defender.idle();
        _bubble.say(_line(request.attackerArmy, request.attacker, 'attack'), left: true);
      case BattlePhase.attack:
        _attacker.attack(towards: _right - _left - 150, hitAt: t.hitAt, total: t.attack);
      case BattlePhase.victory:
        _bubble.say(_line(request.attackerArmy, request.attacker, 'victory'), left: true);
        _attacker.victory(t.victory);
      case BattlePhase.exit:
        _bubble.say('', left: true);
        final out = EffectController(duration: BattleDirector.exitTime, curve: Curves.easeIn);
        _attacker.add(ScaleEffect.to(Vector2.zero(), out));
        if (director.skipped) _defender.add(ScaleEffect.to(Vector2.zero(), EffectController(duration: BattleDirector.exitTime)));
      case BattlePhase.done:
        _finish();
      case BattlePhase.enter:
        break;
    }
  }

  void _onHit() {
    _bubble.say(_line(request.defenderArmy, request.defender, 'defeat'), left: false);
    _defender.defeat(director.timing.defeat);
    _burst(Vector2(_right - 40, _ground - 40), Color(request.attackerArmy.accent));
    camera.viewfinder.add(
      SequenceEffect([
        for (var i = 0; i < 4; i++) MoveEffect.by(Vector2((i.isEven ? 1 : -1) * 14.0, (i.isEven ? -1 : 1) * 6.0), EffectController(duration: 0.04)),
        MoveEffect.to(Vector2.zero(), EffectController(duration: 0.05)),
      ]),
    );
  }

  /// Shared sparkle fx (BATTLES §1: one particle set for everyone).
  void _burst(Vector2 at, Color color) {
    world.add(
      ParticleSystemComponent(
        position: at,
        particle: Particle.generate(
          count: 28,
          lifespan: 0.8,
          generator: (i) {
            final a = _rnd.nextDouble() * 2 * pi;
            final speed = 180 + _rnd.nextDouble() * 260;
            return AcceleratedParticle(
              speed: Vector2(cos(a), sin(a)) * speed,
              acceleration: Vector2(0, 420),
              child: CircleParticle(
                radius: 4 + _rnd.nextDouble() * 6,
                paint: Paint()..color = i.isEven ? color : const Color(0xFFFFFFFF),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Tap to skip after 0.5 s.
  @override
  void onTapDown(TapDownEvent event) {
    if (director.skip()) _onPhase(BattlePhase.exit);
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    onFinished();
  }
}

class ArenaBackground extends Component with HasGameReference<BattleGame> {
  ArenaBackground(this.top, this.bottom);

  final Color top;
  final Color bottom;

  @override
  void render(Canvas canvas) {
    final size = game.canvasSize;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRect(
      rect,
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, Color.lerp(top, bottom, .5)!, bottom]).createShader(rect),
    );
    // Soft hills so the fighters stand somewhere.
    final hill = Paint()..color = const Color(0x55FFFFFF);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.x * .25, size.y * .78), width: size.x * .9, height: size.y * .35), hill);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.x * .8, size.y * .82), width: size.x * .9, height: size.y * .3), hill);
  }
}

/// A round "cute chunky" stand-in: army body, accent ring, piece glyph,
/// eyes. Same API the sprite fighter will have.
class PlaceholderFighter extends PositionComponent {
  PlaceholderFighter({required this.army, required this.type, required this.facingRight})
    : super(size: Vector2.all(180), anchor: Anchor.bottomCenter);

  final Army army;
  final PieceType type;
  final bool facingRight;
  Effect? _bob;

  double get _dir => facingRight ? 1 : -1;

  @override
  Future<void> onLoad() async {
    final r = size.x / 2;
    add(CircleComponent(radius: r * .55, position: Vector2(r, size.y + 6), anchor: Anchor.center, paint: Paint()..color = const Color(0x33000000))
      ..scale = Vector2(1.4, .3));
    add(CircleComponent(radius: r, paint: Paint()..color = Color(army.primary)));
    add(CircleComponent(radius: r, paint: Paint()
      ..color = Color(army.accent)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10));
    add(
      TextComponent(
        text: pieceGlyph(type),
        anchor: Anchor.center,
        position: Vector2(r, r * .78),
        textRenderer: TextPaint(style: TextStyle(fontSize: r * 1.1, color: Color(army.dark))),
      ),
    );
    for (final dx in const [-.28, .28]) {
      add(CircleComponent(radius: r * .11, anchor: Anchor.center, position: Vector2(r + (dx + .12 * _dir) * r, r * 1.42), paint: Paint()..color = Color(army.dark)));
    }
  }

  void idle() {
    _bob = ScaleEffect.to(Vector2(1.04, .96), EffectController(duration: .25, alternate: true, infinite: true, curve: Curves.easeInOut));
    add(_bob!);
  }

  void _stopBob() {
    _bob?.removeFromParent();
    _bob = null;
    scale = Vector2.all(1);
  }

  /// Wind-up, lunge to the hit, step back.
  void attack({required double towards, required double hitAt, required double total}) {
    _stopBob();
    final wind = hitAt * .45;
    final lunge = hitAt - wind;
    add(
      SequenceEffect([
        MoveEffect.by(Vector2(-30 * _dir, 0), EffectController(duration: wind, curve: Curves.easeOut)),
        MoveEffect.by(Vector2((towards + 30) * _dir, -20), EffectController(duration: lunge, curve: Curves.easeIn)),
        MoveEffect.by(Vector2(-towards * _dir, 20), EffectController(duration: max(.05, total - hitAt), curve: Curves.easeOut)),
      ]),
    );
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2(.85, 1.15), EffectController(duration: wind)),
        ScaleEffect.to(Vector2(1.2, .85), EffectController(duration: lunge)),
        ScaleEffect.to(Vector2.all(1), EffectController(duration: max(.05, total - hitAt))),
      ]),
    );
  }

  /// Bonk → spin and fly off the side ("odchází do hradu").
  void defeat(double duration) {
    _stopBob();
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2(1.3, .7), EffectController(duration: duration * .15)),
        ScaleEffect.to(Vector2.all(1), EffectController(duration: duration * .1)),
      ]),
    );
    add(MoveEffect.by(Vector2(-_dir * 520, -380), EffectController(duration: duration * .75, startDelay: duration * .25, curve: Curves.easeIn)));
    add(RotateEffect.by(-_dir * 4 * pi, EffectController(duration: duration * .75, startDelay: duration * .25)));
    add(ScaleEffect.to(Vector2.all(.4), EffectController(duration: duration * .75, startDelay: duration * .25)));
  }

  void victory(double duration) {
    _stopBob();
    add(MoveEffect.by(Vector2(0, -70), EffectController(duration: duration / 4, alternate: true, repeatCount: 2, curve: Curves.easeOut)));
    add(RotateEffect.by(.15 * _dir, EffectController(duration: duration / 4, alternate: true, repeatCount: 2)));
  }
}

/// Rounded bubble with the character's line.
class SpeechBubble extends PositionComponent {
  SpeechBubble() : super(anchor: Anchor.center);

  String _text = '';
  bool _left = true;
  final _paint = KidTextPaint.of(KidRole.dialog, KidPalette.lavender, size: 34);

  void say(String text, {required bool left}) {
    _text = text;
    _left = left;
  }

  @override
  void render(Canvas canvas) {
    if (_text.isEmpty) return;
    final metrics = _paint.getLineMetrics(_text);
    final w = metrics.width + 48, h = metrics.height + 32;
    final cx = _left ? -120.0 : 120.0;
    final rect = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, 0), width: w, height: h), const Radius.circular(28));
    final tail = Path()
      ..moveTo(cx - 20, h / 2 - 2)
      ..lineTo(cx + (_left ? -40 : 40), h / 2 + 34)
      ..lineTo(cx + 20, h / 2 - 2)
      ..close();
    final fill = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawPath(tail, fill);
    canvas.drawRRect(rect, fill);
    canvas.drawRRect(rect, Paint()
      ..color = KidPalette.lavender.dark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4);
    _paint.render(canvas, _text, Vector2(cx, 0), anchor: Anchor.center);
  }
}
