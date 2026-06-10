library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aes_wrapper is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        encdec       : in  STD_LOGIC;
        init         : in  STD_LOGIC;
        next_block   : in  STD_LOGIC;
        block_in     : in  STD_LOGIC_VECTOR(127 downto 0);
        result       : out STD_LOGIC_VECTOR(127 downto 0);
        result_valid : out STD_LOGIC;
        ready        : out STD_LOGIC
    );
end aes_wrapper;

architecture Behavioral of aes_wrapper is

    signal rst_n : STD_LOGIC;

    component aes_core
        Port (
            clk          : in  STD_LOGIC;
            reset_n      : in  STD_LOGIC;
            encdec       : in  STD_LOGIC;
            init         : in  STD_LOGIC;
            \next\       : in  STD_LOGIC;
            ready        : out STD_LOGIC;
            key          : in  STD_LOGIC_VECTOR(255 downto 0);
            keylen       : in  STD_LOGIC;
            \block\      : in  STD_LOGIC_VECTOR(127 downto 0);
            result       : out STD_LOGIC_VECTOR(127 downto 0);
            result_valid : out STD_LOGIC
        );
    end component;

    constant AES_KEY : STD_LOGIC_VECTOR(255 downto 0) :=
        x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";

begin

    rst_n <= NOT rst;

    AES_CORE_INST : aes_core
        port map (
            clk          => clk,
            reset_n      => rst_n,
            encdec       => encdec,
            init         => init,
            \next\       => next_block,
            ready        => ready,
            key          => AES_KEY,
            keylen       => '1',
            \block\      => block_in,
            result       => result,
            result_valid => result_valid
        );

end Behavioral;
