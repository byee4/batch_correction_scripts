cwlVersion: v1.0

class: CommandLineTool

baseCommand: [Rscript, /home/bay001/projects/codebase/batch_correction/combatsva/combatBatchCorrect.R]

inputs:

  counts:
    type: File[]
    inputBinding:
      position: 1
      prefix: --counts
    label: "input counts matrix file"
    doc: "input raw counts matrix with columns describing cells, rows describing genes"

  outdir:
    type: string
    inputBinding:
      position: 2
      prefix: --outdir
    label: "output directory"
    doc: "output directory where batch correction outputs go."

outputs:

  output_file:
    type: File[]
    outputBinding:
      glob: "$(inputs.outdir)*.corrected2.tsv"
    label: "output"
    doc: "File containing output of sva ComBat() function"

  # output_plot:
  #   type: File
  #   outputBinding:
  #     glob: "$(inputs.outdir.basename)*pdf"
  #   label: "output QC plot"
