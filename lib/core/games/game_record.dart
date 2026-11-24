import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../chess/position.dart';
import '../chess/rules.dart';
import '../chess/types.dart';
import 'pgn.dart';
import 'san_reader.dart';

enum GameResult {
  whiteWins('1-0'),
  blackWins('0-1'),
  draw('1/2-1/2'),
  unfinished('*');

  const GameResult(this.pgn);
  final String pgn;

  static GameResult parse(String s) => values.firstWhere((r) => r.pgn == s, orElse: () => unfinished);

  Side? get winner => switch (this) {
    whiteWins => Side.white,
    blackWins => Side.black,
    _ => null,
  };
}

class GameFormatException implements Exception {
  GameFormatException(this.message, {this.ply});
  final String message;
  final int? ply;
  @override
  String toString() => 'GameFormatException: $message';
}

/// One fully replayed game: headers, moves and the position after every ply.
/// `positions[0]` is the start, `positions[i + 1]` follows `moves[i]`.
class GameRecord {
  GameRecord._(this.headers, this.moves, this.sans, this.positions, this.result, {this.clocks = const [], this.evals = const []});

  factory GameRecord.fromPgn(PgnGame g) {
    const rules = Rules();
    final fen = g.headers['FEN'];
    var pos = fen != null && fen.isNotEmpty ? Position.fromFen(fen) : Position.initial();
    final positions = [pos];
    final moves = <Move>[];
    final sans = <String>[];
    for (final (i, san) in g.sans.indexed) {
      final m = readSan(pos, san, rules: rules);
      if (m == null) {
        final n = pos.fullmove;
        final dots = pos.sideToMove == Side.white ? '.' : '...';
        throw GameFormatException('${_who(g)}: illegal or ambiguous move $n$dots$san', ply: i);
      }
      sans.add(rules.san(pos, m));
      moves.add(m);
      pos = pos.apply(m);
      positions.add(pos);
    }
    return GameRecord._(
      g.headers,
      List.unmodifiable(moves),
      List.unmodifiable(sans),
      List.unmodifiable(positions),
      GameResult.parse(g.result),
      clocks: g.clocks,
      evals: g.evals,
    );
  }

  static String _who(PgnGame g) => '${g.header('White')} – ${g.header('Black')}, ${g.header('Date')}';

  final Map<String, String> headers;
  final List<Move> moves;

  /// Re-written SAN (normalised: `O-O`, `=Q`, check marks).
  final List<String> sans;
  final List<Position> positions;
  final GameResult result;

  /// Mover's clock after each ply, or empty (library games have none).
  final List<Duration?> clocks;

  /// Engine evaluation after each ply, or empty.
  final List<Eval?> evals;

  /// Last known clock of [side] after [ply] plies were played, or null.
  Duration? clockOf(Side side, int ply) {
    for (var i = ply - 1; i >= 0; i--) {
      final mover = positions[i].sideToMove;
      if (mover == side && i < clocks.length && clocks[i] != null) return clocks[i];
    }
    return null;
  }

  /// Latest evaluation at or before [ply] plies, or null.
  Eval? evalAt(int ply) {
    for (var i = (ply < evals.length ? ply : evals.length) - 1; i >= 0; i--) {
      if (evals[i] != null) return evals[i];
    }
    return null;
  }

  int get length => moves.length;
  String get white => headers['White'] ?? '?';
  String get black => headers['Black'] ?? '?';
  String get event => headers['Event'] ?? '';

  /// Four-digit year from the `Date` header, or null.
  int? get year => int.tryParse((headers['Date'] ?? '').split('.').first);

  Position get finalPosition => positions.last;
  GameStatus get finalStatus => const Rules().status(finalPosition);
  bool get endsInMate => finalStatus == GameStatus.checkmate;

  /// Stable id: hash of players, date and moves — the same game from two
  /// sources gets the same id, so shelves can share it (PLAN §2).
  String get id {
    String norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final key = '${norm(white)}|${norm(black)}|${headers['Date'] ?? ''}|${moves.map((m) => m.uci).join(' ')}';
    return sha1.convert(utf8.encode(key)).toString().substring(0, 12);
  }

  /// Consistency problems lint reports: a mate the header disagrees with.
  List<String> problems() {
    final out = <String>[];
    if (endsInMate) {
      final winner = finalPosition.sideToMove.opponent;
      if (result.winner != winner) out.add('ends in mate by ${winner.name} but Result is ${result.pgn}');
    }
    if (finalStatus == GameStatus.stalemate && result != GameResult.draw) {
      out.add('ends in stalemate but Result is ${result.pgn}');
    }
    return out;
  }
}
