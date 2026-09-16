`ifndef APB_IF_SV
  `define APB_IF_SV

  `ifndef APB_MAX_DATA_WIDTH
    `define APB_MAX_DATA_WIDTH 32
  `endif // APB_MAX_DATA_WIDTH

  `ifndef APB_MAX_ADDR_WIDTH
    `define APB_MAX_ADDR_WIDTH 16
  `endif // APB_MAX_ADDR_WIDTH

  
  interface apb_if(input pclk);
    logic preset_n;							// reset is asynchronous
    logic [`APB_MAX_ADDR_WIDTH-1:0] paddr;
    logic pwrite;
    logic psel;
    logic penable;
    logic [`APB_MAX_DATA_WIDTH-1:0] pwdata;
    logic pready;
    logic [`APB_MAX_DATA_WIDTH-1:0] prdata;
    logic pslverr;
    bit   has_checks;
    
    initial begin
      has_checks = 1;
    end
    
    
    // Rule 1: PENABLE must be asserted in the second cycle of the transfer
    // In setup phase can we have 2 cases:
    // Case 1.1: New transfer
	// Case 1.2: Transfer continuation
    sequence setup_phase_s;
      (psel == 1) && (($past(psel) == 0) || (($past(psel) == 1) && ($past(pready) == 1)));
    endsequence
    
    sequence access_phase_s;
      (psel == 1) && (penable == 1);
    endsequence
    
    property penable_at_setup_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      setup_phase_s |-> (penable == 0);
    endproperty
    
    PENABLE_AT_SETUP_PHASE_A : assert property(penable_at_setup_phase_p) else
      $error("PENABLE at \"Setup phase\" is not equal to 0");
      
    property penable_entering_at_access_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      setup_phase_s |=> (penable == 1);
    endproperty
    
    PENABLE_ENTERING_ACCESS_PHASE_A : assert property(penable_entering_at_access_phase_p) else
      $error("PENABLE when entering at \"Access phase\" is not equal to 1");  
      
    // Rule 2: PENABLE must be deasserted at the end of the transfer
    property penable_exiting_access_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      access_phase_s and (pready == 1) |=> (penable == 0);
    endproperty
      
    PENABLE_EXITING_ACCESS_PHASE_A: assert property(penable_exiting_access_phase_p) else
      $error("PENABLE when exiting \"Access phase\" is not equal to 0");    
      
    // Rule 3: Master driven signals must remain constant throughout the transfer
    property penable_stable_at_access_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      access_phase_s |-> (penable == 1);
    endproperty
      
    PENABLE_STABLE_AT_ACCESS_PHASE_A : assert property(penable_stable_at_access_phase_p) else
      $error("PENABLE was not stable during \"Access phase\"");
      
    property pwrite_stable_at_access_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      access_phase_s |-> $stable(pwrite);
    endproperty  
    
    PWRITE_STABLE_AT_ACCESS_PHASE_A : assert property(pwrite_stable_at_access_phase_p) else
      $error("PWRITE was not stable during \"Access phase\"");
    
    property paddr_stable_at_access_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      access_phase_s |-> $stable(paddr);
    endproperty
      
    PADDR_STABLE_AT_ACCESS_PHASE_A : assert property(paddr_stable_at_access_phase_p) else
      $error("PADDR was not stable during \"Access phase\"");
      
    property pwdata_stable_at_access_phase_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      (access_phase_s and (pwrite == 1)) |-> $stable(pwdata);
    endproperty  
    
      PWDATA_STABLE_AT_ACCESS_PHASE_A : assert property(pwdata_stable_at_access_phase_p) else
        $error("PWDATA was not stable during \"Access phase\"");
      
    // Rule 4: APB Signals can not have unknown values (e.g. x, z)
    property unknown_value_psel_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      ($isunknown(psel) == 0);
    endproperty
        
    UNKNOWN_VALUE_PSEL_A : assert property(unknown_value_psel_p) else
      $error("Detected unknown value for APB signal PSEL");
      
    property unknown_value_penable_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      (psel == 1) |-> ($isunknown(penable) == 0);
    endproperty
        
    UNKNOWN_VALUE_PENABLE_A : assert property(unknown_value_penable_p) else
        $error("Detected unknown value for APB signal PENABLE"); 
      
    property unknown_value_pwrite_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      (psel == 1) |-> ($isunknown(pwrite) == 0);
    endproperty
        
    UNKNOWN_VALUE_PWRITE_A : assert property(unknown_value_pwrite_p) else
      $error("Detected unknown value for APB signal PWRITE"); 
       
    property unknown_value_paddr_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      (psel == 1) |-> ($isunknown(paddr) == 0);
    endproperty
        
    UNKNOWN_VALUE_PADDR_A : assert property(unknown_value_paddr_p) else
      $error("Detected unknown value for APB signal PADDR"); 
      
    property unknown_value_pwdata_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      ((psel == 1) && (pwrite == 1))|-> ($isunknown(pwdata) == 0);
    endproperty
        
    UNKNOWN_VALUE_PWDATA_A : assert property(unknown_value_pwdata_p) else
      $error("Detected unknown value for APB signal PWDATA"); 
      
    property unknown_value_prdata_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      ((psel == 1) && (pwrite == 0) && (pready == 1) && (pslverr == 0)) |-> ($isunknown(prdata) == 0);
    endproperty
        
    UNKNOWN_VALUE_PRDATA_A : assert property(unknown_value_prdata_p) else
      $error("Detected unknown value for APB signal PRDATA"); 
      
    property unknown_value_pready_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      (psel == 1) |-> ($isunknown(pready) == 0);
    endproperty
        
    UNKNOWN_VALUE_PREADY_A : assert property(unknown_value_pready_p) else
      $error("Detected unknown value for APB signal PREADY"); 
      
    property unknown_value_pslverr_p;
      @(posedge pclk) disable iff(!preset_n || !has_checks)
      ((psel == 1) && (pready == 1)) |-> ($isunknown(pslverr) == 0);
    endproperty
        
    UNKNOWN_VALUE_SLVERR_A : assert property(unknown_value_pslverr_p) else
      $error("Detected unknown value for APB signal PSLVERR"); 
    
    // Rule 5: APB transfer can not have an infinite length
    // It was implemented inside apb_monitor
    
  endinterface : apb_if
`endif // APB_IF_SV