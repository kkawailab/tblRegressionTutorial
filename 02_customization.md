# カスタマイズ編：表の見た目と内容をカスタマイズする

## 🎯 この章で学ぶこと

- p値の表示形式を変更する方法
- 表のヘッダー（列名）を変更する方法
- 特定の行を太字や斜体にする方法
- グローバルp値を追加する方法
- モデルの統計情報を追加する方法

## 📊 p値の表示形式をカスタマイズ

### デフォルトの表示

デフォルトでは、p値は自動的に丸められて表示されます。

```r
library(gtsummary)

# サンプルモデルの作成
model <- glm(response ~ age + grade,
             data = trial,
             family = binomial)

# 基本的な表
tbl_regression(model, exponentiate = TRUE)
```

### p値の表示桁数を変更

`pvalue_fun`オプションで、p値の表示方法を変更できます。

```r
# p値を小数点以下3桁で表示
tbl_regression(
  model,
  exponentiate = TRUE,
  pvalue_fun = function(x) style_pvalue(x, digits = 3)
)
```

**💡 コメント解説：**
- `pvalue_fun`：p値の表示形式を指定するオプション
- `style_pvalue()`：gtsummaryのp値フォーマット関数
- `digits = 3`：小数点以下3桁まで表示

### 非常に小さいp値の表示

```r
# p値が0.001未満の場合は「<0.001」と表示
tbl_regression(
  model,
  exponentiate = TRUE,
  pvalue_fun = function(x) style_pvalue(x, digits = 2)
)

# または、科学的記数法で表示（例：1.23e-05）
tbl_regression(
  model,
  exponentiate = TRUE,
  pvalue_fun = function(x) format.pval(x, digits = 2, eps = 0.001)
)
```

**💡 コメント解説：**
- `eps = 0.001`：この値より小さいp値は「<0.001」と表示
- `format.pval()`：Rの標準的なp値フォーマット関数

## 🏷️ 列名（ヘッダー）のカスタマイズ

### デフォルトの列名を変更

`modify_header()`関数を使って、列名を変更できます。

```r
# 列名を日本語に変更
tbl_regression(model, exponentiate = TRUE) %>%
  modify_header(
    label = "**変数**",           # 変数名の列
    estimate = "**オッズ比**",    # 推定値の列
    ci = "**95% 信頼区間**",      # 信頼区間の列
    p.value = "**P値**"           # p値の列
  )
```

**💡 コメント解説：**
- `%>%`：パイプ演算子。「そして〜する」という意味
- `modify_header()`：列名を変更する関数
- `**テキスト**`：マークダウン記法で太字を指定

### 列に説明を追加

```r
# 列名に詳しい説明を追加
tbl_regression(model, exponentiate = TRUE) %>%
  modify_header(
    estimate = "**OR**",  # ORは Odds Ratio の略
    ci = "**95% CI**",
    p.value = "**P値**"
  ) %>%
  modify_footnote(
    estimate ~ "OR = オッズ比",
    ci ~ "CI = 信頼区間"
  )
```

**💡 コメント解説：**
- `modify_footnote()`：表の下部に脚注を追加
- `列名 ~ "脚注テキスト"`の形式で指定

## 🎨 行の書式設定（太字・斜体）

### 変数名を太字にする

```r
# 変数名（label）を太字に
tbl_regression(model, exponentiate = TRUE) %>%
  bold_labels()
```

**💡 コメント解説：**
- `bold_labels()`：すべての変数名を太字にする関数
- パイプ（%>%）で簡単につなげられる

### カテゴリー値を斜体にする

```r
# カテゴリー変数の水準を斜体に
tbl_regression(model, exponentiate = TRUE) %>%
  bold_labels() %>%        # 変数名は太字
  italicize_levels()       # カテゴリー値は斜体
```

**💡 コメント解説：**
- `italicize_levels()`：カテゴリカル変数の各水準を斜体に
- 例：「grade」という変数の「I, II, III」などを斜体化

### 有意なp値を太字にする

```r
# p < 0.05の行を太字に
tbl_regression(model, exponentiate = TRUE) %>%
  bold_p(t = 0.05)  # t = threshold（閾値）
```

**💡 コメント解説：**
- `bold_p()`：指定した閾値より小さいp値の行を太字に
- `t = 0.05`：0.05未満を太字に（デフォルト）
- `t = 0.01`とすれば、0.01未満を太字に

## ➕ 追加情報の表示

### 1. グローバルp値を追加

カテゴリカル変数（複数のダミー変数）全体のp値を表示します。

```r
# グローバルp値を追加
tbl_regression(model, exponentiate = TRUE) %>%
  add_global_p()
```

**💡 コメント解説：**
- `add_global_p()`：カテゴリカル変数全体の有意性を検定
- 例：「grade」という変数が全体として有意かどうか
- Wald検定またはLRT検定を使用

### 2. モデルの適合度統計を追加

AICやR²などのモデル統計量を表の下部に追加できます。

```r
# モデルの統計情報を脚注に追加
tbl_regression(model, exponentiate = TRUE) %>%
  add_glance_source_note(
    include = c(nobs, AIC)  # サンプルサイズとAICを表示
  )
```

**💡 コメント解説：**
- `add_glance_source_note()`：モデル統計を脚注に追加
- `include`：表示する統計量を指定
  - `nobs`：観測数（サンプルサイズ）
  - `AIC`：赤池情報量規準
  - `BIC`：ベイズ情報量規準
  - `r.squared`：決定係数（線形回帰の場合）

### 3. 多重共線性の診断（VIF）を追加

VIF（分散拡大係数）を表に追加して、多重共線性をチェックできます。

```r
# VIF（分散拡大係数）を追加
tbl_regression(model) %>%
  add_vif()
```

**💡 コメント解説：**
- `add_vif()`：VIF値を新しい列として追加
- VIF > 10：多重共線性の可能性が高い
- VIF > 5：注意が必要

### 4. 参照カテゴリーを表示

カテゴリカル変数の参照カテゴリー（基準）を表に含めることができます。

```r
# 参照カテゴリーを表示
tbl_regression(model, exponentiate = TRUE) %>%
  add_reference_rows()
```

**💡 コメント解説：**
- `add_reference_rows()`：参照カテゴリーの行を追加
- 参照カテゴリーのオッズ比は常に1.00
- 「〜 ref」と表示される

## 🎨 総合的なカスタマイズ例

これまで学んだ内容を組み合わせた例です。

```r
# すべてのカスタマイズを組み合わせる
tbl_regression(
  model,
  exponentiate = TRUE,
  # p値を3桁で表示
  pvalue_fun = function(x) style_pvalue(x, digits = 3),
  # 変数名を日本語に
  label = list(
    age ~ "年齢（歳）",
    grade ~ "腫瘍グレード"
  )
) %>%
  # グローバルp値を追加
  add_global_p() %>%
  # 参照カテゴリーを表示
  add_reference_rows() %>%
  # 変数名を太字、カテゴリーを斜体
  bold_labels() %>%
  italicize_levels() %>%
  # 有意な結果を太字
  bold_p(t = 0.05) %>%
  # 列名を日本語に
  modify_header(
    label = "**変数**",
    estimate = "**オッズ比**",
    ci = "**95% CI**",
    p.value = "**P値**"
  ) %>%
  # モデル統計を追加
  add_glance_source_note(
    include = c(nobs, AIC)
  )
```

**💡 この例で使っているテクニック：**
1. オッズ比表示
2. p値の桁数指定
3. 変数ラベルの日本語化
4. グローバルp値の追加
5. 参照カテゴリーの表示
6. 太字・斜体の設定
7. 列名の日本語化
8. モデル統計の追加

## 📝 練習問題

以下のコードを実行して、様々なカスタマイズを試してみましょう。

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
    estimate = "**OR**",
    ci = "**95% CI**",
    p.value = "**P値**"
  )

# 練習3：包括的なカスタマイズ
tbl_regression(
  practice_model,
  exponentiate = TRUE
) %>%
  add_global_p() %>%
  add_glance_source_note(include = c(nobs, AIC, BIC)) %>%
  bold_labels() %>%
  italicize_levels() %>%
  bold_p()
```

## 🎯 まとめ

この章で学んだこと：

- ✅ `pvalue_fun`でp値の表示をカスタマイズ
- ✅ `modify_header()`で列名を変更
- ✅ `bold_labels()`や`italicize_levels()`で書式設定
- ✅ `add_global_p()`でグローバルp値を追加
- ✅ `add_glance_source_note()`でモデル統計を追加
- ✅ `add_vif()`でVIF値を追加
- ✅ パイプ（`%>%`）で複数のカスタマイズを連結

次の章では、より実践的な応用例を見ていきます。

---

**次へ：** [応用編](./03_advanced_examples.md)
**前へ：** [基本編](./01_basic_usage.md)
