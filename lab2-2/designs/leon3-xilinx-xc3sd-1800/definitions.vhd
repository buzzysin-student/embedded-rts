
package definitions is
  
-- AHB master inputs
--  type ahb_mst_in_type is record
--    hgrant	: std_logic_vector(0 to NAHBMST-1);     -- bus grant
--    hready	: std_ulogic;                         	-- transfer done
--    hresp	: std_logic_vector(1 downto 0); 	-- response type
--    hrdata	: std_logic_vector(AHBDW-1 downto 0); 	-- read data bus
--    hcache	: std_ulogic;                         	-- cacheable
--    hirq  	: std_logic_vector(NAHBIRQ-1 downto 0);	-- interrupt result bus
--    testen	: std_ulogic;                         	-- scan test enable
--    testrst	: std_ulogic;                         	-- scan test reset
--    scanen 	: std_ulogic;                         	-- scan enable
--    testoen 	: std_ulogic;                         	-- test output enable 
--  end record;
--

---- AHB master outputs
--  type ahb_mst_out_type is record
--    hbusreq	: std_ulogic;                         	-- bus request
--    hlock	: std_ulogic;                         	-- lock request
--    htrans	: std_logic_vector(1 downto 0); 	-- transfer type
--    haddr	: std_logic_vector(31 downto 0); 	-- address bus (byte)
--    hwrite	: std_ulogic;                         	-- read/write
--    hsize	: std_logic_vector(2 downto 0); 	-- transfer size
--    hburst	: std_logic_vector(2 downto 0); 	-- burst type
--    hprot	: std_logic_vector(3 downto 0); 	-- protection control
--    hwdata	: std_logic_vector(AHBDW-1 downto 0); 	-- write data bus
--    hirq   	: std_logic_vector(NAHBIRQ-1 downto 0);	-- interrupt bus
--    hconfig 	: ahb_config_type;	 		-- memory access reg.
--    hindex  	: integer range 0 to NAHBMST-1;	 	-- diagnostic use only
--  end record;

-- AHB DMA IN TYPE
--type ahb_dma_in_type is record
--    address         : std_logic_vector(31 downto 0);
--    wdata           : std_logic_vector(AHBDW-1 downto 0);
--    start           : std_ulogic;
--    burst           : std_ulogic;
--    write           : std_ulogic;
--    busy            : std_ulogic;
--    irq             : std_ulogic;
--    size            : std_logic_vector(2 downto 0);
--  end record;
  
-- AHB DMA OUT TYPE
--  type ahb_dma_out_type is record
--    start           : std_ulogic;
--    active          : std_ulogic;
--    ready           : std_ulogic;
--    retry           : std_ulogic;
--    mexc            : std_ulogic;
--    haddr           : std_logic_vector(9 downto 0);
--    rdata           : std_logic_vector(AHBDW-1 downto 0);
--  end record;

end package;