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
      #(105ns);
      
      fork
        // Stimulus with simple_seq
        begin
          apb_simple_sequence simple_seq = apb_simple_sequence::type_id::create("simple_seq");
          void'(simple_seq.randomize() with {
            item.addr == 'h0; // Address 0x000 provides access to the control register
            item.dir == APB_WRITE;
            item.data == 'h11;
          });
          simple_seq.start(env.apb_agt.apb_sqcr);
        end
      	
        // Stimulus with rw_seq
        begin
          apb_rw_sequence rw_seq = apb_rw_sequence::type_id::create("rw_seq");
          void'(rw_seq.randomize() with {
            addr == 'hC; // Address 0xC provides access to the status register
            //wr_data == 'h65;
          });
          rw_seq.start(env.apb_agt.apb_sqcr);
        end
        
	    // Stimulus with random_seq
        begin
          apb_random_sequence random_seq = apb_random_sequence::type_id::create("random_seq");
          void'(random_seq.randomize() with {
            num_items == 3;
          });
          random_seq.start(env.apb_agt.apb_sqcr);
        end
      join
        
      `uvm_info("DEBUG", "End of test", UVM_LOW)
      phase.drop_objection(this, "TEST_DONE");
    endtask : run_phase
  endclass : aligner_reg_access_test

`endif // ALIGNER_REG_ACCESS_TEST_SV