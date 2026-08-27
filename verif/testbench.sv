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
  
  // Instance of the APB interface
  apb_if apb_if(.pclk(clk));
  
  initial begin : clock_generator
    clk = 0;
    
    forever begin
      clk = #5ns ~clk;
    end
  end
  
  initial begin : reset_generator
    apb_if.preset_n = 1;
    #6ns;
    apb_if.preset_n = 0;
    #30ns;
    apb_if.preset_n = 1;
  end
  
  // Instantiate aligner module
  cfs_aligner dut(
    .clk	(clk),
    .reset_n(apb_if.preset_n),
    .paddr(apb_if.paddr),
    .pwrite(apb_if.pwrite),
    .psel(apb_if.psel),
    .penable(apb_if.penable),
    .pwdata(apb_if.pwdata),
    .pready(apb_if.pready),
    .prdata(apb_if.prdata),
    .pslverr(apb_if.pslverr)
  );
  
  initial begin : start_uvm_test
    
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.apb_agt", "vif", apb_if);
    
    run_test("");
  end

  // We have to use $dumpfile and $dumpvars to be able to see the waveforms
  initial begin : dump_vcd
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
  
  
  
  