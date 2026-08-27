`ifndef ALIGNER_PKG_SV
  `define ALIGNER_PKG_SV

  `include "uvm_macros.svh"
  `include "apb_pkg.sv"
  
  package aligner_pkg;
    import uvm_pkg::*;
    import apb_pkg::*;

    `include "aligner_env.sv"
  endpackage : aligner_pkg

`endif // ALIGNER_PKG_SV