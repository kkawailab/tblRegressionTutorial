# HTMLファイルからマークダウンリンクを削除

html_files <- list.files("examples/output", pattern = "\\.html$", full.names = TRUE)

for (html_file in html_files) {
  # HTMLファイルを読み込む
  html_content <- readLines(html_file, warn = FALSE)
  
  # マークダウンリンクの行を探す
  link_lines <- grep("Markdown版を見る", html_content)
  
  if (length(link_lines) > 0) {
    # リンク行を削除
    html_content <- html_content[-link_lines]
    
    # ファイルに書き戻す
    writeLines(html_content, html_file)
    cat("リンクを削除しました:", basename(html_file), "\n")
  } else {
    cat("リンクが見つかりませんでした:", basename(html_file), "\n")
  }
}

cat("\n完了しました。\n")
