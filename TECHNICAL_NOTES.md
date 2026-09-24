# Technical Notes

These notes document implementation details visible in the archived final RTL and Quartus project.

## Top-Level Module

```text
FinalProject_FPGABoard
```

Primary top-level input groups:

```text
Level[1:0]      difficulty selection
Pswd[3:0]       ID/password digit input
Plyr1[3:0]      player game input
PswdEnter_B     authentication submit
Start_B         game start
Load_B          player answer submit
Logout_B        logout
clk             50 MHz board clock
rst             active-low reset
```

Primary outputs drive five seven-segment functions and four status LEDs.

## GameController Sequence Depth

The integrated source currently declares:

```verilog
reg [3:0] Sequence [0:7];
```

Therefore the integrated game controller stores eight 4-bit random values during the memorization phase.

This is distinct from the 15-state PRNG cycle discussed in the final presentation. The PRNG's state/cycle length and the number of values retained for one gameplay round are separate concepts.

## GameController State Machine

```text
INIT
MEMORIZE
RCFG_TIMER
WAIT_START
START_RELEASE
GAMEPLAY
GUESS_RELEASE
SUBMIT_SCORE
GAMEOVER
```

During `MEMORIZE`, `RNG_In` is sampled on the one-second timeout pulse. During `GAMEPLAY`, the player's 4-bit switch value is compared against the stored sequence entry. Correct values increment `playerScore`.

At the end of the round, `scoreReady` is asserted until `CompleteScoreTracker` returns `isValid`.

## LFSR Implementation

The archived integrated module is `LFSR16_8016`. It stores a 16-bit LFSR state and derives a 4-bit game value with:

```verilog
assign Rand = {LFSR[14], LFSR[11], LFSR[7], LFSR[2]};
```

This should be distinguished from earlier/conceptual project documentation describing a standalone 4-bit maximal-length LFSR.

## Authentication Storage

`ID_check` and `PW_Auth` each collect four 4-bit entries using `StackRegister16`.

The stored authentication values are provided by Intel-generated single-port ROM blocks:

```text
ID_ROM
PW_ROM
```

Initialization data is retained in `src/ID_initval.hex` and `src/PW_initval.hex`.

## Score Tracker

`ScoreTracker` clears its RAM address range after reset, then waits for a `scoreReady` transaction. It reads the player's stored score, updates a personal best when exceeded, tracks a global best, and asserts `isValid` to complete the handshake.

## ButtonShaper

The board buttons are active-low. The state flow is:

```text
WAIT
  -> PRESSED  (one-cycle button_out)
  -> HOLD
  -> WAIT
```

## Countdown

`TwoDigitTimer` combines a one-second timing path with two digit timers. Implemented level settings are:

```text
00 -> 99
01 -> 66
10 -> 33
11 -> 11
```

## Quartus Project

Target family: **Cyclone V**

Target device: **5CEBA4F23C7**

The cleaned repository keeps the Quartus project/configuration and Intel-generated ROM/RAM wrappers while excluding build databases and compilation outputs.

## Final Hardware Status

The final presentation documents successful hardware operation for authentication, level selection, timer display, player display, and game-start timing.

The random sequence display remained unresolved at final submission. The team's proposed debug path focused on top-level routing, RNG enable behavior, RNG-to-decoder signal tracing, sequence HEX pin mapping, and Quartus warnings.
