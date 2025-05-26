def bisplit_verilog_style(N):
    stack = []
    # (nL, nR, state)
    stack.append((0, N, 0))
    results = {}

    while stack:
        nL, nR, state = stack.pop()

        if nR - nL == 1:
            # 単位区間
            b = 1
            p = 1
            q = nR
            t = 1 * p
            results[(nL, nR)] = (b, p, q, t)
        elif state == 0:
            m = (nL + nR) >> 1
            # 左を処理
            stack.append((nL, nR, 1))  # 戻ったら右を処理
            stack.append((nL, m, 0))
        elif state == 1:
            m = (nL + nR) >> 1
            # 右を処理
            stack.append((nL, nR, 2))  # 戻ったら合成
            stack.append((m, nR, 0))
        else:  # state == 2
            m = (nL + nR) >> 1
            bL, pL, qL, tL = results[(nL, m)]
            bR, pR, qR, tR = results[(m, nR)]

            b = bL * bR
            p = pL * pR
            q = qL * qR
            t = bR * qR * tL + bL * pL * tR
            results[(nL, nR)] = (b, p, q, t)

    return results[(0, N)]


def calc_e_verilog_style(digits):
    N = 10 * digits
    n10 = 10 ** N
    _, _, q, t = bisplit_verilog_style(N)
    return n10 + (t * n10) // q


if __name__ == '__main__':
    digits = 10
    result = calc_e_verilog_style(digits)
    print(result)
