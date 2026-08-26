`ifndef ALIGNER_REG_ACCESS_TEST_SV
  `define ALIGNER_REG_ACCESS_TEST_SV

  class aligner_reg_access_test extends aligner_base_test;
    `uvm_component_utils(aligner_reg_access_test)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this, "TEST_DONE");
      `uvm_info("DEBUG", "Start of test", UVM_LOW)
      #100ns;
      `uvm_info("DEBUG", "End of test", UVM_LOW)
      phase.drop_objection(this, "TEST_DONE");
    endtask : run_phase
  endclass : aligner_reg_access_test

`endif // ALIGNER_REG_ACCESS_TEST_SV