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

DPT_consistent <- function(row)
{
  if(FALSE %in% (row>=1)){return(FALSE)}
  A24 <- row[c("A24wt_L","A24wt_2","A24wt_3")]
  # DPts <- row[-(1:3)]
  DPt2 <- row[c("D_Pt2_1","D_Pt2_2","D_Pt2_3")]
  DPt4 <- row[c("D_Pt4_1","D_Pt4_2","D_Pt4_3")]
  DPt8 <- row[c("D_Pt8_1","D_Pt8_2","D_Pt8_3")]
  DPtReg <-c(0,0,0)
  if((mean(DPt2)/mean(A24))>=1.1){
    DPtReg[1]=1
  }else if((mean(DPt2)/mean(A24))<=0.9){
    DPtReg[1]=-1
  }

  if((mean(DPt4)/mean(A24))>=1.1){
    DPtReg[2]=1
  }else if((mean(DPt4)/mean(A24))<=0.9){
    DPtReg[2]=-1
  }

  if((mean(DPt8)/mean(A24))>=1.1){
    DPtReg[3]=1
  }else if((mean(DPt8)/mean(A24))<=0.9){
    DPtReg[3]=-1
  }

  Ups <- length(DPtReg[DPtReg==1])
  Downs <- length(DPtReg[DPtReg==-1])

  inconsistent <- ((Ups>=1)&&(Downs>=1))
  !inconsistent
}

gtf <- rtracklayer::import('./Index/Metassembly.gtf')
gtf_df=as.data.frame(gtf)
rm(gtf)
gtf_df <- dplyr::select(gtf_df, target_id = transcript_id, gene_id, gene_name, ref_gene_id)
gtf_df <- dplyr::distinct(gtf_df,target_id,gene_id,.keep_all=TRUE)


so <- sleuth_prep(s2c, ~condition,extra_bootstrap_summary=TRUE, target_mapping =gtf_df,filter_fun=DPT_consistent, aggregation_column='gene_id', num_cores=4) 

so <- sleuth_fit(so, ~condition, 'full')

so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')

gene_table <- sleuth_results(so, 'reduced:full', test_type='lrt', show_all=FALSE, pval_aggregate = TRUE)
write.table(gene_table,file="genelist_filtered.txt",sep="\t")
