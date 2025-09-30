# サンプルコードと実行結果

このディレクトリには、チュートリアルで使用するサンプルコードと実行結果が含まれています。

## 📁 ディレクトリ構成

- `generate_examples.R` - すべての例を生成するRスクリプト
- `01_basic_examples.R` - 基本編のサンプルコード
- `output/` - 生成されたHTMLファイルが保存されるディレクトリ

## 🚀 実行方法

```bash
# すべての例を生成
Rscript examples/generate_examples.R
```

## 📊 生成される出力

1. `01_basic_regression.html` - 基本的なロジスティック回帰の表
2. `02_odds_ratio.html` - オッズ比を表示した表
3. `03_linear_regression.html` - 線形回帰の表
4. `04_japanese_labels.html` - 日本語ラベルを使用した表
5. `05_comprehensive.html` - 総合的なカスタマイズの例
6. `06_model_comparison.html` - 複数モデルの比較表

各HTMLファイルは、ブラウザで開くことで美しくフォーマットされた表を確認できます。
