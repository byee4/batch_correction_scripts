cwlVersion: v1.0

class: CommandLineTool

baseCommand: [/home/bay001/projects/codebase/batch_correction/filtering_scripts/filter_cellranger_mtx.py]

inputs:

  mtx:
    type: File
    inputBinding:
      position: 1
      prefix: --mtx
    label: "input matrix file"
    doc: "input matrix file"

  genes:
    type: File
    inputBinding:
      position: 2
      prefix: --genes
    label: "genes file"
    doc: "genes file"

  barcodes:
    type: File
    inputBinding:
      position: 3
      prefix: --barcodes
    label: "barcodes file"
    doc: "barcodes file"

  filtered_mtx:
    type: string
    inputBinding:
      position: 4
      prefix: --filtered_mtx
    label: "filtered mtx file"
    doc: "filtered mtx file"

  filtered_genes:
    type: string
    inputBinding:
      position: 5
      prefix: --filtered_genes
    label: "filtered genes file"
    doc: "filtered genes file"

  filtered_barcodes:
    type: string
    inputBinding:
      position: 6
      prefix: --filtered_barcodes
    label: "filtered barcodes file"
    doc: "filtered barcodes file"

  keep_genes:
    type: File
    inputBinding:
      position: 7
      prefix: --keep_genes_file
    default: null
    label: "keep genes file"
    doc: "keep genes file"

  toss_genes:
    type: File
    inputBinding:
      position: 8
      prefix: --toss_genes_file
    default: null
    label: "filter genes file"
    doc: "filter genes file"

  min_columns:
    type: int
    inputBinding:
      position: 9
      prefix: --min_columns
    default: 3
    label: "minimum number of columns with --min_count counts to keep the gene (default: 3). Works with --min_count"
    doc: "minimum number of columns with --min_count counts to keep the gene (default: 3). Works with --min_count"

  min_count:
    type: int
    inputBinding:
      position: 10
      prefix: --min_count
    default: 3
    label: "minimum number of counts that --min_columns must contain (default: 3). Works with --min_columns"
    doc: "minimum number of counts that --min_columns must contain (default: 3). Works with --min_columns"


outputs:
  output_filtered_mtx:
    type: File
    outputBinding:
      glob: $(inputs.filtered_mtx)
    label: "output matrix"
    doc: "output matrix"

  output_filtered_genes:
    type: File
    outputBinding:
      glob: $(inputs.filtered_genes)
    label: "output genes"
    doc: "output genes"

  output_filtered_barcodes:
    type: File
    outputBinding:
      glob: $(inputs.filtered_barcodes)
    label: "output barcodes"
    doc: "output barcodes"

