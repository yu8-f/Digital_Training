# build.ps1

# for tb_adder_400bit.v
# iverilog -g2012 -o tb_adder_400bit.out init_400bit.v adder_400bit.v tb_adder_400bit.v
# vvp tb_adder_400bit.out

# for tb_divider_400bit.v
iverilog -o tb_divider_400bit.out divider_400bit.v tb_divider_400bit.v
vvp tb_divider_400bit.out