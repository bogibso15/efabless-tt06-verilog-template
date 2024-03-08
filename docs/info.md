<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a basic implementation of AES-128 Encrypt, able to run either a single encryption, or in Output Feedback mode. The Input Vector is all 0's and the Key is determined by the 4 least significant IO switches in a 1-hot encoding (or none). The most significant input switch controls if it will run a single encryption (low) or semi-continuously in output feedback mode for 2 Million sequential encryptions. If running a single encryption, the 7 segment display will show an X if the encryption output does not match the expected output, and a O if it does.

## How to test

Set the MSB of the input to 0 to use single encryption, and look for an O on the 7-segment display.

## External hardware

None.
