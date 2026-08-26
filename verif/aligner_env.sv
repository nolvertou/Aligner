`ifndef ALIGNER_ENV_SV
  `define ALIGNER_ENV_SV
  
  class aligner_env extends uvm_env;
    `uvm_component_utils(aligner_env)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
  endclass : aligner_env

`endif // ALIGNER_ENV_SV