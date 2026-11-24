// Babylon scene: the kid chessboard of lib/features/board/chess_board.dart seen from
// above with an orthographic camera. Squares are painted into one DynamicTexture
// (with selection, move dots and the last move); each piece is the army's sprite on
// a plane standing on a gold (mine) or dark (theirs) plate, as in piece_token.dart.
import type { Engine } from '@babylonjs/core/Engines/engine';
import { Scene } from '@babylonjs/core/scene';
import { FreeCamera } from '@babylonjs/core/Cameras/freeCamera';
import { Camera } from '@babylonjs/core/Cameras/camera';
import { Color3, Color4 } from '@babylonjs/core/Maths/math.color';
import { Vector3 } from '@babylonjs/core/Maths/math.vector';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { DynamicTexture } from '@babylonjs/core/Materials/Textures/dynamicTexture';
import { Texture } from '@babylonjs/core/Materials/Textures/texture';
import { TransformNode } from '@babylonjs/core/Meshes/transformNode';
import type { Mesh } from '@babylonjs/core/Meshes/mesh';
import { CreatePlane } from '@babylonjs/core/Meshes/Builders/planeBuilder';
import { CreateDisc } from '@babylonjs/core/Meshes/Builders/discBuilder';
// Bundle the StandardMaterial shaders up front: no lazy-load round trip before the first frame.
import '@babylonjs/core/Shaders/default.vertex';
import '@babylonjs/core/Shaders/default.fragment';

import type { Position } from '../rules/position';
import { fileOf, isLight, rankOf, sq, type Move, type Piece, type PieceType, type Side, type Square } from '../rules/types';
import { BOARD, PLATE, rgb01 } from '../ui/palette';
import type { ArmyArt } from '../ui/armies';

/** Frame around the squares, in square units (the coordinate strip of the Flutter board). */
const FRAME = 0.32;
const SLIDE_S = 0.38;

export interface ScreenRect { left: number; top: number; width: number; height: number }
export interface BoardMarks { selected: Square | null; dots: ReadonlySet<Square> }

interface Token { node: TransformNode; piece: Piece; square: Square }

const flat = (scene: Scene, name: string, rgb: readonly number[]): StandardMaterial => {
  const m = new StandardMaterial(name, scene);
  m.disableLighting = true;
  m.emissiveColor = Color3.FromArray([...rgb]);
  m.backFaceCulling = false;
  return m;
};

export class BoardScene {
  readonly scene: Scene;
  private readonly camera: FreeCamera;
  private readonly squares: DynamicTexture;
  private readonly plates: Record<'mine' | 'theirs', StandardMaterial>;
  private readonly spriteMats = new Map<string, StandardMaterial>();
  private tokens: Token[] = [];
  private occupied = new Set<Square>();
  private slide: { token: Token; from: Vector3; to: Vector3; t: number } | null = null;
  private view: { rect: ScreenRect; unitsPerPx: number; cx: number; cy: number } | null = null;

  constructor(engine: Engine, private readonly armyOf: (s: Side) => ArmyArt, private readonly mySide: Side) {
    const scene = (this.scene = new Scene(engine));
    scene.clearColor = Color4.FromArray([...rgb01(BOARD.background), 1]);
    scene.skipPointerMovePicking = true;
    const cam = (this.camera = new FreeCamera('cam', new Vector3(4, 4, -10), scene));
    cam.mode = Camera.ORTHOGRAPHIC_CAMERA;
    cam.setTarget(new Vector3(4, 4, 0));
    cam.minZ = 0.1;
    cam.maxZ = 100;

    const size = 8 + 2 * FRAME;
    const board = CreatePlane('board', { size }, scene);
    board.position.set(4, 4, 0.5);
    this.squares = new DynamicTexture('squares', { width: 1024, height: 1024 }, scene, true);
    const bm = flat(scene, 'boardMat', [1, 1, 1]);
    bm.diffuseTexture = this.squares;
    bm.emissiveColor = Color3.White();
    board.material = bm;
    this.plates = { mine: flat(scene, 'plateMine', rgb01(PLATE.mine)), theirs: flat(scene, 'plateTheirs', rgb01(PLATE.theirs)) };
    this.paint({ selected: null, dots: new Set() });
  }

  /** Screen position (board units) of a square for the player's side at the bottom. */
  private place(s: Square): Vector3 {
    const f = this.mySide === 'white' ? fileOf(s) : 7 - fileOf(s);
    const r = this.mySide === 'white' ? rankOf(s) : 7 - rankOf(s);
    // Lower rows stand in front of the row behind them.
    return new Vector3(f + 0.5, r + 0.5, r * 0.01);
  }

  private spriteMat(side: Side, type: PieceType): StandardMaterial | null {
    const art = this.armyOf(side);
    const url = art.sprite(type);
    if (!url) return null;
    let m = this.spriteMats.get(url);
    if (!m) {
      const tex = new Texture(url, this.scene, false, true, Texture.TRILINEAR_SAMPLINGMODE);
      tex.hasAlpha = true;
      m = new StandardMaterial(url, this.scene);
      m.disableLighting = true;
      m.emissiveColor = Color3.White();
      m.diffuseTexture = tex;
      m.useAlphaFromDiffuseTexture = true;
      m.backFaceCulling = false;
      this.spriteMats.set(url, m);
    }
    return m;
  }

  private makeToken(piece: Piece, square: Square): Token {
    const node = new TransformNode(`piece${square}`, this.scene);
    const mine = piece.side === this.mySide;
    const plate: Mesh = CreateDisc('plate', { radius: 0.39, tessellation: 32 }, this.scene);
    plate.scaling.y = 0.26;
    plate.parent = node;
    plate.position.set(0, -0.36, 0.002);
    plate.material = this.plates[mine ? 'mine' : 'theirs'];
    const mat = this.spriteMat(piece.side, piece.type);
    if (mat) {
      const sprite = CreatePlane('sprite', { width: 0.96, height: 0.93 }, this.scene);
      sprite.parent = node;
      sprite.position.set(0, 0.035, 0);
      // Rival characters face the other way, towards "my" side.
      if (!mine) sprite.scaling.x = -1;
      sprite.material = mat;
    }
    node.position = this.place(square);
    return { node, piece, square };
  }

  /** Rebuilds the pieces; with `move`, the moved piece slides in from its start square. */
  setPosition(pos: Position, move: Move | null = null): void {
    for (const t of this.tokens) t.node.dispose();
    this.tokens = [...pos.pieces()].map(([s, p]) => this.makeToken(p, s));
    this.occupied = new Set(this.tokens.map((t) => t.square));
    this.slide = null;
    if (move) {
      const token = this.tokens.find((t) => t.square === move.to);
      if (token) {
        const to = token.node.position.clone();
        const from = this.place(move.from);
        from.z = -0.05; // the moving piece passes in front of everything
        token.node.position = from.clone();
        this.slide = { token, from, to, t: 0 };
      }
    }
  }

  get sliding(): boolean { return this.slide !== null; }

  /** Advances the slide animation by dt seconds. */
  tick(dt: number): void {
    const s = this.slide;
    if (!s) return;
    s.t = Math.min(1, s.t + dt / SLIDE_S);
    const k = 1 - (1 - s.t) ** 3; // ease-out cubic, like Curves.easeOutCubic
    s.token.node.position = Vector3.Lerp(s.from, s.to, k);
    if (s.t >= 1) {
      s.token.node.position = s.to;
      this.slide = null;
    }
  }

  paint(marks: BoardMarks): void {
    const g = this.squares.getContext() as CanvasRenderingContext2D;
    const px = 1024 / (8 + 2 * FRAME);
    g.fillStyle = BOARD.frame;
    g.fillRect(0, 0, 1024, 1024);
    for (let s = 0; s < 64; s++) {
      const p = this.place(s);
      const x = (p.x - 0.5 + FRAME) * px;
      const y = (8 - (p.y + 0.5) + FRAME) * px;
      g.fillStyle = isLight(s) ? BOARD.light : BOARD.dark;
      g.fillRect(x, y, px + 0.5, px + 0.5);
      if (marks.selected === s) {
        g.fillStyle = BOARD.selected;
        g.fillRect(x, y, px + 0.5, px + 0.5);
      }
      if (marks.dots.has(s)) {
        // chess_board.dart: a dot on an empty square, a ring around a piece that can be taken.
        g.beginPath();
        if (this.occupied.has(s)) {
          g.strokeStyle = BOARD.dotRing;
          g.lineWidth = px * 0.07;
          g.arc(x + px / 2, y + px / 2, px * 0.45 - px * 0.035, 0, Math.PI * 2);
          g.stroke();
        } else {
          g.fillStyle = BOARD.dot;
          g.arc(x + px / 2, y + px / 2, px * 0.14, 0, Math.PI * 2);
          g.fill();
        }
      }
    }
    this.squares.update();
  }

  /** Fits the board into a CSS-pixel rectangle of the canvas. */
  fit(rect: ScreenRect, canvasW: number, canvasH: number): void {
    const size = 8 + 2 * FRAME;
    const unitsPerPx = size / Math.min(rect.width, rect.height);
    // Centre of the rect in board units, then the camera window covering the whole canvas.
    const cx = 4 - (rect.left + rect.width / 2 - canvasW / 2) * unitsPerPx;
    const cy = 4 + (rect.top + rect.height / 2 - canvasH / 2) * unitsPerPx;
    const c = this.camera;
    c.position.set(cx, cy, -10);
    c.setTarget(new Vector3(cx, cy, 0));
    c.orthoLeft = -canvasW / 2 * unitsPerPx;
    c.orthoRight = canvasW / 2 * unitsPerPx;
    c.orthoBottom = -canvasH / 2 * unitsPerPx;
    c.orthoTop = canvasH / 2 * unitsPerPx;
    this.view = { rect: { left: 0, top: 0, width: canvasW, height: canvasH }, unitsPerPx, cx, cy };
  }

  /** Square under a canvas CSS-pixel point, or null outside the board. */
  squareAt(x: number, y: number): Square | null {
    const v = this.view;
    if (!v) return null;
    const bx = v.cx + (x - v.rect.width / 2) * v.unitsPerPx;
    const by = v.cy - (y - v.rect.height / 2) * v.unitsPerPx;
    const f = Math.floor(bx);
    const r = Math.floor(by);
    if (f < 0 || f > 7 || r < 0 || r > 7) return null;
    return this.mySide === 'white' ? sq(f, r) : sq(7 - f, 7 - r);
  }
}
