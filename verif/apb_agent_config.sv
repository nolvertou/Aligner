`ifndef APB_AGENT_CONFIG_SV
  `define APB_AGENT_CONFIG_SV

  class apb_agent_config extends uvm_component;
    `uvm_component_utils(apb_agent_config)
    
    local apb_vif vif;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual function apb_vif get_vif();
      return vif;
    endfunction : get_vif
    
    virtual function void set_vif(apb_vif value);
      if(vif == null) begin
        vif = value; 
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
      end
    endfunction : set_vif
    
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      
      if(get_vif() == null) begin
        `uvm_fatal("ALGORITHM_ISSUE", "The APB virtual interface is not configured at \"Start of simulation\" phase")
      end
      else begin
        `uvm_info("APB_CONFIG", "The APB virtual interface is configured at \"Start of simulation\" phase", UVM_LOW)
      end
    endfunction : start_of_simulation_phase
  
  endclass : apb_agent_config

`endif // APB_AGENT_CONFIG_SV