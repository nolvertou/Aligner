`ifndef ALIGINER_RANDOM_FILL_RX_FIFO_TEST_SV
`define ALIGINER_RANDOM_FILL_RX_FIFO_TEST_SV
  class aligner_random_fill_rx_fifo_test extends aligner_base_test;
    `uvm_component_utils(aligner_random_fill_rx_fifo_test)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this, "TEST_DONE");
      
      #(100ns);
      
      fork
        begin
          md_slave_response_forever_sequence forever_seq = md_slave_response_forever_sequence::type_id::create("forever_seq");
          forever_seq.start(env.md_tx_agt.md_sqcr);
        end
      join_none
      
      repeat(15) begin
        md_master_simple_sequence simple_seq = md_master_simple_sequence::type_id::create("simple_seq");
        
        simple_seq.set_sequencer(env.md_rx_agt.md_sqcr);

        void'(simple_seq.randomize() with{
          simple_seq.item.data.size() 		== env.md_rx_agt.md_sqcr.get_data_width() / 8;
          simple_seq.item.offset 			== 0;
          simple_seq.item.pre_drive_delay 	== 0;
          simple_seq.item.post_drive_delay 	== 0;
        });

        simple_seq.start(env.md_rx_agt.md_sqcr);
      end
      
      #(500ns);
      
      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
      phase.drop_objection(this, "TEST_DONE"); 
    endtask : run_phase
   
  endclass : aligner_random_fill_rx_fifo_test

`endif // ALIGINER_RANDOM_FILL_RX_FIFO_TEST_SV
