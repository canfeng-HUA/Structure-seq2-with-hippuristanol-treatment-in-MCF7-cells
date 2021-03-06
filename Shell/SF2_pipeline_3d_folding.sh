#!/bin/bash

#This script will produce data required for the Sliding_windows_folded.R and Stats_plots.R scripts
#Ensure that the input files are in the current directory before running

#fold 50 and 100nt windows for all 5'UTRs more than 100nt else full length 5'UTRs
#generate a fasta and react files for all 100nt windows with the 5'UTRs of all filtered transcripts with a 5'UTR more than 100nt
react_windows.py control_fpUTR.react hippuristanol_fpUTR.react MCF7_2015_fpUTRs.fasta -wlen 100 -wstep 10 -restrict filtered_plus_100_transcripts.txt -fastaout -reactout
react_windows.py control_fpUTR.react hippuristanol_fpUTR.react MCF7_2015_fpUTRs.fasta -wlen 50 -wstep 10 -restrict filtered_plus_100_transcripts.txt -fastaout -reactout

#rename outputted fasta files
mv control_fpUTR_hippuristanol_fpUTR_100win_10step.fasta fpUTR_100win_10step.fasta
mv control_fpUTR_hippuristanol_fpUTR_50win_10step.fasta fpUTR_50win_10step.fasta

#extract all transcript_step IDs from FASTA
return_IDs.py fpUTR_100win_10step.fasta
return_IDs.py fpUTR_50win_10step.fasta

#fold all windows
batch_fold_rna.py fpUTR_100win_10step_IDs.txt fpUTR_100win_10step.fasta 1 -r control_fpUTR_100win_10step.react
batch_fold_rna.py fpUTR_100win_10step_IDs.txt fpUTR_100win_10step.fasta 1 -r hippuristanol_fpUTR_100win_10step.react
batch_fold_rna.py fpUTR_50win_10step_IDs.txt fpUTR_50win_10step.fasta 1 -r control_fpUTR_50win_10step.react
batch_fold_rna.py fpUTR_50win_10step_IDs.txt fpUTR_50win_10step.fasta 1 -r hippuristanol_fpUTR_50win_10step.react

#rename folders
mv output_files_control_fpUTR_100win_10step.react_fpUTR_100win_10step_IDs.txt_310.15_fpUTR_100win_10step.fasta_RNAstructure-mfe_sht_0_md_99999 \
output_files_control_fpUTR_100win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999
mv output_files_hippuristanol_fpUTR_100win_10step.react_fpUTR_100win_10step_IDs.txt_310.15_fpUTR_100win_10step.fasta_RNAstructure-mfe_sht_0_md_99999 \
output_files_hippuristanol_fpUTR_100win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999
mv output_files_control_fpUTR_50win_10step.react_fpUTR_50win_10step_IDs.txt_310.15_fpUTR_50win_10step.fasta_RNAstructure-mfe_sht_0_md_99999 \
output_files_control_fpUTR_50win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999
mv output_files_hippuristanol_fpUTR_50win_10step.react_fpUTR_50win_10step_IDs.txt_310.15_fpUTR_50win_10step.fasta_RNAstructure-mfe_sht_0_md_99999 \
output_files_hippuristanol_fpUTR_50win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999

#extract MFEs and strandedness
structure_statistics.py -d output_files_control_fpUTR_100win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999/CT -mode F -offset 1 -name control_fpUTR_100win_10step_structure_statistics.csv
structure_statistics.py -d output_files_hippuristanol_fpUTR_100win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999/CT -mode F -offset 1 -name hippuristanol_fpUTR_100win_10step_structure_statistics.csv
structure_statistics.py -d output_files_control_fpUTR_50win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999/CT -mode F -offset 1 -name control_fpUTR_50win_10step_structure_statistics.csv
structure_statistics.py -d output_files_hippuristanol_fpUTR_50win_10step_filtered_plus_100_transcripts_310.15_RNAstructure-mfe_sht_0_md_99999/CT -mode F -offset 1 -name hippuristanol_fpUTR_50win_10step_structure_statistics.csv

#calculate GC content of 50nt windows
fasta_composition.py -single fpUTR_50win_10step.fasta

#fold all full length 5'UTRs less than or equal to 100nt
batch_fold_rna.py filtered_minus_100_transcripts.txt MCF7_2015_fpUTRs.fasta 1 -r control_fpUTR.react
batch_fold_rna.py filtered_minus_100_transcripts.txt MCF7_2015_fpUTRs.fasta 1 -r hippuristanol_fpUTR.react

#extract MFEs and strandedness
structure_statistics.py -d output_files_control_fpUTR.react_filtered_minus_100_transcripts.txt_310.15_MCF7_2015_fpUTRs.fasta_RNAstructure-mfe_sht_0_md_99999/CT -mode F -offset 0 -name control_fpUTR_structure_statistics.csv
structure_statistics.py -d output_files_hippuristanol_fpUTR.react_filtered_minus_100_transcripts.txt_310.15_MCF7_2015_fpUTRs.fasta_RNAstructure-mfe_sht_0_md_99999/CT -mode F -offset 0 -name hippuristanol_fpUTR_structure_statistics.csv

