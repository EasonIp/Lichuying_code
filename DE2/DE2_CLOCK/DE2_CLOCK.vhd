LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
-- This code displays time in the DE2's LCD Display
-- Key2  resets time
ENTITY DE2_CLOCK IS
	PORT(reset, clk_50Mhz				: IN	STD_LOGIC;
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END DE2_CLOCK;

ARCHITECTURE a OF DE2_CLOCK IS
	TYPE STATE_TYPE IS (HOLD, FUNC_SET, DISPLAY_ON, MODE_SET, WRITE_CHAR1,
	WRITE_CHAR2,WRITE_CHAR3,WRITE_CHAR4,WRITE_CHAR5,WRITE_CHAR6,WRITE_CHAR7,
	WRITE_CHAR8, WRITE_CHAR9, WRITE_CHAR10 , RETURN_HOME, TOGGLE_E, RESET1, RESET2, 
	RESET3, DISPLAY_OFF, DISPLAY_CLEAR, SET_CGRAM1R1, SET_CGRAM1R2, SET_CGRAM1R3, SET_CGRAM1R4, SET_CGRAM1R5,
	SET_CGRAM1R6, SET_CGRAM1R7, SET_CGRAM1R8, SET_CH1R1, SET_CH1R2, SET_CH1R3, SET_CH1R4, SET_CH1R5, SET_CH1R6,
	SET_CH1R7, SET_CH1R8);
	SIGNAL state, next_command: STATE_TYPE;
	SIGNAL DATA_BUS_VALUE: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CLK_COUNT_400HZ: STD_LOGIC_VECTOR(19 DOWNTO 0);
	SIGNAL CLK_COUNT_10HZ: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CLK_400HZ, CLK_10HZ : STD_LOGIC;
BEGIN
	LCD_ON <= '1';
	LCD_E<='1';
-- BIDIRECTIONAL TRI STATE LCD DATA BUS
	DATA_BUS <= DATA_BUS_VALUE WHEN LCD_RW = '0' ELSE "ZZZZZZZZ";

	PROCESS
	BEGIN
	 WAIT UNTIL CLK_50MHZ'EVENT AND CLK_50MHZ = '1';
		IF RESET = '0' THEN
		 CLK_COUNT_400HZ <= X"00000";
		 CLK_400HZ <= '0';
		ELSE
				IF CLK_COUNT_400HZ < X"0F424" THEN 
				 CLK_COUNT_400HZ <= CLK_COUNT_400HZ + 1;
				ELSE
		    	 CLK_COUNT_400HZ <= X"00000";
				 CLK_400HZ <= NOT CLK_400HZ;
				END IF;
		END IF;
	END PROCESS;
	PROCESS (CLK_400HZ, reset)
	BEGIN
		IF reset = '0' THEN
			state <= RESET1;
			DATA_BUS_VALUE <= X"38";
			next_command <= RESET2;
			--LCD_E <= '1';
			LCD_RS <= '0';
			LCD_RW <= '0';

		ELSIF CLK_400HZ'EVENT AND CLK_400HZ = '1' THEN
-- GENERATE 1/10 SEC CLOCK SIGNAL FOR SECOND COUNT PROCESS
			IF CLK_COUNT_10HZ < 19 THEN
				CLK_COUNT_10HZ <= CLK_COUNT_10HZ + 1;
			ELSE
				CLK_COUNT_10HZ <= X"00";
				CLK_10HZ <= NOT CLK_10HZ;
			END IF;
-- SEND TIME TO LCD			
			CASE state IS
-- Set Function to 8-bit transfer and 2 line display with 5x8 Font size
-- see Hitachi HD44780 family data sheet for LCD command and timing details
				WHEN RESET1 =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= RESET2;
				WHEN RESET2 =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= RESET3;
				WHEN RESET3 =>
						---LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= FUNC_SET;
-- EXTRA STATES ABOVE ARE NEEDED FOR RELIABLE PUSHBUTTON RESET OF LCD
				WHEN FUNC_SET =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= DISPLAY_OFF;
-- Turn off Display and Turn off cursor
				WHEN DISPLAY_OFF =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"08";
						state <= TOGGLE_E;
						next_command <= DISPLAY_CLEAR;
-- Turn on Display and Turn off cursor
				WHEN DISPLAY_CLEAR =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"01";
						state <= TOGGLE_E;
						next_command <= DISPLAY_ON;
-- Turn on Display and Turn off cursor
				WHEN DISPLAY_ON =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"0C";
						state <= TOGGLE_E;
						next_command <= MODE_SET;
-- Set write mode to auto increment address and move cursor to the right
				WHEN MODE_SET =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"06";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R1;
--HERE WE ADD SOME CODES
               WHEN SET_CGRAM1R1 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"40";
						state <= TOGGLE_E;
						next_command <= SET_CH1R1;
			  
               WHEN SET_CH1R1 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"08";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R2;
						
			  WHEN SET_CGRAM1R2 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"41";
						state <= TOGGLE_E;
						next_command <= SET_CH1R2;
			  
               WHEN SET_CH1R2 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"0f";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R3;
			   
			   WHEN SET_CGRAM1R3 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"42";
						state <= TOGGLE_E;
						next_command <= SET_CH1R3;
			  
               WHEN SET_CH1R3 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"12";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R4;
						
			  WHEN SET_CGRAM1R4 =>
                      --  LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"43";
						state <= TOGGLE_E;
						next_command <= SET_CH1R4;
			  
               WHEN SET_CH1R4 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"0f";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R5;
						
			  WHEN SET_CGRAM1R5 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"44";
						state <= TOGGLE_E;
						next_command <= SET_CH1R5;
			  
               WHEN SET_CH1R5 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"0a";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R6;
						
			   WHEN SET_CGRAM1R6 =>
                      --  LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"45";
						state <= TOGGLE_E;
						next_command <= SET_CH1R6;
			  
               WHEN SET_CH1R6 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"1f";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R7;
			
			   WHEN SET_CGRAM1R7 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"46";
						state <= TOGGLE_E;
						next_command <= SET_CH1R7;
			  
               WHEN SET_CH1R7 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"02";
						state <= TOGGLE_E;
						next_command <= SET_CGRAM1R8;
						
			   WHEN SET_CGRAM1R8 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"47";
						state <= TOGGLE_E;
						next_command <= SET_CH1R8;
			  
               WHEN SET_CH1R8 =>
                       -- LCD_E <= '1';
                        LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"02";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR1;
--END ADDED CODES
-- Write ASCII hex character in first LCD character location
				WHEN WRITE_CHAR1 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"32";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR2;
-- Write ASCII hex character in second LCD character location
				WHEN WRITE_CHAR2 =>
					--	LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"30";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR3;
-- Write ASCII hex character in third LCD character location
				WHEN WRITE_CHAR3 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"30";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR4;
-- Write ASCII hex character in fourth LCD character location
				WHEN WRITE_CHAR4 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"39";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR5;
-- Write ASCII hex character in fifth LCD character location
				WHEN WRITE_CHAR5 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"31";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR6;
-- Write ASCII hex character in sixth LCD character location
				WHEN WRITE_CHAR6 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR7;
-- Write ASCII hex character in seventh LCD character location
				WHEN WRITE_CHAR7 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"32";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR8;
-- Write ASCII hex character in eighth LCD character location
				WHEN WRITE_CHAR8 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"35";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR9;
				WHEN WRITE_CHAR9 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"5f";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR10;
				WHEN WRITE_CHAR10 =>
						--LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"00";
						state <= TOGGLE_E;
						next_command <= RETURN_HOME;

						
				
-- Return write address to first character postion
				WHEN RETURN_HOME =>
						--LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"80";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR1;
-- The next two states occur at the end of each command to the LCD
-- Toggle E line - falling edge loads inst/data to LCD controller
				WHEN TOGGLE_E =>
						--LCD_E <= '0';--??WW
						state <= HOLD;
-- Hold LCD inst/data valid after falling edge of E line				
				WHEN HOLD =>
						state <= next_command;
			END CASE;
		END IF;
	END PROCESS;
END a;
