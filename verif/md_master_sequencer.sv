`ifndef MD_MASTER_SEQUENCER_SV
`define MD_MASTER_SEQUENCER_SV

  class md_master_sequencer#(int unsigned DATA_WIDTH) extends md_sequencer#(.DRV_ITEM(md_master_drv_item));
  
    `uvm_component_param_utils(md_master_sequencer#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function int unsigned get_data_width();
      return DATA_WIDTH;
    endfunction : get_data_width
    
  endclass : md_master_sequencer
`endif // MD_MASTER_SEQUENCER_SV