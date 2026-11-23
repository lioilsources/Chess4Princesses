// DOM overlay: whose turn it is (the army's king), the end-of-game card and a
// restart button. No words yet: texts come from the ARB files in F3.
import type { ArmyArt } from './armies';

export const byId = (id: string): HTMLElement => {
  const el = document.getElementById(id);
  if (!el) throw new Error(`#${id} missing in index.html`);
  return el;
};

export type Outcome = 'won' | 'lost' | 'draw';

export class Hud {
  private readonly turn = byId('turn') as HTMLImageElement;
  private readonly end = byId('end');
  private readonly fps = byId('fps');

  constructor(onRestart: () => void) {
    for (const el of document.querySelectorAll<HTMLButtonElement>('[data-restart]')) el.addEventListener('click', onRestart);
  }

  setTurn(art: ArmyArt): void {
    const url = art.sprite('king');
    this.turn.hidden = !url;
    if (url) this.turn.src = url;
  }

  showEnd(outcome: Outcome | null, winner: ArmyArt | null): void {
    this.end.hidden = outcome === null;
    if (outcome === null) return;
    this.end.dataset.outcome = outcome;
    const img = this.end.querySelector('img');
    const url = winner?.sprite('king') ?? null;
    if (img) {
      img.hidden = !url;
      if (url) img.src = url;
    }
  }

  showFps(text: string): void {
    this.fps.hidden = false;
    this.fps.textContent = text;
  }
}
