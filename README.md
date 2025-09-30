# gtsummary パッケージの tbl_regression() チュートリアル

## 📚 このチュートリアルについて

このリポジトリは、Rの`gtsummary`パッケージにある`tbl_regression()`関数の使い方を、日本語で分かりやすく解説した初心者向けチュートリアルです。

`tbl_regression()`関数を使うと、回帰分析の結果を **美しく、論文掲載レベルの表** に簡単に変換できます。

## 🎯 学べること

- `tbl_regression()`の基本的な使い方
- 回帰分析の結果を見やすい表にする方法
- 表のカスタマイズテクニック
- 実践的な応用例

## 📋 必要な環境

- R (バージョン 4.0 以上推奨)
- RStudio (推奨)
- 以下のRパッケージ:
  - gtsummary
  - broom
  - dplyr
  - gt (オプション)

## 💾 インストール方法

```r
# gtsummaryパッケージのインストール
install.packages("gtsummary")

# その他の推奨パッケージ
install.packages(c("broom", "dplyr", "gt"))
```

## 📖 チュートリアルの構成

1. **[基本編](./01_basic_usage.md)** - tbl_regression()の基本的な使い方
2. **[カスタマイズ編](./02_customization.md)** - 表の見た目や内容をカスタマイズする方法
3. **[応用編](./03_advanced_examples.md)** - 実践的な使用例と便利なテクニック

各チュートリアルには実行結果の例が含まれています。[examples/output/](./examples/output/) ディレクトリで実際の出力を確認できます。

### 📝 練習問題と回答

各チュートリアルには練習問題があり、詳細な解説付きの回答ページも用意されています。
- [練習問題の回答集](./answers/)
- [基本編の回答](./answers/01_basic_answers.md)
- [カスタマイズ編の回答](./answers/02_customization_answers.md)

## 🚀 クイックスタート

まずは簡単な例を試してみましょう：

```r
# パッケージの読み込み
library(gtsummary)

# サンプルデータで回帰分析
model <- glm(response ~ age + grade,
             data = trial,
             family = binomial)

# 結果を美しい表に変換
tbl_regression(model, exponentiate = TRUE)
```

たったこれだけで、論文に使えるような表が完成します！

## 📚 参考資料

- [公式ドキュメント（英語）](https://www.danieldsjoberg.com/gtsummary/articles/tbl_regression.html)
- [gtsummary パッケージ公式サイト](https://www.danieldsjoberg.com/gtsummary/)

## 🤝 貢献

このチュートリアルへの改善提案や誤字脱字の報告は、Issueやプルリクエストでお願いします。

## 📝 ライセンス

このチュートリアルはMITライセンスのもとで公開されています。

---

**それでは、[基本編](./01_basic_usage.md) から始めましょう！**
