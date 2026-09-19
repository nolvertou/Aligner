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
  
  // Instance of the MD RX interface
  md_if#(.DATA_WIDTH(`ALIGNER_DATA_WIDTH)) md_rx_if(.clk(clk));
  
  // Instance of the MD TX interface
  md_if#(.DATA_WIDTH(`ALIGNER_DATA_WIDTH)) md_tx_if(.clk(clk));
  
  // Assign reset signal
  assign md_rx_if.reset_n = apb_if.preset_n;
  assign md_tx_if.reset_n = apb_if.preset_n;
  
  initial begin : clock_generator
    clk = 0;
    
    forever begin
      clk = #5ns ~clk;
    end
  end
  
  initial begin : reset_generator
    apb_if.preset_n = 1;
    #3ns;
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
    .pslverr(apb_if.pslverr),
    
    // MD RX interface
    .md_rx_valid  (md_rx_if.valid),
    .md_rx_data   (md_rx_if.data),
    .md_rx_offset (md_rx_if.offset),
    .md_rx_size   (md_rx_if.size),
    .md_rx_ready  (md_rx_if.ready),
    .md_rx_err    (md_rx_if.err),
    
    // MD TX interface
    .md_tx_valid  (md_tx_if.valid),
    .md_tx_data   (md_tx_if.data),
    .md_tx_offset (md_tx_if.offset),
    .md_tx_size   (md_tx_if.size),
    .md_tx_ready  (md_tx_if.ready),
    .md_tx_err    (md_tx_if.err)
  );
  
  initial begin : start_uvm_test
    // Put these interfaces in the database
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.apb_agt", "vif", apb_if);
    uvm_config_db#(virtual md_if#(.DATA_WIDTH(`ALIGNER_DATA_WIDTH)))::set(null, "uvm_test_top.env.md_rx_agt", "vif", md_rx_if);
    uvm_config_db#(virtual md_if#(.DATA_WIDTH(`ALIGNER_DATA_WIDTH)))::set(null, "uvm_test_top.env.md_tx_agt", "vif", md_tx_if);
    
    run_test("");
  end

  // We have to use $dumpfile and $dumpvars to be able to see the waveforms
  initial begin : dump_vcd
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
  
  
  
  