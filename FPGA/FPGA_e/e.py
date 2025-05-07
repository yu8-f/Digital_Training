def bisplit(nL, nR, fn):
    if nR - nL == 1:
        an, bn, pn, qn = fn
        b = bn(nR)
        p = pn(nR)
        q = qn(nR)
        t = an(nR) * p
        return b, p, q, t
    else:
        m = (nL + nR) >> 1  # shift right 1 == integer division by 2
        bL, pL, qL, tL = bisplit(nL, m, fn)
        bR, pR, qR, tR = bisplit(m, nR, fn)
        b = bL * bR
        p = pL * pR
        q = qL * qR
        t = bR * qR * tL + bL * pL * tR
        return b, p, q, t

def calc_e(nn):
    n10 = 10 ** nn
    # 定義する関数たち
    an = lambda n: 1
    bn = lambda n: 1
    pn = lambda n: 1
    qn = lambda n: n
    _, _, q, t = bisplit(0, nn, (an, bn, pn, qn))
    return n10 + (t * n10) // q

if __name__ == '__main__':
    digits = 10  # 10^digits桁まで計算
    result = calc_e(10 * digits)
    print(result)