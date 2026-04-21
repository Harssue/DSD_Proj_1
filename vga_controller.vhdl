library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    Port (
        clk       : in  STD_LOGIC;
        pixel_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        addr_out  : out INTEGER range 0 to 19199;

        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;
        r, g, b   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end vga_controller;

architecture Behavioral of vga_controller is

    signal h_count : INTEGER := 0;
    signal v_count : INTEGER := 0;

begin

process(clk)
begin
    if rising_edge(clk) then

        if h_count = 799 then
            h_count <= 0;
            if v_count = 524 then
                v_count <= 0;
            else
                v_count <= v_count + 1;
            end if;
        else
            h_count <= h_count + 1;
        end if;

        if h_count < 640 and v_count < 480 then
            addr_out <= (v_count/4)*160 + (h_count/4);

            r <= pixel_in(7 downto 4);
            g <= pixel_in(7 downto 4);
            b <= pixel_in(7 downto 4);
        else
            r <= (others => '0');
            g <= (others => '0');
            b <= (others => '0');
        end if;

    end if;
end process;

hsync <= '0' when (h_count >= 656 and h_count < 752) else '1';
vsync <= '0' when (v_count >= 490 and v_count < 492) else '1';

end Behavioral;