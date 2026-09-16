`ifndef APB_AGENT_SV
  `define APB_AGENT_SV
  
class apb_agent extends uvm_agent implements apb_reset_handler;
    
    // Handlers
    apb_agent_config 	apb_agt_cfg;
    apb_sequencer 		apb_sqcr;
    apb_driver 			apb_drv;
    apb_monitor			apb_mon;
    apb_coverage        apb_cov;
    
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
      apb_mon = apb_monitor::type_id::create("apb_mon", this);
      
      if(apb_agt_cfg.get_has_coverage()) begin
        apb_cov = apb_coverage::type_id::create("apb_cov", this);
      end
      
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
      
      apb_mon.apb_agt_cfg = apb_agt_cfg;
      
      if(apb_agt_cfg.get_has_coverage()) begin
        apb_cov.apb_agt_cfg = apb_agt_cfg;
        apb_mon.output_put.connect(apb_cov.port_item);
      end
      
      if(apb_agt_cfg.get_active_passive() == UVM_ACTIVE) begin
        apb_drv.apb_agt_cfg = apb_agt_cfg;
        apb_drv.seq_item_port.connect(apb_sqcr.seq_item_export);
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
      
      // Get all the instantiated components under the apb_agent
      get_children(children);
      foreach(children[idx]) begin
        apb_reset_handler reset_handler;
        
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
      apb_agt_cfg.wait_reset_start();
    endtask : wait_reset_start
    
    
    // Task for waiting the reset end
    virtual task wait_reset_end();
      apb_agt_cfg.wait_reset_end();
    endtask : wait_reset_end
      
  endclass : apb_agent

`endif // APB_AGENT_SV