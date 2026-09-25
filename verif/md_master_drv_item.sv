`ifndef MD_MASTER_DRV_ITEM_SV
`define MD_MASTER_DRV_ITEM_SV

  class md_master_drv_item extends md_drv_item;
    
    // Pre drive delay
    rand int unsigned pre_drive_delay;
    
    // Post drive delay
    rand int unsigned post_drive_delay;
    
    // Data driven by the master
    rand bit[7:0] data[$];
    
    // Offset of the data
    rand int unsigned offset;
    
    // Constraint
    constraint pre_drive_delay_default_c {
      soft pre_drive_delay <= 5;
    }
    
    constraint post_drive_delay_default_c {
      soft post_drive_delay <= 5;
    }
    
    constraint data_default_c {
      soft data.size() == 1;
    }
    
    constraint data_hard_c {
      data.size() > 0;
    }
    
    constraint offset_default_c {
      soft offset == 0;
    }
    
    `uvm_object_utils(md_master_drv_item)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual function string convert2string();
      string data_as_string = "{";
      
      foreach(data[idx]) begin
        data_as_string = $sformatf("%0s'h%02x%0s", data_as_string, data[idx], idx == data.size() - 1 ? "" : ", " ) ;
      end
      
      data_as_string = $sformatf("%0s}", data_as_string);
      
      return $sformatf("data: %0s, offset: %0d, pre_drive_delay: %0d, post_drive_delay: %0d", data_as_string, offset, pre_drive_delay, post_drive_delay);
    endfunction : covert2string

  endclass : md_master_drv_item

`endif // MD_MASTER_DRV_ITEM_SV