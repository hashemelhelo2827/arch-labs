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