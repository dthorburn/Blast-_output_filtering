# Loggerhead Sea Turtle Olfactory Genes Project

This repository aims to publish a series of scripts in a pipeline to process pair ended reads from a hyper-polymorphic region, apply appropriate filters, and assign genotypes. 

## Blast+ filtering

This step was introducted after an earlier attempt to assign genotypes resulted in an unrealisticly high number. The ```Blast+_Filtering_Function.R``` script defines a function ```get_turtle_olf```, which will take a Blast+ format 6 output table and then converts the accession numbers to the name of the hit. In my case, I want to ensure the hit is from a sea turtle species, and an olfactory receptor. To change this parameter, you need only modify or remove the ```double_check``` function from line 35.  

One prerequisite of this analysis to be used in the same manner as I use it, is to only accept the best hit for each sequence. To generate the input file, you need to invoke ```-max_target_seqs 1``` and ```-outfmt 6``` in a Blast+ analysis and read the tab-delimited text file into R. 

There are a few additional filtering parameters in the ```get_turtle_olf``` function that are easily changed too. I included an alignment length and percentage identity filter too. 
