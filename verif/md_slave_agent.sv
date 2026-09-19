`ifndef MD_SLAVE_AGENT_SV
`define MD_SLAVE_AGENT_SV

  class md_slave_agent#(int unsigned DATA_WIDTH = 32) extends md_agent#(DATA_WIDTH);
  
    `uvm_component_param_utils(md_slave_agent#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      // Override all md_agt_cfg instances under this component md_slave_agent
      md_agent_config#(DATA_WIDTH)::type_id::set_inst_override(md_slave_agent_config#(DATA_WIDTH)::get_type(), "md_agt_cfg", this);
    endfunction : new

  endclass : md_slave_agent

`endif // MD_SLAVE_AGENT_SV