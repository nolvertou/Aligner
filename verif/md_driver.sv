`ifndef MD_DRIVER_SV
`define MD_DRIVER_SV

  class md_driver#(type DRV_ITEM = md_drv_item) extends uvm_driver#(.REQ(DRV_ITEM));
    
    // Handlers
    md_agent_config md_agt_cfg;
    
    // Process for drive_transactions() task
    protected process process_drive_transactions;
    
    `uvm_component_param_utils(md_driver#(DRV_ITEM))
    
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
    
          protected virtual task drive_transaction(DRV_ITEM item);
      `uvm_fatal("ALGORITHM ISSUE", "Implement drive_transaction()") 
    endtask : drive_transaction
    
    virtual function void handle_reset(uvm_phase phase);
      
      if(process_drive_transactions != null) begin
        process_drive_transactions.kill();
        
        process_drive_transactions = null;
      end
    
    endfunction : handle_reset
  
    // Task for waiting the reset end
    virtual task wait_reset_end();
      md_agt_cfg.wait_reset_end();
    endtask : wait_reset_end

  endclass : md_driver

`endif // MD_DRIVER_SV