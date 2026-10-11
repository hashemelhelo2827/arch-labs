library ieee;
use ieee.STD_LOGIC_1164.all;

ENTITY adder IS
    PORT(
        A, B, Cin, E : IN std_logic;
        F, Cout      : OUT std_logic
    );
END ENTITY adder;

ARCHITECTURE arch1 OF adder IS
    SIGNAL b_mod : std_logic;
BEGIN
    b_mod <= B xor E;
    F <= ((A xor b_mod) xor Cin);
    Cout <= (A and b_mod) or ((A xor b_mod) and Cin);
END ARCHITECTURE arch1;


library ieee;
use ieee.STD_LOGIC_1164.all;

ENTITY PARTA IS
    GENERIC (
        n : INTEGER := 8
    );
    PORT (
        A, B       : IN std_logic_vector(n-1 DOWNTO 0);
        S          : IN std_logic_vector(1 DOWNTO 0);
        Cin        : IN std_logic;
        F          : OUT std_logic_vector(n-1 DOWNTO 0);
        Cout       : OUT std_logic 
    );
END ENTITY PARTA;

ARCHITECTURE arch1 OF PARTA IS

    COMPONENT adder IS
        PORT (
            A, B, Cin, E : IN std_logic;
            F, Cout      : OUT std_logic
        );
    END COMPONENT;
        
    SIGNAL temp       : std_logic_vector(n DOWNTO 0);
    SIGNAL B_modified : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL sum        : std_logic_vector(n-1 DOWNTO 0);
BEGIN

    WITH S SELECT
        B_modified <= (others => '0') WHEN "00", 
                      B               WHEN "01",
                      B               WHEN "10", 
                      (others => '0') WHEN OTHERS;


    temp(0) <= Cin;

    loop1 : FOR i IN 0 TO n-1 GENERATE
        fx : adder
        PORT MAP(
                A    => A(i),
                B    => B_modified(i),
                Cin  => temp(i),
                E    => S(1),
                F    => sum(i),
                Cout => temp(i+1)
                 );
                  
    END GENERATE;

    -- Operation S = "11" with Cin = 1 is defined as F = 0, Cout = 0.
    -- (The full adder would otherwise leave F = A + 2**n = A.)
    F    <= (others => '0') WHEN (S = "11" AND Cin = '1') ELSE sum;
    Cout <= '0'             WHEN (S = "11" AND Cin = '1') ELSE temp(n);

END ARCHITECTURE arch1;
