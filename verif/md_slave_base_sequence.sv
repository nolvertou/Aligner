`ifndef MD_SLAVE_BASE_SEQUENCE_SV
`define MD_SLAVE_BASE_SEQUENCE_SV

  class md_slave_base_sequence extends md_base_sequence#(.DRV_ITEM(md_slave_drv_item));
    
    `uvm_declare_p_sequencer(md_slave_base_sequencer)
    `uvm_object_utils(md_slave_base_sequence)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
    
  endclass : md_slave_base_sequence


`endif // MD_SLAVE_BASE_SEQUENCE_SV