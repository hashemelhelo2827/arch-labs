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
    F    <= (others => '0') WHEN (S = "11" AND Cin = '1') ELSE sum;
    Cout <= '0'             WHEN (S = "11" AND Cin = '1') ELSE temp(n);

END ARCHITECTURE arch1;


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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTD IS 
    generic (
        n : integer := 8
    );
    PORT(
        Cin         : IN std_logic;
        S    : IN std_logic_vector(1 DOWNTO 0);
        A           : IN std_logic_vector(n-1 DOWNTO 0);
        F           : OUT std_logic_vector(n-1 DOWNTO 0);
        Cout        : OUT std_logic 
    );
END ENTITY PARTD; 

architecture arch1 OF PARTD is
begin
     with S select
        F <= (A(n-2 DOWNTO 0) & '0')    when "00",
             (A(n-2 DOWNTO 0) & A(n-1)) when "01",
             (A(n-2 DOWNTO 0) & Cin)    when "10",
             (others => '0')            when others;   -- "11"

    Cout <= '0' when S = "11" else A(n-1);
end architecture arch1;


library ieee;
use ieee.STD_LOGIC_1164.all;

ENTITY ALU is
    generic(
        n : integer := 16
    );
    PORT(
        Cin  : IN std_logic;
        S    : IN std_logic_vector(3 DOWNTO 0);
        A, B : IN std_logic_vector(n-1 DOWNTO 0);
        F    : OUT std_logic_vector(n-1 DOWNTO 0);
        Cout : OUT std_logic
    );
end entity ALU;

architecture arch1 of ALU IS
    
    component PARTA IS
        generic(
            n : integer
        ); 
        PORT (
            A, B : IN std_logic_vector(n-1 DOWNTO 0);
            S    : IN std_logic_vector(1 DOWNTO 0);
            Cin  : IN std_logic;
            F    : OUT std_logic_vector(n-1 DOWNTO 0);
            Cout : OUT std_logic 
        );
    end component PARTA;

    component PARTB IS 
        generic(
            n : integer
        );
        PORT(
            S    : IN std_logic_vector(1 DOWNTO 0);
            A, B : IN std_logic_vector(n-1 DOWNTO 0);
            F    : OUT std_logic_vector(n-1 DOWNTO 0)
        );
    end component PARTB;

    component PARTC IS
        generic(
            n : integer
        );
        PORT(
            Cin  : IN std_logic;
            S    : IN std_logic_vector(1 DOWNTO 0);
            A    : IN std_logic_vector(n-1 DOWNTO 0);
            F    : OUT std_logic_vector(n-1 DOWNTO 0);
            Cout : OUT std_logic
        );
    end component PARTC;

    component PARTD IS 
        generic (
            n : integer
        );
        PORT(
            Cin  : IN std_logic;
            S    : IN std_logic_vector(1 DOWNTO 0);
            A    : IN std_logic_vector(n-1 DOWNTO 0);
            F    : OUT std_logic_vector(n-1 DOWNTO 0);
            Cout : OUT std_logic 
        );
    end component PARTD; 

    signal F_A, F_B, F_C, F_D : std_logic_vector(n-1 DOWNTO 0);
    signal cout_a, cout_c, cout_d : std_logic;

begin

    U_PARTA: PARTA 
        generic map (n => n)
        PORT MAP(
            S => S(1 downto 0), A => A, B => B, Cin => Cin, F => F_A, Cout => cout_a
        );

    U_PARTB: PARTB 
        generic map (n => n)
        PORT MAP(
            S => S(1 downto 0), A => A, B => B, F => F_B
        );

    U_PARTC: PARTC 
        generic map (n => n)
        PORT MAP(
            S => S(1 downto 0), Cin => Cin, A => A, F => F_C, Cout => cout_c
        );

    U_PARTD: PARTD 
        generic map (n => n)
        PORT MAP(
            S => S(1 downto 0), Cin => Cin, A => A, F => F_D, Cout => cout_d
        );

    WITH S(3 DOWNTO 2) SELECT
        F <= F_A WHEN "00", 
             F_B WHEN "01",
             F_C WHEN "10", 
             F_D WHEN OTHERS; 
             
    WITH S(3 DOWNTO 2) SELECT
        Cout <= cout_a WHEN "00", 
                '0'    WHEN "01",
                cout_c WHEN "10", 
                cout_d WHEN OTHERS;

end architecture arch1;
