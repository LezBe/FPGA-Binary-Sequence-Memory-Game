# Project Verification & Hardware Status

## Module-Level Verification

According to the final project presentation, the core modules were individually exercised in ModelSim.

| Module / subsystem | Verified behavior |
|---|---|
| ButtonShaper | Single pulse for short and held button presses |
| Decoder_4to7 | Hex inputs mapped to seven-segment patterns |
| LoadRegister | Stored value remains stable until next load |
| DigitTimer | Reconfiguration, decrement, borrow, timeout |
| PRNG / LFSR | Pseudo-random sequence behavior |
| ID_check / PW_Auth | ID/password collection and comparison |
| AccessController | Two-stage authentication and player routing |
| ScoreTracker | Personal-best and global-best updates |

## Hardware Bring-Up

### Working
- authentication
- logged-in indication
- difficulty selection
- countdown timer
- player display
- start/load interaction

### Open issue

The random sequence was not successfully routed to the intended seven-segment display at game start.

Potential causes identified by the team:
- LFSR enable/control path
- top-level signal routing
- seven-segment sequence output wiring
- pin assignments
- Quartus synthesis warnings

## Portfolio Interpretation

The most accurate description of the completed project is:

> A modular FPGA binary-memory-game architecture verified at the module level in ModelSim, with authentication and timing successfully demonstrated on DE0-CV hardware and a remaining top-level sequence-display integration issue.
