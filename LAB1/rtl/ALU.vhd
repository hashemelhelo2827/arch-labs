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