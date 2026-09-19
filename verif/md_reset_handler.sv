`ifndef MD_RESET_HANDLER_SV
`define MD_RESET_HANDLER_SV

  interface class md_reset_handler;
    
    // Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);
  endclass : md_reset_handler

`endif // MD_RESET_HANDLER_SV