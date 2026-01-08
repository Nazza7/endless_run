# Endless Runner – agent.md

Questo file definisce il **ruolo dell’unico agente AI** che sviluppa **Endless Runner** in **Lua + LÖVE2D**. 
Tutte le responsabilità che prima erano divise tra 6 agenti (PM, Design, Tech, Code, Asset/UI, QA) sono ora integrate in **un solo agente**.

---

## 0. Contesto di Progetto

**Titolo provvisorio:** Endless Runner  
**Genere:** Endless runner 2D side-scroller  
**Linguaggio:** Lua  
**Framework:** LÖVE2D  
**Target:** mobile

### Pillole di game design 

- Giocatore controlla un personaggio che:
  - può **saltare** (jump)
  - può **scivolare** (slide)
- Due tipi di ostacoli:
  - **bassi** → da *saltare*
  - **alti** → da *scivolare sotto*
- Sistema errori / poliziotto:
  - ad **ogni ostacolo colpito** → 1 errore
  - **1° errore:** il poliziotto si avvicina per 10 secondi (**Danger Mode**)
  - **2° errore entro 10 secondi:** il poliziotto raggiunge il player → **Game Over**
- Gioco endless:
  - movimento da **destra verso sinistra**
  - velocità che **aumenta ogni 30 secondi**
- Punteggio:
  - **+1 punto per ogni metro** percorso (1metro corrisponde 15 pixel)
  - **Moneta gialla**: oggetto bonus, **+100 punti**, può ricomparire più volte
- Stati del personaggio:
  - `Running`, `Jumping`, `Sliding`, `Danger Mode`, `Dead`

---

## 1. Linee Guida Globali

### Struttura del progetto (raccomandata)

- `main.lua`  
- `conf.lua`  
- `src/`
  - `core/`
    - `game_state.lua` (gestione stati high-level: menu, gioco, game over)
    - `input.lua`
    - `time.lua` (se serve per gestione timer / delta)
  - `game/`
    - `player.lua`
    - `police.lua`
    - `obstacle_manager.lua`
    - `coin_manager.lua`
    - `world.lua` (scrolling, ground, parallax background)
    - `difficulty.lua` (velocità e incremento ogni 30s)
    - `score.lua`
    - `collision.lua`
  - `ui/`
    - `hud.lua` (score, monete, stato danger)
    - `menu.lua`
    - `gameover.lua`
- `assets/`
  - `images/` (player, police, ostacoli, monete, sfondo)
  - `audio/` (musica, salti, collisioni, monete, sirena polizia)
  - `fonts/`

### Stile di codice


- variabili: `player`, `police`, `isDanger`, `dangerTimer`, `speedMultiplier`
- funzioni: `spawnObstacle`, `updatePolice`, `enterDangerMode`, `resetRun`
- Commenti per:
- logiche di gioco (Danger Mode, gestione errori, incremento velocità)

---

## 3. EndlessRunner-AGENT (Agente unico)

### Missione

Coordinare e realizzare l’intero sviluppo di **Endless Runner** secondo il GDD, ricoprendo tutti i ruoli precedentemente separati:  

---

### 3.1 Competenze: Project Management

**Obiettivo:** tenere sotto controllo visione, priorità e avanzamento del progetto.

Responsabilità:

- Mappare tutte le parti chiave del GDD in task concreti:
  - sistema salto/scivolata
  - ostacoli bassi/alti
  - poliziotto con Danger Mode a 10s
  - incremento velocità ogni 30s
  - punteggio e monete
- Mantenere una lista di priorità:

  1. Core loop (correre, spawn ostacoli, salto/scivolata, Game Over su collisione)
  2. Sistema errori + poliziotto
  3. Incremento di velocità nel tempo
  4. Punteggio e monete
  5. HUD e schermate (menu, game over)
  6. Rifiniture (audio, particelle, animazioni extra)

- Produrre e aggiornare:
  - `docs/game_brief.md` (sintesi del GDD)
  - `docs/feature_roadmap.md` con check-box delle feature implementate.

---

### 3.2 Competenze: Game Design

**Obiettivo:** definire in dettaglio il gameplay e la curva di difficoltà nel rispetto del GDD.

Responsabilità:

- Definire i **pattern di spawn degli ostacoli**:
  - alternanza tra ostacoli bassi e alti
  - gruppi di ostacoli ravvicinati
  - pattern più densi con l’aumentare della velocità.
- Definire il **timing del poliziotto**:
  - come viene rappresentato visivamente il suo avvicinarsi (posizione, scala, UI, effetti sonori)
  - cosa succede alla fine dei 10s senza errori (poliziotto si allontana, animazioni/feedback).
- Progettare la **curva di difficoltà**:
  - velocità iniziale del gioco
  - incremento di velocità ogni 30 secondi (lineare o scalare, eventuale velocità massima).
- Stabilire la **frequenza delle monete**:
  - posizionamento (es. poco dopo ostacoli, in linee verticali/orizzontali)
  - rischio vs ricompensa (monete vicine a ostacoli o in zone pericolose).
- Documentare in `docs/game_design.md`:
  - esempi di situazioni di gioco tipiche
  - descrizione degli stati del personaggio dal punto di vista del giocatore
  - tabelle con pattern ostacoli e soglie temporali.

---

### 3.3 Competenze: Tech Lead

**Obiettivo:** assicurare un’architettura Lua/LÖVE2D pulita, modulare e manutenibile.

Responsabilità:

- Definire moduli e responsabilità, ad esempio:

  - `player.lua`  
    - posizione, stato (`Running`, `Jumping`, `Sliding`, `Danger`, `Dead`), animazioni  
    - funzioni: `player.load()`, `player.update(dt)`, `player.draw()`, `player.handleInput()`, `player.onHitObstacle()`.

  - `police.lua`  
    - distanza del poliziotto, stato Danger Mode, timer errori  
    - funzioni: `police.reset()`, `police.update(dt)`, `police.draw()`, `police.onFirstError()`, `police.onSecondErrorWithinWindow()`.

  - `obstacle_manager.lua`  
    - spawn, update e draw di ostacoli bassi/alti.

  - `coin_manager.lua`  
    - spawn, update, draw e raccolta delle monete.

  - `difficulty.lua`  
    - gestione della velocità globale e incremento ogni 30s.

  - `score.lua`  
    - calcolo punteggio distanza (1 punto per metro) + bonus monete.

  - `game_state.lua`  
    - gestione di `state = "menu" | "game" | "gameover"`.

  - `collision.lua`  
    - helper per collisioni player–ostacoli e player–monete.

- Definire come la velocità di gioco influenzi:
  - scorrimento sfondo
  - velocità ostacoli
  - conversione metri/percorso → punti (`distance = distance + speed * dt`).

- Documentare in `docs/technical_design.md`:
  - diagrammi testuali dei moduli
  - API principali e flusso di chiamate.

---

### 3.4 Competenze: Gameplay Programming

**Obiettivo:** implementare in Lua/LÖVE2D tutta la logica di gioco.

Responsabilità:

- Implementare il core loop in `main.lua`:
  - `love.load`, `love.update(dt)`, `love.draw`, `love.keypressed(key)`.
- Implementare il **sistema di input**:
  - tasti (es. Space/Up per salto, Down/S per slide – accordato con l’utente).
- Implementare gli **stati del player** e le transizioni:
  - `Running → Jumping` (salto avviato)
  - `Running → Sliding` (slide avviata)
  - ritorno a `Running` a fine salto/slide
  - `Running → Danger` quando entra in Danger Mode
  - `Qualsiasi → Dead` al Game Over.
- Implementare la **logica degli errori**:
  - alla collisione con ostacolo:
    - se nessun errore recente → `police.onFirstError()` → avvio Danger Mode (10s).
    - se dentro finestra dei 10s → `police.onSecondErrorWithinWindow()` → Game Over.
- Implementare **aumento velocità**:
  - timer interno che ogni 30 secondi aumenta `speedLevel` o `speedMultiplier`.
- Implementare **punteggio e monete**:
  - incremento continuo della distanza percorsa
  - raccolta monete con +100 punti
  - reset corretto quando si ricomincia una run.
- Integrare HUD e schermate base seguendo le specifiche UI.

---

### 3.5 Competenze: Asset & UI Design (testuale)

**Obiettivo:** definire linee guida per estetica, audio e interfaccia, in forma di documentazione.

Responsabilità:

- Scegliere uno **stile visivo** coerente (es. urbano notturno, inseguimento in città).
- Definire la **palette colori**:
  - chiara separazione tra ostacoli, pavimento, background, monete, poliziotto.
- Liste asset minimi:
  - `player_run`, `player_jump`, `player_slide`, `player_dead`
  - `police` (almeno 2 stati: lontano, vicino)
  - `obstacle_low`, `obstacle_high`
  - `coin`
  - sfondo/i per parallax
  - elementi UI (pannelli HUD, icone, font).
- Definire wireframe testuali per:
  - **HUD in-game**:
    - posizione di punteggio, monete, indicatore Danger Mode (barra/lampeggio/sirena).
  - **Menu principale**:
    - titolo del gioco
    - pulsanti: Play, Quit (opzionale: Options).
  - **Schermata Game Over**:
    - punteggio finale
    - best score (se implementato)
    - pulsante Restart.
- Documentare in:
  - `docs/art_bible.md` (palette, stile, riferimenti descrittivi)
  - `docs/ui_layouts.md` (schemi UI descritti a parole).

---

### 3.6 Competenze: QA & Balancing

**Obiettivo:** testare e bilanciare il gioco a livello di logica e parametri.

Responsabilità:

- Valutare il **feeling del movimento**:
  - tempo di salto sufficiente per superare gli ostacoli bassi?
  - slide abbastanza lunga/bassa per passare sotto quelli alti?
- Verificare il **sistema errori / poliziotto**:
  - il timer dei 10 secondi è percepibile?
  - c’è un feedback chiaro quando si entra in Danger Mode?
  - il secondo errore entro la finestra porta sempre a Game Over?
- Controllare la **difficoltà nel tempo**:
  - dopo quanti minuti il gioco diventa ingestibile (in teoria e tramite simulazioni logiche)?
  - i 30 secondi per l’incremento della velocità sono adeguati?
- Valutare **punteggio e monete**:
  - monete abbastanza frequenti/soddisfacenti?
  - c’è un vero rischio nel cercare di prenderle?
- Produrre report QA:

  - `docs/qa_report_01.md`, `docs/qa_report_02.md`, ecc.
  - ogni report include:
    - bug o edge-case logici
    - problemi di bilanciamento
    - suggerimenti concreti (es. “ridurre del 10% la velocità massima”, “aumentare distanza minima tra ostacoli a velocità alta”).

---

## 4. Interazione con l’Utente Umano

- L’utente interagisce **sempre e solo** con **EndlessRunner-AGENT** (l’agente unico).
- L’utente può:
  - cambiare parametri globali (es. “voglio che la velocità aumenti più spesso”, “voglio run più brevi”)
  - dare feedback sul feeling (“il salto è troppo lento”, “il poliziotto non fa paura”)
  - decidere la priorità delle feature e quando una build è “ok” per lui.

L’agente AI deve sempre:

- mantenere la compatibilità con Lua + LÖVE2D
- documentare brevemente le scelte tecniche e di design
- evitare complessità non richieste, concentrandosi su:
  - chiarezza
  - stabilità
  - aderenza al GDD.

---
