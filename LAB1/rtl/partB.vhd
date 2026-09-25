library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTB IS
    PORT(
        S0, S1 : IN std_LOGIC;
        A, B   : IN std_logic_vector(15 DOWNTO 0);
        F      : OUT std_logic_vector(15 DOWNTO 0)
    );
END PARTB;

architecture arch1 of PARTB is
begin
    F <= A and B when S0 = '0' AND S1 = '0' else
         A or B  when S0 = '1' AND S1 = '0' else
         A xor B when S0 = '0' AND S1 = '1' else
         not A;   

end architecture;  