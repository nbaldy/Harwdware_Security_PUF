----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:44:42 09/21/2011 
-- Design Name: 
-- Module Name:    puf_top - Behavioral 
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

entity puf_top is
	port(
		clk: in std_logic;
		rst: in std_logic;
		rx: in std_logic;
		tx: out std_logic;
		puf_en: in std_logic;
		sw : in std_logic_vector(1 downto 0);
		led: out std_logic;
		switch: in std_logic_vector(2 downto 0)
		);
end puf_top;

architecture Behavioral of puf_top is

component puf_control
	port(
		clk: in std_logic;
		rst: in std_logic;
		rx: in std_logic;
		tx: out std_logic;
		puf_en: in std_logic;
		sw : in std_logic_vector(1 downto 0);
		led: out std_logic;
		puf_input: out std_logic_vector(15 downto 0);
		puf_output: in std_logic_vector(7 downto 0);
		puf_done: in std_logic
		);
end component;

component puf
	port(
		clk: in std_logic;
		rst: in std_logic;
		data_in: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(7 downto 0);
		done: out std_logic
		);
end component;

component puf2
	port(
		clk: in std_logic;
		rst: in std_logic;
		data_in: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(7 downto 0);
		done: out std_logic
		);
end component;

signal puf_input: std_logic_vector(15 downto 0);
signal puf_output: std_logic_vector(7 downto 0);
signal puf_done: std_logic;

signal puf_in0, puf_in1, puf_in2, puf_in3 : std_logic_vector(15 downto 0);
signal puf_in4, puf_in5, puf_in6, puf_in7 : std_logic_vector(15 downto 0);
signal puf_out0, puf_out1, puf_out2, puf_out3 : std_logic_vector(7 downto 0);
signal puf_out4, puf_out5, puf_out6, puf_out7 : std_logic_vector(7 downto 0);
signal puf_done0, puf_done1, puf_done2, puf_done3 : std_logic;
signal puf_done4, puf_done5, puf_done6, puf_done7 : std_logic;

begin

	puf_input_mux: process(switch, puf_input)
	begin
		case switch is
			when "000" => puf_in0 <= puf_input;
			when "001" => puf_in1 <= puf_input;
			when "010" => puf_in2 <= puf_input;
			when "011" => puf_in3 <= puf_input;
			when "100" => puf_in4 <= puf_input;
			when "101" => puf_in5 <= puf_input;
			when "110" => puf_in6 <= puf_input;
			when "111" => puf_in7 <= puf_input;
			when others => puf_in0 <= (others => '0');
		end case;
	end process;
	
	puf_output_mux: process(switch, puf_out0, puf_out1, puf_out2, puf_out3, puf_out4, puf_out5, puf_out6, puf_out7)
	begin
		case switch is
			when "000" => puf_output <= puf_out0;
			when "001" => puf_output <= puf_out1;
			when "010" => puf_output <= puf_out2;
			when "011" => puf_output <= puf_out3;
			when "100" => puf_output <= puf_out4;
			when "101" => puf_output <= puf_out5;
			when "110" => puf_output <= puf_out6;
			when "111" => puf_output <= puf_out7;
			when others => puf_output <= (others => '0');
		end case;
	end process;
	
	puf_done_mux: process(switch, puf_done0, puf_done1, puf_done2, puf_done3, puf_done4, puf_done5, puf_done6, puf_done7)
	begin
		case switch is
			when "000" => puf_done <= puf_done0;
			when "001" => puf_done <= puf_done1;
			when "010" => puf_done <= puf_done2;
			when "011" => puf_done <= puf_done3;
			when "100" => puf_done <= puf_done4;
			when "101" => puf_done <= puf_done5;
			when "110" => puf_done <= puf_done6;
			when "111" => puf_done <= puf_done7;
			when others => puf_done <= '0';
		end case;
	end process;
	
	Controller: puf_control
		port map (
			clk => clk,
			rst => rst,
			rx => rx,
			tx => tx,
			puf_en => puf_en,
			sw => sw,
			led => led,
			puf_input => puf_input,
			puf_output => puf_output,
			puf_done => puf_done
			);
			
	Puf_circuit0: puf
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in0,
			data_out => puf_out0,
			done => puf_done0
			);
			
	Puf_circuit1: puf
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in1,
			data_out => puf_out1,
			done => puf_done1
			);
			
	Puf_circuit2: puf
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in2,
			data_out => puf_out2,
			done => puf_done2
			);
			
	Puf_circuit3: puf
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in3,
			data_out => puf_out3,
			done => puf_done3
			);
			
	Puf_circuit4: puf
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in4,
			data_out => puf_out4,
			done => puf_done4
			);
			
	Puf_circuit5: puf2
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in5,
			data_out => puf_out5,
			done => puf_done5
			);
			
	Puf_circuit6: puf
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in6,
			data_out => puf_out6,
			done => puf_done6
			);
			
	Puf_circuit7: puf2
		port map (
			clk => clk,
			rst => rst,
			data_in => puf_in7,
			data_out => puf_out7,
			done => puf_done7
			);

end Behavioral;

