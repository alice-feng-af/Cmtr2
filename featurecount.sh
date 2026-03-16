#!/bin/bash
#SBATCH --job-name=featurecounts
#SBATCH --partition=normal,bigmem,long
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=24G
#SBATCH --output=log%J.out
#SBATCH --error=log%J.err

# load modules
module load samtools
module load subread/2.0.2

# define paths
STAR_RESULTS_DIR="$HOME/results/STAR"
GENOME_GTF="$HOME/04.Ref/genome.gtf"

cd "$STAR_RESULTS_DIR" || exit 1

# create featureCounts matrix from STAR coordinate-sorted BAMs
#s = 0 because library is unstranded
featureCounts \
  -a "$GENOME_GTF" \
  -o "${STAR_RESULTS_DIR}/gene_counts.txt" \
  -T "$SLURM_CPUS_PER_TASK" \
  -s 0 \
  -p -B -C \
  -t exon \
  -g gene_id \
  --extraAttributes gene_name \
  A*_Aligned.sortedByCoord.out.bam
