`ifndef APB_AGENT_CONFIG_SV
  `define APB_AGENT_CONFIG_SV

  class apb_agent_config extends uvm_component;
    `uvm_component_utils(apb_agent_config)
    
    // Properties
    // Virtual Interface
    local apb_vif vif;
    
    // UVM Active/Passive Control
    local uvm_active_passive_enum active_passive;
    
    // Switch to enable the checks
    local bit has_checks; // Checks are enabled by default
    
    // Number of clock cycles after which an APB transfer is consider suck and an error is triggered
    local int unsigned stuck_threshold;
    
    // Switch to enable coverage
    local bit has_coverage;
    
    // Constructor
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      active_passive = UVM_ACTIVE; // Default value
      has_checks = 1;
      stuck_threshold = 1000;	   // Default is 1000 cycles
      has_coverage = 1;			   // Coverage is enabled by default
    endfunction : new
    
    // Getters / Setters
    // GET/SET for the APB Virtual Interface
    virtual function apb_vif get_vif();
      return vif;
    endfunction : get_vif
    
    virtual function void set_vif(apb_vif value);
      if(vif == null) begin
        vif = value; 
        
        // Synchronization to update the has_checks value
        set_has_checks(get_has_checks());
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
      end
    endfunction : set_vif
    
    // GET/SET for the APB Active/Passivev control
    virtual function uvm_active_passive_enum get_active_passive();
      return active_passive;
    endfunction : get_active_passive
    
    virtual function void set_active_passive(uvm_active_passive_enum value);
      active_passive = value;
    endfunction : set_active_passive
    
    // GET/SET for has_checks
    virtual function bit get_has_checks();
      return has_checks;
    endfunction : get_has_checks

    virtual function void set_has_checks(bit value);
      has_checks = value;

      if(vif != null) begin
        vif.has_checks = has_checks;
      end
    endfunction : set_has_checks
    
    // GET/SET for stuck_threshold
    virtual function int unsigned get_stuck_threshold();
      return stuck_threshold;
    endfunction : get_stuck_threshold
    
    virtual function void set_stuck_threshold(bit value);
      stuck_threshold = value;
    endfunction : set_stuck_threshold
    
    // GET/SET for has_coverage
    virtual function bit get_has_coverage();
      return has_coverage;
    endfunction : get_has_coverage

    virtual function void set_has_coverage(bit value);
      has_coverage = value;
    endfunction : set_has_coverage

    // UVM Phases
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      
      if(get_vif() == null) begin
        `uvm_fatal("ALGORITHM_ISSUE", "The APB virtual interface is not configured at \"Start of simulation\" phase")
      end
      else begin
        `uvm_info("APB_CONFIG", "The APB virtual interface is configured at \"Start of simulation\" phase", UVM_LOW)
      end
    endfunction : start_of_simulation_phase
    
    // Run phase
    virtual task run_phase(uvm_phase phase);
      forever begin
        @(vif.has_checks); // Look for changes on the has_checks field from virtual interface

        // vif.has_checks and this.has_checks must be equal and should it not be changed directly in vif
        if(vif.has_checks != get_has_checks()) begin
          `uvm_error("ALGORITHM_ISSUE", $sformatf("Can not change \' has_checks\' from APB interface directly - use %0s.set_has_checks()", get_full_name()))
        end
      end
    endtask : run_phase
  
  
  
  endclass : apb_agent_config

`endif // APB_AGENT_CONFIG_SV