`ifndef MD_BASE_ITEM_SV
`define MD_BASE_ITEM_SV

  class md_base_item extends uvm_sequence_item;
    
    `uvm_object_utils(md_base_item)
    
    function new(string name = "");
      super.new(name);
    endfunction : new

  endclass : md_base_item

`endif // MD_BASE_ITEM_SV