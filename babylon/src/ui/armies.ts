// Army art from assets/armies/<id>/manifest.json (lib/core/armies/army.dart),
// copied to public/armies/ by scripts/copy-assets.ts.
import type { PieceType } from '../rules/types';

/** Army ids in picker order (Army.baseIds). */
export const ARMY_IDS = [
  'fairies', 'witches', 'kingdom', 'devils', 'fairies_toy', 'witches_toy', 'bees', 'hornets',
  'dinos', 'iceage', 'cats', 'dogs', 'fruit', 'veggies',
] as const;

export interface ArmyArt {
  id: string;
  /** URL of the board sprite, or null → placeholder plate only. */
  sprite(type: PieceType): string | null;
}

interface Manifest { id: string; pieces: Partial<Record<PieceType, { sprite?: string }>> }

export async function loadArmy(id: string): Promise<ArmyArt> {
  const base = `./armies/${id}/`;
  const m = (await (await fetch(`${base}manifest.json`)).json()) as Manifest;
  return { id: m.id, sprite: (t) => (m.pieces[t]?.sprite ? base + m.pieces[t].sprite : null) };
}

/** ?army=<id> picks a known army, otherwise the fallback (Progress defaults). */
export const armyParam = (v: string | null, fallback: string): string =>
  v && (ARMY_IDS as readonly string[]).includes(v) ? v : fallback;
