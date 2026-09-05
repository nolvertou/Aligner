`ifndef APB_IF_SV
  `define APB_IF_SV

  `ifndef APB_MAX_DATA_WIDTH
    `define APB_MAX_DATA_WIDTH 32
  `endif // APB_MAX_DATA_WIDTH

  `ifndef APB_MAX_ADDR_WIDTH
    `define APB_MAX_ADDR_WIDTH 16
  `endif // APB_MAX_ADDR_WIDTH

  
  interface apb_if(input pclk);
    logic preset_n;
    logic [`APB_MAX_ADDR_WIDTH-1:0] paddr;
    logic pwrite;
    logic psel;
    logic penable;
    logic [`APB_MAX_DATA_WIDTH-1:0] pwdata;
    logic pready;
    logic [`APB_MAX_DATA_WIDTH-1:0] prdata;
    logic pslverr;
    
  endinterface : apb_if
`endif // APB_IF_SV