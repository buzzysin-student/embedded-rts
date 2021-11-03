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
    -- AHB Signals
    dmai    : out ahb_dma_in_type;
    dmao    : in  ahb_dma_out_type;
    -- CortexM0 signals
    HADDR   : in std_logic_vector(31 downto 0);
    HSIZE   : in std_logic_vector( 2 downto 0);
    HTRANS  : in std_logic_vector( 1 downto 0);
    HWDATA  : in std_logic_vector(31 downto 0);
    HWRITE  : in std_logic;
    HREADY  : out std_logic
  );
end;

architecture behav of state_machine is
  
  type STATE_TYPE is (
    IDLE,
    IDLE_FETCH,
    FETCH,
    FETCH_IDLE
  );
  
  signal curState, nextState : STATE_TYPE;
  
begin
  
  next_state_register : process(clkm, rstn) is
  begin
    if rstn = '0' then
      curState <= IDLE;
    elsif clkm'event and clkm = '1' then
      curState <= nextState;
    end if;
  end process;
  
  next_state_logic : process(curState, clkm) is
  begin
    case curState is
      when IDLE =>  
        if HTRANS = "10" then
          nextState <= IDLE_FETCH;
        end if;
      when IDLE_FETCH =>
        nextState <= FETCH;
      when FETCH =>
        if dmao.ready = '1' then
          nextState <= FETCH_IDLE;
        end if;
      when FETCH_IDLE =>
        nextState <= IDLE;
      when OTHERS => 
        nextState <= IDLE;
    end case; 
  end process;


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
  next_state_outputs : process(curState) is
  begin
    case curState is
      when IDLE =>  
        HREADY <= '1';
        dmai.start <= '0';
      when IDLE_FETCH =>
        dmai.start <= '1';
      when FETCH =>
        HREADY <= '0';
        dmai.start <= '0';
      when FETCH_IDLE =>
        HREADY <= '1';
      when OTHERS => 
    end case;
  end process;
  
  -- Asynchronous connections
  dmai.address <= HADDR;
  dmai.wdata <= HWDATA;
  -- dmai.start is synchronous
  dmai.burst <= '0';
  dmai.write <= HWRITE; 
  dmai.busy <= '0';
  dmai.irq <= '0';
  dmai.size <= HSIZE;
  
end architecture;