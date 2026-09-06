`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV
  class apb_monitor extends uvm_monitor;
    // Handlers
    apb_agent_config apb_agt_cfg;
    
    // TLM ports
    uvm_analysis_port#(apb_mon_item) output_put;
    
    // UVM macros
    `uvm_component_utils(apb_monitor)
    
    // Constructor
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      output_put = new("output_put", this);
    endfunction : new
    
    virtual task run_phase(uvm_phase phase);
      collect_transactions();
    endtask : run_phase
    
    protected virtual task collect_transactions();
      forever begin
        collect_transaction();
      end
    endtask : collect_transactions
    
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
      end
      
      item.response = apb_response_e'(vif.pslverr);
      
      if(item.dir === APB_READ) begin
        item.data = vif.prdata;
      end
      
      output_put.write(item);
      `uvm_info("DEBUG", $sformatf("Monitored item: %0s", item.convert2string()), UVM_NONE);
      
      
      @(posedge vif.pclk);
      
    endtask : collect_transaction
  endclass : apb_monitor

`endif // APB_MONITOR_SV