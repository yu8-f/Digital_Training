# build.ps1

# for tb_adder_400bit.v
iverilog -g2012 -o tb_adder_400bit.out init_400bit.v adder_400bit.v tb_adder_400bit.v
vvp tb_adder_400bit.out