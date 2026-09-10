`ifndef APB_COVER_INDEX_WRAPPER_SV
`define APB_COVER_INDEX_WRAPPER_SV

  class apb_cover_index_wrapper #(int unsigned MAX_VALUE_PLUS_1 = 16) extends apb_cover_index_wrapper_base;
    
    // UVM Macros
    `uvm_component_param_utils(apb_cover_index_wrapper#(MAX_VALUE_PLUS_1))
  
    // Covergroups
    covergroup cover_index with function sample(int unsigned value);
      option.per_instance = 1;
    
      index: coverpoint value {
        option.comment = "Index";
        bins values [MAX_VALUE_PLUS_1] = {[0: MAX_VALUE_PLUS_1-1]};
      }
    endgroup : cover_index
  
    // Constructor
    function new(string name, uvm_component parent);
      super.new(name, parent);
      cover_index = new();
      cover_index.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_index"));
    endfunction : new
  
    virtual function void sample(int unsigned value);
      cover_index.sample(value);
    endfunction : sample
  
    virtual function string coverage2string();
      string result = {
        $sformatf("\n 	cover_index:			%03.2f%%", cover_index.get_inst_coverage()), 
        $sformatf("\n	index:				%03.2f%%", cover_index.index.get_inst_coverage())
      };
      return result;
    endfunction : coverage2string
  
  endclass : apb_cover_index_wrapper
`endif // APB_COVER_INDEX_WRAPPER_SV