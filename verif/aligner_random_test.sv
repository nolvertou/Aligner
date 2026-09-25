`ifndef ALIGNER_RANDOM_TEST_SV
`define ALIGNER_RANDOM_TEST_SV
  class aligner_random_test extends aligner_base_test;
    `uvm_component_utils(aligner_random_test)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this, "TEST_DONE");
      
      #(100ns);
      
      repeat(4) begin
        md_master_simple_sequence simple_seq = md_master_simple_sequence::type_id::create("simple_seq");
        
        simple_seq.set_sequencer(env.md_rx_agt.md_sqcr);

        void'(simple_seq.randomize());

        simple_seq.start(env.md_rx_agt.md_sqcr);
      end
      
      #(100ns);
      
      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
      phase.drop_objection(this, "TEST_DONE"); 
    endtask : run_phase
   
  endclass : aligner_random_test

`endif // ALIGNER_RANDOM_TEST_SV
