`ifndef MD_SLAVE_SEQUENCER_SV
`define MD_SLAVE_SEQUENCER_SV

  class md_slave_sequencer#(int unsigned DATA_WIDTH) extends md_slave_base_sequencer;
  
    `uvm_component_param_utils(md_slave_sequencer#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function int unsigned get_data_width();
      return DATA_WIDTH;
    endfunction : get_data_width
    
  endclass : md_slave_sequencer
`endif // MD_SLAVE_SEQUENCER_SV