# BioInfoKallisto
Benchmark kallisto against HISAT2 + featureCounts in eQTL mapping 

# Step 1 - installing kallisto

It is highly encouraged to use [HPC](https://hpc.ut.ee/en/guides/slurm/). Not only will this speed up the analysis, but will also give access to some important files that you cannot get easily without the use of HPC.

Install [miniconda](https://docs.conda.io/en/latest/miniconda.html) for Linux, newest Python version (version 3.9 as of this edit).

Put it in your HCP using the following bash command (alternatively, use FileZilla). Once it is in place, run the second command to install miniconda
```bash
scp <filename> user@rocket.hpc.ut.ee:directoy
bash <conda file>
```

Restart HPC before doing executing any more commands. After restarting, run the following command to install kallisto.
```bash
conda install -c bioconda kallisto
```

# Step 2 - creating the transcript file for kallisto

Copy the genotype transcripts file to your work directory (where the makeTranscript.sh is located). Note that you can change the name of the transcripts.fa file, however, you will have to modify bash script for parallezation.
```bash
cp /gpfs/hpc/projects/genomic_references/annotations/eQTLCatalogue/v0.1/gencode.v30.transcripts.fa gencode.v30.transcripts.fa
```

Create a separate stage for your HPC
```bash
ssh stage1
screen
```
If you want to be notified when the transcript file is created, modify the makeTranscript.sh file by adding the following two lines right after #SBATCH --mem=32G
```bash
#SBATCH --mail-type=END

#SBATCH --mail-user=<YOUR_EMAIL@EMAIL.DOMAIN>
```

Run the bash script for parallelization, which is provided in the github repository. This process takes about 15 minutes. After it is finished, you should see a transcript.idx file in your work directory.
```bash
sbatch makeTranscript.sh
```

# Step 3 - Creating fastQ somethings (Jens you got this)

It is recommended to get acquainted with [nextflow](https://github.com/AlasooLab/onboarding/blob/main/resources/nextflow.md) before moving further. However, it is optional.

Run the following two commands (hopefully still on a separate stage) to create fastQ somethings. This takes approximately 3 and a half hours.
```bash
module load java-1.8.0_40
./nextflow makeFastq.nf --studyFile study_file.txt
```

Run the python script to create an out.tsv somethings and move it to the qtlmap testdata folder.
```bash
module load python
python makeMatrix.py ResultsQ
mv out.tsv qtlmap/testdata/out.tsv
```

# Step 4 - Running the eQTL analysis

Navigate to the qtlmap directory
```bash
cd qtlmap
```

Finally, run the eQTL analysis using the following command (still on a separate stage). Note the end of the command asks for your email - this is for notifying when the work is done.
```bash
module load java-1.8.0_40
module load singularity/3.5.3

nextflow run main.nf -resume --run_permutation -profile tartu_hpc   --studyFile testdata/multi_test.tsv --vcf_has_R2_field FALSE    --varid_rsid_map_file testdata/varid_rsid_map.tsv.gz --n_batches 200 --run_nominal false --email "sinu@email.com"
```

This should create a "results" folder. Most notable file is in results/sumstats/GEUVADIS_test_ge.permuted.tsv. 

# Step 5 - comparing with other results

Note that you require the kallisto file that you got from Step 4 and another .tsv file for comparison. In order to create the comparison, modify the "eQTLcomparison.r" script by adding appropriate file paths.
```bash
hisat <-  read.csv("<comparison_file.tsv>", sep = '\t', header = TRUE)
kallista <- read.csv("<kallisto.tsv>", sep = '\t', header = TRUE)
```


