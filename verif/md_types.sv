`ifndef MD_TYPES_SV
`define MD_TYPES_SV
  
  //typedef virtual md_if#(.DATA_WIDTH(32)) md_vif;
  typedef enum bit {MD_OKAY = 0, MD_ERR = 1} md_response_t;

`endif // MD_TYPES_SV