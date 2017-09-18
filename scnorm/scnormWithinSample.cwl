cwlVersion: v1.0

class: CommandLineTool

baseCommand: [Rscript, /home/bay001/projects/codebase/batch_correction/scnorm/scnormWithinSample.R]

inputs:

  counts:
    type: File
    inputBinding:
      position: 1
      prefix: --counts
    label: "input counts matrix file"
    doc: "input raw counts matrix with columns describing cells, rows describing genes"

  outfile:
    type: string
    inputBinding:
      position: 2
      prefix: --outfile
    label: "output tsv file"
    doc: "output normalized expression file"

  ditherCounts:
    type: boolean
    inputBinding:
      position: 3
      prefix: --ditherCounts
    label: "output tsv file"
    doc: " expression file"

  filterCellNum:
    type: int
    inputBinding:
      position: 4
      prefix: --filterCellNum
    label: " SCnorm only considers genes having at least this number of non-zero expression values"

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
    label: "output"
    doc: "File containing output of scran normalize() function"


