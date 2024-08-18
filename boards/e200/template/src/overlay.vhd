library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity overlay is
    port ( 
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_I0_data : in std_logic_vector(15 downto 0);
        i_I0_valid : in std_logic;
        i_Q0_data : in std_logic_vector(15 downto 0);
        i_Q0_valid : in std_logic;
        i_I1_data : in std_logic_vector(15 downto 0);
        i_I1_valid : in std_logic;
        i_Q1_data : in std_logic_vector(15 downto 0);
        i_Q1_valid : in std_logic;
        o_I0_data : out std_logic_vector(15 downto 0);
        o_I0_valid : out std_logic;
        o_Q0_data : out std_logic_vector(15 downto 0);
        o_Q0_valid : out std_logic;
        o_I1_data : out std_logic_vector(15 downto 0);
        o_I1_valid : out std_logic;
        o_Q1_data : out std_logic_vector(15 downto 0);
        o_Q1_valid : out std_logic
    );
end overlay;

architecture behavior of overlay is

    
    
begin

    process(i_clk)
    begin
        if(rising_edge(i_clk)) then
            o_I0_data <= i_I0_data;
            o_I0_valid <= i_I0_valid;
            o_Q0_data <= i_Q0_data;
            o_Q0_valid <= i_Q0_valid;
            o_I1_data <= i_I1_data;
            o_I1_valid <= i_I1_valid;
            o_Q1_data <= i_Q1_data;
            o_Q1_valid <= i_Q1_valid;
        end if;
    end process;

end behavior;
