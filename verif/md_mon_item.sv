`ifndef MD_MON_ITEM_SV
`define MD_MON_ITEM_SV

  class md_mon_item extends md_base_item;
    
    // Number of clock cycles from the previous item
    int unsigned prev_item_delay;
    
    // Length, in clock cycles, of the MD transfer
    int unsigned length;
    
    // Data monitored by the time
    bit [7:0] data[$];
    
    // Offset of the data
    int unsigned offset;
    
    // Response
    md_response_t response;
    
    `uvm_object_utils(md_mon_item)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual function string convert2string();
      string data_as_string = "{";
      
      foreach(data[idx]) begin
        data_as_string = $sformatf("%0s'h%02x%0s", data_as_string, data[idx], (idx == data.size() - 1) ? "" : ", " ) ;
      end
      
      data_as_string = $sformatf("%0s}", data_as_string);
      
      return $sformatf("[%0t..%0s] data: %0s, offset: %0d, response: %0s, length: %0d, prev_item_delay: %0d", 
                       get_begin_time(), 
                       is_active() ? "" : $sformatf("%0t", get_end_time()),
                       data_as_string, offset, response.name(), length, prev_item_delay);
    endfunction : convert2string

  endclass : md_mon_item

`endif // MD_MON_ITEM_SV