`ifndef MD_MASTER_BASE_SEQUENCE_SV
`define MD_MASTER_BASE_SEQUENCE_SV

  class md_master_base_sequence extends md_base_sequence#(.DRV_ITEM(md_master_drv_item));
    
    `uvm_declare_p_sequencer(md_master_base_sequencer)
    `uvm_object_utils(md_master_base_sequence)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
  
  endclass : md_master_base_sequence

`endif // MD_MASTER_BASE_SEQUENCE_SV