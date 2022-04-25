library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity PUFDec256_5 is
port(
	i_Sel : in std_logic_vector(7 downto 0);
	o_Q : out std_logic_vector(255 downto 0) -- Data value output
);
end PUFDec256_5;

architecture behavior of PUFDec256_5 is

begin



	--gen_ro_and_counters: for i in 0 to 511 generate
gener: for i in 0 to 255 generate
	process (i_Sel)
		begin
			if( i = unsigned(i_Sel)) then
				o_Q(i) <= '1';
			else
				o_Q(i) <= '0';
		end if;	

	end process;
end generate;	
--Possible alternate solution	


-- o_Q <= (i_Sel=>'1', OTHERS=>'0');	

end behavior;
