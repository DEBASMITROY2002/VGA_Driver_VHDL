------------------------------------------------------------------------
-- Mimas V2 demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MimasV2TopModuleLX9 is
  GENERIC (          BoardDescription                               : STRING   := "NUMATO LAB Mimas V2";
                     DeviceDescripition                             : STRING   := "SPARTAN6 LX9";
                     ClockFrequency                                 : INTEGER  := 100_000_000;
                     NumberOfDIPSwitch                              : INTEGER  := 8;
                     NumberOfPushButtonSwitch                       : INTEGER  := 6;
                     NumberOfLEDs                                   : INTEGER  := 8;
                     NumberOfEachPortIOs                            : INTEGER  := 8;
                     VGAResolution                                  : STRING   := "640x480 @ 60Hz";
                     NumberOfVGAColor                               : INTEGER  := 3;                 
                     NumberOfSevenSegmentModule                     : INTEGER  := 3;
                     SevenSegmentLED                                : INTEGER  := 8
                );
  PORT ( -- Input's
            -- Assuming 100MHz input clock and active Low reset.
                     CLK                                            : IN   STD_LOGIC;
							RST_n                                          : IN   STD_LOGIC;
             -- Dip Switches and Switches.
                     DPSwitch                                       : IN   STD_LOGIC_VECTOR(NumberOfDIPSwitch-1 downto 0);
                     Switch                                         : IN   STD_LOGIC_VECTOR(NumberOfPushButtonSwitch-1 downto 0);
            -- Output's
              -- VGA Display
                     HSync                                          : OUT   STD_LOGIC;
                     VSync                                          : OUT   STD_LOGIC;
                     Red                                            : OUT   STD_LOGIC_VECTOR(NumberOfVGAColor-1 downto 0);
                     Green                                          : OUT   STD_LOGIC_VECTOR(NumberOfVGAColor-1 downto 0);
                     Blue                                           : OUT   STD_LOGIC_VECTOR(NumberOfVGAColor-1 downto 1)
             

          );

end MimasV2TopModuleLX9;

architecture Behavioral of MimasV2TopModuleLX9 is

 component clocking
   port    (  --Input clock 100 MHz
                     CLK_IN                                          : in std_logic;
                --Output
                     CLK_100MHz                                      : out std_logic;
                     CLK_50MHz                                       : out std_logic);
 end component;
 
 component MimasV2VGADisplay
   generic (       VGAResolution                                    : STRING ;
                   NumberOfVGAColor                                 : INTEGER);
   port    (  -- Input clock 100 MHz
                     CLK                                            : in std_logic;
							RST_n                                          : in std_logic;
                -- Output
                     HSync                                          : out std_logic;
                     VSync                                          : out std_logic;
                     Red                                            : out std_logic_vector(NumberOfVGAColor-1 downto 0);
                     Green                                          : out std_logic_vector(NumberOfVGAColor-1 downto 0);
                     Blue                                           : out std_logic_vector(NumberOfVGAColor-1 downto 1)
                    );
 end component;




	 signal  CLK_100MHz                                              : std_logic := '0';
	 signal  CLK_50MHz                                               : std_logic := '0';
begin

    clocking_Instant            : clocking
                                   port map (CLK_IN                                         => CLK,
                                             CLK_100MHz                                     => CLK_100MHz,
                                             CLK_50MHz                                      => CLK_50MHz);
															 										 
    VGA_instant                 : MimasV2VGADisplay
                                   generic map(VGAResolution                                 => VGAResolution,
                                               NumberOfVGAColor                              => NumberOfVGAColor)
                                   port map   (CLK                                           => CLK_50MHz,
											              RST_n                                         => RST_n,
                                               hsync                                         => hsync,
                                               vsync                                         => vsync,
                                               Red                                           => Red,
                                               Green                                         => Green,
                                               Blue                                          => Blue);

end Behavioral;

