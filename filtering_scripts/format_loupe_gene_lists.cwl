cwlVersion: v1.0

class: CommandLineTool

baseCommand: [/home/bay001/projects/codebase/batch_correction/filtering_scripts/format_loupe_gene_lists.py]

inputs:

  loupe_export:
    type: File
    inputBinding:
      position: 1
      prefix: --loupe_export
    label: "loupe export file"
    doc: "loupe export file"

  output:
    type: string
    inputBinding:
      position: 2
      prefix: --output
    label: "output file"
    doc: "output file"

  export_type:
    type: int
    inputBinding:
      position: 3
      prefix: --export_type
    default: null
    label: "export type"
    doc: "export type"

  list_id:
    type: string
    inputBinding:
      position: 4
      prefix: --list_id
    default: null
    label: "list id"
    doc: "list id"

outputs:
  output_list:
    type: File
    outputBinding:
      glob: $(inputs.output)
    label: "output list"
    doc: "output list"


