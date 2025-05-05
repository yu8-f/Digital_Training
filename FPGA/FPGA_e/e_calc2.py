WORDS = 32
FRACTION_BITS = 16
LOG2_N = 25  # 25回の繰り返しで十分

def fixed_point_multiply(a, b):
    """固定小数点の掛け算"""
    # 掛け算結果をスケーリングして16ビットに収める
    return (a * b) >> FRACTION_BITS

def e_calc_square_fixed():
    """(1 + 1/n)^n を固定小数点で計算"""
    # 初期値 (1 + 1/n) を固定小数点で表現
    init_value = (1 << FRACTION_BITS) + (1 << FRACTION_BITS) // 2  # (1 + 1/n)
    result = init_value
    for _ in range(LOG2_N):
        result = fixed_point_multiply(result, result)
        # 必要以上に大きくならないようにマスク
        result &= (1 << (WORDS)) - 1
    return result

if __name__ == "__main__":
    result = e_calc_square_fixed()
    # 固定小数点の結果を10進数に変換して表示
    print(f"Fixed-point result: {result}")
    print(f"Approximation of e: {result / (1 << FRACTION_BITS)}")