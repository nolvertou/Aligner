`ifndef MD_MASTER_SIMPLE_SEQUENCE_SV
`define MD_MASTER_SIMPLE_SEQUENCE_SV

  class md_master_simple_sequence extends md_master_base_sequence;
	
    // Item to drive
    rand md_master_drv_item item;
    
    constraint item_hard{
      item.data.size() > 0;
      item.data.size() <= (p_sequencer.get_data_width() / 8);
      
      item.offset < (p_sequencer.get_data_width() / 8);
      
      (item.data.size() + item.offset) <= (p_sequencer.get_data_width() / 8);
    }
    
    `uvm_object_utils(md_master_simple_sequence)

    function new(string name = "");
      super.new(name);
      
      item = md_master_drv_item::type_id::create("item");
      item.data_default_c.constraint_mode(0);
      item.offset_default_c.constraint_mode(0);
    endfunction : new
    
    virtual task body();
      `uvm_send(item);
    endtask : body

  endclass : md_master_simple_sequence


`endif // MD_MASTER_SIMPLE_SEQUENCE_SV