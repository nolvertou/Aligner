`ifndef MD_COVERAGE_SV
`define MD_COVERAGE_SV

// Analysis implementation declaration for item transactions
`uvm_analysis_imp_decl(_item)

class md_coverage#(int unsigned DATA_WIDTH = 32) extends uvm_component implements md_reset_handler;

  typedef virtual md_if#(DATA_WIDTH) md_vif;

  // Handlers
  md_agent_config#(DATA_WIDTH) md_agt_cfg;

  // TLM ports
  uvm_analysis_imp_item#(md_mon_item, md_coverage#(DATA_WIDTH)) port_item;

  // Wrapper over the coverage group covering the indices of the PWDATA signal 
  // at this which the bit of the data is 0
  md_cover_index_wrapper #(DATA_WIDTH) wrap_cover_data_0;
  // Wrapper over the coverage group covering the indices of the PWDATA signal 
  // at this which the bit of the data is 1
  md_cover_index_wrapper #(DATA_WIDTH) wrap_cover_data_1;

  // UVM Macros
  `uvm_component_param_utils(md_coverage#(DATA_WIDTH))

  // Covergroups
  covergroup cover_item with function sample(md_mon_item item);
    option.per_instance = 1;

    offset : coverpoint (item.offset) {
      option.comment = "Offset of the MD access";
      bins values[] = {[0: ((DATA_WIDTH / 8)-1)]};
    }

    size : coverpoint (item.data.size()) {
      option.comment = "Size of the MD access";
      bins values[] = {[1: (DATA_WIDTH / 8)]};
    }

    response : coverpoint (item.response){
      option.comment = "Response of the MD access";
    }

    length : coverpoint (item.length){
      option.comment = "Length of the MD access";

      bins length_eq_1     = {1};
      bins length_le_10[9] = {[2:10]};
      bins length_gt_10    = {[11:$]};

      illegal_bins length_lt_1 = {0};
    }

    prev_item_delay : coverpoint (item.prev_item_delay){
      option.comment = "Delay, in clock cycles, between 2 consecutive MD accesses";

      bins back2back 		= {0};
      bins delay_le_5[5] 	= {[1:5]};
      bins delay_gt_5		= {[6:$]};
    }

    offset_x_size : cross offset, size {
      ignore_bins ignore_offset_plus_size_gt_data_width = offset_x_size with ((offset + size) > (DATA_WIDTH / 8));
    }
  endgroup

  covergroup cover_reset with function sample(bit valid);
    option.per_instance = 1;

    access_ongoing : coverpoint (valid) {
      option.comment = "An MD access was ongoing at reset";
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

    wrap_cover_data_0 = md_cover_index_wrapper #(DATA_WIDTH)::type_id::create("wrap_cover_data_0", this);
    wrap_cover_data_1 = md_cover_index_wrapper #(DATA_WIDTH)::type_id::create("wrap_cover_data_1", this);
  endfunction : build_phase

  // Function to handle the reset
  virtual function void handle_reset(uvm_phase phase);
    md_vif vif = md_agt_cfg.get_vif();
    cover_reset.sample(vif.valid);
  endfunction : handle_reset

  // Other Methods
  // Function associated with port_item port
  virtual function void write_item(md_mon_item item);
    cover_item.sample(item);

    // Sampling Wrapper Coverage for data	
    foreach(item.data[byte_index]) begin
      for(int bit_index = 0; bit_index < 8; bit_index++) begin
        if(item.data[byte_index][bit_index]) begin
          wrap_cover_data_1.sample((item.offset * 8) + (byte_index * 8) + bit_index);
        end
        else begin
          wrap_cover_data_0.sample((item.offset * 8) + (byte_index * 8) + bit_index);
        end
      end // for
    end // foreach
  endfunction : write_item

  // Function associated with port_item port
  // In a real project it is not required to print this
  // Add -coverage functional in Compile Options to enable coverage collection in EDAPlayground
  virtual function string coverage2string();
    string result = {
      $sformatf("\n 	cover_item:		    	%03.2f%%", cover_item.get_inst_coverage()),       
      $sformatf("\n	offset: 			%03.2f%%", cover_item.offset.get_inst_coverage()),
      $sformatf("\n	size: 			%03.2f%%", cover_item.size.get_inst_coverage()),
      $sformatf("\n	response: 			%03.2f%%", cover_item.response.get_inst_coverage()),
      $sformatf("\n	length: 			%03.2f%%", cover_item.length.get_inst_coverage()),
      $sformatf("\n	prev_item_delay: 		%03.2f%%", cover_item.prev_item_delay.get_inst_coverage()),
      $sformatf("\n	offset_x_size: 		%03.2f%%", cover_item.offset_x_size.get_inst_coverage()),
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
      md_cover_index_wrapper_base wrapper;

      // If we encounter such a child then we add the output from its coverage to string to out result here
      if($cast(wrapper, children[idx]))begin
        result = $sformatf("%0s\n\n	Child component: 		%0s%0s", result, wrapper.get_name(), wrapper.coverage2string()); 
      end
    end

    return result;
  endfunction : coverage2string

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);


    // IMPORTANT: DON'T DO THIS IN A REAL PROJECT!!!
    `uvm_info("DEBUG", $sformatf("Coverage: %0s", coverage2string()), UVM_NONE)
  endfunction : report_phase

endclass : md_coverage
`endif // MD_COVERAGE_SV

