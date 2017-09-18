#!/usr/bin/env python

"""
Filters sparse matrices based on some kind of criteria.
"""

import argparse
import pandas as pd
import csv
import os
import scipy.sparse
import scipy.io

def read_mtx_as_dataframe(mtx_file, genes_list, barcodes_list):
    """
    Reads a mtx file and returns a pandas dataframe
    :param mtx_file: sparse matrix
    :return df: Pandas.DataFrame()
    """
    mat = scipy.io.mmread(mtx_file)
    df = pd.DataFrame(mat.todense(), columns=barcodes_list, index=genes_list)
    return df

def filter_by_count(df, min_columns, min_count):
    """
    Filters dataframe to include just the rows with at least
    min_count counts in at least min_columns columns.

    :param df: pandas.DataFrame
    :param min_columns: int
    :param min_count: int
    :return df: pandas.DataFrame
    """
    num_columns = len(df.columns)
    df = df.ix[df[df >= min_count].isnull().sum(axis=1) < (num_columns - min_columns)]
    return df

def create_new_genes_file(old_genes_file, df, new_genes_file):
    """
    Creates a new genes file based on the filtered matrix.

    :param old_genes_file: basestring
    :param df: pandas.DataFrame
    :param new_genes_file: basestring
    :return:
    """
    genes = pd.read_table(
        old_genes_file, names=['gene_name'], index_col=0
    )
    genes.ix[df.index].to_csv(
        new_genes_file,
        index=True, header=False, sep='\t'
    )

def create_new_barcodes_file(old_barcodes_file, df, new_barcodes_file):
    """
    Creates a new barcodes file based on the filtered matrix.

    :param old_barcodes_file: basestring
    :param df: pandas.DataFrame
    :param new_barcodes_file: basestring
    :return:
    """
    barcodes = pd.read_table(
        old_barcodes_file, index_col=0, names=['barcodes']
    )

    barcodes.ix[df.columns].to_csv(
        new_barcodes_file,
        index=True, header=False
    )

def create_new_mtx_file(df, new_mtx_file):
    mtx = scipy.sparse.csr_matrix(df.values)
    scipy.io.mmwrite(new_mtx_file, mtx)

def filter_by_names(df, names_list):
    """
    Returns a filtered dataframe based on indices specified by names_list.

    :param df: pandas.DataFrame()
    :param names_list: list
    :return filtered_df: pandas.DataFrame
    """

    return df.ix[names_list]

def filter_cellranger(mtx_file, genes_file, barcodes_file,
                      kept_genes_file, toss_genes_file,
                      min_columns, min_count,
                      new_mtx_file, new_genes_file, new_barcodes_file):
    """

    :param mtx_file: string
    :param genes_file: string
    :param barcodes_file: string
    :param kept_genes_file: string
    :param toss_genes_file: string
    :param min_columns: int
    :param min_count: int
    :param new_mtx_file: string
    :param new_genes_file: string
    :param new_barcodes_file: string
    :return:
    """

    gene_ids = [
        row[0] for row in csv.reader(open(genes_file), delimiter="\t")
    ]
    barcodes = [
        row[0] for row in
            csv.reader(open(barcodes_file), delimiter="\t")
    ]

    df = read_mtx_as_dataframe(
        mtx_file, gene_ids, barcodes
    )

    # If we want to subset our matrix using a list of genes
    if kept_genes_file is not None:
        names_list = [row[0] for row in
            csv.reader(open(kept_genes_file), delimiter="\t")
        ]
    else:
        names_list = list(df.index)

    # If we want to subset our matrix by removing genes
    if toss_genes_file is not None:
        toss_list = [row[0] for row in
            csv.reader(open(toss_genes_file), delimiter="\t")
        ]
        names_list = list(set(names_list) - set(toss_list))

    print("dim: ", df.shape)
    dx = filter_by_names(df, names_list)
    print("dim after filtering names: ", dx.shape)
    dy = filter_by_count(dx, min_columns, min_count)
    print("dim after filtering counts: ", dy.shape)
    create_new_genes_file(
        genes_file, dy, new_genes_file
    )
    create_new_barcodes_file(
        barcodes_file, dy, new_barcodes_file
    )
    create_new_mtx_file(
        dy, new_mtx_file
    )

def main():
    """
    Filters an mtx file from cellranger given certain criteria.
    --mtx, --genes, and --barcodes are typically in a folder
    called outs/filtered_gene_bc_matrices/$SPECIES/

    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--mtx",
        required=True,
        help="matrix.mtx file from cellranger"
    )
    parser.add_argument(
        "--genes",
        required=True,
        help="genes.tsv file (tabbed ENSG\tGENENAME) from cellranger"
    )
    parser.add_argument(
        "--barcodes",
        required=True,
        help="barcodes.tsv file from cellranger"
    )
    parser.add_argument(
        "--filtered_mtx",
        required=True,
        help="output matrix.filtered.mtx file"
    )
    parser.add_argument(
        "--filtered_genes",
        required=True,
        help="output genes.filtered.tsv"
    )
    parser.add_argument(
        "--filtered_barcodes",
        required=True,
        help="output barcodes.filtered.tsv"
    )
    parser.add_argument(
        "--keep_genes_file",
        required=False,
        default=None,
        help = "line-delimited genes to filter in (keep) in your matrix "
               "(default: None, keep all genes)"
    )
    parser.add_argument(
        "--toss_genes_file",
        required=False,
        default=None,
        help="line-delimited genes to filter out (toss) in your matrix "
             "(default: None, keep all genes)"
    )
    parser.add_argument(
        "--min_columns",
        required=False,
        default=3,
        type=int,
        help="minimum number of columns with --min_count counts to "
             "keep the gene (default: 3). Works with --min_count"
    )
    parser.add_argument(
        "--min_count",
        required=False,
        default=3,
        type=int,
        help = "minimum number of counts that --min_columns must contain"
               " (default: 3). Works with --min_columns"
    )
    args = parser.parse_args()

    mtx_file = args.mtx
    genes_file = args.genes
    barcodes_file = args.barcodes
    keep_genes_file = args.keep_genes_file
    toss_genes_file = args.toss_genes_file
    min_columns = args.min_columns
    min_count = args.min_count
    new_mtx_file = args.filtered_mtx
    new_genes_file = args.filtered_genes
    new_barcodes_file = args.filtered_barcodes

    filter_cellranger(
        mtx_file, genes_file, barcodes_file, keep_genes_file, toss_genes_file,
        min_columns, min_count,
        new_mtx_file, new_genes_file, new_barcodes_file
    )

if __name__ == "__main__":
    main()
