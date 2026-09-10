`ifndef APB_COVERAGE_SV
`define APB_COVERAGE_SV

  // Analysis implementation declaration for item transactions
  `uvm_analysis_imp_decl(_item)
  
  class apb_coverage extends uvm_component;
    
    // Handlers
    apb_agent_config apb_agt_cfg;
    
    // TLM ports
    uvm_analysis_imp_item#(apb_mon_item, apb_coverage) port_item;
	
    // Wrapper over the coverage group covering the indices of the PADDR signal
    // at this which the bit of the PADDR is 0
    apb_cover_index_wrapper #(`APB_MAX_ADDR_WIDTH) wrap_cover_addr_0;
    
    // Wrapper over the coverage group covering the indices of the PADDR signal
    // at this which the bit of the PADDR is 1
    apb_cover_index_wrapper #(`APB_MAX_ADDR_WIDTH) wrap_cover_addr_1;

    // Wrapper over the coverage group covering the indices of the PWDATA signal 
    // at this which the bit of the PWDATA is 0
    apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH) wrap_cover_wr_data_0;
    // Wrapper over the coverage group covering the indices of the PWDATA signal 
    // at this which the bit of the PWDATA is 1
    apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH) wrap_cover_wr_data_1;

    // Wrapper over the coverage group covering the indices of the PRDATA signal 
    // at this which the bit of the PRDATA is 0
    apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH) wrap_cover_rd_data_0;
    // Wrapper over the coverage group covering the indices of the PRDATA signal 
    // at this which the bit of the PRDATA is 1
    apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH) wrap_cover_rd_data_1;
 
    // UVM Macros
    `uvm_component_utils(apb_coverage)
    
    // Covergroups
    covergroup cover_item with function sample(apb_mon_item item);
      option.per_instance = 1;
      
      direction : coverpoint (item.dir) {
        option.comment = "Direction of the APB access";
      }
      
      response : coverpoint (item.response){
        option.comment = "Response of the APB access";
      }
      
      length : coverpoint (item.length){
        option.comment = "Length of the APB access";
        
        bins length_eq_2     = {2};
        bins length_le_10[8] = {[3:10]};
        bins length_gt_10    = {[11:$]};
      }
      
      prev_item_delay : coverpoint (item.prev_item_delay){
        option.comment = "Delay, in clock cycles, between 2 consecutive APB accesses";
        
        bins back2back 		= {0};
        bins delay_le_5[5] 	= {[1:5]};
        bins delay_gt_6		= {[6:$]};
      }
      
      response_x_direction : cross response, direction;
      
      trans_direction : coverpoint (item.dir) {
        option.comment = "Transitions of the APB direction";
        // this bin is checking whether all four possible direction transitions occur.
        bins direction_trans[] = (APB_READ, APB_WRITE => APB_READ, APB_WRITE);
      }
    endgroup
    
    covergroup cover_reset with function sample(bit psel);
      option.per_instance = 1;
      
      access_ongoing : coverpoint (psel) {
        option.comment = "An APB access was ongoing at reset";
      }
    endgroup
    
    // Constructor
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      port_item = new("port_item", this);
      
      cover_item = new();
      // Set instance name that will be used to map this cover_item in verification plan
      cover_item.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_item"));
      
      cover_reset = new();
      cover_reset.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_reset"));
    endfunction : new
        
    // UVM Phases
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      // Address
      wrap_cover_addr_0 = apb_cover_index_wrapper #(`APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_0", this);
      wrap_cover_addr_1 = apb_cover_index_wrapper #(`APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_1", this);
      // Write Data
      wrap_cover_wr_data_0 = apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_wr_data_0", this);
      wrap_cover_wr_data_1 = apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_wr_data_1", this);
      // Read Data
      wrap_cover_rd_data_0 = apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_rd_data_0", this);
      wrap_cover_rd_data_1 = apb_cover_index_wrapper #(`APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_rd_data_1", this);
    endfunction : build_phase
    
    virtual task run_phase(uvm_phase phase);
      apb_vif vif = apb_agt_cfg.get_vif();
      
      forever begin
        @(negedge vif.preset_n);
        cover_reset.sample(vif.psel);
      end
    endtask : run_phase
    
    // Other Methods
    // Function associated with port_item port
    virtual function void write_item(apb_mon_item item);
      cover_item.sample(item);
      
      // Sampling Wrapper Coverage for ADDR	
      for(int i = 0; i < `APB_MAX_ADDR_WIDTH; i++) begin
        if(item.addr[i]) begin
          wrap_cover_addr_1.sample(i);
        end
        else begin
          wrap_cover_addr_0.sample(i);
        end
      end

      // Sampling Wrapper Coverage for WRDATA
      for(int i = 0; i < `APB_MAX_DATA_WIDTH; i++) begin

        case(item.dir) 
          APB_WRITE: begin 
            if(item.data[i]) begin
              wrap_cover_wr_data_1.sample(i);
            end
            else begin
              wrap_cover_wr_data_0.sample(i);
            end  
          end

          APB_READ: begin
            if(item.data[i]) begin
              wrap_cover_rd_data_1.sample(i);
            end
            else begin
              wrap_cover_rd_data_0.sample(i);
            end 
          end

          default: begin
            `uvm_error("ALGORITHM_ISSUE", $sformatf("Currernt version of the code does not support item.dir: %0s", item.dir.name()))
          end
        endcase 
      end
      // IMPORTANT: DON'T DO THIS IN A REAL PROJECT!!!
      `uvm_info("DEBUG", $sformatf("Coverage: %0s", coverage2string()), UVM_NONE)
    endfunction : write_item
    
    // Function associated with port_item port
    // In a real project it is not required to print this
    // Add -coverage functional in Compile Options to enable coverage collection in EDAPlayground
    virtual function string coverage2string();
      string result = {
        $sformatf("\n 	cover_item:		    	%03.2f%%", cover_item.get_inst_coverage()),       
        $sformatf("\n	direction: 			%03.2f%%", cover_item.direction.get_inst_coverage()),
        $sformatf("\n	response: 			%03.2f%%", cover_item.response.get_inst_coverage()),
        $sformatf("\n	length: 			%03.2f%%", cover_item.length.get_inst_coverage()),
        $sformatf("\n	prev_item_delay: 		%03.2f%%", cover_item.prev_item_delay.get_inst_coverage()),
        $sformatf("\n	response_x_direction: 		%03.2f%%", cover_item.response_x_direction.get_inst_coverage()),
        $sformatf("\n	trans_direction: 		%03.2f%%", cover_item.trans_direction.get_inst_coverage()),
        $sformatf("\n"),
        $sformatf("\n	cover_reset: 		%03.2f%%", cover_reset.get_inst_coverage()),
        $sformatf("\n	access_ongoing: 		%03.2f%%", cover_reset.access_ongoing.get_inst_coverage())
      };
      
      uvm_component children[$];
      
      // UVM has function called get_children, and this will get all the components which are instantiated under the coverage group,
      // and this is exactly the case for the use here with the wrapper classes
      get_children(children);
      
      
      // Then we can create a for loop and check if any of the children is of type cover index wrapper
      foreach(children[idx]) begin
        apb_cover_index_wrapper_base wrapper;

        // If we encounter such a child then we add the output from its coverage to string to out result here
        if($cast(wrapper, children[idx]))begin
          result = $sformatf("%0s\n\n	Child component: 		%0s%0s", result, wrapper.get_name(), wrapper.coverage2string()); 
        end
      end
       
      return result;
    endfunction : coverage2string
    
  endclass : apb_coverage
`endif // APB_COVERAGE_SV

