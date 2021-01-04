library("shiny")
library("sleuth")
base_dir <- getwd()
sample_id <- dir(file.path(base_dir,"Kallisto_Results_Separate"))
print(sample_id)
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "Kallisto_Results_Separate", id,"abundance.h5"))
print(kal_dirs)

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

s2c <- read.table(file.path(base_dir, "samples_info.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = sample_name, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)

so <- sleuth_prep(s2c, ~condition,extra_bootstrap_summary=TRUE,filter_fun=DPT_consistent, num_cores=3) 

so <- sleuth_fit(so, ~condition, 'full')

so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')
write.table(so$obs_norm_filt,file="obs_norm_filt.txt",sep="\t")


results_table <- sleuth_results(so, 'reduced:full', test_type = 'lrt', show_all=FALSE)
write.table(results_table,file="Out_filtered.txt",sep="\t")
	
