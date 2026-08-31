`ifndef APB_BASE_SEQUENCE_SV
  `define APB_BASE_SEQUENCE_SV

  class apb_base_sequence extends uvm_sequence#(.REQ(apb_drv_item));
    
    `uvm_declare_p_sequencer(apb_sequencer)
    `uvm_object_utils(apb_base_sequence)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
  
  endclass : apb_base_sequence

`endif // APB_BASE_SEQUENCE_SV