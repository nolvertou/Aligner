`ifndef MD_PKG_SV
`define MD_PKG_SV

  `include "md_if.sv"  

  package md_pkg;
    import uvm_pkg::*;

    `include "md_types.sv"
    `include "md_agent_config.sv"
	`include "md_slave_agent_config.sv"
    `include "md_master_agent_config.sv"
    `include "md_reset_handler.sv"
 	`include "md_agent.sv"
	`include "md_master_agent.sv"
	`include "md_slave_agent.sv"
	

  endpackage : md_pkg
`endif // MD_PKG_SV