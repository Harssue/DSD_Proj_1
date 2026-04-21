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

    signal clk25         : STD_LOGIC := '0';
    signal pixel         : STD_LOGIC_VECTOR(7 downto 0);
    signal vga_addr      : INTEGER range 0 to 19199;  -- ✅ DECLARED HERE
    signal bram_addr_sig : STD_LOGIC_VECTOR(17 downto 0);

begin

    -- Clock Divider (100 MHz → 25 MHz)
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            clk25 <= not clk25;
        end if;
    end process;

    -- Frame ROM - Fixed port connections
    frame_ctrl: entity work.frame_controller
        port map (
            clk        => clk25,
            freeze_btn => BTNC,
            pixel_addr => vga_addr,      -- ✅ Now declared
            bram_addr  => bram_addr_sig
        );
   
    frame_mem: entity work.blk_mem_gen_0
        port map (
            clka  => clk25,              -- ✅ Fixed: clk25 instead of clk
            addra => bram_addr_sig,
            douta => pixel
        );

    -- VGA Controller
    vga: entity work.vga_controller
        port map (
            clk       => clk25,
            pixel_in  => pixel,
            addr_out  => vga_addr,       -- ✅ Now properly connected
            hsync     => VGA_HS,
            vsync     => VGA_VS,
            r         => VGA_R,
            g         => VGA_G,
            b         => VGA_B
        );

end Behavioral;
