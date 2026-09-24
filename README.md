# FPGA Binary Number Sequence Memory Game

Single-player **binary sequence memory game** implemented in **Verilog HDL** for the **Terasic DE0-CV / Intel Cyclone V FPGA**. The design combines multi-stage user authentication, pseudo-random sequence generation, configurable countdown timing, score tracking in on-chip RAM, finite-state-machine control, and seven-segment/LED feedback.

This project was developed for **ECE 5440 – Advanced Digital Design** at the University of Houston by **Team F.P.G.A. Board**.

## Project Overview

The player authenticates with an ID and password, observes a generated sequence of 4-bit values, and then attempts to replay the sequence using FPGA switches before the countdown timer expires.

```text
Authenticate
    |
    v
Observe generated values
    |
    v
Replay values with switches
    |
    v
Score + personal/global best tracking
```

The project was developed as a modular RTL system and verified extensively in ModelSim before hardware bring-up on the DE0-CV.

## Final Project Status

### Verified in simulation

The final project documentation reports module-level verification for the major subsystems, including:

- button pulse shaping
- hexadecimal seven-segment decoding
- load/register behavior
- countdown timing and borrow propagation
- pseudo-random value generation
- ID/password authentication
- access-control integration
- score tracking and personal/global best logic

### Verified on the DE0-CV

During final board bring-up, the following functions operated on hardware:

- ID + password authentication
- logged-in / logged-out status LEDs
- difficulty selection
- countdown timer loading and display
- player ID/input display
- game/start button interaction

### Remaining integration issue

The final hardware demo did **not** fully display the generated number sequence at game start. The project documentation identifies the remaining issue as a top-level integration/debug problem involving the RNG enable/display path, routing, or seven-segment pin assignment.

This repository therefore presents the project as a **module-verified FPGA design with partial top-level hardware bring-up**, rather than claiming a fully completed board implementation.

## FPGA Platform

| Item | Implementation |
|---|---|
| Development board | Terasic DE0-CV |
| FPGA family | Intel Cyclone V |
| Device | `5CEBA4F23C7` |
| HDL | Verilog |
| System clock | 50 MHz |
| Synthesis | Intel Quartus Prime |
| Simulation | ModelSim |
| Top-level RTL | `FinalProject_FPGABoard.v` |

## System Architecture

The final RTL is organized into four major cooperating paths:

### Authentication

```text
Switches
   |
ButtonShaper
   |
   +--> ID_check --> ID_ROM
   |
   +--> PW_Auth  --> PW_ROM
              |
              v
       AccessController
```

The game remains gated until authentication succeeds.

### Game Control

`GameController.v` contains the main game FSM. Its principal states include:

```text
INIT
  -> MEMORIZE
  -> RCFG_TIMER
  -> WAIT_START
  -> START_RELEASE
  -> GAMEPLAY
  -> GUESS_RELEASE
  -> SUBMIT_SCORE
  -> GAMEOVER
```

The controller coordinates sequence capture, player guesses, countdown control, scoring, and the score-tracker handshake.

### Timing and Display

The timer is built hierarchically from lower-level timing and digit modules. Two digit timers provide the visible countdown, while seven-segment decoders drive the board displays.

Difficulty settings implemented in the RTL are:

| `Level` | Countdown |
|---|---:|
| `00` | 99 s |
| `01` | 66 s |
| `10` | 33 s |
| `11` | 11 s |

### Score Memory

`CompleteScoreTracker.v` combines the score-tracking FSM with Intel on-chip RAM.

The score subsystem:

- stores a personal best for each indexed player
- compares the current score against the stored personal best
- tracks a global best score
- raises personal/global record flags
- handshakes with `GameController` through `scoreReady` / `isValid`

## Pseudo-Random Sequence Generation

The archived implementation uses `LFSR16_8016.v`, a **16-bit LFSR-based generator**. Four selected LFSR bits are exposed as the game's 4-bit random value:

```verilog
assign Rand = {LFSR[14], LFSR[11], LFSR[7], LFSR[2]};
```

`GameController.v` samples these values once per second during the memorization phase and stores **8 four-bit values**:

```verilog
reg [3:0] Sequence [0:7];
```

The final presentation describes the design concept as a 4-bit pseudo-random sequence generator with a 15-value nonzero sequence. The source archive represents the later integrated implementation and is used as the primary technical reference in this repository.

## Authentication

The authentication subsystem uses separate FSMs for ID and password entry.

### `ID_check.v`

- captures four 4-bit entries into a 16-bit shift register
- walks through stored ID ROM entries
- reports an ID match and player index

### `PW_Auth.v`

- captures four 4-bit password digits
- reads the password associated with the matched player
- compares the entered password with ROM data
- allows up to three password attempts
- drives logged-in / logged-out status

### ROM initialization

The project includes:

```text
ID_initval.hex
PW_initval.hex
```

These are retained so the authentication memories can be rebuilt with the Quartus project.

## Button Conditioning

Mechanical board buttons are active-low and can remain asserted for many 50 MHz clock cycles.

`ButtonShaper.v` converts a press into a single-cycle control pulse using a three-state FSM:

```text
WAIT -> PRESSED -> HOLD -> WAIT
```

This prevents one physical press from being interpreted as repeated game actions.

## Repository Structure

```text
.
├── README.md
├── TECHNICAL_NOTES.md
├── .gitignore
├── src/
│   ├── FinalProject_FPGABoard.v
│   ├── GameController.v
│   ├── AccessController.v
│   ├── ID_check.v
│   ├── PW_Auth.v
│   ├── ButtonShaper.v
│   ├── LFSR16_8016.v
│   ├── CompleteScoreTracker.v
│   ├── ScoreTracker.v
│   ├── StackReg.v
│   ├── LoadRegister.v
│   ├── TwoDigitTimer.v
│   ├── Digit_Timer.v
│   ├── Decoder_4to7.v
│   ├── timing / counter modules
│   ├── ID_initval.hex
│   └── PW_initval.hex
├── quartus/
│   ├── FinalProject_FPGABoard.qpf
│   ├── FinalProject_FPGABoard.qsf
│   ├── ID_ROM.*
│   ├── PW_ROM.*
│   └── RAM_ScoreTracker.*
├── docs/
│   ├── Final_Project_Presentation.pptx
│   ├── PROJECT_ARCHITECTURE.md
│   └── PROJECT_STATUS.md
└── images/
    ├── system_architecture.png
    └── accesscontrol_fsm.svg
```

Generated Quartus compilation databases and output files are intentionally excluded.

## Pin Mapping

The included `.qsf` contains the DE0-CV pin assignments for:

- 50 MHz clock
- reset
- password/ID switches
- player-input switches
- difficulty switches
- password enter / game start / player load / logout buttons
- logged-in and logged-out LEDs
- personal/global best LEDs
- timer, level, RNG, and player seven-segment outputs

## Skills Demonstrated

Verilog HDL · FPGA Development · RTL Design · Finite-State Machines · Digital System Integration · LFSR · ROM/RAM · On-Chip Memory · Authentication Logic · Clock Division · Counters · Seven-Segment Displays · ModelSim · Quartus Prime · Hardware Bring-Up · FPGA Debugging

## Team

**Team F.P.G.A. Board**

Leziga Beage · Luke Dvorak · Jonathan Gaucin · Claire Lewis · Mohammed Mohiuddin

## Portfolio

This repository is intended to be referenced from:

**[Leziga_Portfolio](https://github.com/LezBe/Leziga_Portfolio)**