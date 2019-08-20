#########################################################################################################
#                     Convert blast+ accession number format to human readable values                   #         
######################################################################################################### 
## Date: 20/08/2019
## Involved: Miles
## Task: Filter blast+ format 6 output tables to only keep sequences that have met the following citeria:
##       1) Are from sea turtle species, and function as olfactory receptors (easily changed below)
##       2) Are within a length range, and have high enough sequence identity
##       The output tables from these functions, can easily generate an id_list.txt file that can be used
##       with seqkit to filter fasta/q files to only keep the correct sequences.

library("taxize")
library("dplyr")
taxize::use_entrez()
  
input_file <- read.table("~/BVG082_Blast_hits.txt", sep = "\t", header = FALSE)


## Function to take a vector of the accession ID column from blast+ output.  
convert_id <- function(input_id_vector){
  input_id_vector %>% genbank2uid(id = .) -> temp_output
  attr(temp_output[[1]], which = "name")
}

## I have two parts of the top hit I need to match, the species and the function. 
double_check <- function(convert_id_output){
  grepl(pattern = "Chelonia mydas|Caretta caretta", convert_id_output) == grepl(pattern = "olfactory receptor", convert_id_output)
}

get_turtle_olf <- function(input_format6_table, max_length = 550, min_length = 500, pident_min = 90){
  names(input_format6_table) <- c("query_name", "hit_id", "pident", "length", "mismatch", "gapopen", "q_start", "q_end", "aln_start", "aln_end", "e_val", "bitscore")
  ## getting the id column to pass through my first function, but ensuring it's characters, not factors. 
  hit_id <- input_format6_table$hit_id %>% unique %>% as.character
  ## Applying the two above functions to convert the accession number and ensure it's the right species and function
  lapply(X = hit_id, FUN = convert_id) %>% double_check %>% unlist -> output_results
  ## Binding the results to make an index table
  bound <- cbind(hit_id, output_results)
  ## filtering the original input table by changeable parameters after binding it to the index table 
  merge(input_format6_table, bound, by = "hit_id") %>% filter(., output_results == "TRUE" & length >= min_length & length <= max_length & pident >= pident_min)
}

get_turtle_olf(input_file)

