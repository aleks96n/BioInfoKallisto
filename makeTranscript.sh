#!/bin/bash

#The job should run on the testing partition
#SBATCH -p testing

#The name of the job is test_job
#SBATCH -J parallel_uname

#The job requires 4 compute nodes
#SBATCH -N 4

#The job requires 2 task per node
#SBATCH --ntasks-per-node=2

#SBATCH --cpus-per-task=10

#SBATCH -t 02:00:00

#SBATCH --mem=32G

#These commands are run on one of the nodes allocated to the job (batch node)
kallisto index -i transcripts.idx gencode.v30.transcripts.fa
sleep 30
