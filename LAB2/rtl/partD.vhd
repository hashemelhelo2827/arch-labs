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
