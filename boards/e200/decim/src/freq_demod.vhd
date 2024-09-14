library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity freq_demod is
    port ( 
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_I_data : in std_logic_vector(15 downto 0);
        i_I_valid : in std_logic;
        i_Q_data : in std_logic_vector(15 downto 0);
        i_Q_valid : in std_logic;
        o_data : out std_logic_vector(31 downto 0);
        o_valid : out std_logic
    );
end freq_demod;

architecture behavior of freq_demod is
    
    signal I_data_z1 : signed(15 downto 0) := to_signed(0, 16);
    signal I_data_z2 : signed(15 downto 0) := to_signed(0, 16);
    signal Q_data_z1 : signed(15 downto 0) := to_signed(0, 16);
    signal Q_data_z2 : signed(15 downto 0) := to_signed(0, 16);
    
    signal diff_I : signed(15 downto 0) := to_signed(0, 16);
    signal diff_Q : signed(15 downto 0) := to_signed(0, 16);
    
    signal prod_I : signed(31 downto 0) := to_signed(0, 32);
    signal prod_Q : signed(31 downto 0) := to_signed(0, 32);

    signal freq : signed(31 downto 0) := to_signed(0, 32);

    signal valid : std_logic_vector(2 downto 0) := (others => '0');
    
begin

    delay : process(i_clk)
    begin
        if (rising_edge(i_clk)) then
            if (i_I_valid = '1') then
                I_data_z1 <= signed(i_I_data);
                I_data_z2 <= I_data_z1;
            end if;
            if (i_Q_valid = '1') then
                Q_data_z1 <= signed(i_Q_data);
                Q_data_z2 <= Q_data_z1;
            end if;
            valid(2 downto 1) <= valid(1 downto 0);
            valid(0) <= i_I_valid;
        end if;
    end process;

    work : process(i_clk)
    begin
        if (rising_edge(i_clk)) then
            diff_I <= signed(i_I_data) - I_data_z2;
            diff_Q <= signed(i_Q_data) - Q_data_z2;
            
            prod_I <= diff_I * Q_data_z2;
            prod_Q <= diff_Q * I_data_z2;

            freq <= prod_Q - prod_I;
        end if;
    end process;
    
    output : process(i_clk, i_rst)
    begin
        if (i_rst = '1') then
            o_data <= (others => '0');
            o_valid <= '0';
        elsif (rising_edge(i_clk)) then
            if (valid(2) = '1') then
                o_data <= std_logic_vector(freq);
                o_valid <= valid(2);
            else
                o_valid <= '0';
            end if;
        end if;
    end process;
    

end behavior;
