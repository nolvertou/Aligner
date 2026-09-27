`ifndef MD_MASTER_DRIVER
`define MD_MASTER_DRIVER

  class md_master_driver#(int unsigned DATA_WIDTH = 32) extends md_driver#(.DRV_ITEM(md_master_drv_item));
  
    typedef virtual md_if#(DATA_WIDTH) md_vif;
    
    `uvm_component_param_utils(md_master_driver#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    protected virtual task drive_transaction(md_master_drv_item item);
      md_vif vif = md_agt_cfg.get_vif();
      int unsigned data_width_in_bytes = (DATA_WIDTH / 8);
      
      `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE)
      
      if((item.offset + item.data.size()) > data_width_in_bytes) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Trying to drive an item with offset %0d and %0d bytes but the width of the data bus, in bytes, is %0d", item.data.size(), item.offset, data_width_in_bytes))
      end
      
      for(int i = 0; i < item.pre_drive_delay; i++) begin : pre_drive_delay_generation
        @(posedge vif.clk);
      end
      
      vif.valid <= 1;
      
      // // Pack data bytes into the bus at the specified offset.
      begin 
        bit[DATA_WIDTH-1:0] data = 0;
        
        foreach(item.data[idx]) begin
          bit[DATA_WIDTH-1:0] temp;
          
          temp= item.data[idx] << ((item.offset + idx) * 8);
          
          data = data | temp;
        end
        vif.data 	<= data;
      end
      
      vif.offset 	<= item.offset;
      vif.size 		<= item.data.size();
      
      @(posedge vif.clk);
      
      
      while(vif.ready !== 1 ) begin
        @(posedge vif.clk);
      end
      
      vif.valid  <= 0;
      vif.data   <= 0;
      vif.offset <= 0;
      vif.size   <= 0;
      
      for(int i = 0; i < item.post_drive_delay; i++) begin
        @(posedge vif.clk);
      end
      
    endtask : drive_transaction
    
    virtual function void handle_reset(uvm_phase phase);
      md_vif vif = md_agt_cfg.get_vif();
      
      super.handle_reset(phase);
      
      // Reset the values
      vif.valid 	<= 0;
      vif.data 		<= 0;
      vif.offset 	<= 0;
      vif.size 		<= 0;
      
    endfunction : handle_reset

  endclass : md_master_driver




`endif // MD_MASTER_DRIVER