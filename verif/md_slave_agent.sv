`ifndef MD_SLAVE_AGENT_SV
`define MD_SLAVE_AGENT_SV

  class md_slave_agent#(int unsigned DATA_WIDTH = 32) extends md_agent#(DATA_WIDTH, md_slave_drv_item);
  
    `uvm_component_param_utils(md_slave_agent#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      // Override all md_agt_cfg instances under this component md_slave_agent
      md_agent_config#(DATA_WIDTH)::type_id::set_inst_override(md_slave_agent_config#(DATA_WIDTH)::get_type(), "md_agt_cfg", this);
      md_base_sequencer#(md_slave_drv_item)::type_id::set_inst_override(md_slave_sequencer#(DATA_WIDTH)::get_type(), "md_sqcr", this);
      md_driver#(md_slave_drv_item)::type_id::set_inst_override(md_slave_driver#(DATA_WIDTH)::get_type(), "md_drv", this);
    endfunction : new
    
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      connect_port_from_mon_to_slave_sequencer();
    endfunction : connect_phase
      
    protected virtual function void connect_port_from_mon_to_slave_sequencer();
      if(md_agt_cfg.get_active_passive() == UVM_ACTIVE) begin
        md_slave_sequencer#(DATA_WIDTH) md_sqcr;
        
        if($cast(md_sqcr, super.md_sqcr) == 0) begin
          `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Could not cast %0s to %0s", super.md_sqcr.get_full_name(), md_slave_sequencer#(DATA_WIDTH)::type_id::type_name))
        end
        
        md_mon.output_put.connect(md_sqcr.port_from_mon);
      end
    endfunction : connect_port_from_mon_to_slave_sequencer

  endclass : md_slave_agent

`endif // MD_SLAVE_AGENT_SV