`ifndef ALIGNER_TEST_PKG_SV
  `define ALIGNER_TEST_PKG_SV
  
  `include "uvm_macros.svh"
  `include "aligner_pkg.sv"  

  package aligner_test_pkg;
    import uvm_pkg::*; 
    import aligner_pkg::*;    

    `include "aligner_base_test.sv"
	`include "aligner_reg_access_test.sv"
  endpackage : aligner_test_pkg

`endif // ALIGNER_TEST_PKG_SV