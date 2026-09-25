library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTC IS
    PORT(
        S0 , S1 , Cin: IN std_LOGIC;
        A   : IN std_logic_vector(15 DOWNTO 0);
        F      : OUT std_logic_vector(15 DOWNTO 0)
    );
END PARTC;

architecture arch1 of PARTC is
begin
    F <= '0' & A(15 DOWNTO 1)  when S0 = '0' AND S1 = '0' else
         A(0) & A(15 DOWNTO 1)  when S0 = '1' AND S1 = '0' else
         Cin & A(15 DOWNTO 1) when S0 = '0' AND S1 = '1' else
         not A(15)& A(0) & A(14 DOWNTO 1);   

end architecture;