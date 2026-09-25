library IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PARTD IS 
    PORT(
        S0 , S1 , Cin : IN  std_LOGIC;
        A : IN std_logic_vector (15 DOWNTO 0 );
        F : OUT std_logic_vector (15 DOWNTO 0)
    );
    END PARTD ; 

architecture arch1 OF PARTD is
    begin
        F <= A(14 DOWNTO 0) & '0' WHEN S0= '0' AND S1 = '0' else
            A(14 DOWNTO 0) & A(15) WHEN S0= '0' AND S1 = '1' else
            A(14 DOWNTO 0) & Cin WHEN S0= '1' AND S1 = '0' else
                (others => '0');
    end architecture;