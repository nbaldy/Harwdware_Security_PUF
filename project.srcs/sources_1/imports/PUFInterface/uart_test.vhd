----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:02:08 07/23/2011 
-- Design Name: 
-- Module Name:    uart_8051 - Behavioral 
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
use ieee.std_logic_unsigned.all;

entity uart_8051 is
	port(
	clk: in std_logic;
	rst: in std_logic;
	io_pin: in std_logic_vector(1 downto 0);
	rx: in std_logic;
	tx: out std_logic;
	readWrite: out std_logic;
	rec_data: out std_logic_vector(7 downto 0);
	xmit_data: in std_logic_vector(7 downto 0);
	ram_addr: out std_logic_vector(10 downto 0)
	);
end uart_8051;

architecture Behavioral of uart_8051 is

	constant MAX_RAM_ADDR: integer := 10;
	
    component uart
    port(
         sys_clk : in  std_logic;
         sys_rst_l : in  std_logic;
         uart_clk : out  std_logic;
         uart_XMIT_dataH : out  std_logic;
         xmitH : in  std_logic;
         xmit_dataH : in  std_logic_vector(7 downto 0);
         xmit_doneH : out  std_logic;
         uart_REC_dataH : in  std_logic;
         rec_dataH : out  std_logic_vector(7 downto 0);
         rec_readyH : out  std_logic
        );
    end component;
	
	-- uart_8051 Inputs
	signal xmitH : std_logic := '0';

	-- uart_8051 Outputs
	signal uart_clk : std_logic;
	signal xmit_doneH : std_logic;
	signal rec_readyH : std_logic;

	-- state machine
	type state_type is (
		readOrWrite, 
		output, 
		waitForXmit, 
		updateXmit, 
		waitForRec, 
		updateRec, 
		doneWrite, 
		done);
		
	signal current_state : state_type := readOrWrite;
	signal next_state: state_type;

	-- Memory
	-- signal ram_addr: std_logic_vector(MAX_RAM_ADDR downto 0) := (others => '0');
	constant INT_MAX: std_logic_vector(MAX_RAM_ADDR downto 0) := "01111111111";
	constant INSTR_MAX: std_logic_vector(MAX_RAM_ADDR downto 0) := "11111111111";
	
	-- misc
	signal rec_rdy_new: std_logic := '0';
	signal rec_rdy_old: std_logic := '0';
	signal rst_low: std_logic;
	
	signal rec_data2: std_logic_vector(7 downto 0);
	signal ram_addr2 : std_logic_vector(MAX_RAM_ADDR downto 0);
	signal tmp_enable: std_logic := '0';
	signal tmp_max: std_logic_vector(MAX_RAM_ADDR downto 0);
   
begin

	-- uart_8051 takes active low reset
	rst_low <= not rst;
	rec_data <= rec_data2;
	ram_addr <= ram_addr2;
	
	tmp_max <= INT_MAX when io_pin(1) = '0' else INSTR_MAX;
	--tmp_max <= INT_MAX;
	
   muart: uart PORT MAP (
          sys_clk => clk,
          sys_rst_l => rst_low,
          uart_clk => uart_clk,
          uart_XMIT_dataH => tx,
          xmitH => xmitH,
          xmit_dataH => xmit_data,
          xmit_doneH => xmit_doneH,
          uart_REC_dataH => rx,
          rec_dataH => rec_data2,
          rec_readyH => rec_readyH
        );
	
	fsm: process(uart_clk, rst)
	begin
		if rst = '1' then
			current_state <= readOrWrite;
		elsif rising_edge(uart_clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process(current_state, xmit_doneH, io_pin, rec_rdy_new)
	begin
		readWrite <= '0';
		xmitH <= '0';
		case current_state is
			
			when readOrWrite =>
				if io_pin(0) = '1' then
					next_state <= waitForRec;
				else
					next_state <= output;
				end if;
			
			when output =>
				xmitH <= '1';
				next_state <= waitForXmit;
			
			when waitForXmit =>
				if xmit_doneH = '1' then
					next_state <= updateXmit;
				else
					next_state <= waitForXmit;
				end if;
			
			when updateXmit =>
				if ram_addr2 = tmp_max then
					next_state <= done;
				else
					next_state <= output;
				end if;
			
			when waitForRec =>
				if tmp_enable = '0' then
					next_state <= waitForRec;	
				elsif rec_rdy_new = '1' then
					next_state <= updateRec;
				elsif io_pin(0) = '0'  then
					next_state <= output;
				else
					next_state <= waitForRec;
				end if;
					
			when updateRec =>
				readWrite <= '1';
				if ram_addr2 = INSTR_MAX then
					next_state <= doneWrite;
				else
					next_state <= waitForRec;
				end if;
				
			when doneWrite =>
				if io_pin(0) = '0' then
					next_state <= output;
				else
					next_state <= doneWrite;
				end if;
				
			when done =>
				if io_pin(0) = '1' then
					next_state <= waitForRec;
				else
					next_state <= done;
				end if;
				
		end case;
	end process;
	
	-- Updates the address of the instruction RAM
	addr_update: process(current_state, uart_clk, rst, io_pin)
	begin
		if rst = '1' or (current_state = waitForRec and io_pin(0) = '0') then
			ram_addr2 <= (others => '0');
		elsif rising_edge(uart_clk) then
			if current_state = updateRec or current_state = updateXmit then
				ram_addr2 <= ram_addr2 + 1;
			else
				ram_addr2 <= ram_addr2;
			end if;
		end if;
	end process;
	
	-- Simple rising edge detection circuit, outputs a pulse when
	-- uart_8051 received line is stable
	edge_detector: process(uart_clk, rec_readyH, rst)
	begin
		if rst = '1' then
		elsif rising_edge(uart_clk) then
			rec_rdy_old <= rec_readyH;
		end if;
	end process;
	rec_rdy_new <= (not rec_rdy_old) and rec_readyH;
	
	process(uart_clk, current_state, rst)
	begin
		if rst = '1' then
			tmp_enable <= '0';
		elsif rising_edge(uart_clk) then
			if current_state = waitForRec and tmp_enable = '0' then
				tmp_enable <= '1';
			end if;
		end if;
	end process;
	
end Behavioral;

