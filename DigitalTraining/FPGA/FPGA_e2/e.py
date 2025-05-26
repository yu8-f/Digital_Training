N = 4
ans = 1
Q = 1
for i in range(1, N+1):
    Q /= i
    ans += Q
print(ans)