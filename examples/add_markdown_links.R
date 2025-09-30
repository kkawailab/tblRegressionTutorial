# HTMLファイルにマークダウンリンクを追加

html_files <- list.files("examples/output", pattern = "\\.html$", full.names = TRUE)

for (html_file in html_files) {
  # 対応するマークダウンファイル名を取得
  md_file <- sub("\\.html$", ".md", basename(html_file))
  
  # HTMLファイルを読み込む
  html_content <- readLines(html_file, warn = FALSE)
  
  # リンクが既に存在するかチェック
  if (!any(grepl("Markdown版を見る", html_content))) {
    # <body>タグの後にリンクを挿入
    body_pos <- grep("<body", html_content)[1]
    if (!is.na(body_pos)) {
      link_html <- sprintf(
        '<div style="padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ccc;"><a href="%s">📄 Markdown版を見る</a></div>',
        md_file
      )
      html_content <- c(
        html_content[1:body_pos],
        link_html,
        html_content[(body_pos + 1):length(html_content)]
      )
      
      # ファイルに書き戻す
      writeLines(html_content, html_file)
      cat("リンクを追加しました:", basename(html_file), "\n")
    }
  } else {
    cat("リンクは既に存在します:", basename(html_file), "\n")
  }
}

cat("\n完了しました。\n")
