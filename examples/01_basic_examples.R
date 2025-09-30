# 基本編のサンプルスクリプト

# パッケージの読み込み
library(gtsummary)
library(dplyr)

# サンプルデータの確認
cat("=== サンプルデータの確認 ===\n")
print(head(trial))

cat("\n=== 例1: 基本的なロジスティック回帰 ===\n")
# ロジスティック回帰モデルの作成
model1 <- glm(
  response ~ age + grade,
  data = trial,
  family = binomial
)

# 基本的な使い方
tbl1 <- tbl_regression(model1)
print(as_tibble(tbl1))

cat("\n=== 例2: オッズ比を表示 ===\n")
# オッズ比を表示
tbl2 <- tbl_regression(
  model1,
  exponentiate = TRUE
)
print(as_tibble(tbl2))

cat("\n=== 例3: 線形回帰 ===\n")
# 線形回帰モデル
model2 <- lm(
  age ~ marker + grade,
  data = trial
)

tbl3 <- tbl_regression(model2)
print(as_tibble(tbl3))

cat("\n=== 例4: 変数のラベルを変更 ===\n")
# 変数名を日本語に
tbl5 <- tbl_regression(
  model1,
  exponentiate = TRUE,
  label = list(
    age ~ "年齢",
    grade ~ "グレード"
  )
)
print(as_tibble(tbl5))

cat("\nスクリプト実行完了！\n")
