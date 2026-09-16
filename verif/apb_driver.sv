`ifndef APB_DRIVER_SV
  `define APB_DRIVER_SV

  class apb_driver extends uvm_driver#(.REQ(apb_drv_item)) implements apb_reset_handler;
    `uvm_component_utils(apb_driver)
    
    // Handlers
    apb_agent_config apb_agt_cfg;
    apb_vif vif;
    
    // Process for drive_transactions() task
    protected process process_drive_transactions;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual task run_phase(uvm_phase phase);
      forever begin
        fork 
          begin
            wait_reset_end();
            drive_transactions();
            disable fork;
          end
        join
      end
    endtask : run_phase
      
    protected virtual task drive_transactions();
      
      fork
        begin
          process_drive_transactions = process::self();
          
          forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
          end
        end
      join
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
    
    virtual function void handle_reset(uvm_phase phase);
      vif = apb_agt_cfg.get_vif();
      
      if(process_drive_transactions != null) begin
        process_drive_transactions.kill();
        
        process_drive_transactions = null;
      end
      
      // Initialize de signals
      vif.psel 		<= 0;
      vif.penable 	<= 0;
      vif.pwrite 	<= 0;
      vif.paddr 	<= 0;
      vif.pwdata 	<= 0;
    endfunction : handle_reset
  
    // Task for waiting the reset end
    virtual task wait_reset_end();
      apb_agt_cfg.wait_reset_end();
    endtask : wait_reset_end
  endclass : apb_driver
`endif // APB_DRIVER_SV