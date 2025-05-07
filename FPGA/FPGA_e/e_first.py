from decimal import Decimal, getcontext

# 小数点以下100桁＋余裕をもたせる
getcontext().prec = 110

n = 2**32
n_decimal = Decimal(n)

# e ≈ (1 + 1/n)^n
e_approx = (Decimal(1) + Decimal(1)/n_decimal) ** n_decimal

# 小数点以下100桁まで出力
# format関数を使うときれいにできます
e_str = format(e_approx, 'f')  # 'f'は通常の浮動小数点表記

# 100桁ちょうどに切り取る
integer_part, fractional_part = e_str.split('.')
fractional_part = fractional_part[:100]  # 100桁だけに
result = integer_part + '.' + fractional_part

print(result)

bit_one = 0
for i in range(32):
    if buffer[i] != 0:
        bit_one = i
if bit_one >= 15:
    for i in range(0, 15):
        buffer[i] = buffer[i + (bit_one-14)]
    for i in range(15, 32):
        buffer[i] = 0