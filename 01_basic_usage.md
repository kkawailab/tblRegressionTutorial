# 基本編：tbl_regression()の基本的な使い方

## 🎯 この章で学ぶこと

- `tbl_regression()`関数の基本
- 簡単な回帰分析の結果を表にする方法
- 基本的なオプションの使い方

## 📚 tbl_regression()とは？

`tbl_regression()`は、回帰分析の結果を**自動的に**美しい表に変換してくれる関数です。

### 主な特徴

- ✅ コードが短く、簡単に使える
- ✅ 論文掲載レベルの見た目
- ✅ 40種類以上の回帰モデルに対応
- ✅ 内部で`broom::tidy()`を使用

## 🚀 基本的な使い方

### ステップ1：準備

まずは必要なパッケージを読み込みます。

```r
# パッケージの読み込み
library(gtsummary)  # メインのパッケージ
library(dplyr)      # データ操作用（オプション）

# サンプルデータの確認
# gtsummaryパッケージに含まれる「trial」データを使います
head(trial)
```

**💡 コメント解説：**
- `library()`：パッケージを読み込む関数
- `trial`：がん臨床試験のサンプルデータ（gtsummaryパッケージに付属）
- `head()`：データの最初の6行を表示する関数

### ステップ2：回帰分析を実行

まずは通常通り回帰分析を行います。

```r
# ロジスティック回帰モデルの作成
# 目的：「response（反応あり/なし）」を予測する
model1 <- glm(
  response ~ age + grade,  # 式：反応 ~ 年齢 + グレード
  data = trial,            # 使用するデータ
  family = binomial        # ロジスティック回帰を指定
)

# モデルの確認（従来の方法）
summary(model1)
```

**💡 コメント解説：**
- `glm()`：一般化線形モデルを実行する関数
- `response ~ age + grade`：モデル式（反応を年齢とグレードで予測）
- `~`：チルダ記号。「〜によって予測される」という意味
- `family = binomial`：二値データ（Yes/No）のロジスティック回帰を指定

### ステップ3：tbl_regression()で表に変換

ここからが本題です！`summary()`の代わりに`tbl_regression()`を使います。

```r
# 基本的な使い方
tbl_regression(model1)
```

**💡 これだけで美しい表が完成！**

表には以下が自動的に含まれます：
- 変数名
- 回帰係数（Beta）
- 信頼区間（95% CI）
- p値

### ステップ4：オッズ比を表示する

ロジスティック回帰では、**オッズ比（Odds Ratio）**で結果を解釈することが一般的です。

```r
# オッズ比を表示（exponentiate = TRUEを追加）
tbl_regression(
  model1,
  exponentiate = TRUE  # 係数を指数変換してオッズ比に
)
```

**💡 コメント解説：**
- `exponentiate = TRUE`：係数をexp()で変換し、オッズ比として表示
- オッズ比が1より大きい→その変数が増えると反応が起きやすい
- オッズ比が1より小さい→その変数が増えると反応が起きにくい

## 📊 実践例：線形回帰

次は連続値を予測する線形回帰の例です。

```r
# 線形回帰モデルの作成
# 目的：「age（年齢）」を予測する
model2 <- lm(
  age ~ marker + grade,  # 式：年齢 ~ マーカー値 + グレード
  data = trial           # 使用するデータ
)

# 結果を表に変換
tbl_regression(model2)
```

**💡 コメント解説：**
- `lm()`：線形回帰（Linear Model）を実行する関数
- 線形回帰では`exponentiate`は不要（係数をそのまま解釈）

## 🎨 基本的なカスタマイズ

### 1. 信頼区間のレベルを変更

デフォルトは95%信頼区間ですが、変更できます。

```r
# 90%信頼区間に変更
tbl_regression(
  model1,
  exponentiate = TRUE,
  conf.level = 0.90  # 0.90 = 90%
)
```

**💡 コメント解説：**
- `conf.level`：信頼区間の水準（0〜1の値で指定）
- 0.95 = 95%信頼区間（デフォルト）
- 0.99 = 99%信頼区間（より厳密）

### 2. 変数のラベルを変更

デフォルトでは変数名がそのまま表示されますが、日本語に変更できます。

```r
# 変数名を日本語に変更
tbl_regression(
  model1,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢",      # ageを「年齢」に
    grade ~ "グレード" # gradeを「グレード」に
  )
)
```

**💡 コメント解説：**
- `label`：変数名を変更するオプション
- `list()`：複数の変更をまとめて指定
- `変数名 ~ "新しい名前"`の形式で指定

### 3. 特定の変数だけを表示

すべての変数ではなく、一部だけを表に含めることもできます。

```r
# ageだけを表示
tbl_regression(
  model1,
  exponentiate = TRUE,
  include = age  # ageだけを含める
)

# 複数の変数を指定する場合
tbl_regression(
  model1,
  exponentiate = TRUE,
  include = c(age, grade)  # c()で複数指定
)
```

**💡 コメント解説：**
- `include`：表に含める変数を指定
- `c()`：複数の要素をまとめる関数（combine の c）

## 📝 練習問題

以下のコードを実行して、結果を確認してみましょう。

```r
# 練習1：基本的な表の作成
model_practice <- glm(
  response ~ age + marker + grade,
  data = trial,
  family = binomial
)

# 表を作成（オッズ比表示）
tbl_regression(model_practice, exponentiate = TRUE)

# 練習2：ラベルをカスタマイズ
tbl_regression(
  model_practice,
  exponentiate = TRUE,
  label = list(
    age ~ "患者年齢（歳）",
    marker ~ "バイオマーカー値",
    grade ~ "腫瘍グレード"
  )
)
```

## 🎯 まとめ

この章で学んだこと：

- ✅ `tbl_regression()`の基本的な使い方
- ✅ `exponentiate = TRUE`でオッズ比を表示
- ✅ `conf.level`で信頼区間を変更
- ✅ `label`で変数名を変更
- ✅ `include`で表示する変数を選択

次の章では、さらに詳しいカスタマイズ方法を学びます。

---

**次へ：** [カスタマイズ編](./02_customization.md)
