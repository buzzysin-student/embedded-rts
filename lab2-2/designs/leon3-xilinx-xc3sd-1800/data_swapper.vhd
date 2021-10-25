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
  port (
    -- Wierd stuff
    dmao    : in ahb_dma_out_type;
    -- ARM Cortext-M0 AHB-Lite signals
    HADDR   : out std_logic_vector (31 downto 0)
  );
end; 

architecture behav of data_swapper is 
  
begin
  
end architecture;
