`ifndef APB_BASE_ITEM_SV
  `define APB_BASE_ITEM_SV

  class apb_base_item extends uvm_sequence_item;
    `uvm_object_utils(apb_base_item)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
  
  endclass : apb_base_item

`endif // APB_BASE_ITEM_SV