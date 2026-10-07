`ifndef MD_BASE_SEQUENCE_SV
`define MD_BASE_SEQUENCE_SV

  class md_base_sequence#(type DRV_ITEM = md_drv_item) extends uvm_sequence#(.REQ(DRV_ITEM));
    
    `uvm_object_param_utils(md_base_sequence#(DRV_ITEM))
    
    function new(string name = "");
      super.new(name);
    endfunction : new
  endclass : md_base_sequence
`endif // MD_BASE_SEQUENCE_SV