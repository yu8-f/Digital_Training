# eの計算結果があってるかどうか確認する

# 16進数文字列（あなたの出力）
hex_str = "02abfd9a476e30f2eed959a7886487b78fc7a8ae9f53cf8345dc4f1269b29f3b1b223474e9fe3d508b926eff01baae220342"

# 16進数 → 整数（2進数と同じ扱いになる）
big_int = int(hex_str, 16)

# Q8.392 のスケーリング
value = big_int / (2 ** 392)

# 結果表示（小数点以下100桁表示）
print(f"e ≈ {value:.100f}")
