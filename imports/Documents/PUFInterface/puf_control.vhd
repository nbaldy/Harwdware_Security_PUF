----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:20:48 09/20/2011 
-- Design Name: 
-- Module Name:    puf_control - Behavioral 
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

entity puf_control is
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
end puf_control;

architecture Behavioral of puf_control is

	-- Number of entries
	constant MAX_RAM_ADDR: integer := 10;
	constant MAX_ADDR: std_logic_vector(MAX_RAM_ADDR-1 downto 0) := (others => '1');
	
	component uart_8051
		port(
			clk: in std_logic;
			rst: in std_logic;
			io_pin: in std_logic_vector(1 downto 0);
			rx: in std_logic;
			tx: out std_logic;
			readWrite: out std_logic;
			rec_data: out std_logic_vector(7 downto 0);
			xmit_data: in std_logic_vector(7 downto 0);
			ram_addr: out std_logic_vector(10 downto 0));
	end component;

	component ram2kx8
		port (
		clka: in std_logic;
		wea: in std_logic_vector(0 downto 0);
		addra: in std_logic_vector(MAX_RAM_ADDR downto 0);
		dina: in std_logic_vector(7 downto 0);
		douta: out std_logic_vector(7 downto 0));
	end component;

	component ram1kx8
		port (
		clka: in std_logic;
		wea: in std_logic_vector(0 downto 0);
		addra: in std_logic_vector(MAX_RAM_ADDR-1 downto 0);
		dina: in std_logic_vector(7 downto 0);
		douta: out std_logic_vector(7 downto 0));
	end component;

	type state_type is (
		waitForPufEnable, 
		getMemLoc1, 
		getMemLoc2, 
		pufCalc, 
		waitForUser);
		
	signal current_state : state_type := waitForPufEnable;
	signal next_state: state_type;
	
	signal rec_data: std_logic_vector(7 downto 0);
	signal ram_rw: std_logic;
	signal mem_data: std_logic_vector(7 downto 0);
	signal mem_data2: std_logic_vector(7 downto 0);
	signal xmit_data: std_logic_vector(7 downto 0);
	signal puf_addr: std_logic_vector(MAX_RAM_ADDR downto 0) := (others => '0');
	signal puf_addr2: std_logic_vector(MAX_RAM_ADDR-1 downto 0) := (others => '0');
	signal uart_addr: std_logic_vector(MAX_RAM_ADDR downto 0) := (others => '0');
	signal mem_addr: std_logic_vector(MAX_RAM_ADDR downto 0) := (others => '0');
	signal mem_addr2: std_logic_vector(MAX_RAM_ADDR-1 downto 0) := (others => '0');
	signal mem_out_en: std_logic;
	signal update_addr_en: std_logic;
	
begin
	
	RS232: uart_8051
		port map (
			clk => clk,
			rst => rst,
			io_pin => sw,
			rx => rx,
			tx => tx,
			readWrite => ram_rw,
			rec_data => rec_data,
			xmit_data => xmit_data,
			ram_addr => uart_addr);
	
	Memory_In : ram2kx8
		port map (
			clka => clk,
			wea(0) => ram_rw,
			addra => mem_addr,
			dina => rec_data,
			douta => mem_data
			);

	Memory_Out : ram1kx8
		port map (
			clka => clk,
			wea(0) => mem_out_en,
			addra => mem_addr2,
			dina => puf_output,
			douta => mem_data2
			);
			
	process(puf_en, uart_addr, puf_addr)
	begin
		case puf_en is
			when '0' => mem_addr <= uart_addr;
			when '1' => mem_addr <= puf_addr;
			when others => mem_addr <= (others => '0');
		end case;
	end process;
	
	process(puf_en, uart_addr, puf_addr2)
	begin
		if puf_en = '0' then
			mem_addr2 <= uart_addr(MAX_RAM_ADDR-1 downto 0);
		else
			mem_addr2 <= puf_addr2(MAX_RAM_ADDR-1 downto 0);
		end if;
	end process;
			
	-- process(sw(1), uart_addr, puf_addr2)
	-- begin
		-- case sw(1) is
			-- when '1' => mem_addr2 <= uart_addr(5 downto 0);
			-- when '0' => mem_addr2 <= puf_addr2(5 downto 0);
			-- when others => mem_addr2 <= (others => '0');
		-- end case;
	-- end process;
	
	--xmit_data <= mem_data2;
	process(sw(1), mem_data2, mem_data)
	begin
		case sw(1) is
			when '0' => xmit_data <= mem_data2;
			when '1' => xmit_data <= mem_data;
			when others => xmit_data <= (others => '0');
		end case;
	end process;

	process(clk, current_state, puf_addr, rst)
	begin
		if rst = '1' then
			puf_addr <= (others => '0');
		elsif rising_edge(clk) then
			if update_addr_en = '1' then
				puf_addr <= puf_addr + 1;
			end if;
		end if;
	end process;
	
	process(clk, puf_done, puf_en, rst)
	begin
		if puf_en = '0' or rst = '1' then
			puf_addr2 <= (others => '0');
		elsif rising_edge(clk) then
			if puf_done = '1' then
				puf_addr2 <= puf_addr2 + 1;
			end if;
		end if;
	end process;

	process(current_state, puf_en, mem_data, puf_done, puf_addr2)
	begin
		mem_out_en <= '1';
		led <= '0';
		update_addr_en <= '0';
		case current_state is
			
			when waitForPufEnable =>
				mem_out_en <= '0';
				if puf_en = '1' then
					next_state <= getMemLoc1;
				else
					next_state <= waitForPufEnable;
				end if;
			
			-- puf_input is 16bits, inputs are stored as 8bits.
			-- therefore fetch two values
			when getMemLoc1 =>
				puf_input(15 downto 8) <= mem_data;
				update_addr_en <= '1';
				next_state <= getMemLoc2;
			
			-- delay state
			when getMemLoc2 =>
				next_state <= pufCalc;
				
			when pufCalc =>
				puf_input(7 downto 0) <= mem_data;
				if puf_addr2 = MAX_ADDR then
					next_state <= waitForUser;
				elsif puf_done = '1' then
					update_addr_en <= '1';
					next_state <= waitForPufEnable;
				else
					next_state <= pufCalc;
				end if;
				
			when waitForUser =>
				mem_out_en <= '0';
				led <= '1';
				next_state <= waitForUser;
				
		end case;
	end process;
	
	fsm: process(clk, rst)
	begin
		if rst = '1' then
			current_state <= waitForPufEnable;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
end Behavioral;

