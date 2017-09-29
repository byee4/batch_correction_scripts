#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: []

inputs:

  algorithm:
    type: File
    inputBinding:
      position: -1
    label: "runner for a specific algorithm"

  counts:
    type: File[]
    inputBinding:
      position: 1
      prefix: --counts
    label: "input counts matrix file"
    doc: "input raw counts matrix with columns describing cells, rows describing genes"

outputs:

  output_s:
    type: File[]
    outputBinding:
      glob: "*normWithinGroup-*.tsv"
    label: "output"
    doc: "Files containing outputs of * normalize() function"

  plot_s:
    type: File[]
    outputBinding:
      glob: "*.pdf"
    label: "output"
    doc: "File containing PDF qc plots"

  other_s:
    type: File[]
    outputBinding:
      glob: "*.txt"
    label: "output"
    doc: "File containing other outputs from the * normalize() function"

  obj_s:
    type: File[]
    outputBinding:
      glob: "*.robj"
    label: "output"
    doc: "File containing robject of * normalize() function"