# Project Architecture

## Top-Level Flow

```text
                       +----------------------+
Switches + buttons --->| ButtonShaper modules |
                       +----------+-----------+
                                  |
             +--------------------+--------------------+
             |                                         |
             v                                         v
+---------------------------+                +----------------------+
| Authentication subsystem  |                | GameController FSM   |
| ID_check / ID_ROM         |--------------->| sequence + gameplay  |
| PW_Auth / PW_ROM          |  AuthSignal    | scoring handshake    |
| AccessController          |                +----+------------+----+
+---------------------------+                     |            |
                                                  |            |
                                      +-----------+            +-------------+
                                      v                                      v
                             +------------------+                   +------------------+
                             | TwoDigitTimer    |                   | LFSR16_8016      |
                             | 99/66/33/11 sec  |                   | 4-bit game value |
                             +------------------+                   +------------------+
                                      |
                                      v
                             Seven-segment display

                                       Game score
                                           |
                                           v
                                +------------------------+
                                | CompleteScoreTracker   |
                                | ScoreTracker + RAM     |
                                +------------------------+
```

## Source Modules

### Control / integration
- `FinalProject_FPGABoard.v`
- `GameController.v`
- `AccessController.v`

### Authentication
- `ID_check.v`
- `PW_Auth.v`
- `StackReg.v`
- Intel-generated `ID_ROM`
- Intel-generated `PW_ROM`

### Game / data path
- `LFSR16_8016.v`
- `LoadRegister.v`

### Timing
- `TwoDigitTimer.v`
- `Digit_Timer.v`
- `OneSecTimer.v`
- `OneHundredMilSecTimer.v`
- `OneMilSec.v`
- `countTo10.v`
- `countTo100.v`

### Display / I/O
- `ButtonShaper.v`
- `Decoder_4to7.v`

### Score tracking
- `CompleteScoreTracker.v`
- `ScoreTracker.v`
- Intel-generated `RAM_ScoreTracker`

## Design Philosophy

The project follows a modular FSM/datapath approach. Authentication, game control, timing, random-value generation, display decoding, and score storage are isolated into separate RTL blocks and then integrated at the top level.

That modularity made it possible to verify the majority of the design independently in ModelSim even though the final board-level sequence-display path still required debugging.
