`ifndef MD_SLAVE_AGENT_CONFIG_SV
`define MD_SLAVE_AGENT_CONFIG_SV

  class md_slave_agent_config#(int unsigned DATA_WIDTH) extends md_agent_config#(DATA_WIDTH);
    
    `uvm_component_param_utils(md_slave_agent_config#(DATA_WIDTH))
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
  endclass : md_slave_agent_config
`endif // MD_SLAVE_AGENT_CONFIG_SV