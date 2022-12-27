----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:28:24 12/26/2022 
-- Design Name: 
-- Module Name:    vga_driver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC;
           RGB : out  STD_LOGIC_VECTOR (2 downto 0));
end vga_driver;

architecture Behavioral of vga_driver is

	signal clk25 : std_logic := '0';
	
	constant HD : integer := 639;
	constant HFP : integer := 16;
	constant HSP : integer := 96;
	constant HBP : integer := 48;
	
	constant VD : integer := 479;
	constant VFP : integer := 10;
	constant VSP : integer := 2;
	constant VBP : integer := 33;	
	
	signal hPos : integer := 0;
	signal vPos : integer := 0;	
	
	signal videoOn : std_logic := '0';

begin

clk_div: process(CLK)
begin
	if(CLK'event and CLK = '1')then
		clk25 <= not clk25;
	end if;
end process;


Horizontal_position_counter: process(clk25, RST)
begin
	if(RST = '1')then
		hPos <= 0;
	elsif(clk25'event and clk25 = '1')then
		if (hPos = (HD + HFP + HSP + HBP))	then
			hPos<=0;
		else
			hPos<=hPos+1; 
		end if;
	end if;
end process;


Vertical_position_counter: process(clk25, RST, hPos)
begin
	if(RST = '1')then
		vPos <= 0;
	elsif(clk25'event and clk25 = '1')then
		if (hPos = (HD + HFP + HSP + HBP))	then
			if (vPos = (VD + VFP + VSP + VBP))	then
				vPos<=0;
			else
				vPos<=vPos+1; 
			end if;
		end if;
	end if;
end process;




Horizontal_Synchronisation:process(clk25, RST, hPos)
begin
	if(RST = '1')then
		HSYNC <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((hPos <= (HD+HFP)) OR (hPos > (HD + HFP + HSP)))then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
end process;


Vertical_Synchronisation:process(clk25, RST, vPos)
begin
	if(RST = '1')then
		VSYNC <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((vPos <= (VD+VFP)) OR (vPos > (VD + VFP + VSP)))then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
end process;



video_on:process(clk25, RST, hPos, vPos)
begin
	if(RST = '1')then
		videoOn <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((hPos <= VD) and (vPos <= VD) )then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;



draw:process(clk25, RST, hPos, vPos, videoOn)
begin
	if(RST = '1')then
		RGB <= "000";
	elsif(clk25'event and clk25 = '1')then
		if(videoOn = '1')then
			if((hPos >=10 and hPos<=60)and(vPos >=10 and vPos<=60))then
				RGB <= "111";
			else
				RGB <= "000";
			end if;
		else
			RGB<="000";
		end if;
	end if;
end process;
 

end Behavioral;

