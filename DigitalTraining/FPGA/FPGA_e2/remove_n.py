import sys

def main():
    # 標準入力から全体を読み取る
    input_text = sys.stdin.read()

    # 改行コードをすべて取り除く
    single_line_text = input_text.replace('\n', '').replace('\r', '')

    # 出力をファイルに書き込む
    with open('output2.txt', 'w', encoding='utf-8') as f:
        f.write(single_line_text)

if __name__ == "__main__":
    main()
