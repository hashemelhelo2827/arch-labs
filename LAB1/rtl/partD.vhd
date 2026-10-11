library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTD IS 
    PORT(
        S0, S1, Cin : IN std_logic;
        A           : IN std_logic_vector(15 DOWNTO 0);
        F           : OUT std_logic_vector(15 DOWNTO 0);
        Cout        : OUT std_logic 
    );
END ENTITY PARTD; 

architecture arch1 OF PARTD is
begin
    F <= (A(14 DOWNTO 0) & '0')   when (S1 = '0' AND S0 = '0') else  
         (A(14 DOWNTO 0) & A(15)) when (S1 = '0' AND S0 = '1') else  
         (A(14 DOWNTO 0) & Cin)  when (S1 = '1' AND S0 = '0') else  
         (others => '0');                                            

    Cout <= '0' when (S1 = '1' AND S0 = '1') else A(15);
end architecture arch1;
