`ifndef APB_DRIVER_SV
  `define APB_DRIVER_SV

  class apb_driver extends uvm_driver#(.REQ(apb_drv_item));
    `uvm_component_utils(apb_driver)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction : new
    
    virtual task run_phase(uvm_phase phase);
      forever begin
//         apb_drv_item item;
        seq_item_port.get_next_item(req);
        `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %s", req.get_full_name(), req.convert2string()), UVM_NONE)
        seq_item_port.item_done();
      end
    endtask : run_phase
    
  endclass : apb_driver
`endif // APB_DRIVER_SV