`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV
  class apb_monitor extends uvm_monitor implements apb_reset_handler;
    // Handlers
    apb_agent_config apb_agt_cfg;
    
    // TLM ports
    uvm_analysis_port#(apb_mon_item) output_put;
    
    // Process for collect_transactions() task
    protected process process_collect_transactions;
    
    // UVM macros
    `uvm_component_utils(apb_monitor)
    
    // Constructor
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      output_put = new("output_put", this);
    endfunction : new
    
    virtual task run_phase(uvm_phase phase);
      forever begin
        fork 
          begin
            wait_reset_end();
        	collect_transactions();
            disable fork;
          end
      	join 
      end
    endtask : run_phase
    
    protected virtual task collect_transactions();
      fork 
        begin
          forever begin
            process_collect_transactions = process::self();
            collect_transaction();
          end
        end
      join
    endtask : collect_transactions
          
    // Function to handle the reset
    virtual function void handle_reset(uvm_phase phase);
      if(process_collect_transactions != null) begin
        process_collect_transactions.kill();
        
        process_collect_transactions = null;
      end
    endfunction 
    
    protected virtual task collect_transaction();
      apb_vif vif = apb_agt_cfg.get_vif();
      apb_mon_item item = apb_mon_item::type_id::create("item");
      
      // Counting time befor setup phase
      while(vif.psel !== 1) begin : prev_delay_count
        @(posedge vif.pclk);
        item.prev_item_delay++;
      end
      
      // Sampling info in setup phase
      item.addr = vif.paddr;
      item.dir  = apb_dir'(vif.pwrite);
      
      if(item.dir === APB_WRITE) begin
        item.data = vif.pwdata;
      end
      item.length = 1; // At this time it would be in clock cycle length 1
      /////////////////////
       
      // Counting time in acces phase
      @(posedge vif.pclk); 
      item.length++;
      
      while(vif.pready !== 1) begin
        @(posedge vif.pclk);
        item.length++;
        
        if(apb_agt_cfg.get_has_checks()) begin
          if(item.length >=  apb_agt_cfg.get_stuck_threshold()) begin
            `uvm_error("PROTOCOL_ERROR", $sformatf("The APB transfer reached the stuck threshold of %0d clock cycles", item.length ))
          end
        end
      end
      
      item.response = apb_response_e'(vif.pslverr);
      
      if(item.dir === APB_READ) begin
        item.data = vif.prdata;
      end
      
      output_put.write(item);
      `uvm_info("DEBUG", $sformatf("Monitored item: %0s", item.convert2string()), UVM_NONE);
      
      @(posedge vif.pclk);
      
    endtask : collect_transaction
          
    
    // Task for waiting the reset end
    virtual task wait_reset_end();
      apb_agt_cfg.wait_reset_end();
    endtask : wait_reset_end

  endclass : apb_monitor

`endif // APB_MONITOR_SV