`ifndef APB_AGENT_SV
  `define APB_AGENT_SV
  
  class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)
    
    apb_agent_config apb_cfg;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      apb_cfg = apb_agent_config::type_id::create("apb_cfg", this);
    endfunction : build_phase
    
    virtual function void connect_phase(uvm_phase phase);
      apb_vif vif;
      
      super.connect_phase(phase);
      
      if(!uvm_config_db#(apb_vif)::get(this, "", "vif", vif)) begin
        `uvm_fatal("APB_NO_VIF", "Could not get from the database the APB virtual interface")
      end
      else begin
        apb_cfg.set_vif(vif);
      end
      
    endfunction : connect_phase
      
  endclass : apb_agent

`endif // APB_AGENT_SV