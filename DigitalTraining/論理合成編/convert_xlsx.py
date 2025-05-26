import csv
import pandas as pd

# 読み込み対象のCSVファイル
input_csv = './RESULT/result.csv'
output_xlsx = './RESULT/result.xlsx'

# CSVを読み込んでレコードごとに整理
records = []
record = {}

with open(input_csv, 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        if not row or all(cell.strip() == "" for cell in row):
            if record:
                records.append(record)
                record = {}
        else:
            key = row[0].strip()
            value = row[1].strip()
            try:
                record[key] = float(value)
            except ValueError:
                record[key] = value  # 数値変換できない場合は文字列のまま

# 最後のレコードも追加
if record:
    records.append(record)

# DataFrameへ変換
df = pd.DataFrame(records)

# カラム名の修正（slack を除外）
expected_columns = {
    "bits": "Clock[ns]",
    "maxdelay": "MaxDelay[ns]",
    "area": "Area[um^2]",
    "dynamicpower": "DynamicPower[mW]",
    "leakagepower": "LeakagePower[nW]",
    "cputime": "Cputime[s]"
}

# 表示名の変換と列の並び替え
df.rename(columns=expected_columns, inplace=True)
df = df[list(expected_columns.values())]

# Excelファイルとして保存
df.to_excel(output_xlsx, index=False)
print(f"✅ 'slack' 列を除いたExcelファイルを保存しました: {output_xlsx}")