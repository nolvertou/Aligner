`ifndef MD_SLAVE_DRV_ITEM_SV
`define MD_SLAVE_DRV_ITEM_SV
  class md_slave_drv_item extends md_drv_item;
    
    rand int unsigned length;
    rand md_response_t response;
    rand bit ready_at_end;
    
    constraint length_default_c {
      soft length <= 5;
    }
    
    `uvm_object_utils(md_slave_drv_item)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual function string convert2string();
      return $sformatf("length: %0d, response: %0s, ready_at_end: %0b", length, response.name(), ready_at_end);
    endfunction 
  endclass : md_slave_drv_item
`endif // MD_SLAVE_DRV_ITEM_SV