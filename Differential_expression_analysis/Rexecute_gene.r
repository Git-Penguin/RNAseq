library("shiny")
library("sleuth")
library("rtracklayer")
base_dir <- getwd()
sample_id <- dir(file.path(base_dir,"Kallisto_Results_Separate"))
print(sample_id)
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "Kallisto_Results_Separate", id,"abundance.h5"))
print(kal_dirs)
s2c <- read.table(file.path(base_dir, "samples_info.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = sample_name, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)

gtf <- rtracklayer::import('./Index/Metassembly.gtf')
gtf_df=as.data.frame(gtf)
rm(gtf)
gtf_df <- dplyr::select(gtf_df, target_id = transcript_id, gene_id, gene_name, ref_gene_id)
gtf_df <- dplyr::distinct(gtf_df,target_id,gene_id,.keep_all=TRUE)


so <- sleuth_prep(s2c, ~condition,extra_bootstrap_summary=TRUE, target_mapping =gtf_df, aggregation_column='gene_id', num_cores=3) 

so <- sleuth_fit(so, ~condition, 'full')

so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')

gene_table <- sleuth_results(so, 'reduced:full', test_type='lrt', show_all=FALSE, pval_aggregate = TRUE)
write.table(gene_table,file="genelist_unfiltered.txt",sep="\t")
