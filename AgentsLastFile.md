# Agents.md — Endless Runner (Lua + LÖVE2D)

Questo documento definisce **l’unico agente AI** responsabile dello sviluppo del progetto **Endless Runner** in **Lua** con il framework **LÖVE2D**.

> Obiettivo: avere una guida operativa unica (ruoli, responsabilità, workflow, standard) per realizzare il gioco in modo coerente col GDD.

---

## 1) Contesto di progetto

- **Titolo provvisorio:** Endless Runner  
- **Genere:** Endless runner 2D side-scroller  
- **Tech:** **Lua + LÖVE2D**  
- **Target:** mobile  
- **Direzione di scorrimento:** destra → sinistra  
- **Aumento velocità:** ogni **30 secondi**  

---

## 2) Pillole di gameplay (core design)

### 2.1 Controlli player
- **Jump**: il giocatore può saltare
- **Slide**: il giocatore può scivolare

### 2.2 Ostacoli
- **Ostacoli bassi** → da **saltare**
- **Ostacoli alti** → da **scivolare sotto**

### 2.3 Sistema errori / poliziotto (Danger Mode)
- Ogni ostacolo colpito = **1 errore**
- **1° errore:** attiva **Danger Mode** per **10 secondi** (il poliziotto si avvicina)
- **2° errore entro 10 secondi:** il poliziotto raggiunge il player → **Game Over**
- Se passano 10 secondi senza ulteriori errori: Danger Mode termina (poliziotto si allontana)

### 2.4 Punteggio e monete
- **+1 punto per ogni metro** percorso  
  - **1 metro = 15 pixel**
- **Moneta gialla**: oggetto bonus, **+100 punti**
  - può ricomparire più volte

### 2.5 Stati del personaggio
- `Running`, `Jumping`, `Sliding`, `Danger Mode`, `Dead`

---

## 3) Agente unico: EndlessRunner-AGENT

### Missione
Coordinare e realizzare l’intero sviluppo di **Endless Runner** ricoprendo tutti i ruoli:
- Project Management
- Game Design
- Tech Lead / Architecture
- Gameplay Programming
- Asset & UI (linee guida testuali)
- QA & Balancing

---

## 4) Responsabilità per ruolo

### 4.1 Project Management (PM)
**Obiettivo:** tenere sotto controllo visione, priorità e avanzamento.

**Task map (feature principali):**
- salto / scivolata
- ostacoli bassi/alti
- poliziotto con Danger Mode (10s)
- aumento velocità ogni 30s
- punteggio distanza + monete
- HUD, menu, game over
- polish (audio, animazioni, particelle)

**Priorità consigliata:**
1. Core loop (correre, spawn ostacoli, jump/slide, game over su collisione)
2. Sistema errori + poliziotto (Danger Mode)
3. Incremento velocità nel tempo
4. Punteggio e monete
5. HUD e schermate (menu, game over)
6. Rifiniture (audio, particelle, animazioni extra)



### 4.2 Game Design
**Obiettivo:** definire in dettaglio gameplay e curva di difficoltà.

**Spawn pattern ostacoli:**
- alternanza low/high
- gruppi ravvicinati
- densità crescente con l’aumento velocità

**Percezione Danger Mode:**
-  feedback visivo (lo schermo ha aloni rossi)
- feedback audio (sirena)
- comportamento a fine timer (spariscono feedback visivo e audio)

**Curva di difficoltà:**
- velocità iniziale
- incremento ogni 30s (lineare)
- eventuale velocità massima (cap)

**Monete:**
- frequenza e posizionamento
- rischio vs ricompensa (vicino a ostacoli / zone pericolose)

**Documento grafica:**
- `graphic.md` (linee guida grafica)

---

### 4.3 Tech Lead (Architettura Lua/LÖVE2D)
**Obiettivo:** mantenere codice pulito, modulare e manutenibile.

**Moduli suggeriti (API minime):**
- `player.lua`
  - stato, movimento, animazioni
  - `load()`, `update(dt)`, `draw()`, `handleInput()`, `onHitObstacle()`
- `police.lua`
  - gestione errori e Danger Mode
  - `reset()`, `update(dt)`, `draw()`, `onFirstError()`, `onSecondErrorWithinWindow()`
- `obstacle_manager.lua`
  - spawn/update/draw ostacoli
- `coin_manager.lua`
  - spawn/update/draw + raccolta
- `difficulty.lua`
  - velocità globale + incremento ogni 30s
- `score.lua`
  - distanza in metri + bonus monete
- `collision.lua`
  - helper collisioni
- `game_state.lua`
  - `menu`, `game`, `gameover`
- `world.lua`
  - scrolling ground + parallax

**Regole chiave di integrazione velocità:**
- la velocità influenza:
  - scorrimento mondo/sfondo
  - velocità ostacoli
  - calcolo distanza: `distance += speed * dt`



### 4.4 Gameplay Programming (Lua + LÖVE2D)
**Obiettivo:** implementare tutta la logica in LÖVE2D.

**Core loop in `main.lua`:**
- `love.load()`
- `love.update(dt)`
- `love.draw()`
- `love.keypressed(key)` (e/o input touch in futuro)

**Input consigliato (desktop):**
- Jump: `space` / `up`
- Slide: `down` / `s`

**Transizioni stato player:**
- `Running → Jumping` (inizio salto)
- `Running → Sliding` (inizio slide)
- ritorno a `Running` a fine salto/slide
- `Running → Danger Mode` quando entra Danger
- `Qualsiasi → Dead` a Game Over

**Logica errori:**
- collisione con ostacolo:
  - se non in Danger: `police.onFirstError()` → avvia Danger (10s)
  - se in Danger: `police.onSecondErrorWithinWindow()` → Game Over

**Reset run:**
- reset velocità, distanza, score, ostacoli, monete, poliziotto, stato player

---

### 4.5 Asset & UI (linee guida testuali)
 Per le linee guida della grafica leggere il file graphic.md

**Asset minimi:**
- player: `run`, `jump`, `slide`, `dead`
- police: `far`, `near` (o scale/varianti)
- ostacoli: `low`, `high`
- coin
- background parallax
- UI: pannelli HUD, icone, font

**Wireframe (testuale)**
- HUD in-game:
  - score (alto sinistra o centro)
  - monete (alto destra)
  - indicatore Danger Mode (icona + barra/lampeggio)
- Menu:
  - titolo
  - Play (+ Quit opzionale)
- Game Over:
  - punteggio finale
  - best score (opzionale)
  - Restart

**Documenti consigliati:**
- `docs/art_bible.md`
- `docs/ui_layouts.md`

---

### 4.6 QA & Balancing
**Obiettivo:** testare logica e parametri (feeling + difficoltà).

**Checklist test:**
- salto: durata/altezza sufficienti per ostacoli bassi
- slide: durata/hitbox coerente per ostacoli alti
- Danger Mode:
  - timer percepibile?
  - feedback chiaro?
  - secondo errore entro finestra = sempre Game Over?
- difficoltà nel tempo:
  - dopo quanti minuti diventa ingestibile?
  - incremento ogni 30s adeguato?
- monete:
  - frequenza soddisfacente?
  - rischio reale nel prenderle?

**Report QA suggeriti:**
- `docs/qa_report_01.md`, `docs/qa_report_02.md`, …
  - bug / edge-case
  - problemi di bilanciamento
  - proposte numeriche (es. “-10% velocità max”)

---

## 5) Struttura progetto raccomandata

```
main.lua
conf.lua
src/
  core/
    game_state.lua
    input.lua
    time.lua
  game/
    player.lua
    police.lua
    obstacle_manager.lua
    coin_manager.lua
    world.lua
    difficulty.lua
    score.lua
    collision.lua
  ui/
    hud.lua
    menu.lua
    gameover.lua
assets/
  images/
  audio/
  fonts/
docs/
  game_brief.md
  feature_roadmap.md
  game_design.md
  technical_design.md
  art_bible.md
  ui_layouts.md
  qa_report_01.md
```

---

## 6) Convenzioni di stile (Lua)

- variabili: `player`, `police`, `isDanger`, `dangerTimer`, `speedMultiplier`
- funzioni: `spawnObstacle()`, `updatePolice()`, `enterDangerMode()`, `resetRun()`
- commenti obbligatori sulle logiche:
  - Danger Mode
  - gestione errori
  - incremento velocità

---

## 7) Regole di collaborazione (utente ↔ agente)

- L’utente parla **solo** con **EndlessRunner-AGENT**
- L’utente può:
  - cambiare parametri globali (velocità, frequenza ostacoli/monete, durata run)
  - dare feedback sul feeling (salto troppo lento, poliziotto poco “minaccioso”)
  - definire priorità feature e accettare una build

L’agente deve:
- restare compatibile con **Lua + LÖVE2D**
- documentare brevemente scelte tecniche e di design
- evitare complessità non richiesta, privilegiando:
  - chiarezza
  - stabilità
  - aderenza al GDD
