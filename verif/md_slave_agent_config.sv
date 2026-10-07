`ifndef MD_SLAVE_AGENT_CONFIG_SV
`define MD_SLAVE_AGENT_CONFIG_SV

  class md_slave_agent_config#(int unsigned DATA_WIDTH = 32) extends md_agent_config#(DATA_WIDTH);
    
    // Value of the "ready" signal at reset
    local bit ready_at_reset;
  
    `uvm_component_param_utils(md_slave_agent_config#(DATA_WIDTH))
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      ready_at_reset = 1;
    endfunction : new
    
    virtual function void set_ready_at_reset(bit value);
      ready_at_reset = value;
    endfunction : set_ready_at_reset
    
    virtual function bit get_ready_at_reset();
      return ready_at_reset;
    endfunction : get_ready_at_reset
    
  endclass : md_slave_agent_config
`endif // MD_SLAVE_AGENT_CONFIG_SV