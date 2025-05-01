import csv
import pandas as pd

# 読み込み対象のCSVファイル
input_csv = './RESULT/result.csv'
output_xlsx = './RESULT/result_clk.xlsx'

# CSVを読み込んでデータを整理
records = []
with open(input_csv, 'r') as f:
    reader = csv.reader(f)
    record = {}
    for row in reader:
        if not row or all(cell.strip() == "" for cell in row):  # 空行をスキップ
            if record:
                records.append(record)
                record = {}
        else:
            key = row[0].strip()
            value = row[1].strip()
            if key == "std_cell_utilization" and value.endswith('%'):
                value = value.rstrip('%')  # %を取り除く
            try:
                record[key] = float(value)  # 数値に変換
            except ValueError:
                record[key] = value  # 数値変換できない場合は文字列のまま
    if record:  # 最後のレコードを追加
        records.append(record)

# DataFrameへ変換
df = pd.DataFrame(records)

# 必要なカラムを指定して並び替え
columns_order = ["clock", "std_cell_utilization", "total_violations", "slack"]
df = df.reindex(columns=columns_order)

# Excelファイルとして保存
df.to_excel(output_xlsx, index=False)
print(f"✅ 整形されたExcelファイルを保存しました: {output_xlsx}")