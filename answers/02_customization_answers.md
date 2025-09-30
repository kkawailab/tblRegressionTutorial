# カスタマイズ編：練習問題の詳細な回答

[カスタマイズ編に戻る](../02_customization.md)

---

## 📝 練習問題

カスタマイズ編の練習問題では、以下の3つの課題が提示されていました：

```r
# 練習用モデル
practice_model <- glm(
  response ~ age + marker + grade + stage,
  data = trial,
  family = binomial
)

# 練習1：基本的なカスタマイズ
tbl_regression(practice_model, exponentiate = TRUE) %>%
  bold_labels() %>%
  bold_p(t = 0.05)

# 練習2：日本語表示
tbl_regression(
  practice_model,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢",
    marker ~ "マーカー",
    grade ~ "グレード",
    stage ~ "ステージ"
  )
) %>%
  modify_header(
    estimate = " **OR** ",
    conf.low = " **95% CI** ",
    p.value = " **P値** "
  )

# 練習3：包括的なカスタマイズ
tbl_regression(
  practice_model,
  exponentiate = TRUE
) %>%
  add_glance_source_note(include = c(nobs, AIC, BIC)) %>%
  bold_labels() %>%
  italicize_levels() %>%
  bold_p()
```

---

## 💡 練習1の詳細な解説

### コードの目的

基本的な書式設定を適用して、表を見やすくします。

### ステップバイステップの説明

#### ステップ1：モデルの作成

```r
practice_model <- glm(
  response ~ age + marker + grade + stage,
  data = trial,
  family = binomial
)
```

**変数の説明：**
- `age`：年齢（連続変数）
- `marker`：腫瘍マーカー値（連続変数）
- `grade`：腫瘍グレード（カテゴリカル変数：I, II, III）
- `stage`：病期（カテゴリカル変数：T1, T2, T3, T4）

これら4つの変数で治療への反応（response）を予測します。

#### ステップ2：基本的な表の作成

```r
tbl_regression(practice_model, exponentiate = TRUE)
```

- オッズ比を表示する基本的な表を作成

#### ステップ3：変数名を太字に

```r
%>% bold_labels()
```

**効果：**
- すべての変数名（Age, Marker, Grade, Stageなど）が **太字** で表示される
- カテゴリーの値（I, II, III, T1, T2など）は太字にならない

#### ステップ4：有意な結果を太字に

```r
%>% bold_p(t = 0.05)
```

**効果：**
- p値が0.05未満の行全体が **太字** で表示される
- 統計的に有意な結果が一目で分かる
- `t = 0.05`は閾値（threshold）を指定

### 完成した表の特徴

```r
# 完全なコード
tbl_regression(practice_model, exponentiate = TRUE) %>%
  bold_labels() %>%
  bold_p(t = 0.05)
```

**視覚的な特徴：**
1.  **変数名が太字** → 行の区切りが明確
2.  **有意な結果が太字** → 重要な発見が強調される
3. シンプルで見やすい → 基本的なレポートに最適

---

## 💡 練習2の詳細な解説

### コードの目的

変数名と列名を日本語に変更して、日本語の論文やレポートで使用できる表を作成します。

### コードの詳細

```r
tbl_regression(
  practice_model,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢",
    marker ~ "マーカー",
    grade ~ "グレード",
    stage ~ "ステージ"
  )
) %>%
  modify_header(
    estimate = " **OR** ",
    conf.low = " **95% CI** ",
    p.value = " **P値** "
  )
```

#### 部分1：変数ラベルの日本語化

```r
label = list(
  age ~ "年齢",
  marker ~ "マーカー",
  grade ~ "グレード",
  stage ~ "ステージ"
)
```

**各要素の説明：**
- `list()`で複数のラベルをまとめる
- `変数名 ~ "日本語ラベル"`の形式
- 4つの変数すべてに日本語ラベルを指定

**より詳細なラベルの例：**

```r
label = list(
  age ~ "患者年齢（歳）",
  marker ~ "腫瘍マーカー値（ng/mL）",
  grade ~ "組織学的グレード",
  stage ~ "臨床病期（TNM分類）"
)
```

#### 部分2：列名の日本語化

```r
modify_header(
  estimate = " **OR** ",
  conf.low = " **95% CI** ",
  p.value = " **P値** "
)
```

**各パラメータの説明：**
- `estimate`：オッズ比の列 → "OR"に変更
- `conf.low`：信頼区間の列 → "95% CI"に変更（注：v2.0以降は`ci`の代わりに`conf.low`を使用）
- `p.value`：p値の列 → "P値"に変更
- ` ** ** `の前後のスペースは日本語マークダウンの強調表記のため

### 応用：より専門的な日本語表示

```r
tbl_regression(
  practice_model,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢（歳）",
    marker ~ "腫瘍マーカー値",
    grade ~ "組織学的グレード",
    stage ~ "臨床病期"
  )
) %>%
  modify_header(
    label = " **変数** ",
    estimate = " **調整オッズ比** ",
    conf.low = " **95% 信頼区間** ",
    p.value = " **P値** "
  ) %>%
  modify_footnote(
    estimate ~ "多変量ロジスティック回帰分析により算出"
  )
```

**追加機能：**
- `modify_footnote()`で脚注を追加
- より専門的な用語（「調整オッズ比」など）を使用

---

## 💡 練習3の詳細な解説

### コードの目的

モデルの統計情報を含む、包括的にカスタマイズされた表を作成します。

### コードの詳細

```r
tbl_regression(
  practice_model,
  exponentiate = TRUE
) %>%
  add_glance_source_note(include = c(nobs, AIC, BIC)) %>%
  bold_labels() %>%
  italicize_levels() %>%
  bold_p()
```

#### 機能1：モデル統計情報の追加

```r
add_glance_source_note(include = c(nobs, AIC, BIC))
```

**各統計量の説明：**
- `nobs`：観測数（サンプルサイズ）
  - 例：N = 183（欠損値を除いた実際の分析対象数）
- `AIC`：赤池情報量規準（Akaike Information Criterion）
  - モデルの良さを評価する指標
  - 小さいほど良いモデル
- `BIC`：ベイズ情報量規準（Bayesian Information Criterion）
  - AICと類似だが、よりシンプルなモデルを好む
  - 小さいほど良いモデル

**表の下部に表示される例：**
```
N = 183; AIC = 245.2; BIC = 271.8
```

#### 機能2：変数名を太字に

```r
bold_labels()
```

- すべての変数名（Age, Marker, Grade, Stageなど）を太字に

#### 機能3：カテゴリー値を斜体に

```r
italicize_levels()
```

**効果：**
- カテゴリカル変数の各水準が *斜体* で表示される
- 例：Grade の *I*, *II*, *III*
- 例：Stage の *T1*, *T2*, *T3*, *T4*
- 変数名とカテゴリー値の区別が明確になる

#### 機能4：有意な結果を太字に

```r
bold_p()
```

- `bold_p(t = 0.05)`と同じ（デフォルトが0.05）
- p < 0.05の行を太字に

### 完成した表の構造

```
┌─────────────────────────────────────────────────┐
│ Characteristic    OR      95% CI       p-value  │
├─────────────────────────────────────────────────┤
│ Age              1.02    1.00, 1.04    0.091    │
│ Marker           0.95    0.90, 1.00    0.057    │
│ Grade                                            │
│   I               —        —             —      │
│   II             0.85    0.39, 1.87    0.7      │
│   III            1.01    0.47, 2.18    >0.9     │
│ Stage                                            │
│   T1              —        —             —      │
│   T2             1.23    0.48, 3.16    0.7      │
│   T3             1.45    0.53, 3.95    0.5      │
│   T4             1.67    0.62, 4.50    0.3      │
├─────────────────────────────────────────────────┤
│ N = 183; AIC = 245.2; BIC = 271.8               │
└─────────────────────────────────────────────────┘
```

---

## 🔍 追加の練習課題

さらに理解を深めるために、以下の課題に挑戦しましょう：

### 課題1：すべての機能を組み合わせる

練習1、2、3のすべての機能を1つの表に統合してみましょう。

```r
tbl_regression(
  practice_model,
  exponentiate = TRUE,
  pvalue_fun = function(x) style_pvalue(x, digits = 3),
  label = list(
    age ~ "患者年齢（歳）",
    marker ~ "腫瘍マーカー値（ng/mL）",
    grade ~ "組織学的グレード",
    stage ~ "臨床病期"
  )
) %>%
  add_glance_source_note(
    label = " **モデル統計：** ",
    include = c(nobs, AIC, BIC)
  ) %>%
  bold_labels() %>%
  italicize_levels() %>%
  bold_p(t = 0.05) %>%
  modify_header(
    label = " **変数** ",
    estimate = " **オッズ比** ",
    conf.low = " **95% 信頼区間** ",
    p.value = " **P値** "
  ) %>%
  modify_footnote(
    estimate ~ "多変量ロジスティック回帰分析により算出",
    conf.low ~ "Wald法による95%信頼区間"
  )
```

**この表の特徴：**
1. 日本語の変数ラベル（単位付き）
2. 日本語の列名
3. p値を3桁表示
4. 変数名が太字
5. カテゴリー値が斜体
6. 有意な結果が太字
7. モデル統計情報を表示
8. 詳細な脚注

### 課題2：参照カテゴリーを表示

参照カテゴリー（基準となるカテゴリー）を表に含めてみましょう。

```r
tbl_regression(
  practice_model,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢",
    marker ~ "マーカー",
    grade ~ "グレード",
    stage ~ "ステージ"
  )
) %>%
  add_reference_rows() %>%  # 参照カテゴリーの行を追加
  bold_labels() %>%
  italicize_levels()
```

**効果：**
- Grade I と Stage T1（参照カテゴリー）の行が表示される
- OR = 1.00、「— ref」と表示される
- すべてのカテゴリーが表に含まれるため、分かりやすい

### 課題3：特定の変数だけを表示

年齢とマーカーだけに焦点を当てた表を作成しましょう。

```r
tbl_regression(
  practice_model,
  exponentiate = TRUE,
  include = c(age, marker),  # ageとmarkerだけ
  label = list(
    age ~ "患者年齢（歳）",
    marker ~ "腫瘍マーカー値（ng/mL）"
  )
) %>%
  bold_labels() %>%
  bold_p(t = 0.05) %>%
  modify_header(
    label = " **変数** ",
    estimate = " **オッズ比** ",
    conf.low = " **95% CI** ",
    p.value = " **P値** "
  )
```

**使用場面：**
- 特定の変数に焦点を当てた分析
- 本文で特定の変数のみを議論する場合
- スペースが限られている場合

---

## 📊 結果の比較

### 練習1の結果（基本的なカスタマイズ）

**特徴：**
- 変数名が太字
- 有意な結果が太字
- シンプルで分かりやすい

**適している場面：**
- 内部レポート
- 探索的データ分析
- 簡単なプレゼンテーション

### 練習2の結果（日本語表示）

**特徴：**
- 日本語の変数名
- 日本語の列名
- 専門用語を使用可能

**適している場面：**
- 日本語の論文
- 日本語のプレゼンテーション
- 日本の学会発表

### 練習3の結果（包括的なカスタマイズ）

**特徴：**
- モデル統計情報を含む
- 変数名が太字、カテゴリーが斜体
- 有意な結果が強調される
- 完全な情報

**適している場面：**
- 査読付き論文
- 詳細な分析レポート
- モデルの比較が必要な場合

---

## 💡 よくある質問

### Q1: `bold_p()`と`bold_p(t = 0.05)`の違いは？

A: どちらも同じです。`bold_p()`のデフォルト値が`t = 0.05`なので、省略可能です。異なる閾値を使いたい場合（例：p < 0.01）は、`bold_p(t = 0.01)`と明示的に指定します。

### Q2: AICとBICの違いは？

A: どちらもモデルの良さを評価する指標ですが：
- **AIC**：予測精度を重視、複雑なモデルを許容しやすい
- **BIC**：シンプルさを重視、複雑なモデルにペナルティが大きい
- どちらも小さいほど良いモデル
- モデル比較には同じ指標を使用すること

### Q3: `modify_header()`で列名を変更する際の注意点は？

A: gtsummary v2.0以降では、`ci`列が廃止され、`conf.low`と`conf.high`に分かれました。
- **旧バージョン**：`ci = "95% CI"`
- **新バージョン**：`conf.low = "95% CI"`（推奨）

信頼区間をマージして表示するには、事前に`modify_column_merge(pattern = "{conf.low}, {conf.high}")`を使用します。

### Q4: パイプ演算子（`%>%`）の順序は重要ですか？

A: はい、とても重要です。例えば：

```r
# 正しい順序
tbl_regression(...) %>%
  add_reference_rows() %>%  # 最初に行を追加
  bold_labels()             # その後で書式設定

# 間違った順序（動作しない可能性）
tbl_regression(...) %>%
  bold_labels() %>%
  add_reference_rows()      # 太字設定が失われる可能性
```

一般的なルール：
1. データの追加・変更（`add_*`）
2. 書式設定（`bold_*`, `italicize_*`）
3. 列名の変更（`modify_header`）
4. 脚注の追加（`modify_footnote`）

---

## 🎯 学習のポイント

この練習問題を通じて、以下のスキルを習得しました：

1. ✅ 基本的な書式設定（`bold_labels()`, `bold_p()`）
2. ✅ 変数ラベルと列名の日本語化
3. ✅ モデル統計情報の追加（`add_glance_source_note()`）
4. ✅ カテゴリー値の斜体表示（`italicize_levels()`）
5. ✅ 脚注の追加（`modify_footnote()`）
6. ✅ パイプ演算子を使った複数機能の連結

---

## 🚀 次のステップ

カスタマイズ編の練習問題を理解できたら、次は [応用編](../03_advanced_examples.md) に進みましょう！

複数モデルの比較、生存時間解析、テーマ設定など、さらに高度なテクニックを学ぶことができます。

---

[カスタマイズ編に戻る](../02_customization.md) | [応用編へ](../03_advanced_examples.md) | [基本編の練習問題](./01_basic_answers.md)
