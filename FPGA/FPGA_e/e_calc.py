WORDS = 32
LOG2_N = 15

def split_words(data, word_size=16):
    """データをword_sizeごとに分割する"""
    result = []
    for i in range(WORDS):
        result.append((data >> (i * word_size)) & ((1 << word_size) - 1))
    return result

def combine_words(words, word_size=16):
    """words配列を結合する"""
    result = 0
    for i in range(len(words)):
        result |= (words[i] & ((1 << word_size) - 1)) << (i * word_size)
    return result

def e_multi(a_data, b_data):
    """2つの固定小数点データ列の掛け算"""
    a = split_words(a_data)
    b = split_words(b_data)
    temp = [0] * (2 * WORDS)

    for i in range(WORDS):
        temp[i] = a[i] * b[0]

    for j in range(1, WORDS):
        for i in range(WORDS):
            temp[i + j] += a[i] * b[j]

    for i in range(2 * WORDS - 1):
        temp[i+1] += temp[i] >> 16
        temp[i] &= 0xFFFF
    temp[2 * WORDS - 1] &= 0xFFFF

    out_data = combine_words(temp)
    return out_data

def e_calc_square(start_data):
    """(1 + 1/n)^n を計算する (平方をLOG2_N回)"""
    result = start_data
    for _ in range(LOG2_N):
        result = e_multi(result, result)
        result &= (1 << (16 * WORDS)) - 1  # WORDS分だけマスク
    return result

def e_calc():
    """e_calcの本体"""
    # (1 + 1/n) を初期値として作成する
    init_words = [0] * (WORDS - 2) + [1, 1]
    init_data = combine_words(init_words)

    # 計算実行
    final_data = e_calc_square(init_data)

    # 出力表示
    final_words = split_words(final_data)
    print("Calculation done")
    for i in reversed(range(WORDS)):
        print(f"{i}: {final_words[i]}")

if __name__ == "__main__":
    e_calc()
