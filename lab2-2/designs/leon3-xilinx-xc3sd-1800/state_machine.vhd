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

entity state_machine is  
  port (
    -- Clock and reset
    clkm    : in std_logic;
    rstn    : in std_logic;
    -- Wierd stuff
    dmai    : out ahb_dma_in_type;
    dmao    : in ahb_dma_out_type;
    -- ARM Cortext-M0 AHB-Lite signals
    HADDR   : in std_logic_vector (31 downto 0);
    HSIZE   : in std_logic_vector (2 downto 0);
    HTRANS  : in std_logic_vector (1 downto 0);
    HWRITE  : in std_logic;
    HREADY  : out std_logic
  );
end; 

architecture behav of state_machine is 
  type STATE is (
    IDLE, -- Do nothing
    IDLE_FETCH, -- intermediate thing
    FETCH, -- Get data from xxxxxxx
    FETCH_IDLE -- intermediate thing
  );
  
  signal curState, nextState : STATE;
  
begin
  
  state_register : process (clkm, rstn) is
  begin
    if rstn = '1' then
      curState <= IDLE;
    elsif clkm'event and clkm = '1' then
      curState <= nextState;
    end if;
  end process;
  
  -- Mealy/Moore (delete as necessary)
  next_state_logic : process (curState, clkm) is
  begin
    case curState is 
      when IDLE =>
        if HTRANS = "10" then
          -- Something illegal is about to happen.
          dmai.start <= '1';
          -- Something illegal happened.
          nextState <= FETCH;
        end if; 
      when FETCH =>
        if dmao.ready = '1' then
          -- Something illegal is about to happen.
          HREADY <= '1';
          -- Something illegal happened.
          nextState <= IDLE;
        end if;
      when OTHERS =>
    end case;
  end process;
  
  next_state_outputs : process (curState) is
  begin
    case curState is
      when IDLE =>
        HREADY <= '1';
        dmai.start <= '0';
      when FETCH =>
        HREADY <= '0';
        dmai.start <= '0';
      when OTHERS =>
    end case;
  end process;
  
end architecture; 
