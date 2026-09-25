library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTB IS
    PORT(
        S0, S1 : IN std_LOGIC;
        A, B   : IN std_logic_vector(15 DOWNTO 0);
        F      : OUT std_logic_vector(15 DOWNTO 0)
    );
END PARTB;

architecture arch1 of PARTB is
begin
    F <= A and B when S0 = '0' AND S1 = '0' else
         A or B  when S0 = '1' AND S1 = '0' else
         A xor B when S0 = '0' AND S1 = '1' else
         not A;   

end architecture;  


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY PARTC IS
    PORT(
        S0 , S1 , Cin: IN std_LOGIC;
        A   : IN std_logic_vector(15 DOWNTO 0);
        F      : OUT std_logic_vector(15 DOWNTO 0)
    );
END PARTC;

architecture arch1 of PARTC is
begin
    F <= '0' & A(15 DOWNTO 1)  when S0 = '0' AND S1 = '0' else
         A(0) & A(15 DOWNTO 1)  when S0 = '1' AND S1 = '0' else
         Cin & A(15 DOWNTO 1) when S0 = '0' AND S1 = '1' else
         not A(15)& A(0) & A(14 DOWNTO 1);   

end architecture;


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



library IEEE;
use ieee.std_logic_1164.all;
ENTITY MUX4 IS 
    PORT(
            s3,s2        : IN std_logic;
            In_B, In_C, In_D : IN std_logic_vector(15 DOWNTO 0);
            F          : OUT std_logic_vector(15 DOWNTO 0)
        );
    end ENTITY;

architecture arch1 OF MUX4 IS 
    begin
        F <= (others => '0') when S2 = '0' AND S3 = '0' else
         In_B  when S2 = '1' AND S3 = '0' else
         In_C when S2 = '0' AND S3 = '1' else
         In_D;
    END architecture;

library IEEE;
use ieee.std_logic_1164.all;

ENTITY ALU is
    port (
        S : IN std_logic_vector (3 DOWNTO 0);
        A,B:IN std_logic_vector (15 DOWNTO 0);
        Cin : IN std_LOGIC ;
        F : OUT std_logic_vector (15 DOWNTO 0)
    );
    END ENTITY;



architecture struct OF ALU IS

   component PARTB is
        PORT(
            S0, S1 : IN std_logic;
            A, B   : IN std_logic_vector(15 DOWNTO 0);
            F      : OUT std_logic_vector(15 DOWNTO 0)
        );
    end component;

    component PARTC is
        PORT(
            S0, S1, Cin : IN std_logic;
            A           : IN std_logic_vector(15 DOWNTO 0);
            F           : OUT std_logic_vector(15 DOWNTO 0)
        );
    end component;


    component PARTD is
        PORT(
            S0, S1, Cin : IN std_logic;
            A           : IN std_logic_vector(15 DOWNTO 0);
            F           : OUT std_logic_vector(15 DOWNTO 0)
        );
    end component;

    component MUX4 IS
        PORT(
            s3,s2        : IN std_logic;
            In_B, In_C, In_D : IN std_logic_vector(15 DOWNTO 0);
            F          : OUT std_logic_vector(15 DOWNTO 0)
        );
        end component;

    signal F_B, F_C, F_D : std_logic_vector(15 DOWNTO 0);

begin
        U_PARTB: PARTB PORT MAP(S0 => S(0),S1 => S(1),A  => A,B  => B,F  => F_B);

        U_PARTD: PARTD PORT MAP(S0  => S(0),S1  => S(1),Cin => Cin,A   => A,F   => F_D);

        U_PARTC: PARTC PORT MAP(S0  => S(0),S1  => S(1),Cin => Cin,A   => A,F   => F_C);
        
        U: MUX4 PORT MAP(S3 => S(3),S2 => S(2) ,IN_B => F_B ,In_C=> F_C ,In_D => F_D , F => F);

        END architecture;