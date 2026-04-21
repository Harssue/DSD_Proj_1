library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_video_freeze is
    Port (
        CLK100MHZ : in  STD_LOGIC;
        BTNC      : in  STD_LOGIC;

        VGA_HS    : out STD_LOGIC;
        VGA_VS    : out STD_LOGIC;
        VGA_R     : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_G     : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_B     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_video_freeze;

architecture Behavioral of top_video_freeze is

    signal clk25       : STD_LOGIC := '0';
    signal freeze      : STD_LOGIC := '0';
    signal frame_index : INTEGER range 0 to 9 := 0;

    signal pixel       : STD_LOGIC_VECTOR(7 downto 0);
    signal addr        : INTEGER range 0 to 19199;

begin

-- Clock Divider (100 MHz → 25 MHz)
process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        clk25 <= not clk25;
    end if;
end process;

-- Freeze Toggle
process(clk25)
begin
    if rising_edge(clk25) then
        if BTNC = '1' then
            freeze <= not freeze;
        end if;
    end if;
end process;

-- Frame Counter
process(clk25)
begin
    if rising_edge(clk25) then
        if freeze = '0' then
            if frame_index = 9 then
                frame_index <= 0;
            else
                frame_index <= frame_index + 1;
            end if;
        end if;
    end if;
end process;

-- Frame ROM
frame_mem: entity work.frame_rom
    port map (
        clk   => clk25,
        addr  => frame_index * 19200 + addr,
        data  => pixel
    );

-- VGA
vga: entity work.vga_controller
    port map (
        clk       => clk25,
        pixel_in  => pixel,
        addr_out  => addr,
        hsync     => VGA_HS,
        vsync     => VGA_VS,
        r         => VGA_R,
        g         => VGA_G,
        b         => VGA_B
    );

end Behavioral;