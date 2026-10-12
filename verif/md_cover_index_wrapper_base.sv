`ifndef MD_COVER_INDEX_WRAPPER_BASE_SV
`define MD_COVER_INDEX_WRAPPER_BASE_SV

/*
 *  This base class is used to get automatically all the children of the coverage class that use inheritance from this base classe
 */

virtual class md_cover_index_wrapper_base extends uvm_component;
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  pure virtual function void sample(int unsigned value);
    
  pure virtual function string coverage2string();
  
endclass : md_cover_index_wrapper_base
`endif // MD_COVER_INDEX_WRAPPER_BASE_SV