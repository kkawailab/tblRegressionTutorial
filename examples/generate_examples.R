# 例の出力を生成するスクリプト

library(gtsummary)
library(gt)
library(dplyr)
library(knitr)
library(kableExtra)

# 出力ディレクトリの作成
dir.create("examples/output", showWarnings = FALSE, recursive = TRUE)

# LaTeXをPDFにコンパイルする関数
compile_latex_to_pdf <- function(tex_content, output_file) {
  # 一時的なTeXファイルを作成
  temp_dir <- tempdir()
  tex_file <- file.path(temp_dir, "temp_table.tex")

  # LaTeX文書として完成させる（日本語サポート付き）
  full_tex <- paste0(
    "\\documentclass{article}\n",
    "\\usepackage[utf8]{inputenc}\n",
    "\\usepackage[T1]{fontenc}\n",
    "\\usepackage{CJKutf8}\n",
    "\\usepackage{booktabs}\n",
    "\\usepackage{longtable}\n",
    "\\usepackage{array}\n",
    "\\usepackage{multirow}\n",
    "\\usepackage{wrapfig}\n",
    "\\usepackage{float}\n",
    "\\usepackage{colortbl}\n",
    "\\usepackage{pdflscape}\n",
    "\\usepackage{tabu}\n",
    "\\usepackage{threeparttable}\n",
    "\\usepackage{threeparttablex}\n",
    "\\usepackage[normalem]{ulem}\n",
    "\\usepackage{makecell}\n",
    "\\usepackage{xcolor}\n",
    "\\begin{document}\n",
    "\\begin{CJK}{UTF8}{min}\n",
    tex_content, "\n",
    "\\end{CJK}\n",
    "\\end{document}"
  )

  writeLines(full_tex, tex_file)

  # PDFにコンパイル（エラー出力を抑制）
  system2(
    "pdflatex",
    args = c("-interaction=nonstopmode", "-output-directory", temp_dir, tex_file),
    stdout = FALSE,
    stderr = FALSE
  )

  # 生成されたPDFを目的の場所にコピー
  pdf_file <- file.path(temp_dir, "temp_table.pdf")
  if (file.exists(pdf_file)) {
    file.copy(pdf_file, output_file, overwrite = TRUE)
    return(TRUE)
  } else {
    warning(paste("PDFの生成に失敗しました:", output_file))
    return(FALSE)
  }
}

# HTMLファイルにPDFリンクを追加する関数
add_pdf_link_to_html <- function(html_file, pdf_file) {
  html_content <- readLines(html_file, warn = FALSE)

  # PDF相対パス（同じディレクトリ）
  pdf_basename <- basename(pdf_file)

  # リンクを追加（</body>の前に挿入）
  link_html <- paste0(
    '<div style="text-align:center; margin-top:20px;">',
    '<a href="', pdf_basename, '" style="padding:10px 20px; background-color:#007bff; color:white; text-decoration:none; border-radius:5px;">PDF版をダウンロード</a>',
    '</div>'
  )

  # </body>を探して、その前にリンクを挿入
  body_idx <- grep("</body>", html_content)
  if (length(body_idx) > 0) {
    html_content <- c(
      html_content[1:(body_idx[1] - 1)],
      link_html,
      html_content[body_idx[1]:length(html_content)]
    )
  }

  writeLines(html_content, html_file)
}

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
tbl1 %>%
  as_tibble() %>%
  kable(format = "markdown") %>%
  writeLines("examples/output/01_basic_regression.md")
# LaTeX/PDF出力
tex1 <- tbl1 %>% as_kable_extra(format = "latex")
compile_latex_to_pdf(tex1, "examples/output/01_basic_regression.pdf")
add_pdf_link_to_html("examples/output/01_basic_regression.html", "examples/output/01_basic_regression.pdf")

# 例2: オッズ比を表示
tbl2 <- tbl_regression(
  model1,
  exponentiate = TRUE
)
tbl2 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/02_odds_ratio.html")
tbl2 %>%
  as_tibble() %>%
  kable(format = "markdown") %>%
  writeLines("examples/output/02_odds_ratio.md")
# LaTeX/PDF出力
tex2 <- tbl2 %>% as_kable_extra(format = "latex")
compile_latex_to_pdf(tex2, "examples/output/02_odds_ratio.pdf")
add_pdf_link_to_html("examples/output/02_odds_ratio.html", "examples/output/02_odds_ratio.pdf")

# 例3: 線形回帰
model2 <- lm(
  age ~ marker + grade,
  data = trial
)

tbl3 <- tbl_regression(model2)
tbl3 %>%
  as_gt() %>%
  gt::gtsave(filename = "examples/output/03_linear_regression.html")
tbl3 %>%
  as_tibble() %>%
  kable(format = "markdown") %>%
  writeLines("examples/output/03_linear_regression.md")
# LaTeX/PDF出力
tex3 <- tbl3 %>% as_kable_extra(format = "latex")
compile_latex_to_pdf(tex3, "examples/output/03_linear_regression.pdf")
add_pdf_link_to_html("examples/output/03_linear_regression.html", "examples/output/03_linear_regression.pdf")

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
tbl4 %>%
  as_tibble() %>%
  kable(format = "markdown") %>%
  writeLines("examples/output/04_japanese_labels.md")
# LaTeX/PDF出力
tex4 <- tbl4 %>% as_kable_extra(format = "latex")
compile_latex_to_pdf(tex4, "examples/output/04_japanese_labels.pdf")
add_pdf_link_to_html("examples/output/04_japanese_labels.html", "examples/output/04_japanese_labels.pdf")

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
tbl5 %>%
  as_tibble() %>%
  kable(format = "markdown") %>%
  writeLines("examples/output/05_comprehensive.md")
# LaTeX/PDF出力
tex5 <- tbl5 %>% as_kable_extra(format = "latex")
compile_latex_to_pdf(tex5, "examples/output/05_comprehensive.pdf")
add_pdf_link_to_html("examples/output/05_comprehensive.html", "examples/output/05_comprehensive.pdf")

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
tbl6 %>%
  as_tibble() %>%
  kable(format = "markdown") %>%
  writeLines("examples/output/06_model_comparison.md")
# LaTeX/PDF出力
tex6 <- tbl6 %>% as_kable_extra(format = "latex")
compile_latex_to_pdf(tex6, "examples/output/06_model_comparison.pdf")
add_pdf_link_to_html("examples/output/06_model_comparison.html", "examples/output/06_model_comparison.pdf")

cat("すべての例の出力が examples/output/ ディレクトリに保存されました。\n")
cat("生成されたファイル:\n")
cat("HTML files:\n")
print(list.files("examples/output", pattern = "\\.html$", full.names = TRUE))
cat("\nMarkdown files:\n")
print(list.files("examples/output", pattern = "\\.md$", full.names = TRUE))
cat("\nPDF files:\n")
print(list.files("examples/output", pattern = "\\.pdf$", full.names = TRUE))
