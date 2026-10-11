library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY ALU is
    PORT (
        S    : IN std_logic_vector (3 DOWNTO 0);
        A, B : IN std_logic_vector (15 DOWNTO 0);
        Cin  : IN std_logic;
        F    : OUT std_logic_vector (15 DOWNTO 0);
        Cout : OUT std_logic
    );
END ENTITY ALU;

architecture struct OF ALU IS

    component PARTB is
        PORT(
            S0, S1 : IN std_logic;
            A, B   : IN std_logic_vector(15 DOWNTO 0);
            F      : OUT std_logic_vector(15 DOWNTO 0)
        );
    end component PARTB;

    component PARTC is
        PORT(
            S0, S1, Cin : IN std_logic;
            A           : IN std_logic_vector(15 DOWNTO 0);
            F           : OUT std_logic_vector(15 DOWNTO 0);
            Cout        : OUT std_logic
        );
    end component PARTC;

    component PARTD is
        PORT(
            S0, S1, Cin : IN std_logic;
            A           : IN std_logic_vector(15 DOWNTO 0);
            F           : OUT std_logic_vector(15 DOWNTO 0);
            Cout        : OUT std_logic
        );
    end component PARTD;

    signal F_B, F_C, F_D : std_logic_vector(15 DOWNTO 0);
    signal cout_c, cout_d : std_logic;

begin

    U_PARTB: PARTB PORT MAP(
        S0 => S(0), S1 => S(1), A => A, B => B, F => F_B
    );

    U_PARTC: PARTC PORT MAP(
        S0 => S(0), S1 => S(1), Cin => Cin, A => A, F => F_C, Cout => cout_c
    );

    U_PARTD: PARTD PORT MAP(
        S0 => S(0), S1 => S(1), Cin => Cin, A => A, F => F_D, Cout => cout_d
    );


    F <= (others => '0') when (S(3) = '0' AND S(2) = '0') else
        F_B            when (S(3) = '0' AND S(2) = '1') else
        F_C            when (S(3) = '1' AND S(2) = '0') else
        F_D;

    Cout <= cout_c when (S(3) = '1' AND S(2) = '0') else
            cout_d when (S(3) = '1' AND S(2) = '1') else
            '0';

end architecture struct;