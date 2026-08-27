# Aligner

This repository contains a SystemVerilog RTL implementation of an alignment block and a UVM-based verification environment for exercising it.

## Overview

The design is built around a data-aligner module intended to accept unaligned memory-data transactions, realign them according to a configured offset and size, and then forward the aligned data to a TX interface. The module exposes an APB register interface for configuration and status/interrupt control.

The core RTL is organized in the [src](src) directory, while the simulation and verification scaffolding lives in the [verif](verif) directory.

## Project Structure

```text
Aligner/
├── README.md
├── src/
│   ├── cfs_aligner.v
│   ├── cfs_aligner_core.v
│   ├── cfs_ctrl.v
│   ├── cfs_edge_detect.v
│   ├── cfs_regs.v
│   ├── cfs_rx_ctrl.v
│   ├── cfs_synch.v
│   ├── cfs_synch_fifo.v
│   ├── cfs_tx_ctrl.v
│   └── design.sv
├── verif/
│   ├── aligner_pkg.sv
│   ├── aligner_env.sv
│   ├── aligner_base_test.sv
│   ├── aligner_reg_access_test.sv
│   ├── aligner_test_pkg.sv
│   ├── apb_agent.sv
│   ├── apb_agent_config.sv
│   ├── apb_if.sv
│   ├── apb_pkg.sv
│   ├── apb_types.sv
│   └── testbench.sv
└── .git/
```

## RTL Components

The design is composed of several modules that collectively implement the aligner block:

- [src/cfs_aligner.v](src/cfs_aligner.v): top-level wrapper that connects the core block to a single-clock context
- [src/cfs_aligner_core.v](src/cfs_aligner_core.v): main aligner logic, FIFOs, APB access handling, and IRQ generation
- [src/cfs_ctrl.v](src/cfs_ctrl.v): alignment controller that transforms incoming unaligned data into aligned output
- [src/cfs_regs.v](src/cfs_regs.v): APB register block for CTRL, STATUS, IRQEN, and IRQ behavior
- [src/cfs_synch_fifo.v](src/cfs_synch_fifo.v): synchronized FIFO implementation
- [src/cfs_rx_ctrl.v](src/cfs_rx_ctrl.v): RX-side control logic
- [src/cfs_tx_ctrl.v](src/cfs_tx_ctrl.v): TX-side control logic
- [src/cfs_edge_detect.v](src/cfs_edge_detect.v): edge-detection helper used in interrupt generation
- [src/design.sv](src/design.sv): top-level include file that compiles the RTL hierarchy

## Verification Environment

The verification environment is centered around UVM and is staged under [verif](verif):

- [verif/testbench.sv](verif/testbench.sv): top-level testbench with clock/reset generation, DUT instantiation, and APB interface hookup
- [verif/apb_if.sv](verif/apb_if.sv): APB interface used to connect the testbench to the DUT
- [verif/apb_pkg.sv](verif/apb_pkg.sv): package containing the APB interface and APB agent-related definitions
- [verif/apb_agent_config.sv](verif/apb_agent_config.sv): configuration component used to hold the APB virtual interface
- [verif/apb_agent.sv](verif/apb_agent.sv): APB agent instantiated inside the environment
- [verif/aligner_pkg.sv](verif/aligner_pkg.sv): UVM package for the design environment
- [verif/aligner_env.sv](verif/aligner_env.sv): environment component scaffold with APB agent creation
- [verif/aligner_base_test.sv](verif/aligner_base_test.sv): base UVM test
- [verif/aligner_reg_access_test.sv](verif/aligner_reg_access_test.sv): placeholder test for register access validation
- [verif/aligner_test_pkg.sv](verif/aligner_test_pkg.sv): package that includes the UVM test classes

The APB interface is passed to the agent through `uvm_config_db`, which is the standard UVM mechanism for sharing virtual interface references between testbench components.

## Functional Behavior

The aligner supports:

- configurable data alignment using CTRL.SIZE and CTRL.OFFSET
- RX and TX memory-data handshaking interfaces
- FIFO occupancy and error tracking
- drop counting for invalid access patterns
- interrupt generation for FIFO status changes and max-drop conditions
- APB register access for configuration and status monitoring

The register model described in the RTL comments includes registers such as:

- CTRL
- STATUS
- IRQEN
- IRQ

## Simulation / Build Status

This project is in a RTL + UVM scaffold stage. The APB interface, configuration component, and agent instance are now in place, and the environment is beginning to model a realistic verification hierarchy. The project still needs additional monitor, driver, sequence, and scoreboard development to become a complete verification environment.

## Typical Simulation Flow

A typical simulator flow for this type of project would include:

1. Compile the RTL sources and the verification package
2. Elaborate the top-level testbench
3. Run the UVM test
4. Inspect waveforms and logs

Example pattern for a simulator command line (tool-specific):

```bash
vlog -sv src/*.v verif/*.sv
vsim -c work.testbench -do "run -all; quit"
```

The exact command syntax may vary depending on the simulator being used (e.g. Questa, ModelSim, VCS, or Cadence tools).

## Current Notes

- The RTL appears to be the primary implementation target.
- The UVM environment is intentionally minimal at this stage.
- The design and verification files are organized in a conventional pattern for a SystemVerilog project, but the project still needs a fuller verification architecture for regression testing and coverage.

## Next Recommended Improvements

- add a formal build script or Makefile
- create a deeper verification hierarchy with driver, monitor, sequencer, and scoreboard
- implement a simple APB transaction sequence and test stimulus
- replace the placeholder register-access test with real register-level checks
- document the exact simulator commands for the target toolchain
- add coverage and regression execution steps

## License

No explicit license file is currently present in the repository. If this project is intended for public distribution, add a LICENSE file and update this section accordingly.
