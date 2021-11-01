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
    -- Weird stuff
    dmao    : in ahb_dma_out_type;
    -- ARM Cortext-M0 AHB-Lite signals
    HRDATA   : out std_logic_vector (31 downto 0)
  );
end; 

architecture behav of data_swapper is 
begin
  
  -- Task: and output reverse in
  flip_endianness: process(dmao) is
  variable data: std_logic_vector(31 downto 0);
  variable flip: std_logic_vector(31 downto 0);
  begin
    data := dmao.rdata;
    flip := 
      data( 7 downto  0) & 
      data(15 downto  8) & 
      data(23 downto 16) & 
      data(31 downto 24);
      
    HRDATA <= flip;
  end process;
  
end architecture;
