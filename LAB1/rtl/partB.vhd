library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTB IS
    PORT(
        S0, S1 : IN std_logic;
        A, B   : IN std_logic_vector(15 DOWNTO 0);
        F      : OUT std_logic_vector(15 DOWNTO 0)
    );
END ENTITY PARTB;

architecture arch1 of PARTB is
begin
    F <= (A and B) when (S1 = '0' AND S0 = '0') else
         (A or B)  when (S1 = '0' AND S0 = '1') else
         (A xor B) when (S1 = '1' AND S0 = '0') else
         (not A);
end architecture arch1;