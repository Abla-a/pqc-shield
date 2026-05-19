library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_tx is
    Generic (
        CLK_FREQ  : integer := 100000000; -- System clock in Hz (default 100MHz)
        BAUD_RATE : integer := 9600       -- UART baud rate
    );
    Port (
        clk       : in  STD_LOGIC;                     -- System clock
        rst       : in  STD_LOGIC;                     -- Active-high synchronous reset
        tx_start  : in  STD_LOGIC;                     -- Pulse high for 1 cycle to begin transmission
        tx_data   : in  STD_LOGIC_VECTOR(7 downto 0);  -- Byte to transmit
        tx_serial : out STD_LOGIC;                     -- UART TX line output
        tx_done   : out STD_LOGIC;                     -- Pulses high 1 cycle when transmission complete
        tx_busy   : out STD_LOGIC                      -- High while transmitting, ignore tx_start when busy
    );
end uart_tx;

architecture Behavioral of uart_tx is

    -- Number of clock cycles per UART bit period
    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;

    -- FSM states: IDLE waits for start, START sends start bit,
    -- DATA sends 8 bits LSB first, STOP sends stop bit
    type state_type is (IDLE, START, DATA, STOP);
    signal state : state_type := IDLE;

    -- Internal registered versions of outputs (avoids output port read-back issues)
    signal tx_serial_reg : STD_LOGIC := '1'; -- Line idles HIGH in UART
    signal tx_done_reg   : STD_LOGIC := '0';
    signal tx_busy_reg   : STD_LOGIC := '0';

    -- Internal working signals
    signal clk_counter  : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_index    : integer range 0 to 7 := 0;
    signal tx_data_reg  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

    -- Connect internal registers to output ports
    -- This pattern avoids reading output ports directly inside the process
    tx_serial <= tx_serial_reg;
    tx_done   <= tx_done_reg;
    tx_busy   <= tx_busy_reg;

    process(clk)
    begin
        if rising_edge(clk) then

            -- Default: clear done pulse every cycle (self-clearing)
            tx_done_reg <= '0';

            if rst = '1' then
                -- Return all signals to safe initial state
                state          <= IDLE;
                tx_serial_reg  <= '1'; -- UART line rests HIGH
                tx_busy_reg    <= '0';
                tx_done_reg    <= '0';
                clk_counter    <= 0;
                bit_index      <= 0;

            else
                case state is

                    -- Wait for tx_start pulse, capture data only here (safe capture)
                    when IDLE =>
                        tx_serial_reg <= '1'; -- Hold line HIGH while idle
                        tx_busy_reg   <= '0';
                        if tx_start = '1' then
                            tx_data_reg <= tx_data; -- Latch input data safely in IDLE only
                            clk_counter <= 0;
                            tx_busy_reg <= '1';
                            state       <= START;
                        end if;

                    -- Send start bit (logic LOW) for exactly one bit period
                    when START =>
                        tx_serial_reg <= '0';
                        if clk_counter < CLKS_PER_BIT - 1 then
                            clk_counter <= clk_counter + 1;
                        else
                            clk_counter <= 0;
                            bit_index   <= 0;
                            state       <= DATA;
                        end if;

                    -- Send 8 data bits LSB first (UART standard)
                    when DATA =>
                        tx_serial_reg <= tx_data_reg(bit_index);
                        if clk_counter < CLKS_PER_BIT - 1 then
                            clk_counter <= clk_counter + 1;
                        else
                            clk_counter <= 0;
                            if bit_index < 7 then
                                bit_index <= bit_index + 1;
                            else
                                bit_index <= 0;
                                state     <= STOP;
                            end if;
                        end if;

                    -- Send stop bit (logic HIGH) then signal completion
                    when STOP =>
                        tx_serial_reg <= '1';
                        if clk_counter < CLKS_PER_BIT - 1 then
                            clk_counter <= clk_counter + 1;
                        else
                            clk_counter <= 0;
                            tx_done_reg <= '1'; -- Pulse done for exactly 1 clock cycle
                            state       <= IDLE;
                        end if;

                end case;
            end if;
        end if;
    end process;

end Behavioral;