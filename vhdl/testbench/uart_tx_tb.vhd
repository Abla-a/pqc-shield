library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_tx_tb is
end uart_tx_tb;

architecture Behavioral of uart_tx_tb is

    component uart_tx
        Generic(
            CLK_FREQ  : integer := 100000000;
            BAUD_RATE : integer := 9600
        );
        Port(
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            tx_start  : in  STD_LOGIC;
            tx_data   : in  STD_LOGIC_VECTOR(7 downto 0);
            tx_serial : out STD_LOGIC;
            tx_done   : out STD_LOGIC;
            tx_busy   : out STD_LOGIC
        );
    end component;

    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '1';
    signal tx_start  : STD_LOGIC := '0';
    signal tx_data   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tx_serial : STD_LOGIC;
    signal tx_done   : STD_LOGIC;
    signal tx_busy   : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    clk <= not clk after CLK_PERIOD / 2;

    DUT: uart_tx
        generic map(
            CLK_FREQ  => 100000000,
            BAUD_RATE => 9600
        )
        port map(
            clk       => clk,
            rst       => rst,
            tx_start  => tx_start,
            tx_data   => tx_data,
            tx_serial => tx_serial,
            tx_done   => tx_done,
            tx_busy   => tx_busy
        );

    process
    begin
        wait for 200 ns;
        rst <= '0';

        wait for 1 us;
        tx_data  <= "01000001";
        tx_start <= '1';
        wait for CLK_PERIOD;
        tx_start <= '0';

        wait until tx_done = '1';
        wait for 10 us;

        tx_data  <= "01010101";
        tx_start <= '1';
        wait for CLK_PERIOD;
        tx_start <= '0';

        wait until tx_done = '1';
        wait for 50 us;

        report "Simulation complete" severity NOTE;
        wait;
    end process;

end Behavioral;
