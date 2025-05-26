# eの計算結果があってるかどうか確認する

# 16進数文字列（あなたの出力）
hex_str = "02b7e151628aed2a6abf7158809cf4f3c762e7160f38b4da56a784d9045190cfef324e7738926cfbe5f4bf62d2c9de13d397"

# 16進数 → 整数（2進数と同じ扱いになる）
big_int = int(hex_str, 16)

# Q8.392 のスケーリング
value = big_int / (2 ** 392)

# 結果表示（小数点以下100桁表示）
print(f"e ≈ {value:.100f}")
