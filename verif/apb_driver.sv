`ifndef APB_DRIVER_SV
  `define APB_DRIVER_SV

  class apb_driver extends uvm_driver#(.REQ(apb_drv_item));
    `uvm_component_utils(apb_driver)
    
    apb_agent_config apb_agt_cfg;
    apb_vif vif;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual task run_phase(uvm_phase phase);
      drive_transactions();
    endtask : run_phase
      
    protected virtual task drive_transactions();
      vif = apb_agt_cfg.get_vif();
      
      // Initialize de signals
      vif.psel 		<= 0;
      vif.penable 	<= 0;
      vif.pwrite 	<= 0;
      vif.paddr 	<= 0;
      vif.pwdata 	<= 0;
      
      forever begin
        seq_item_port.get_next_item(req);
        drive_transaction(req);
        seq_item_port.item_done();
      end
    endtask : drive_transactions
    
    protected virtual task drive_transaction(apb_drv_item item);
      
      `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %s", req.get_full_name(), req.convert2string()), UVM_NONE)
      
      for(int i = 0; i < req.pre_drive_delay; i++) begin: pre_drive_delay_generation
        @(posedge vif.pclk);
      end
    
      begin : setup_phase
        vif.psel <= 1;
        vif.pwrite <= bit'(req.dir);
        vif.paddr <= req.addr;
      
        if(req.dir == APB_WRITE)begin
          vif.pwdata <= req.data;
        end
      
        // Wait one cycle for the setup phase
        @(posedge vif.pclk);
      end
    
      begin : access_phase
        vif.penable <= 1;
      
        // Wait one cycle in the access phase
        @(posedge vif.pclk);
      end
    
    
      begin : wait_ready
        // Wait for pready to know that that apb transfer ended.
        while(vif.pready !== 1) begin
          @(posedge vif.pclk);
        end
      end
    
      begin : reset_signals
        vif.psel 	<= 0;
        vif.penable <= 0;
        vif.pwrite	<= 0;
        vif.paddr 	<= 0;
        vif.pwdata	<= 0;
      end
    
      for(int i = 0; i < req.post_drive_delay; i++) begin: post_drive_delay_generation
        @(posedge vif.pclk);
      end
  
    endtask : drive_transaction
    
    
  endclass : apb_driver
`endif // APB_DRIVER_SV