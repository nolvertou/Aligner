`ifndef APB_TYPES_SV
  `define APB_TYPES_SV

  // Virtual Interface type
  typedef virtual apb_if apb_vif;

  // APB Direction
  typedef enum bit {APB_READ = 0, APB_WRITE = 1} apb_dir;

  // APB Address
  typedef bit [`APB_MAX_ADDR_WIDTH-1:0] apb_addr;
 
  // APB Data
  typedef bit [`APB_MAX_DATA_WIDTH-1:0] apb_data;

  // APB FSM State
  typedef enum bit[1:0] {APB_IDLE, APB_SETUP, APB_ACCESS} apb_fsm_state;

`endif // APB_TYPES_SV