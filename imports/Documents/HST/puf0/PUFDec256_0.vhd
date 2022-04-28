library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity PUFDec2560 is
port(
	i_Sel0 : in std_logic_vector(15 downto 0);
	o_Q0 : out std_logic_vector(255 downto 0) -- Data value output
);
end PUFDec2560;

architecture behavior of PUFDec2560 is

begin



	--gen_ro_and_counters: for i in 0 to 511 generate
gener: for i in 0 to 255 generate
	process (i_Sel0)
		begin
			if( i = unsigned(i_Sel0)) then
				o_Q0(i) <= '1';
			else
				o_Q0(i) <= '0';
		end if;	

	end process;
end generate;	
--Possible alternate solution	


-- o_Q <= (i_Sel=>'1', OTHERS=>'0');	

end behavior;
