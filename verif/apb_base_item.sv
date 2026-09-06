`ifndef APB_BASE_ITEM_SV
  `define APB_BASE_ITEM_SV

  class apb_base_item extends uvm_sequence_item;
    
    // Variables
    rand apb_dir dir;		// Direction
    rand apb_addr addr;		// Address
    rand apb_data data;		// Data
    
    // UVM Macros
    `uvm_object_utils(apb_base_item)
    
    // Constructor
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    // Methods
    virtual function string convert2string();
      string result = $sformatf("dir: %0s, addr: 0x%0x", dir.name(), addr);
      
      if(dir == APB_WRITE) begin
        result = $sformatf("%0s, data: 0x%0x", result, data);
      end
      
      return result;
    endfunction : convert2string
    
  endclass : apb_base_item

`endif // APB_BASE_ITEM_SV