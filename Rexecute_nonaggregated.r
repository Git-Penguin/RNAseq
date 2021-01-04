library("shiny")
library("sleuth")
base_dir <- getwd()
sample_id <- dir(file.path(base_dir,"Kallisto_Results_Separate"))
print(sample_id)
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "Kallisto_Results_Separate", id,"abundance.h5"))
print(kal_dirs)

s2c <- read.table(file.path(base_dir, "samples_info.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = sample_name, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)

so <- sleuth_prep(s2c, ~condition,extra_bootstrap_summary=TRUE,num_cores=3) 

so <- sleuth_fit(so, ~condition, 'full')

so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')
write.table(so$obs_norm_filt,file="obs_norm_filt.txt",sep="\t")


results_table <- sleuth_results(so, 'reduced:full', test_type = 'lrt', show_all=FALSE)
write.table(results_table,file="Out.txt",sep="\t")
	
