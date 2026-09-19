`ifndef ALIGNER_BASE_TEST_SV
  `define ALIGNER_BASE_TEST_SV

  class aligner_base_test extends uvm_test;
    `uvm_component_utils(aligner_base_test)
    
    aligner_env#(`ALIGNER_DATA_WIDTH) env;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      env = aligner_env#(`ALIGNER_DATA_WIDTH)::type_id::create("env", this);
    endfunction : build_phase
    
  endclass : aligner_base_test

`endif // ALIGNER_BASE_TEST_SV