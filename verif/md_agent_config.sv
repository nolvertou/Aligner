`ifndef MD_AGENT_CONFIG_SV
`define MD_AGENT_CONFIG_SV

  class md_agent_config#(int unsigned DATA_WIDTH = 32) extends uvm_component;
    
    typedef virtual md_if#(DATA_WIDTH) md_vif;
    
    // Virtual Interface
    local md_vif vif;
    
    // UVM Active/Passive Control
    local uvm_active_passive_enum active_passive;
    
    // Switch to enable the checks
    local bit has_checks; // Checks are enabled by default
    
    // Number of clock cycles after which an APB transfer is consider suck and an error is triggered
    local int unsigned stuck_threshold;
    
    // Switch to enable coverage
    local bit has_coverage;
    
    `uvm_component_param_utils(md_agent_config#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      active_passive = UVM_ACTIVE; 	// Default value
      has_checks = 1;				// Checks are enabled by default
      stuck_threshold = 1000;	  	// Default is 1000 cycles
      has_coverage = 1;			   	// Coverage is enabled by default
    endfunction : new
    
    // Run phase
    virtual task run_phase(uvm_phase phase);
      forever begin
        @(vif.has_checks); // Look for changes on the has_checks field from virtual interface

        // vif.has_checks and this.has_checks must be equal and should it not be changed directly in vif
        if(vif.has_checks != get_has_checks()) begin
          `uvm_error("ALGORITHM_ISSUE", $sformatf("Can not change \' has_checks\' from MD interface directly - use %0s.set_has_checks()", get_full_name()))
        end
      end
    endtask : run_phase
    
    // Getters / Setters
    // GET/SET for the MD Virtual Interface
    virtual function md_vif get_vif();
      return vif;
    endfunction : get_vif
    
    virtual function void set_vif(md_vif value);
      if(vif == null) begin
        vif = value; 
        
        // Synchronization to update the has_checks value
        set_has_checks(get_has_checks());
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the MD virtual interface more than once")
      end
    endfunction : set_vif
    
    // GET/SET for the MD Active/Passivev control
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
    
    // Task for waiting the reset to start
    virtual task wait_reset_start();
      if(vif.reset_n !== 0) begin
        // If reset_n is not exactly 0, wait for reset to become active
        @(negedge vif.reset_n);
      end
    endtask : wait_reset_start
    
    
    // Task for waiting the reset end
    virtual task wait_reset_end();
      while(vif.reset_n === 0) begin
        @(posedge vif.clk);
      end
    endtask : wait_reset_end

  endclass : md_agent_config
`endif // MD_AGENT_CONFIG_SV
