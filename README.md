# Shift-Register-Based Serial Communication System

An 8-bit serial communication system implemented in Verilog HDL using
shift registers, transmitter/receiver modules, and RTL-level control logic.

## Overview

This project implements a serial communication system based on an 8-bit
bidirectional shift register.

The transmitter converts 8-bit parallel data into a serial bit stream,
while the receiver reconstructs the original 8-bit data from the serial input.

The design was developed and simulated using Xilinx ISE.

## System Architecture

The system consists of four main components:

- `rlshift`: 8-bit bidirectional shift register
- `uart_tx`: parallel-to-serial transmitter
- `uart_rx`: serial-to-parallel receiver
- `Top`: top-level system integration

## Features

- 8-bit parallel-to-serial conversion
- 8-bit serial-to-parallel conversion
- Bidirectional shift register
- Synchronous reset and parallel loading
- LSB-first data transmission
- RTL-level simulation
- 50 MHz clock simulation

## Simulation

The design was tested using multiple data patterns:

- `0x55`
- `0xAA`
- `0xFF`
- `0xA5`
- `0x88`

The top-level simulation verified that the received data matched the
transmitted data.

## Project Structure

```text
src/
├── rlshift.v
├── uart_tx.v
├── uart_rx.v
└── Top.v

tb/
├── test_rlshift.v
├── uart_tx_tb.v
├── uart_rx_tb.v
└── Top_sim.v

simulation/
└── waveform screenshots

report/
└── project report
