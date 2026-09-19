`ifndef MD_MASTER_AGENT_SV
`define MD_MASTER_AGENT_SV

  class md_master_agent#(int unsigned DATA_WIDTH = 32) extends md_agent#(DATA_WIDTH);
  
    `uvm_component_param_utils(md_master_agent#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      // Override all md_agt_cfg instances under this component md_master_agent
      md_agent_config#(DATA_WIDTH)::type_id::set_inst_override(md_master_agent_config#(DATA_WIDTH)::get_type(), "md_agt_cfg", this);
    endfunction : new

  endclass : md_master_agent

`endif // MD_MASTER_AGENT_SV