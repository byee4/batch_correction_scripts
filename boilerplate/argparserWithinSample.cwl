#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: []

inputs:
  algorithm:
    type: File
    inputBinding:
      position: -1
    label: "algorithm"
    doc: "algorithm"

  counts:
    type: File
    inputBinding:
      position: 1
      prefix: --counts
    label: "input counts matrix file"
    doc: "input raw counts matrix with columns describing cells, rows describing genes"

outputs:
  output_file:
    type: File
    outputBinding:
      glob: "$(inputs.counts.basename)-within-sample-normalization-*.tsv"
    label: "output"
    doc: "File containing output of * normalize() function"

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

  obj:
    type: File[]
    outputBinding:
      glob: "*.Data"
    label: "output"
    doc: "File containing robject of * normalize() function"