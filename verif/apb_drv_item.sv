`ifndef APB_DRV_ITEM_SV
  `define APB_DRV_ITEM_SV

  class apb_drv_item extends apb_base_item;
    
    // Variables
    rand apb_dir dir;
    rand apb_addr addr;
    rand apb_data data;
    rand int unsigned pre_drive_delay;
    rand int unsigned post_drive_delay;
    
    // Constraints
    constraint pre_drive_delay_default_c {
      soft pre_drive_delay <= 5;
    }
    
    constraint post_drive_delay_default_c {
      soft post_drive_delay <= 5;
    }
    
    // UVM macros
    `uvm_object_utils(apb_drv_item)
    
    // Methods
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual function string convert2string();
      string result = $sformatf("dir: %0s, addr: 0x%0x", dir.name(), addr);
      
      if(dir == APB_WRITE) begin
        result = $sformatf("%0s, data: 0x%0x", result, data);
      end
      
      result = $sformatf("%0s, pre_drive_delay: %0d, post_drive_delay: %0d", 
                         result, pre_drive_delay, post_drive_delay);
      
      return result;
    endfunction : convert2string
    
  endclass : apb_drv_item

`endif // APB_DRV_ITEM_SV