library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTB IS
    generic (
        n : integer := 8
    );
    PORT(
        S    : IN std_logic_vector(1 DOWNTO 0);
        A, B : IN std_logic_vector(n-1 DOWNTO 0);
        F    : OUT std_logic_vector(n-1 DOWNTO 0)
    );
END ENTITY PARTB;

ARCHITECTURE arch1 OF PARTB IS
begin
    with S select
        F <= A and B when "00",
             A or B  when "01",
             A nor B when "10",
             not A   when others;   -- "11"
END ARCHITECTURE arch1;
