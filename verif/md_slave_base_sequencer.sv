`ifndef MD_SLAVE_BASE_SEQUENCER_SV
`define MD_SLAVE_BASE_SEQUENCER_SV

  class md_slave_base_sequencer extends md_base_sequencer#(.DRV_ITEM(md_slave_drv_item));
    
    // Port for receiving items from the monitor
    uvm_analysis_imp#(md_mon_item, md_slave_base_sequencer) port_from_mon;
    
    // FIFO containing the pending item(s) on the bus
    uvm_tlm_fifo#(md_mon_item) pending_items;
    
    `uvm_component_utils(md_slave_base_sequencer)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      port_from_mon = new("port_from_mon", this);
      
      // MD protocol is not allowing to start a new item, while previous one did not yet finished,
      // So, for that reason, pending_items fifo need one element size
      pending_items = new("pending_items", this, 1);
    endfunction : new
    
    virtual function void write(md_mon_item item);
      if(item.is_active()) begin
        if(pending_items.is_full()) begin
          `uvm_fatal("ALGORITH_ISSUE", $sformatf("FIFO %0s is full (size: %0d) - a possible cause is that there is no sequence started which pulls information from this FIFO", pending_items.get_full_name(), pending_items.size()))
        end
        
        if(pending_items.try_put(item) == 0) begin
          `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Failed to push a new item in the FIFO %0s", pending_items.get_full_name()))
        end
      end
      
    endfunction : write
    
    virtual function void handle_reset(uvm_phase phase);
      super.handle_reset(phase);
      
      pending_items.flush();
    endfunction : handle_reset
  
  endclass : md_slave_base_sequencer

`endif // MD_SLAVE_BASE_SEQUENCER_SV