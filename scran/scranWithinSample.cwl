cwlVersion: v1.0

class: CommandLineTool

baseCommand: [Rscript, /home/bay001/projects/codebase/batch_correction/scran/scranWithinSample.R]

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

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
    label: "output"
    doc: "File containing output of scran normalize() function"


