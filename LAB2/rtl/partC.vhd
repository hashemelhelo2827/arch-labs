library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTC IS
    generic(
        n:integer := 8
    );
    PORT(
        Cin         : IN std_logic;
        S           : IN std_logic_vector(1 DOWNTO 0);
        A           : IN std_logic_vector(n-1 DOWNTO 0);
        F           : OUT std_logic_vector(n-1 DOWNTO 0);
        Cout        : OUT std_logic
    );
END ENTITY PARTC;

architecture arch1 of PARTC is
begin
    with S select
        F <= ('0' & A(n-1 DOWNTO 1))    when "00",
             (A(0) & A(n-1 DOWNTO 1))   when "01",
             (Cin & A(n-1 DOWNTO 1))    when "10",
             (A(n-1) & A(n-1 DOWNTO 1)) when others;   -- "11"

    Cout <= A(0);
end architecture arch1;
