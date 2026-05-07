library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity uart_rx is
    generic(
        CLK_FREQ : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        rx_serial : in std_logic;
        rx_data : out std_logic_vector(7 downto 0);
        rx_done : out std_logic
        );
end uart_rx;

architecture Behavioral of uart_rx is

    constant CLKS_PER_SAMPLE : integer := CLK_FREQ / (BAUD_RATE * 16);

    type state_type is (IDLE, START, DATA, STOP);
    signal state : state_type := IDLE;

    signal sample_counter : integer range 0 to 15 := 0;
    signal clk_counter : integer range 0 to CLKS_PER_SAMPLE - 1 := 0;
    signal bit_index: integer range 0 to 7 := 0;
    signal rx_shift_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_done_reg : std_logic := '0';

begin

    rx_done <= rx_done_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            rx_done_reg <= '0';

            if rst = '1' then
                state <= IDLE;
                sample_counter <= 0;
                clk_counter <= 0;
                bit_index <= 0;
                rx_shift_reg <= (others => '0');
                rx_done_reg <= '0';

            else
                if clk_counter < CLKS_PER_SAMPLE - 1 then
                    clk_counter <= clk_counter + 1;
                else
                    clk_counter <= 0;

                    case state is

                        when IDLE =>
                            if rx_serial = '0' then
                                sample_counter <= 0;
                                state <= START;
                            end if;

                        when START =>
                            if sample_counter = 7 then
                                if rx_serial = '0' then
                                    sample_counter <= 0;
                                    state <= DATA;
                                else
                                    state <= IDLE;
                                end if;
                            else
                                sample_counter <= sample_counter + 1;
                            end if;

                        when DATA =>
                            if sample_counter = 7 then
                                rx_shift_reg(bit_index) <= rx_serial;
                            end if;
                            if sample_counter = 15 then
                                sample_counter <= 0;
                                if bit_index < 7 then
                                    bit_index <= bit_index + 1;
                                else
                                    bit_index <= 0;
                                    state <= STOP;
                                end if;
                            else
                                sample_counter <= sample_counter + 1;
                            end if;

                        when STOP =>
                            if sample_counter = 7 then
                                if rx_serial = '1' then
                                    rx_data <= rx_shift_reg;
                                    rx_done_reg <= '1';
                                end if;
                                sample_counter <= 0;
                                state <= IDLE;
                            else
                                sample_counter <= sample_counter + 1;
                            end if;

                    end case;
                end if;
            end if;
        end if;
    end process;

end Behavioral;