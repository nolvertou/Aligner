`ifndef APB_AGENT_SV
  `define APB_AGENT_SV
  
  class apb_agent extends uvm_agent;
    
    // Handlers
    apb_agent_config 	apb_agt_cfg;
    apb_sequencer 		apb_sqcr;
    apb_driver 			apb_drv;
    
    // UVM macros
    `uvm_component_utils(apb_agent)
    
    // Constructor
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    // UVM Phases
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      apb_agt_cfg = apb_agent_config::type_id::create("apb_agt_cfg", this);
      
      if(apb_agt_cfg.get_active_passive() == UVM_ACTIVE) begin
        apb_sqcr = apb_sequencer::type_id::create("apb_sqcr", this);
        apb_drv  = apb_driver::type_id::create("apb_driver", this);
      end
    endfunction : build_phase
    
    virtual function void connect_phase(uvm_phase phase);
      apb_vif vif;
      
      super.connect_phase(phase);
      
      if(!uvm_config_db#(apb_vif)::get(this, "", "vif", vif)) begin
        `uvm_fatal("APB_NO_VIF", "Could not get from the database the APB virtual interface")
      end
      else begin
        apb_agt_cfg.set_vif(vif);
      end
      
      if(apb_agt_cfg.get_active_passive() == UVM_ACTIVE) begin
        apb_drv.apb_agt_cfg = apb_agt_cfg;
        apb_drv.seq_item_port.connect(apb_sqcr.seq_item_export);
      end
    endfunction : connect_phase
      
  endclass : apb_agent

`endif // APB_AGENT_SV