`ifndef ALIGNER_ENV_SV
  `define ALIGNER_ENV_SV
  
  class aligner_env extends uvm_env;
    `uvm_component_utils(aligner_env)
    
    apb_agent apb_agt;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      apb_agt = apb_agent::type_id::create("apb_agt", this);
    endfunction : build_phase
    
  endclass : aligner_env

`endif // ALIGNER_ENV_SV