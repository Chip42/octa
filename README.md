# octa
A drone synthesizer to experience the sound of 1Hz difference.

## MIDI
Sending note messages with a MIDI device can change the frequency of the oscillators.
When notes are entered at the same time, the frequency is assigned to the oscillators in order from 1 to 8.
The ninth note pressed will be ignored.

## OSC
| Command | Description |
| --- | --- |
| /volume1 | Controls the volume. Specify the target oscillator by changing the number at the end from 1~8. |
| /cemitone | Manipulate the frequency of all oscillators toward the positive and negative directions. |
| /group_a | Operate the volume of oscillators 1~4. |
| /group_b | Operate the volume of oscillators 5~8. |
