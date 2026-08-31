`ifndef APB_SIMPLE_SEQUENCE_SV
  `define APB_SIMPLE_SEQUENCE_SV

  class apb_simple_sequence extends apb_base_sequence;
    
    rand apb_drv_item item;
    
    `uvm_object_utils(apb_simple_sequence)
    
    function new(string name = "");
      super.new(name);
      item = apb_drv_item::type_id::create("item");
    endfunction : new
    
    virtual task body();
      
      // Sending Item with start/finish methods(Style 1)
      // start_item(item);
      // finish_item(item);
      //////////////////////////////////////////////////
      
      // Sending Item with uvm send macro(Style 1)
      `uvm_send(item);
      
    endtask : body

  endclass : apb_simple_sequence
`endif // APB_SIMPLE_SEQUENCE_SV