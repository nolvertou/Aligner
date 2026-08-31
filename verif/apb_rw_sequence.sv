`ifndef APB_RW_SEQUENCE_SV
  `define APB_RW_SEQUENCE_SV

  class apb_rw_sequence extends apb_base_sequence;
    
    // Attributes
    rand apb_addr addr;
    rand apb_data wr_data;
  
    // UVM macros
    `uvm_object_utils(apb_rw_sequence)
    
    // Constructor
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual task body();
      apb_drv_item item;
      
      `uvm_do_with(item, {
        dir  == APB_READ;
        addr == local::addr;
      })
      
      `uvm_do_with(item, {
        dir  == APB_WRITE;
        addr == local::addr;
        data == wr_data;
      })
      
    endtask : body
    
  endclass : apb_rw_sequence
  
`endif // APB_RW_SEQUENCE_SV