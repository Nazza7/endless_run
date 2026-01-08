# graphic.md — Linee guida grafiche (Endless Runner · Lua + LÖVE2D)

Questo documento definisce le **linee guida visual** per il progetto *Endless Runner*.
Serve a mantenere coerenza tra **personaggi, ostacoli, UI e feedback** (soprattutto Danger Mode).

---

## 1) Fantasia
**Tema:** fuga urbana — il protagonista è un **ladro** in corsa, inseguito dalla polizia.  
**Tono:** adrenalinico, “heist escape”, leggibilità prima di tutto.  
**Stile consigliato:** 2D **cartoon/stylized** (forme pulite, silhouette riconoscibili) oppure **flat + outline**.



## 2) Personaggi (character bible)

### 2.1 Protagonista — Il Ladro
**Ruolo:** player character (sempre al centro dell’azione).  
**Silhouette:** compatta, dinamica, immediatamente riconoscibile.

**Dettagli visivi suggeriti (scegline 2–3, non tutti):**
- passamontagna o cappuccio
- zaino/borsone (bottino)
- guanti
- scarpe “da corsa”
- piccolo bagliore o oggetto rubato visibile (es. gemma/lingotto)

**Animazioni minime:**
- `player_run` (loop)
- `player_jump`
- `player_slide`
- `player_dead` (caduta / inciampo / “caught”)

---

### 2.2 Poliziotto — Inseguitore
**Ruolo:** pressione costante + minaccia durante Danger Mode.  
**Silhouette:** più “grande” del ladro, postura in avanti, riconoscibile anche in piccolo.

**Rappresentazione distanza (semplice e leggibile):**
- 2 sprite stati: `police_far`, `police_near`
- oppure 1 sprite + **scala** (più vicino = più grande) + leggera vibrazione

**Animazioni :**
- lampeggiante (luce) sincronizzato con sirena


## 3) Ambientazione & Background

**Setting :** città notturna con:
- marciapiede/strada come “ground”
- edifici con finestre (parallax)
- insegne neon e lampioni
- elementi ripetibili (performance-friendly)

**Parallax:**
- Layer 1: skyline lontano (lento)
- Layer 2: palazzi medi (medio)
- Layer 3: dettagli vicini (più veloce)
- Ground: scorrimento più rapido, costante

**Regola d’oro:** il background non deve competere con ostacoli/coin.
Contrasto più basso e meno saturazione rispetto al gameplay layer.

---

## 4) Ostacoli (readability-first)

### 4.1 Ostacoli bassi (da saltare)
 bidoni, cassette


### 4.2 Ostacoli alti (da scivolare sotto)
    sbarre, ponte basso.


**Regola leggibilità:**
- low obstacle = “spunta dal basso”
- high obstacle = “blocca dall’alto”

---

## 5) Monete / Bonus

**Moneta gialla**: icona brillante e “pulita”, con piccolo outline.
- **colore caldo** (oro) sempre consistente
- animazione loop (rotazione/bounce)
- VFX raccolta: pop + sparkle breve (0.2–0.4s)

---

## 6) UI / HUD (mobile friendly)

### Elementi HUD:
- **Score** (in alto, preferibilmente sinistra o centro)
- **Coin count** (alto destra)
- **Danger indicator** (vicino allo score o centro-alto)

**Tipografia:**
- sans bold, numeri grandi
- outline o shadow per leggibilità

**Layout:**
- margini safe-area
- dimensioni leggibili su schermi piccoli (evitare font troppo sottili)

---

## 7) Danger Mode — Linguaggio visivo

Quando entra Danger Mode (dopo il 1° errore):
- **aloni rossi** ai bordi dello schermo (vignette)
- **lampeggio** leggero (non fastidioso)
- sirena (audio, gestita altrove)
- poliziotto “near” / più grande

Quando finisce Danger Mode:
- aloni rossi svaniscono (fade-out 0.3–0.6s)
- sirena si interrompe
- poliziotto si allontana

**Accessibilità / comfort:**
- evitare flash troppo rapidi
- preferire un **pulse** lento (1–1.5s)

---

## 8) Palette (principi, non colori assoluti)

Non imponiamo HEX precisi: contano i **ruoli cromatici**.

- **Gameplay layer (ostacoli)**: contrasto alto, colori più scuri o più saturi del background
- **Background**: contrasto medio-basso, meno saturazione
- **Coin**: colore caldo e brillante, sempre “top priority”
- **Danger overlay**: rosso/ambra semitrasparente ai bordi
- **Player**: 1 colore dominante + 1 accento (per riconoscibilità)
- **Police**: colori freddi (blu/nero) con accento (badge/luce)

---

## 9) Specifiche asset (consigliate per LÖVE2D)

**Formato:** PNG con trasparenza  
**Scale:** lavorare in pixel art *solo* se tutto il progetto è pixel art; altrimenti sprite puliti + outline.  
**Export:**
- mantenere dimensioni coerenti (player e ostacoli su griglia)
- evitare texture enormi: preferire sprite piccoli e ripetibili

**Naming (consigliato):**
- `player_run.png`, `player_jump.png`, `player_slide.png`, `player_dead.png`
- `police_far.png`, `police_near.png`
- `obstacle_low_01.png`, `obstacle_high_01.png`
- `coin.png`
- `bg_layer_1.png`, `bg_layer_2.png`, `bg_layer_3.png`, `ground.png`
- `ui_hud_panel.png`, `ui_danger_icon.png`

---

## 10) Checklist di coerenza (prima di chiudere una build)

- [ ] Player sempre leggibile sullo sfondo
- [ ] Ostacoli distinguibili in < 0.5s
- [ ] Coin riconoscibile anche durante Danger Mode
- [ ] Danger Mode visivamente inconfondibile
- [ ] UI non copre la zona di gameplay
- [ ] Palette coerente tra menu / game / game over
