`ifndef MD_SLAVE_DRIVER_SV
`define MD_SLAVE_DRIVER_SV

  class md_slave_driver#(int unsigned DATA_WIDTH = 32) extends md_driver#(.DRV_ITEM(md_slave_drv_item)) ;
    
    typedef virtual md_if#(DATA_WIDTH) md_vif;
    
    md_slave_agent_config#(DATA_WIDTH) md_agt_cfg;
    
    `uvm_component_param_utils(md_slave_driver#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      
      if(super.md_agt_cfg == null) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("At this point the pointer to md_agt_cfg from %0s should not be null", get_full_name()))
      end
      
      if($cast(md_agt_cfg, super.md_agt_cfg) == 0) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Could not cast %0s to %0s", super.md_agt_cfg.get_full_name(), md_slave_driver#(DATA_WIDTH)::type_id::type_name))
      end
    endfunction : end_of_elaboration_phase
    
    
    
    protected virtual task drive_transaction(md_slave_drv_item item);
      md_vif vif = md_agt_cfg.get_vif();
      
      `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE)
      
      // Valid must be equal to 1
      if(vif.valid !== 1) begin
        `uvm_error("ALGORITHM_ISSUE", $sformatf("Trying to drive a slave item when there is no item started by the master - item: %0s", item.convert2string()))
      end
      
      `uvm_info("DEBUG", $sformatf("Driving ready : %0b", vif.ready), UVM_NONE)
      
      // Initially ready will be drive as low
      vif.ready <= 0;
      
      // Wait for the number of clock cycles according to length field
      for(int i = 0; i < item.length; i++) begin
        @(posedge vif.clk);
      end
      
      // Drive response values
      vif.ready <= 1;
      vif.err	<= bit'(item.response);
      
      @(posedge vif.clk);
      
      // Reset values
      vif.ready <= item.ready_at_end;   // FIXME: Forgot to use here "ready_at_end"
      vif.err 	<= 0;
        
    endtask : drive_transaction
    
    virtual function void handle_reset(uvm_phase phase);
      md_vif vif = md_agt_cfg.get_vif();
      
      super.handle_reset(phase);
      
      `uvm_info("[DEBUG]", "Debug handle_reset", UVM_NONE)
      vif.ready <= md_agt_cfg.get_ready_at_reset();
      vif.err	<= 0;
    endfunction : handle_reset
    
  endclass : md_slave_driver

`endif // MD_SLAVE_DRIVER_SV