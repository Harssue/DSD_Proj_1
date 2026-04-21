library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frame_controller is
    Port (
        clk        : in  STD_LOGIC;
        freeze_btn : in  STD_LOGIC;
        pixel_addr : in  INTEGER range 0 to 19199;
        bram_addr  : out STD_LOGIC_VECTOR(17 downto 0)
    );
end frame_controller;

architecture Behavioral of frame_controller is

    signal frame_index : INTEGER range 0 to 9 := 0;
    signal freeze      : STD_LOGIC := '0';
    signal btn_prev    : STD_LOGIC := '0';
    signal counter     : INTEGER := 0;
    constant FRAME_DELAY : INTEGER := 500000;

begin

    -- Button debounce (edge detect)
    process(clk)
    begin
        if rising_edge(clk) then
            if (freeze_btn = '1' and btn_prev = '0') then
                freeze <= not freeze;
            end if;
            btn_prev <= freeze_btn;
        end if;
    end process;

    -- Frame rate control
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = FRAME_DELAY then
                counter <= 0;
                if freeze = '0' then
                    if frame_index = 9 then
                        frame_index <= 0;
                    else
                        frame_index <= frame_index + 1;
                    end if;
                end if;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Address calculation: frame_index * 19200 + pixel_addr
    process(clk)
    begin
        if rising_edge(clk) then
            bram_addr <= std_logic_vector(to_unsigned(frame_index * 19200 + pixel_addr, 18));
        end if;
    end process;

end Behavioral;
