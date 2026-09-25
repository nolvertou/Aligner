`ifndef MD_SEQUENCER_SV
`define MD_SEQUENCER_SV

  class md_sequencer#(type DRV_ITEM = md_drv_item) extends uvm_sequencer#(.REQ(DRV_ITEM)) implements md_reset_handler;
  
    `uvm_component_param_utils(md_sequencer#(DRV_ITEM))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function void handle_reset(uvm_phase phase);
      int objections_count;
        
      stop_sequences();
      
      objections_count = uvm_test_done.get_objection_count(this);
      
      `uvm_info("RESET_OBJECTION", $sformatf("Found %0d objections before reset", objections_count), UVM_LOW)
      
      if(objections_count > 0) begin
        uvm_test_done.drop_objection(this, $sformatf("Dropping %0d objections at reset", objections_count), objections_count);
      end
      
      start_phase_sequence(phase);
      
    endfunction : handle_reset
    
    virtual function int unsigned get_data_width();
      `uvm_fatal("ALGORITHM ISSUE", "Implement get_data_width()")
    endfunction : get_data_width
    
  endclass : md_sequencer

`endif // MD_SEQUENCER_SV