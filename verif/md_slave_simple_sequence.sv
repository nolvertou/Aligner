`ifndef MD_SLAVE_SIMPLE_SEQUENCE_SV
`define MD_SLAVE_SIMPLE_SEQUENCE_SV

  class md_slave_simple_sequence extends md_slave_base_sequence;
    
    // Item to drive
    rand md_slave_drv_item item;
    
    `uvm_object_utils(md_slave_simple_sequence)
    
    function new(string name = "");
      super.new(name);
      
      item = md_slave_drv_item::type_id::create("item");
    endfunction : new
    
    virtual task body();
      `uvm_send(item)
    endtask : body
    
  endclass : md_slave_simple_sequence

`endif // MD_SLAVE_SIMPLE_SEQUENCE_SV