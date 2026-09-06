`ifndef APB_MON_ITEM_SV
`define APB_MON_ITEM_SV

  class apb_mon_item extends apb_base_item;
    
    // Variables
    apb_response_e response;
    int unsigned   length;
    int unsigned   prev_item_delay;
    
    // UVM macros
    `uvm_object_utils(apb_mon_item)
	
    // Constructor
    function new(string name = "");
      super.new(name);
    endfunction : new

    // Methods
    virtual function string convert2string();
      string result = super.convert2string();
      
      if(dir == APB_WRITE) begin
        result = $sformatf("%0s, data: 0x%0x", result, data);
      end
      
      result = $sformatf("%0s, data: 0x%0x, response:%0s, length: %0d, prev_item_delay: %0d", 
                         result, data, response.name(), length, prev_item_delay);
      
      return result;
    endfunction : convert2string
    
  endclass : apb_mon_item

`endif // APB_MON_ITEM_SV