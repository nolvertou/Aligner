`ifndef APB_RESET_HANDLER_SV
`define APB_RESET_HANDLER_SV

  interface class apb_reset_handler;
  
    // Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);

  endclass : apb_reset_handler
`endif // APB_RESET_HANDLER_SV