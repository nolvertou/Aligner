/* 
 * File: 			testbench.sv
 * Author: 			Nolverto Urias Obeso
 * Date: 			08/25/2026
 * Description:		UVM Testbench to validate aligner dut
 */

`include "aligner_test_pkg.sv"
module testbench();
  
  import uvm_pkg::*;
  import aligner_test_pkg::*;
  
  reg clk;		// Clock
  reg rst_n; 	// Reset active low 
  
  initial begin : clock_generator
    clk = 0;
    
    forever begin
      clk = #5ns ~clk;
    end
  end
  
  initial begin : reset_generator
    rst_n = 1;
    #6ns;
    rst_n = 0;
    #30ns;
    rst_n = 1;
  end
  
  // Instantiate aligner module
  cfs_aligner dut(
    .clk	(clk),
    .reset_n(rst_n)
  );
  
  initial begin : start_uvm_test
    run_test("");
  end

  // We have to use $dumpfile and $dumpvars to be able to see the waveforms
  initial begin : dump_vcd
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
  
  
  
  