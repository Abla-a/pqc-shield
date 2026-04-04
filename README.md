# PQC Shield — FPGA-Based Post-Quantum Cryptographic Bridge

**Author:** Abla BENMOUSSA MAHI — Electronics Engineering Student, University of Boumerdes, Algeria  
**Type:** Licence Final Year Project (PFC)  
**Timeline:** April – May 2026  
**Status:** 🔵 In Progress

---

## Overview

The PQC Shield is an FPGA-based hardware bridge designed to retrofit 
legacy IoT devices with quantum-resistant cryptographic security at 
the physical layer. It intercepts device communication and applies 
ML-KEM key encapsulation and AES-256 symmetric encryption, without 
requiring infrastructure replacement.

This project addresses the immediate threat of "Harvest Now, Decrypt 
Later" (HNDL) attacks targeting government and military infrastructure, 
aligned with NIST PQC standards finalized in 2024 (FIPS 203).

---

## Architecture

| Version |          Feature           |      Status    |
|---------|----------------------------|----------------|
|    V1   | AES-256 UART Bridge        | 🔵 In Progress |
|    V2   | ML-KEM Key Encapsulation   | ⚪ Planned     |
|    V3   | PUF Hardware Root of Trust | ⚪ Planned     |

---

## Repository Structure
pqc-shield/
├── docs/
│   ├── abstract/       # Project abstract (LaTeX + PDF)
│   └── diagrams/       # Architecture and block diagrams
├── vhdl/
│   ├── src/            # VHDL source files
│   └── testbench/      # Simulation testbenches
├── report/
│   └── sections/       # LaTeX report sections
└── assets/             # Images, references, misc

---

## Technical Stack

- **Hardware:** Xilinx FPGA (Basys 3 / Nexys A7) 
- **HDL:** VHDL
- **Tools:** Vivado Design Suite, ModelSim
- **Documentation:** LaTeX (Overleaf)
- **Standards:** NIST FIPS 203 (ML-KEM), FIPS 197 (AES-256)

---

## References

- NIST FIPS 203 — ML-KEM Standard (2024)
- NIST IR 8413 — PQC Standardization Report
- Mosca, M. — "Cybersecurity in an Era of Quantum Computers"

---

*This project is part of an ongoing research initiative in hardware 
security and post-quantum cryptography.*
