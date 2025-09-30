# 基本編：練習問題の詳細な回答

[基本編に戻る](../01_basic_usage.md)

---

## 📝 練習問題

基本編の練習問題では、以下のコードが提示されていました：

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

---

## 💡 練習1の詳細な解説

### コードの目的

この練習では、3つの説明変数（age, marker, grade）を使用して、response（治療への反応）を予測するロジスティック回帰モデルを作成し、結果をオッズ比で表示します。

### ステップバイステップの説明

#### ステップ1：モデルの作成

```r
model_practice <- glm(
  response ~ age + marker + grade,
  data = trial,
  family = binomial
)
```

**各要素の説明：**
- `glm()`：一般化線形モデル（Generalized Linear Model）を実行する関数
- `response ~ age + marker + grade`：
  - `response`：目的変数（反応あり=1、なし=0）
  - `~`：「によって説明される」という意味
  - `age + marker + grade`：3つの説明変数
- `data = trial`：使用するデータセット
- `family = binomial`：二値データなのでロジスティック回帰を指定

#### ステップ2：表の作成

```r
tbl_regression(model_practice, exponentiate = TRUE)
```

**パラメータの説明：**
- `model_practice`：先ほど作成したモデルオブジェクト
- `exponentiate = TRUE`：回帰係数をexp()で変換してオッズ比として表示

### 結果の解釈

表には以下の情報が含まれます：

| 変数 | オッズ比（OR） | 95% CI | p値 |
|------|---------------|--------|-----|
| Age | 1.02 | 1.00, 1.04 | 0.091 |
| Marker | 0.95 | 0.90, 1.00 | 0.057 |
| Grade I | — | — | — |
| Grade II | 0.95 | 0.43, 2.09 | 0.9 |
| Grade III | 1.10 | 0.50, 2.42 | 0.8 |

**解釈のポイント：**

1.  **Age（年齢）**
   - OR = 1.02：年齢が1歳増加すると、反応のオッズが1.02倍（2%増加）
   - p = 0.091：統計的には有意ではない（p > 0.05）
   - 年齢が高いほど反応する傾向があるが、統計的には弱い

2.  **Marker（バイオマーカー）**
   - OR = 0.95：マーカー値が1単位増加すると、反応のオッズが0.95倍（5%減少）
   - p = 0.057：統計的には有意ではないが、境界線上
   - マーカー値が高いほど反応しにくい可能性

3.  **Grade（グレード）**
   - Grade Iが参照カテゴリー（基準）
   - Grade IIとIIIは、Grade Iと比べて有意差なし
   - p値が大きいため、グレードは反応を予測する要因ではない可能性

---

## 💡 練習2の詳細な解説

### コードの目的

練習1と同じモデルを使用しますが、変数名を日本語の分かりやすいラベルに変更します。

### コードの詳細

```r
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

**labelパラメータの説明：**
- `label = list(...)`：複数の変数ラベルをリスト形式で指定
- `age ~ "患者年齢（歳）"`：age変数を「患者年齢（歳）」と表示
- `marker ~ "バイオマーカー値"`：marker変数を「バイオマーカー値」と表示
- `grade ~ "腫瘍グレード"`：grade変数を「腫瘍グレード」と表示
- `~`記号：「を〜としてラベル付けする」という意味

### 日本語ラベルを使う理由

1.  **論文や報告書での使用**
   - 日本語の論文では、変数名を日本語で表示する必要がある
   - 単位（歳、ng/mLなど）を明記できる

2.  **可読性の向上**
   - 英語の変数名（age, marker）よりも意味が明確
   - プレゼンテーションや報告書で理解しやすい

3.  **詳細な説明の追加**
   - 「年齢」だけでなく「患者年齢（歳）」と単位まで記載
   - より専門的な用語（「バイオマーカー値」など）に変更可能

---

## 🔍 追加の練習課題

理解を深めるために、以下の追加課題に挑戦してみましょう：

### 課題1：信頼区間のレベルを変更

90%信頼区間で表示してみましょう。

```r
tbl_regression(
  model_practice,
  exponentiate = TRUE,
  conf.level = 0.90,  # 90%信頼区間
  label = list(
    age ~ "患者年齢（歳）",
    marker ~ "バイオマーカー値",
    grade ~ "腫瘍グレード"
  )
)
```

**ポイント：**
- `conf.level = 0.90`で90%信頼区間に変更
- 信頼区間が狭くなる（95% → 90%）

### 課題2：特定の変数だけを表示

年齢とマーカーだけを表示してみましょう。

```r
tbl_regression(
  model_practice,
  exponentiate = TRUE,
  include = c(age, marker),  # ageとmarkerだけを含める
  label = list(
    age ~ "患者年齢（歳）",
    marker ~ "バイオマーカー値"
  )
)
```

**ポイント：**
- `include = c(age, marker)`で表示する変数を限定
- gradeは表に含まれない

### 課題3：p値の表示形式を変更

p値を3桁で表示してみましょう。

```r
tbl_regression(
  model_practice,
  exponentiate = TRUE,
  pvalue_fun = function(x) style_pvalue(x, digits = 3),
  label = list(
    age ~ "患者年齢（歳）",
    marker ~ "バイオマーカー値",
    grade ~ "腫瘍グレード"
  )
)
```

**ポイント：**
- `pvalue_fun`でp値のフォーマット関数を指定
- `digits = 3`で小数点以下3桁まで表示

---

## 📊 実行結果の確認

実際に上記のコードを実行すると、以下のような表が得られます：

```r
# パッケージの読み込み
library(gtsummary)

# モデルの作成
model_practice <- glm(
  response ~ age + marker + grade,
  data = trial,
  family = binomial
)

# 基本的な表
print("=== 練習1の結果 ===")
tbl_regression(model_practice, exponentiate = TRUE)

# 日本語ラベル付きの表
print("=== 練習2の結果 ===")
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

---

## 🎯 学習のポイント

この練習問題を通じて、以下のスキルを習得しました：

1. ✅ 複数の説明変数を持つロジスティック回帰モデルの作成
2. ✅ `tbl_regression()`の基本的な使い方
3. ✅ オッズ比の表示方法（`exponentiate = TRUE`）
4. ✅ 変数ラベルのカスタマイズ（`label`パラメータ）
5. ✅ 結果の解釈（オッズ比、信頼区間、p値）

---

## 💡 よくある質問

### Q1: オッズ比が1より大きいとはどういう意味ですか？

A: オッズ比が1より大きい場合、その変数が増加すると目的変数（この例では治療への反応）が起こりやすくなることを意味します。
- OR = 1.5 → その変数が1単位増えると、反応のオッズが1.5倍（50%増加）
- OR = 1.0 → その変数は反応に影響しない
- OR = 0.5 → その変数が1単位増えると、反応のオッズが0.5倍（50%減少）

### Q2: 信頼区間に1が含まれている場合は？

A: 信頼区間が1を含んでいる場合、その変数の効果は統計的に有意ではありません。
- 例：OR = 1.02, 95% CI: 1.00, 1.04 → ギリギリ有意
- 例：OR = 0.95, 95% CI: 0.43, 2.09 → 有意ではない（1を含む）

### Q3: カテゴリカル変数の参照カテゴリーはどう決まりますか？

A: デフォルトでは、アルファベット順で最初のカテゴリーが参照カテゴリーになります。この例では Grade I が参照カテゴリーです。参照カテゴリーを変更したい場合は、factor関数のlevelsで順序を指定します。

```r
# 参照カテゴリーをGrade IIIに変更する例
trial$grade <- relevel(trial$grade, ref = "III")
```

---

## 🚀 次のステップ

基本編の練習問題を理解できたら、次は [カスタマイズ編](../02_customization.md) に進みましょう！

より高度なテーブルのカスタマイズ方法を学ぶことができます。

---

[基本編に戻る](../01_basic_usage.md) | [カスタマイズ編へ](../02_customization.md)
