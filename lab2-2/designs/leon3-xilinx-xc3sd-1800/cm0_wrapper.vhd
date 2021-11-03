library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

library grlib; 
use grlib.amba.all; 
use grlib.stdlib.all; 
use grlib.devices.all; 

library gaisler; 
use gaisler.misc.all; 

library UNISIM; 
use UNISIM.VComponents.all; 

entity cm0_wrapper is 
  port(
    -- Clock and reset
    clkm : in std_logic;
    rstn : in std_logic;
    -- AHB Signals
    ahbmi : in ahb_mst_in_type;
    ahbmo : out ahb_mst_out_type
  );
end;

architecture structural of cm0_wrapper is 

  -- Declare CORTEXM0DS component
  component CORTEXM0DS is
    port(
      -- CLOCK AND RESETS ------------------
      HCLK      : in std_logic;                       -- Clock
      HRESETn   : in std_logic;                       -- Asynchronous reset
      
      -- AHB-LITE MASTER PORT --------------
      HADDR     : out std_logic_vector(31 downto 0);  -- AHB transaction address
      HBURST    : out std_logic_vector(2 downto 0);   -- AHB burst: tied to single
      HMASTLOCK : out std_logic;                      -- AHB locked transfer (always zero)
      HPROT     : out std_logic_vector(3 downto 0);   -- AHB protection: priv; data or inst
      HSIZE     : out std_logic_vector(2 downto 0);   -- AHB size: byte, half-word or word
      HTRANS    : out std_logic_vector(1 downto 0);   -- AHB transfer: non-sequential only
      HWDATA    : out std_logic_vector(31 downto 0);  -- AHB write-data
      HWRITE    : out std_logic;                      -- AHB write control
      HRDATA    : in std_logic_vector(31 downto 0);   -- AHB read-data
      HREADY    : in std_logic;                       -- AHB stall signal
      HRESP     : in std_logic;                       -- AHB error response
      
      -- MISCELLANEOUS ---------------------
      NMI         : in std_logic;                     -- Non-maskable interrupt input
      IRQ         : in std_logic_vector(15 downto 0); -- Interrupt request inputs
      TXEV        : out std_logic;                    -- Event output (SEV executed)
      RXEV        : in std_logic;                     -- Event input
      LOCKUP      : out std_logic;                    -- Core is locked-up
      SYSRESETREQ : out std_logic;                    -- System reset request

      -- POWER MANAGEMENT ------------------
      SLEEPING    : out std_logic                     -- Core and NVIC sleeping
    );
  end component;
  
  component AHB_bridge is 
    port( 
      -- Clock and Reset ----------------- 
      clkm   : in  std_logic; 
      rstn   : in  std_logic; 
      -- AHB Master records -------------- 
      ahbmi  : in  ahb_mst_in_type; 
      ahbmo  : out ahb_mst_out_type; 
      -- ARM Cortex-M0 AHB-Lite signals --     
      HADDR  : in  std_logic_vector (31 downto 0); -- AHB transaction address 
      HSIZE  : in  std_logic_vector (2 downto 0);  -- AHB size: byte, half-word or word 
      HTRANS : in  std_logic_vector (1 downto 0);  -- AHB transfer: non-sequential only 
      HWDATA : in  std_logic_vector (31 downto 0); -- AHB write-data 
      HWRITE : in  std_logic;                      -- AHB write control 
      HRDATA : out std_logic_vector (31 downto 0); -- AHB read-data 
      HREADY : out std_logic                       -- AHB stall signal 
    ); 
  end component;

  signal sHADDR       : std_logic_vector(31 downto 0);
  signal sHSIZE       : std_logic_vector(2 downto 0);
  signal sHTRANS      : std_logic_vector(1 downto 0);
  signal sHWDATA      : std_logic_vector(31 downto 0);
  signal sHWRITE      : std_logic;
  signal sHRDATA      : std_logic_vector(31 downto 0);
  signal sHREADY      : std_logic;
  
begin
  
  -- init CORTEXM0DS
  init_cortexm0ds : CORTEXM0DS
  port map (
      HCLK          => clkm,
      HRESETn       => rstn,
      HADDR         => sHADDR,  
      HBURST        => open, 
      HMASTLOCK     => open,
      HPROT         => open,
      HSIZE         => sHSIZE,
      HTRANS        => sHTRANS,
      HWDATA        => sHWDATA,
      HWRITE        => sHWRITE,
      HRDATA        => sHRDATA,
      HREADY        => sHREADY,
      HRESP         => '0',
      NMI           => '0',
      IRQ           => (others => '0'),
      TXEV          => open,
      RXEV          => '0',
      LOCKUP        => open,
      SYSRESETREQ   => open,
      SLEEPING      => open
  );
  
  -- init ahblite_bridge
  init_ahblite_bridge : AHB_Bridge
  port map (
    clkm    => clkm,
    rstn    => rstn,
    ahbmi   => ahbmi,
    ahbmo   => ahbmo,
    
    HADDR   => sHADDR,
    HSIZE   => sHSIZE,
    HTRANS  => sHTRANS,
    HWDATA  => sHWDATA,
    HWRITE  => sHWRITE,
    HRDATA  => sHRDATA,
    HREADY  => sHREADY
  );
    
end architecture;
