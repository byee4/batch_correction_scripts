cwlVersion: v1.0

class: CommandLineTool

baseCommand: [Rscript, /home/bay001/projects/codebase/batch_correction/seurat/seuratBatchCorrect.R]

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

  normalize:
    type: boolean
    inputBinding:
      position: 3
      prefix: --normalize
    label: "output directory"
    doc: "output directory where batch correction outputs go."

  nGenes:
    type: int
    inputBinding:
      position: 4
      prefix: --nGenes
    label: "output directory"
    doc: "output directory where batch correction outputs go."

  CCStart:
    type: int
    inputBinding:
      position: 5
      prefix: --CCStart
    label: "CCA range start"
    doc: "CC1"

  CCEnd:
    type: int
    inputBinding:
      position: 6
      prefix: --CCEnd
    label: "CCA range end"
    doc: "CC13"

outputs:

  output_file:
    type: File[]
    outputBinding:
      glob: $(inputs.counts)*.corrected2
    label: "output"
    doc: "File containing output of seurat normalize() function"

