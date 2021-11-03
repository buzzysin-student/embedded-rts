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

entity data_swapper is 
  port(
    -- AHB Signals
    dmao : in ahb_dma_out_type;
    -- To CORTEXM0DS
    HRDATA : out std_logic_vector(31 downto 0)
  );
end;

architecture behav of data_swapper is
begin
  -- Swap data
  swap : process (dmao)
    variable flip : std_logic_vector(31 downto 0);
  begin
    flip( 7 downto  0) := dmao.rdata(31 downto 24);
    flip(15 downto  8) := dmao.rdata(23 downto 16);
    flip(23 downto 16) := dmao.rdata(15 downto  8);
    flip(31 downto 24) := dmao.rdata( 7 downto  0);
    
    HRDATA <= flip;
  end process;
  
end architecture;