`ifndef ALIGNER_ENV_SV
  `define ALIGNER_ENV_SV
  
  class aligner_env#(int unsigned ALIGNER_DATA_WIDTH) extends uvm_env;
    
    // APB Agent handler
    apb_agent apb_agt;
    
    // MD RX Agent handler
    md_master_agent#(ALIGNER_DATA_WIDTH) md_rx_agt;
    
    // MD TX Agent handler
    md_slave_agent#(ALIGNER_DATA_WIDTH) md_tx_agt;
    
    `uvm_component_param_utils(aligner_env#(ALIGNER_DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      apb_agt = apb_agent::type_id::create("apb_agt", this);
      md_rx_agt = md_master_agent#(ALIGNER_DATA_WIDTH)::type_id::create("md_rx_agt", this);
      md_tx_agt = md_slave_agent#(ALIGNER_DATA_WIDTH)::type_id::create("md_tx_agt", this);
      
    endfunction : build_phase
    
  endclass : aligner_env

`endif // ALIGNER_ENV_SV