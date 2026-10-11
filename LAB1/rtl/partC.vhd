library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTC IS
    PORT(
        S0, S1, Cin : IN std_logic;
        A           : IN std_logic_vector(15 DOWNTO 0);
        F           : OUT std_logic_vector(15 DOWNTO 0);
        Cout        : OUT std_logic
    );
END ENTITY PARTC;

architecture arch1 of PARTC is
begin
    F <= ('0' & A(15 DOWNTO 1))   when (S1 = '0' AND S0 = '0') else  
         (A(0) & A(15 DOWNTO 1))  when (S1 = '0' AND S0 = '1') else  
         (Cin & A(15 DOWNTO 1))   when (S1 = '1' AND S0 = '0') else  
         (A(15) & A(15 DOWNTO 1));                                   

    Cout <= A(0);
end architecture arch1;