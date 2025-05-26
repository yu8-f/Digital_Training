from decimal import Decimal, getcontext

# 小数点以下100桁＋余裕をもたせる
getcontext().prec = 110

n = 2**16
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

result_str = str(result)
ideal = "2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642742746639193200305992181741359662904357290033429526059563073813232862794349076323382988075319525101901"

for i in range(len(ideal)):
    if result_str[i] != ideal[i]:
        print(f"{i}桁目が違います: {result_str[:i]} \'{result_str[i]}\'")
        break