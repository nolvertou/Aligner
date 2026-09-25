`ifndef MD_DRV_ITEM_SV
`define MD_DRV_ITEM_SV

  class md_drv_item extends md_base_item;
    
    `uvm_object_utils(md_drv_item)
    
    function new(string name = "");
      super.new(name);
    endfunction : new

  endclass : md_drv_item

`endif // MD_DRV_ITEM_SV