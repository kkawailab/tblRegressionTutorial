# 応用編：実践的な使用例と便利なテクニック

## 🎯 この章で学ぶこと

- 複数のモデルを並べて比較する方法
- 生存時間解析の結果を表にする方法
- テーマを設定してデフォルトの表示を変更する方法
- 様々な回帰モデルでの使用例

## 📊 複数のモデルを並べて比較

### tbl_merge()を使った比較

複数のモデルの結果を横に並べて表示できます。

```r
library(gtsummary)

# モデル1：シンプルなモデル
model1 <- glm(response ~ age,
              data = trial,
              family = binomial)

# モデル2：変数を追加したモデル
model2 <- glm(response ~ age + grade,
              data = trial,
              family = binomial)

# モデル3：さらに変数を追加
model3 <- glm(response ~ age + grade + stage,
              data = trial,
              family = binomial)

# それぞれの表を作成
tbl1 <- tbl_regression(model1, exponentiate = TRUE)
tbl2 <- tbl_regression(model2, exponentiate = TRUE)
tbl3 <- tbl_regression(model3, exponentiate = TRUE)

# 3つの表を横に並べる
tbl_merge(
  tbls = list(tbl1, tbl2, tbl3),           # 並べる表のリスト
  tab_spanner = c(" **モデル1** ",           # 各列の見出し
                  " **モデル2** ",
                  " **モデル3** ")
)
```

**実行結果の例：** [HTML版](examples/output/06_model_comparison.html) | [Markdown版](examples/output/06_model_comparison.md)

**💡 コメント解説：**
- `tbl_merge()`：複数の表を横に結合する関数
- `tbls`：結合する表のリスト
- `tab_spanner`：各モデルの列に表示する見出し
- これにより、モデルの比較が一目で分かる

### より詳しい比較表

```r
# カスタマイズした比較表
tbl_merge(
  tbls = list(tbl1, tbl2, tbl3),
  tab_spanner = c(" **モデル1** ", " **モデル2** ", " **モデル3** ")
) %>%
  # 列名を日本語に
  modify_header(
    estimate_1 = "**OR**",
    estimate_2 = "**OR**",
    estimate_3 = "**OR**"
  ) %>%
  bold_labels()
```

**💡 コメント解説：**
- `estimate_1`, `estimate_2`：各モデルの推定値列を個別に指定
- 結合後も`modify_header()`などの関数が使える

## 🩺 生存時間解析の例

### Cox比例ハザードモデル

生存時間解析でもtbl_regression()が使えます。

```r
# survivalパッケージを読み込む
library(survival)

# Cox比例ハザードモデル
cox_model <- coxph(
  Surv(ttdeath, death) ~ age + grade + stage,  # Surv()で生存データを指定
  data = trial
)

# 結果を表に
tbl_regression(
  cox_model,
  exponentiate = TRUE,  # ハザード比を表示
  label = list(
    age ~ "年齢（歳）",
    grade ~ "腫瘍グレード",
    stage ~ "病期"
  )
) %>%
  bold_labels() %>%
  bold_p(t = 0.05) %>%
  modify_header(
    estimate = " **ハザード比** ",
    ci = " **95% CI** ",
    p.value = " **P値** "
  )
```

**💡 コメント解説：**
- `coxph()`：Cox比例ハザードモデルを実行する関数
- `Surv(ttdeath, death)`：生存時間データの指定
  - `ttdeath`：死亡までの時間
  - `death`：イベント発生（1=死亡、0=打ち切り）
- `exponentiate = TRUE`：ハザード比を表示

### 複数のエンドポイントを比較

```r
# 異なるエンドポイントで2つのモデル
cox_death <- coxph(Surv(ttdeath, death) ~ age + grade,
                   data = trial)

cox_recurrence <- coxph(Surv(ttdeath, death) ~ age + grade,
                        data = trial)

# 表を作成して並べる
tbl_death <- tbl_regression(cox_death, exponentiate = TRUE)
tbl_recurrence <- tbl_regression(cox_recurrence, exponentiate = TRUE)

tbl_merge(
  tbls = list(tbl_death, tbl_recurrence),
  tab_spanner = c(" **全生存期間** ", " **無再発生存期間** ")
)
```

**💡 コメント解説：**
- 複数のエンドポイント（死亡、再発など）を横に並べて比較
- 論文でよく見る形式

## 🎨 テーマの設定

### デフォルトの設定を変更

毎回同じカスタマイズを行うのは面倒です。テーマを設定することで、デフォルトの動作を変更できます。

```r
# テーマを設定（セッション全体で有効）
theme_gtsummary_language(
  language = "ja",              # 日本語に設定
  decimal.mark = ".",           # 小数点記号
  big.mark = ","                # 3桁区切り記号
)

# これ以降の表は日本語がデフォルトに
model <- glm(response ~ age + grade,
             data = trial,
             family = binomial)

tbl_regression(model, exponentiate = TRUE)
# → 自動的に日本語で表示される
```

**💡 コメント解説：**
- `theme_gtsummary_language()`：言語設定を変更
- `language = "ja"`：日本語を指定
- 一度設定すれば、以降すべての表に適用される

### カスタムテーマの作成

独自のデフォルト設定を作ることもできます。

```r
# 自分専用のテーマを設定
my_theme <- list(
  # すべてのtbl_regressionで以下がデフォルトに
  "tbl_regression-str:estimate_fun" = function(x) style_ratio(x, digits = 2),
  "tbl_regression-arg:conf.level" = 0.95,
  "add_global_p-str:type" = "Wald",
  "tbl_regression-str:pvalue_fun" = function(x) style_pvalue(x, digits = 2)
)

# テーマを適用
set_gtsummary_theme(my_theme)

# これ以降、すべてのtbl_regression()で上記の設定がデフォルトに
tbl_regression(model, exponentiate = TRUE)
```

**💡 コメント解説：**
- `set_gtsummary_theme()`：カスタムテーマを設定
- リスト形式で様々な設定を指定
- プロジェクト全体で一貫した表を作成できる

## 📈 様々な回帰モデルの例

### 1. 線形混合モデル（lme4パッケージ）

```r
# lme4パッケージを読み込む
library(lme4)

# 線形混合モデル
lme_model <- lmer(
  age ~ marker + grade + (1 | trt),  # (1 | trt)はランダム効果
  data = trial
)

# 結果を表に
tbl_regression(lme_model)
```

**💡 コメント解説：**
- `lmer()`：線形混合モデル
- `(1 | trt)`：ランダム切片（trtでグループ化）
- gtsummaryは自動的に適切な形式で表示

### 2. 順序ロジスティック回帰

```r
# MASSパッケージを読み込む
library(MASS)

# 順序ロジスティック回帰
# gradeは順序カテゴリカル変数（I < II < III）
ordinal_model <- polr(
  grade ~ age + marker,
  data = trial,
  Hess = TRUE  # ヘッセ行列を計算（標準誤差に必要）
)

# 結果を表に
tbl_regression(ordinal_model, exponentiate = TRUE)
```

**💡 コメント解説：**
- `polr()`：順序ロジスティック回帰
- gradeのような順序データに適している
- `Hess = TRUE`：標準誤差とp値の計算に必要

### 3. ポアソン回帰（カウントデータ）

```r
# カウントデータの回帰
poisson_model <- glm(
  death ~ age + grade + stage,
  data = trial,
  family = poisson  # ポアソン分布を指定
)

# 結果を表に
tbl_regression(
  poisson_model,
  exponentiate = TRUE,  # 発生率比（IRR）を表示
  label = list(
    age ~ "年齢",
    grade ~ "グレード",
    stage ~ "ステージ"
  )
) %>%
  modify_header(estimate = " **発生率比** ")
```

**💡 コメント解説：**
- `family = poisson`：ポアソン回帰を指定
- カウントデータ（0, 1, 2, 3...）の分析に使用
- `exponentiate = TRUE`で発生率比（IRR）を表示

## 🔧 便利なテクニック集

### 1. 表をファイルに保存

```r
# 表を作成
my_table <- tbl_regression(model, exponentiate = TRUE) %>%
  bold_labels() %>%
  bold_p()

# Word文書として保存
my_table %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "regression_table.docx")

# HTMLファイルとして保存
my_table %>%
  as_gt() %>%
  gt::gtsave(filename = "regression_table.html")
```

**💡 コメント解説：**
- `as_flex_table()`：flextableオブジェクトに変換
- `as_gt()`：gtオブジェクトに変換
- それぞれの形式で保存できる

### 2. 特定の統計量だけを表示

```r
# 信頼区間を非表示にして、推定値とp値だけ表示
tbl_regression(
  model,
  exponentiate = TRUE
) %>%
  modify_table_body(
    ~ .x %>% select(-ci)  # ci列を削除
  )
```

**💡 コメント解説：**
- `modify_table_body()`：表の内容を直接操作
- `select(-ci)`：信頼区間の列を削除
- dplyrの文法が使える

### 3. インライン表示（文章中に埋め込み）

R Markdownで論文を書く際に便利です。

```r
# 表オブジェクトを作成
tbl <- tbl_regression(model, exponentiate = TRUE)

# インラインコードで使用
# 例：年齢のオッズ比を文章中に埋め込む
inline_text(tbl, variable = age)
# → "1.02 (95% CI 1.00, 1.04; p=0.091)"のように出力される
```

**💡 コメント解説：**
- `inline_text()`：表から特定の結果を抽出
- R Markdownの文章中で使用
- 例：「年齢のオッズ比は`r inline_text(tbl, variable = age)`であった」

## 📝 実践的な総合例

論文用の完成度の高い表を作成する例です。

```r
# 論文用の完成した表
final_model <- glm(
  response ~ age + marker + grade + stage,
  data = trial,
  family = binomial
)

final_table <- tbl_regression(
  final_model,
  exponentiate = TRUE,
  # 変数ラベルを日本語に
  label = list(
    age ~ "年齢（歳）",
    marker ~ "腫瘍マーカー（ng/mL）",
    grade ~ "組織学的グレード",
    stage ~ "臨床病期"
  ),
  # p値は小数点以下3桁
  pvalue_fun = function(x) style_pvalue(x, digits = 3)
) %>%
  # グローバルp値を追加
  add_global_p() %>%
  # 参照カテゴリーを表示
  add_reference_rows() %>%
  # N（サンプルサイズ）を追加
  add_n() %>%
  # 書式設定
  bold_labels() %>%
  italicize_levels() %>%
  bold_p(t = 0.05) %>%
  # 列名を設定
  modify_header(
    label = " **変数** ",
    estimate = " **オッズ比** ",
    ci = " **95% 信頼区間** ",
    p.value = " **P値** "
  ) %>%
  # モデル統計を追加
  add_glance_source_note(
    label = "モデル統計：",
    include = c(nobs, AIC, BIC)
  ) %>%
  # 脚注を追加
  modify_footnote(
    estimate ~ "多変量ロジスティック回帰分析",
    abbreviation = TRUE
  )

# 表を表示
final_table

# Word文書として保存
final_table %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "final_table.docx")
```

**💡 この例で使っているテクニック：**
1. オッズ比表示
2. 変数ラベルの日本語化
3. p値のフォーマット
4. グローバルp値
5. 参照カテゴリーの表示
6. サンプルサイズの追加
7. 書式設定（太字・斜体）
8. 列名のカスタマイズ
9. モデル統計
10. 脚注の追加
11. ファイル保存

## 🎯 まとめ

この章で学んだこと：

- ✅ `tbl_merge()`で複数モデルを並べて比較
- ✅ Cox回帰など様々なモデルでの使用方法
- ✅ テーマ設定でデフォルト動作を変更
- ✅ 表をファイルに保存する方法
- ✅ `inline_text()`で文章中に結果を埋め込み
- ✅ 論文用の完成度の高い表の作成方法

## 📚 さらに学ぶには

- [公式ドキュメント（英語）](https://www.danieldsjoberg.com/gtsummary/)
- [gtsummaryのビネット一覧](https://www.danieldsjoberg.com/gtsummary/articles/)
- [GitHub リポジトリ](https://github.com/ddsjoberg/gtsummary)

## 💡 Tips

1. **エラーが出たら**：モデルオブジェクトが正しく作成されているか確認
2. **カスタマイズがうまくいかない**：パイプ（`%>%`）の順序を確認
3. **日本語が文字化け**：RStudioのエンコーディング設定を確認
4. **表が見づらい**：`theme_gtsummary_compact()`で行間を狭くできる

---

**前へ：** [カスタマイズ編](./02_customization.md)
**トップへ：** [README](./README.md)
