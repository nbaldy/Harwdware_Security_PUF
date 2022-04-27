----------------------------------------------------------------------------------
-- 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;


entity puf_1 is
	port(
		clk: in std_logic;
		rst: in std_logic;
		data_in: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(7 downto 0);
		done: out std_logic
		);
end puf_1;

architecture Behavioral of puf_1 is
    component PUFDec256_1 is
	port(
		i_Sel0 : in std_logic_vector(15 downto 0);
        o_Q0 : out std_logic_vector(255 downto 0)
	);
	end component;
    
	component PUFMux256_1 is
	port(
		i_D : in std_logic_vector(255 downto 0); -- Data value input
		i_Sel : in std_logic_vector(7 downto 0);
		o_Q : out std_logic -- Data value output
	);
	end component;
	
	signal s_clk_count: std_logic_vector(3 downto 0) := (others => '0');
	
--    signal s_decode_out : std_logic_vector(255 downto 0);
    signal s_decode_out: std_logic_vector(255 downto 0);
	signal s_decode_out0,s_decode_out1,s_decode_out2,s_decode_out3,s_decode_out4,s_decode_out5,s_decode_out6,s_decode_out7 : std_logic_vector(255 downto 0);
    signal s_enables : std_logic_vector(255 downto 0);
    
	signal s_mux_outputs_a,s_mux_outputs_a0,s_mux_outputs_a1,s_mux_outputs_a2,s_mux_outputs_a3,s_mux_outputs_a4,s_mux_outputs_a5,s_mux_outputs_a6,s_mux_outputs_a7 : std_logic_vector(7 downto 0);
	signal s_mux_outputs_b,s_mux_outputs_b0,s_mux_outputs_b1,s_mux_outputs_b2,s_mux_outputs_b3,s_mux_outputs_b4,s_mux_outputs_b5,s_mux_outputs_b6,s_mux_outputs_b7 : std_logic_vector(7 downto 0);
	
	signal s_mux_control_a, s_mux_control_a0,s_mux_control_a1,s_mux_control_a2,s_mux_control_a3,s_mux_control_a4,s_mux_control_a5,s_mux_control_a6,s_mux_control_a7 : std_logic_vector(7 downto 0);
	signal s_mux_control_b,s_mux_control_b0,s_mux_control_b1,s_mux_control_b2,s_mux_control_b3,s_mux_control_b4,s_mux_control_b5,s_mux_control_b6,s_mux_control_b7 : std_logic_vector(7 downto 0);
	
    signal s_dec_input : std_logic_vector(15 downto 0);
    
	signal s_ro_counters_a,s_ro_counters_a0,s_ro_counters_a1,s_ro_counters_a2,s_ro_counters_a3,s_ro_counters_a4,s_ro_counters_a5,s_ro_counters_a6,s_ro_counters_a7 : std_logic_vector(7 downto 0);
    signal s_ro_counters_b,s_ro_counters_b0,s_ro_counters_b1,s_ro_counters_b2,s_ro_counters_b3,s_ro_counters_b4,s_ro_counters_b5,s_ro_counters_b6,s_ro_counters_b7 : std_logic_vector(7 downto 0);
	
	signal ros0,ros1,ros2,ros3,ros4 : std_logic_vector(255 downto 0);
	signal s_ro_clks : std_logic_vector(255 downto 0);
	
    signal s_done : std_logic;
    signal s_data_out : std_logic_vector(7 downto 0);
    
	-- so the ro is not optimized away
	attribute keep: boolean;
	attribute keep of ros0,ros1,ros2,ros3,ros4: signal is true;
	attribute keep of s_decode_out: signal is true; -- TODO: remove this?
	
    
begin    

    -- Mux Control Signals
	
	-- Column0
	s_mux_control_a0 <= data_in(15 downto 8);
	s_mux_control_b0 <= data_in(7 downto 0);
	
	-- Column1
	s_mux_control_a0 <= data_in(15 downto 11) & data_in(2 downto 0);
	s_mux_control_b1 <= data_in(10 downto 3);
	
	-- Column2
	s_mux_control_a2 <= data_in(15 downto 14) & data_in(5 downto 0);
	s_mux_control_b2 <= data_in(13 downto 6);
	
	-- Column3
	s_mux_control_a3 <= data_in(8 downto 1);
	s_mux_control_b4 <= data_in(15 downto 9) & data_in(0);
	
	-- Column4
	s_mux_control_a4 <= data_in(11 downto 4);
	s_mux_control_b4 <= data_in(15 downto 12) & data_in(3 downto 0);
	
	-- Column5
	s_mux_control_a5 <= data_in(14 downto 7);
	s_mux_control_b5 <= data_in(15) & data_in(6 downto 0);
	
	-- Column6
	s_mux_control_a6 <= data_in(15 downto 10) & data_in(1 downto 0);
	s_mux_control_b6 <= data_in(9 downto 2);
	
	-- Column7
	s_mux_control_a7 <= data_in(15 downto 13) & data_in(4 downto 0);
	s_mux_control_b7 <= data_in(12 downto 5);
    
    s_dec_input(15 downto 8) <= s_mux_control_a;
    s_dec_input(7 downto 0) <= s_mux_control_b;
	
	

	
--	decoder: PUF8Dec256
--	port map(
--		i_Sel => s_dec_input,
--		o_Q => s_decode_out
--	);
	
    -- Generate the decoders
	gen_decoders: for i in 0 to 7 generate
		decoder: PUFDec256_1
            port map(
            i_Sel0 => s_dec_input(15 downto 0),
            o_Q0 => s_decode_out);
		
	end generate;
	
	
	-- Generate 256 ROs
	gen_ro_and_counters: for i in 0 to 255 generate
        
        s_enables(i) <= s_decode_out0(i) or s_decode_out1(i) or s_decode_out2(i) or s_decode_out3(i) or s_decode_out4(i) or s_decode_out5(i) or s_decode_out6(i) or s_decode_out7(i);
        
		--Generate the Ring Oscillators
		ros0(i) <= ros4(i) nand (not rst and s_enables(i));
		--ros(i)(0) <= ros(i)(4) nand (not rst);
		ros1(i) <= not ros0(i);
		ros2(i) <= not ros1(i);
		ros3(i) <= not ros2(i);
		ros4(i) <= not ros3(i);
		s_ro_clks(i) <= ros2(i);
		
	end generate;
	
    -- generate 16 muxs and counters
    gen_muxes: for i in 0 to 7 generate
	
		-- Port Map a Single Column of 2 Muxes
		MuxA_i : PUFMux256_1
		port map(
				i_D => s_ro_clks(255 downto 0), -- Data value input
				i_Sel => s_mux_control_a,
				o_Q => s_mux_outputs_a(i) -- Data value output
			);
			
		MuxB_i : PUFMux256_1
		port map(
				i_D => s_ro_clks(255 downto 0), -- Data value input
				i_Sel => s_mux_control_b,
				o_Q => s_mux_outputs_b(i) -- Data value output
			);
		
		-- Generate the ro counters
		ro_counter_a: process(s_mux_outputs_a(i), rst)
        begin
            if(rst = '1') then
                s_ro_counters_a <= "00000000";
            elsif rising_edge(s_mux_outputs_a(i)) then
                    if(s_done = '1') then
                        s_ro_counters_a <= "00000000";
                    else
                        s_ro_counters_a <= s_ro_counters_a + 1;
                    end if;
            end if;
        end process;

		ro_counter_b: process(s_mux_outputs_b(i), rst)
        begin
            if(rst = '1') then
                s_ro_counters_b <= "00000000";
            elsif rising_edge(s_mux_outputs_b(i)) then
                    if(s_done = '1') then
                        s_ro_counters_b <= "00000000";
                    else
                        s_ro_counters_b <= s_ro_counters_b + 1;
                    end if;
            end if;
        end process;

	end generate;
	
    -- compare the 8 pairs of counters and set the output bits
    gen_comparisons: for i in 0 to 7 generate
        
        comparisons: process(s_ro_counters_a(i), s_ro_counters_b(i))
        begin
            if(s_ro_counters_a(i) > s_ro_counters_b(i)) then
                s_data_out(i) <= '1';
            else
                s_data_out(i) <= '0';
            end if;
            
        end process;
    end generate;
    
    -- count the clock values
	process(clk, s_clk_count, rst)
	begin
		if rst = '1' then
			s_clk_count <= (others => '0');
		elsif rising_edge(clk) then
			s_clk_count <= s_clk_count + 1;
			if s_clk_count = "1111" then
				s_clk_count <= (others => '0');
			end if;
		end if;
	end process;
	
    -- set the output on the last cycle
	process(clk, s_clk_count)
	begin
		if rising_edge(clk) then
			if s_clk_count = "1111" then
				data_out <= s_data_out;
			else
				data_out <= (others => '0');
			end if;
		end if;
	end process;
	
    -- set the done flag on the last cycle
	process(clk, s_clk_count)
	begin
		if rising_edge(clk) then
			if s_clk_count = "1111" then
				s_done <= '1';
			else
				s_done <= '0';
			end if;
		end if;
	end process;
	
    done <= s_done;

end Behavioral;

