library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
Port 
( 
	i_reset_n : in std_logic;
	i_clock_100mhz : in STD_LOGIC;
	o_led : out std_logic
);
end top;

architecture Behavioral of top is
	signal s_clock_100mhz : std_logic;
	signal s_clock_80mhz : std_logic;
	signal s_reset : std_logic;
	signal s_clken : std_logic;
	signal s_counter : integer range 0 to 39999999;
	signal s_led : std_logic;
begin

	o_led <= s_led;
	s_reset <= not i_reset_n;

	-- Clock DCM
	dcm : entity work.clk_wiz_v3_6
	port map
	(
	  CLK_IN_100 => i_clock_100mhz,
	  CLK_OUT_100 => s_clock_100mhz,
	  CLK_OUT_80 => s_clock_80mhz
	);
	
	-- Divide by 2 clock enable
	div : process(s_clock_80mhz)
	begin
		if rising_edge(s_clock_80mhz) then
			if s_reset = '1' then
				s_clken <= '0';
			else
				s_clken <= not s_clken;
			end if;
		end if;
	end process;
	
	-- Toggle the led every 1 second
	blink : process(s_clock_80mhz)
	begin
		if rising_edge(s_clock_80mhz) then
			if s_reset = '1' then
				s_led <= '0';
				s_counter <= 0;
			elsif s_clken = '1' then
				if s_counter = 39999999 then
					s_led <= not s_led;
					s_counter <= 0;
				else
					s_counter <= s_counter + 1;
				end if;
			end if;
		end if;
	
	end process;


end Behavioral;

