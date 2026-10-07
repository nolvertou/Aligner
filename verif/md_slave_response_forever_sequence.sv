`ifndef MD_SLAVE_RESPONSE_SEQUENCE_FOREVER_SV
`define MD_SLAVE_RESPONSE_SEQUENCE_FOREVER_SV

  class md_slave_response_forever_sequence extends md_slave_base_sequence;

    `uvm_object_utils(md_slave_response_forever_sequence)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual task body();
      forever begin
        md_slave_response_sequence seq;
        
        `uvm_do_on(seq, p_sequencer)
      end
    endtask : body
    
  endclass : md_slave_response_forever_sequence

`endif // MD_SLAVE_RESPONSE_SEQUENCE_FOREVER_SV