`ifndef MD_AGENT_SV
`define MD_AGENT_SV
  class md_agent#(int unsigned DATA_WIDTH = 32) extends uvm_agent implements md_reset_handler;
    
    typedef virtual md_if#(DATA_WIDTH) md_vif;
    
    // Agent Configuration handler
    md_agent_config#(DATA_WIDTH) md_agt_cfg;
    
    `uvm_component_param_utils(md_agent#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    // UVM Phases
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      md_agt_cfg = md_agent_config#(DATA_WIDTH)::type_id::create("md_agt_cfg", this);
    endfunction : build_phase
    
    virtual function void connect_phase(uvm_phase phase);
      md_vif vif;
      
      super.connect_phase(phase);
      
      if(!uvm_config_db#(md_vif)::get(this, "", "vif", vif)) begin
        `uvm_fatal("md_NO_VIF", "Could not get from the database the md virtual interface")
      end
      else begin
        md_agt_cfg.set_vif(vif);
      end
   
    endfunction : connect_phase
  
    virtual task run_phase(uvm_phase phase);
      forever begin
        wait_reset_start();
        handle_reset(phase);
        wait_reset_end();
      end
    endtask : run_phase
    
    // Methods
    virtual function void handle_reset(uvm_phase phase);
      uvm_component children[$];
      
      // Get all the instantiated components under the md_agent
      get_children(children);
      foreach(children[idx]) begin
        md_reset_handler reset_handler;
        
        //`uvm_info("CHILD", $sformatf("Child: %s", children[idx].get_name()), UVM_LOW)
        if($cast(reset_handler, children[idx])) begin
          reset_handler.handle_reset(phase);
        end
        else begin
          `uvm_info("CHILD", $sformatf("Child: %s failed casting", children[idx].get_name()), UVM_LOW)
        end
      end
      
    endfunction : handle_reset
  
    // Task for waiting the reset to start
    virtual task wait_reset_start();
      md_agt_cfg.wait_reset_start();
    endtask : wait_reset_start
    
    
    // Task for waiting the reset end
    virtual task wait_reset_end();
      md_agt_cfg.wait_reset_end();
    endtask : wait_reset_end
    
  endclass : md_agent

`endif // MD_AGENT_SV
