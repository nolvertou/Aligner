`ifndef MD_MONITOR_SV
`define MD_MONITOR_SV

  class md_monitor#(int unsigned DATA_WIDTH = 32) extends uvm_monitor implements md_reset_handler;
    
    typedef virtual md_if#(DATA_WIDTH) md_vif;
    
    // Handlers
    md_agent_config md_agt_cfg;
    
    // TLM ports
    uvm_analysis_port#(md_mon_item) output_put;
    
    // Process for collect_transactions() task
    protected process process_collect_transactions;
  
    `uvm_component_param_utils(md_monitor#(DATA_WIDTH))
    
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
          process_collect_transactions = process::self();
          forever begin 
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
      md_vif vif = md_agt_cfg.get_vif();
      
      int unsigned data_width_in_bytes = DATA_WIDTH / 8;
      
      md_mon_item item = md_mon_item::type_id::create("item");
      
      // Wait some delay to start monitoring
      #(md_agt_cfg.get_sample_delay_start_tr());
      
      // Calculate previous delay
      while(vif.valid !== 1) begin
        @(posedge vif.clk);
      	
        item.prev_item_delay++; // Increment delay value
        
        #(md_agt_cfg.get_sample_delay_start_tr());
      end  
      
      // Here is detected the start of transaction
      
      item.offset = vif.offset;
      
      // Collect data in data queue
      for( int i = 0; i < vif.size; i++) begin 
        item.data.push_back((vif.data >> ((item.offset + i) * 8)) & 8'hFF);
      end
      
      item.length = 1;
      
      // Sets the begin time to the current simulation time
      void'(begin_tr(item));
      
      output_put.write(item);
      
      @(posedge vif.clk);
      
      // Calculate length
      while(vif.ready !== 1) begin
        @(posedge vif.clk);
        item.length++;
      end
      
      // Here the item ended, and collect response information
      item.response = md_response_t'(vif.err);
      
      // Sets end time value
      end_tr(item);
      
      output_put.write(item);
      
      `uvm_info("DEBUG", $sformatf("Monitored item: %0s", item.convert2string()), UVM_NONE)
      
    endtask : collect_transaction
              
    // Task for waiting the reset end
    virtual task wait_reset_end();
      md_agt_cfg.wait_reset_end();
    endtask : wait_reset_end

  endclass : md_monitor

`endif // MD_MONITOR_SV