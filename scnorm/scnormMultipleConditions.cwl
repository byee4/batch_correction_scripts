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

  conditions:
    type: int[]
    inputBinding:
      position: 2
      prefix: --conditions
    label: "specifies which conditions go with each counts matrix."
    doc: "specifies which conditions go with each counts matrix."

  scnormDitherCounts:
    type: boolean
    inputBinding:
      position: 2
      prefix: --ditherCounts
    label: "output tsv file"
    doc: " expression file"

  scnormFilterCellNum:
    type: int
    inputBinding:
      position: 3
      prefix: --filterCellNum
    label: " SCnorm only considers genes having at least this number of non-zero expression values"

outputs:

  output_s:
    type: File[]
    outputBinding:
      glob: "*between-conditions-normalization-*.tsv"
    label: "output"
    doc: "Files containing outputs of scran normalize() function"

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
    doc: "File containing other outputs from the scran normalize() function"

  obj_s:
    type: File[]
    outputBinding:
      glob: "*.robj"
    label: "output"
    doc: "File containing robject of scran normalize() function"