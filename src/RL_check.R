### make Japanese name - Scientific name relationship
# iNaturalistの開発者ページからDwC-A形式の分類データを入手して、taxon IDで和名-学名対照表をつくる
# Requirements.
# packages: data.table, dplyr
# GitHub Gist: https://gist.github.com/yuchiyama8712/47bc5ab303ebaf1c301d044c0143feab

library(data.table)
library(dplyr)

setwd("./inat-taxonomy") #このディレクトリにそのまま保存する

taxa <- fread("taxa.csv")
setkeyv(taxa, "id")

ja_names <- fread("VernacularNames-japanese.csv")
setkeyv(taxa, "id")

ja_names <- ja_names %>%
				left_join(taxa, by = "id")

# fwrite(ja_names, "wamei-gakumei.csv")  # ここではファイル保存は不要


### make Red list - iNat taxonomy list
# 上で作成した和名-学名対照表と環境省RLを"和名"で名寄せする
# Requirements.
# packages: data.table, dplyr 
# 上記スクリプトを実行済みとする

# set RL filename
# 後で使い回せるように、ファイル名は変えられるようにしておく
RL_year <- "2020"
RL_taxon <- "ikansoku"
RL_filename <- paste0("../japan-red-lists/", "redlist", RL_year, "_", RL_taxon, ".csv")

RL_japan <- fread(RL_filename)
setnames(RL_japan, "和名", "vernacularName")

RL_bind <- RL_japan %>%
				left_join(ja_names, by = "vernacularName")

fwrite(RL_bind, paste0("RL_inat_checklist_", RL_taxon, ".csv"))
