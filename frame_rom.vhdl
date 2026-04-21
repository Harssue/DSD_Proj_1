library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frame_rom is
    Port (
        clk  : in  STD_LOGIC;
        addr : in  INTEGER range 0 to 191999; -- 10 frames
        data : out STD_LOGIC_VECTOR(7 downto 0)
    );
end frame_rom;

architecture Behavioral of frame_rom is

    type mem_type is array (0 to 191999) of STD_LOGIC_VECTOR(7 downto 0);
    signal ROM : mem_type := (
        others => x"00"   -- Replace with .coe initialization
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            data <= ROM(addr);
        end if;
    end process;

end Behavioral;