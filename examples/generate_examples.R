# 例の出力を生成するスクリプト

library(gtsummary)
library(gt)
library(dplyr)

# 出力ディレクトリの作成
dir.create("examples/output", showWarnings = FALSE, recursive = TRUE)

# ==== 基本編の例 ====

# 例1: 基本的なロジスティック回帰
model1 <- glm(
  response ~ age + grade,
  data = trial,
  family = binomial
)

tbl1 <- tbl_regression(model1)
tbl1 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/01_basic_regression.html")

# 例2: オッズ比を表示
tbl2 <- tbl_regression(
  model1,
  exponentiate = TRUE
)
tbl2 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/02_odds_ratio.html")

# 例3: 線形回帰
model2 <- lm(
  age ~ marker + grade,
  data = trial
)

tbl3 <- tbl_regression(model2)
tbl3 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/03_linear_regression.html")

# 例4: 変数ラベルのカスタマイズ
tbl4 <- tbl_regression(
  model1,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢",
    grade ~ "グレード"
  )
)
tbl4 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/04_japanese_labels.html")

# ==== カスタマイズ編の例 ====

# 例5: 総合的なカスタマイズ
tbl5 <- tbl_regression(
  model1,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢（歳）",
    grade ~ "腫瘍グレード"
  )
) %>%
  bold_labels() %>%
  italicize_levels() %>%
  bold_p(t = 0.05) %>%
  modify_header(
    label = " **変数** ",
    estimate = " **オッズ比** ",
    conf.low = " **95% CI** ",
    p.value = " **P値** "
  )

tbl5 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/05_comprehensive.html")

# ==== 応用編の例 ====

# 例6: 複数モデルの比較
model_a <- glm(response ~ age, data = trial, family = binomial)
model_b <- glm(response ~ age + grade, data = trial, family = binomial)
model_c <- glm(response ~ age + grade + stage, data = trial, family = binomial)

tbl_a <- tbl_regression(model_a, exponentiate = TRUE)
tbl_b <- tbl_regression(model_b, exponentiate = TRUE)
tbl_c <- tbl_regression(model_c, exponentiate = TRUE)

tbl6 <- tbl_merge(
  tbls = list(tbl_a, tbl_b, tbl_c),
  tab_spanner = c(" **モデル1** ", " **モデル2** ", " **モデル3** ")
) %>%
  bold_labels()

tbl6 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/06_model_comparison.html")

cat("すべての例の出力が examples/output/ ディレクトリに保存されました。\n")
cat("生成されたファイル:\n")
list.files("examples/output", pattern = "\\.html$", full.names = TRUE)
