#########################################################################################################
#                     Digest large fasta files so remote Blast+ can process them faster                 #         
######################################################################################################### 
## Date: 20/08/2019
## Involved: Miles
## Task: A constant problem with using Blast+ is it appears to lose connection after only a handful of 
##       hits. To remedy this, large fasta's will be broken down into smaller chunks to allow not only
##       a faster analysis, but also one with more redundancy against Blast+'s weakness. 

library(seqinr)
library(stringr)

## A function that writes an output fasta named after the first sequence in it
write_fasta_chunk <- function(name_list, folder_prefix){
  unlisted <- unlist(name_list)
  output_name <- paste("./", folder_prefix,"/",unlisted[1], ".fasta", sep = "")
  write.fasta(sequences = fasta_all[unlisted], names = unlisted, file.out = output_name)
  print(paste(output_name, "created"))
}

## A larger function that takes a file name as input, and a number of sequences in desired output. 
## The function will create a directory based on the name, for example, two of  my replicated samples 
## are named BVG291_paired_assembled.fasta and BVG291-2_paired_assembled.fasta. 
fasta_split <- function(input_fasta_name, split_size = 15){
  input_fasta_name %>% str_extract(pattern = "[A-Z]{1,3}[0-9]{1,3}-?2?") -> dir_name
  dir.create(path = dir_name)
  fasta_all <- read.fasta(input_fasta_name)
  print(paste("Creating", names(fasta_all) %>% length / split_size, "smaller fasta files"))
  names(fasta_all) %>% split(., ceiling(seq_along(names(fasta_all))/split_size)) -> name_chunks  
  mapply(FUN = write_fasta_chunk, name_list = name_chunks, folder_prefix = dir_name)
}

## Usage
fasta_split("BVG291-2_paired_assembled_renamed.fasta")
