library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity detectorbus is
  port ( 
    clkm      : in  std_logic;
    databus   : in  std_logic_vector(31 downto 0);
    trigger   : out std_logic
  );
end detectorbus;

architecture Behavioral of DetectorBus is
begin

  process (clkm, databus)
  begin
	  if databus = "00010001000100010001000100010001" then
			trigger<='1';
		else
			trigger<='0';
	  end if;
	end process;
	
end;
