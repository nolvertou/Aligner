`ifndef MD_MASTER_BASE_SEQUENCER_SV
`define MD_MASTER_BASE_SEQUENCER_SV

  class md_master_base_sequencer extends md_base_sequencer#(.DRV_ITEM(md_master_drv_item));
    `uvm_component_utils(md_master_base_sequencer)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
  endclass : md_master_base_sequencer
`endif // MD_MASTER_BASE_SEQUENCER_SV