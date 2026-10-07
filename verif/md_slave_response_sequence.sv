`ifndef MD_SLAVE_RESPONSE_SEQUENCE_SV
`define MD_SLAVE_RESPONSE_SEQUENCE_SV

  class md_slave_response_sequence extends md_slave_base_sequence;

    `uvm_object_utils(md_slave_response_sequence)
    
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    virtual task body();
      md_mon_item mon_item;
      
      p_sequencer.pending_items.get(mon_item);
      
      begin
        md_slave_simple_sequence seq;
        
        `uvm_do_with(seq, {
          //mon_item.data[0] == 'h78 -> seq.item.response == MD_ERR; // FIXME: Tutorial is using 'h85, why?? in our simulation i did not see this value, so I used 'h78 instead
          //mon_item.data[0] != 'h78 -> seq.item.response == MD_OKAY;
        })
      end
    endtask : body
    
  endclass : md_slave_response_sequence

`endif // MD_SLAVE_RESPONSE_SEQUENCE_SV