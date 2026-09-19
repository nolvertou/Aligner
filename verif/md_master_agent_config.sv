`ifndef MD_MASTER_AGENT_CONFIG_SV
`define MD_MASTER_AGENT_CONFIG_SV

  class md_master_agent_config#(int unsigned DATA_WIDTH) extends md_agent_config#(DATA_WIDTH);
    
    `uvm_component_param_utils(md_master_agent_config#(DATA_WIDTH))
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
  endclass : md_master_agent_config
`endif // MD_MASTER_AGENT_CONFIG_SV