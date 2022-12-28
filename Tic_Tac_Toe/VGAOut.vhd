library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGAOut is
    -- Define the width and the height of the displayed text.
        generic( OutputWidth                       : integer := 5;  
                 OutputHeight                      : integer := 20;
					  dx : integer := 240;
					  dy : integer := 180;
					  NumberOfPushButtonSwitch         : INTEGER := 7
               );
          port (
    -- Assuming 50MHz clock.If the clock is reduced then it might give the unexpected output.      
              clock                                : in std_logic;
				  Switch                                         : IN   STD_LOGIC_VECTOR(NumberOfPushButtonSwitch-1 downto 0);
    -- The counter tells whether the correct position on the screen is reached where the data is to be displayed. 
              hcounter                             : in integer range 0 to 1023;
              vcounter                             : in integer range 0 to 1023;
    -- Output the colour that should appear on the screen. 
              pixels                               : out std_logic_vector(7 downto 0)               
              );
end VGAOut;
architecture Behavioral of VGAOut is   
    -- Intermediate register telling the exact position on display on screen.
	 
			signal clock_1_Hz : std_logic := '0';
			signal count : integer range 0 to 25000001 := 0;
			
			signal x : integer range 0 to 1023 := 10;
			signal y : integer range 0 to 1023 := 8;
			signal flagc : integer range 0 to 2 := 0;
			signal flag1 : integer range 0 to 2 := 0;
			signal flag2 : integer range 0 to 2 := 0;
			signal flag3 : integer range 0 to 2 := 0;
			signal flag4 : integer range 0 to 2 := 0;
			signal flag5 : integer range 0 to 2 := 0;
			
			signal a00 : integer range 0 to 3 := 0;
			signal a01 : integer range 0 to 3 := 0;
			signal a02 : integer range 0 to 3 := 0;
			signal a10 : integer range 0 to 3 := 0;
			signal a11 : integer range 0 to 3 := 0;
			signal a12 : integer range 0 to 3 := 0;
			signal a20 : integer range 0 to 3 := 0;
			signal a21 : integer range 0 to 3 := 0;
			signal a22 : integer range 0 to 3 := 0;

			signal cur_color : integer range 0 to 3 := 1;
			signal OVER : integer range 0 to 2 := 0;

	 
			signal i : integer range 0 to 3 := 0;
         signal j : integer range 0 to 3 := 0;
			
         signal x1 : integer range 0 to 600 := 75;
         signal y1 : integer range 0 to 400 := 55;
			
			signal x2 : integer range 0 to 600 := 60;
         signal y2 : integer range 0 to 400 := 40;
			
			
begin

	clk_divide:process(clock)
	begin
		if (rising_edge(clock))then
			count <= count + 1;
			if(count = 25000000) then
				clock_1_Hz <= not clock_1_Hz;
			end if;
		end if;
	end process;
	
 -- On every positive edge of the clock counter condition is checked,
  output1: process(clock, clock_1_Hz)
              begin 
							
						  -- If the counter satisfy the condition, then output the colour that should appear
                    if rising_edge(clock) then
								pixels <= x"00";
								
								-- board
								if OVER = 0 and (( ((hcounter>155)and(hcounter<165)) or ((hcounter>475)and(hcounter<485)) ) 	or
										( ((vcounter>115)and(vcounter<125)) or ((vcounter>355)and(vcounter<365)) )	)									
										then
										pixels <= x"FF";
								end if;
								
								-- BOard Blinks at 1Hz after win
							  if clock_1_Hz='1' then
										--if flagc = 0 then
											if OVER =  1 and (( ((hcounter>155)and(hcounter<165)) or ((hcounter>475)and(hcounter<485)) ) 	or
											( ((vcounter>115)and(vcounter<125)) or ((vcounter>355)and(vcounter<365)) )	)									
											then
											pixels <= x"FF";
											end if;
										--end if;
										flagc <= 1;
							  end if;
							  
							  
							  --if clock_1_Hz='1' then
								--	flagc <= 0;
							  --end if;
	
								
								-- pointer
								if ((hcounter>=(x1 + dx*i) and hcounter<= x1+ dx*i+10) and(vcounter>=(y1+dy*j) and vcounter<=y1+dy*j+10)) then										
									if 	a00=0 and i=0 and j=0 then 
										pixels <= x"FF";
									elsif a01=0 and i=0 and j=1 then
										pixels <= x"FF";
									elsif a02=0 and i=0 and j=2 then
										pixels <= x"FF";
									elsif a10=0 and i=1 and j=0 then
										pixels <= x"FF";
									elsif a11=0 and i=1 and j=1 then
										pixels <= x"FF";
									elsif a12=0 and i=1 and j=2 then
										pixels <= x"FF";
									elsif a20=0 and i=2 and j=0 then
										pixels <= x"FF";
									elsif a21=0 and i=2 and j=1 then
										pixels <= x"FF";
									elsif a22=0 and i=2 and j=2 then
										pixels <= x"FF";
									end if;
								end if;
								
								-- RIGHT SHIFT @dx
								if (Switch (1) = '0') then
										if flag1 = 0 and i<2 then
											i <= i+1;
										end if;
										flag1 <=1 ;
								end if;
								
								if (Switch (1) = '1') then
									flag1<=0;
								end if;
								
								-- LEFT SHIFT @-dx
								if (Switch (0) = '0') then
										if flag2 = 0 and i>0 then
											i <= i-1;
										end if;
										flag2 <=1 ;
								end if;
								
								if (Switch (0) = '1') then
									flag2<=0;
								end if;
								
								-- DOWN SHIFT @dy
								if (Switch (2) = '0') then
										if flag3 = 0 and j<2 then
											j <= j+1;
										end if;
										flag3 <=1 ;
								end if;
								
								if (Switch (2) = '1') then
									flag3<=0;
								end if;
								
								-- UP SHIFT @+dy
								if (Switch (3) = '0') then
										if flag4 = 0 and j>0 then
											j <= j-1;
										end if;
										flag4 <=1 ;
								end if;
								
								if (Switch (3) = '1') then
									flag4<=0;
								end if;

								-- PUT
								if (OVER=0 and Switch (4) = '0') then
										if flag5 = 0 then
											if  a00=0 and i = 0 and j = 0 then
												a00 <= cur_color;
											elsif a01=0 and i = 0 and j = 1 then
												a01 <= cur_color;
											elsif a02=0 and i = 0 and j = 2 then
												a02 <= cur_color;
											elsif a10=0 and i = 1 and j = 0 then
												a10 <= cur_color;
											elsif a11=0 and i = 1 and j = 1 then
												a11 <= cur_color;
											elsif a12=0 and i = 1 and j = 2 then
												a12 <= cur_color;
											elsif a20=0 and i = 2 and j = 0 then
												a20 <= cur_color;
											elsif a21=0 and i = 2 and j = 1 then
												a21 <= cur_color;
											elsif a22=0 and i = 2 and j = 2 then
												a22 <= cur_color;
											end if;
											
											if cur_color=1 then
												cur_color <= 2;
											else
												cur_color <= 1;
											end if;
										end if;
										
										flag5 <=1 ;
								end if;
								
								if (Switch (4) = '1') then
									flag5<=0;
								end if;	
							
							
							   --------- RESET
								if Switch (5) = '0' then
									x<=10;
									y<=8;
									flag1 <= 0;
									flag2 <= 0;
									flag3 <= 0;
									flag4 <= 0;
									flag5 <= 0;
									
									a00 <= 0;
									a01 <= 0;
									a02 <= 0;
									a10 <= 0;
									a11 <= 0;
									a12 <= 0;
									a20 <= 0;
									a21 <= 0;
									a22 <= 0;
									
									cur_color<=1;
									OVER<=0;
									
									i<=0;
									j<=0;
									
									x1<=75;
									y1<=55;
									
									x2<=60;
									y2<=40;
								end if;
								
								-------------------------------------- Draw Box
								if( (hcounter>x2+dx*0 and hcounter<x2+dx*0+40) and (vcounter>y2+dy*0 and vcounter<y2+dy*0+40) ) then
									if a00 = 1 then
										pixels <= x"DD";
									elsif a00 = 2 then
										pixels <= x"EE";
									end if;
								end if;
								
								if( (hcounter>x2+dx*1 and hcounter<x2+dx*1+40) and (vcounter>y2+dy*0 and vcounter<y2+dy*0+40) ) then
									if a10 = 1 then
										pixels <= x"DD";
									elsif a10 = 2 then 
										pixels <= x"EE";
									end if;
								end if;
								
								if( (hcounter>x2+dx*2 and hcounter<x2+dx*2+40) and (vcounter>y2+dy*0 and vcounter<y2+dy*0+40) ) then
									if a20 = 1 then
										pixels <= x"DD";
									elsif a20 = 2 then
										pixels <= x"EE";
									end if;
								end if;
								
								----------------------
								
								if( (hcounter>x2+dx*0 and hcounter<x2+dx*0+40) and (vcounter>y2+dy*1 and vcounter<y2+dy*1+40) ) then
									if a01 = 1 then
										pixels <= x"DD";
									elsif a01 = 2 then
										pixels <= x"EE";
									end if;
								end if;
								
								if( (hcounter>x2+dx*1 and hcounter<x2+dx*1+40) and (vcounter>y2+dy*1 and vcounter<y2+dy*1+40) ) then
									if a11 = 1 then
										pixels <= x"DD";
									elsif a11 = 2 then 
										pixels <= x"EE";
									end if;
								end if;
								
								if( (hcounter>x2+dx*2 and hcounter<x2+dx*2+40) and (vcounter>y2+dy*1 and vcounter<y2+dy*1+40) ) then
									if a21 = 1 then
										pixels <= x"DD";
									elsif a21 = 2 then
										pixels <= x"EE";
									end if;
								end if;
								
								----------------------
								
								if( (hcounter>x2+dx*0 and hcounter<x2+dx*0+40) and (vcounter>y2+dy*2 and vcounter<y2+dy*2+40) ) then
									if a02 = 1 then
										pixels <= x"DD";
									elsif a02 = 2 then
										pixels <= x"EE";
									end if;
								end if;
								
								if( (hcounter>x2+dx*1 and hcounter<x2+dx*1+40) and (vcounter>y2+dy*2 and vcounter<y2+dy*2+40) ) then
									if a12 = 1 then
										pixels <= x"DD";
									elsif a12 = 2 then 
										pixels <= x"EE";
									end if;
								end if;
								
								if( (hcounter>x2+dx*2 and hcounter<x2+dx*2+40) and (vcounter>y2+dy*2 and vcounter<y2+dy*2+40) ) then
									if a22 = 1 then
										pixels <= x"DD";
									elsif a22 = 2 then
										pixels <= x"EE";
									end if;
								end if;	
							----------------------
							
							
							-- WINNING CONDITION
							
							if a11 /= 0 and (
								(a00 = a11 and a11 = a22) or
								(a02 = a11 and a11 = a20) 
							)then
								OVER<=1;
							end if;
					end if;
           end process;
			  
end Behavioral;