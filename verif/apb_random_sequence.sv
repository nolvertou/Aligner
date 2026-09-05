`ifndef APB_RANDOM_SEQUENCE_SV
  `define APB_RANDOM_SEQUENCE_SV

  class apb_random_sequence extends apb_base_sequence;
    // Attributes
    rand int unsigned num_items;
    
    // Constraints
    constraint num_items_defaults {
      soft num_items inside {[1:10]};
    }
    
    // UVM Macros
    `uvm_object_utils(apb_random_sequence)
  
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual task body();
      for(int i= 0; i < num_items; i++) begin
//         apb_simple_sequence seq = apb_simple_sequence::type_id::create("seq");
//         void'(seq.randomize());
//         seq.start(m_sequencer, this);
        apb_simple_sequence seq;
        `uvm_do(seq)
      end
    endtask : body
    
  endclass : apb_random_sequence

`endif // APB_RANDOM_SEQUENCE_SV