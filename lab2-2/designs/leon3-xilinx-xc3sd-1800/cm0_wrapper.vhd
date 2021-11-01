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
  port (
    -- Clock and Reset ----------------- 
    clkm   : in  std_logic; 
    rstn   : in  std_logic; 
    -- AHB Master records -------------- 
    ahbmi  : in  ahb_mst_in_type; 
    ahbmo  : out ahb_mst_out_type 
  );
end;

architecture structural of cm0_wrapper is
  
  signal s_HADDR  : std_logic_vector (31 downto 0); -- AHB transaction address 
  signal s_HSIZE  : std_logic_vector (2 downto 0);  -- AHB size: byte, half-word or word 
  signal s_HTRANS : std_logic_vector (1 downto 0);  -- AHB transfer: non-sequential only 
  signal s_HWDATA : std_logic_vector (31 downto 0); -- AHB write-data 
  signal s_HWRITE : std_logic;                      -- AHB write control 
  signal s_HRDATA : std_logic_vector (31 downto 0); -- AHB read-data 
  signal s_HREADY : std_logic;                      -- AHB stall signal 
  
  component CORTEXM0DS is 
    port(
      -- Clock and Reset ----------------- 
      HCLK    : in  std_logic; 
      HRESETn : in  std_logic; 
      -- ARM Cortex-M0 AHB-Lite signals --     
      HADDR   : out std_logic_vector (31 downto 0); -- AHB transaction address
      HBURST  : out std_logic_vector (2 downto 0);  -- AHB burst tied to single 
      HMASTLOCK:out std_logic;                      -- AHB Locked Transfer
      HPROT   : out std_logic_vector (3 downto 0);  -- AHB protection: priv; data or inst
      HSIZE   : out std_logic_vector (2 downto 0);  -- AHB size: byte, half-word or word 
      HTRANS  : out std_logic_vector (1 downto 0);  -- AHB transfer: non-sequential only 
      HWDATA  : out std_logic_vector (31 downto 0); -- AHB write-data 
      HWRITE  : out std_logic;                      -- AHB write control 
      HRDATA  : in  std_logic_vector (31 downto 0); -- AHB read-data 
      HREADY  : in  std_logic;                      -- AHB stall signal 
      
      -- Extra signals
      HRESP   : in  std_logic;
      NMI     : in  std_logic;                      -- Non-maskable interrupt input
      IRQ     : in  std_logic_vector (15 downto 0); -- Interrupt request inputs
      TXEV    : out std_logic;                      -- Event output (SEV executed)
      RXEV    : in  std_logic;                      -- Event input
      LOCKUP  : out std_logic;                      -- Core is locked-up
      SYSRESETREQ : out std_logic;                  -- System reset request
      SLEEPING    : out std_logic                   --
    );
  end component;
  
  component AHB_Bridge is 
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
  
begin
  
  cortexm0ds_map : CORTEXM0DS
    port map (
      -- Reset / Clk
      HCLK      => clkm, 
      HRESETn   => rstn, 
      -- Unused
      HBURST    => open,
      HMASTLOCK => open,
      HPROT     => open,
      -- Used
      HADDR     => s_HADDR, 
      HSIZE     => s_HSIZE, 
      HTRANS    => s_HTRANS, 
      HWDATA    => s_HWDATA, 
      HWRITE    => s_HWRITE, 
      HRDATA    => s_HRDATA, 
      HREADY    => s_HREADY,
      -- Unused
      HRESP     => '0',
      NMI       => '0',                     -- Non-maskable interrupt input
      IRQ       => "0000000000000000",      -- Interrupt request inputs
      TXEV      => open,                    -- Event output (SEV executed)
      RXEV      => '0',                     -- Event input
      LOCKUP    => open,                    -- Core is locked-up
      SYSRESETREQ => open,                  -- System reset request
      SLEEPING    => open
    );
      
  ahblite_bridge_map : AHB_Bridge
    port map (
      clkm    => clkm, 
      rstn    => rstn, 
      ahbmi   => ahbmi, 
      ahbmo   => ahbmo, 
      HADDR   => s_HADDR, 
      HSIZE   => s_HSIZE,
      HTRANS  => s_HTRANS, 
      HWDATA  => s_HWDATA, 
      HWRITE  => s_HWRITE, 
      HRDATA  => s_HRDATA, 
      HREADY  => s_HREADY);
  
end architecture;