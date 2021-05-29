params.transcript_idx = "transcripts.idx"

trans = file(params.transcript_idx)

Channel.fromPath(params.studyFile)
    .ifEmpty { error "Cannot find study file: ${params.studyFile}" }
    .splitCsv(header: true, sep: '\t', strip: true)
    .map{row -> [ row.study, file(row.fastq1), file(row.fastq2) ]}
    .set { fastq_ch }


process hisat2Align{
    publishDir 'ResultsQ'
    input:
    file trans
    set sample_name, file(fastq1), file(fastq2) from fastq_ch

    output:
    file "kallisto_${sample_name}" into kallisto_out_dirs

    script:
    """
    mkdir kallisto_${sample_name}
    kallisto quant -i ${trans} -t 12 -o kallisto_${sample_name} -b '100' ${fastq1} ${fastq2}
    """
}
