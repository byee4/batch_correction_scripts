#!/usr/bin/env python

"""
Filters counts matrices based on some kind of criteria.
"""

import argparse
import pandas as pd
import csv
import os
import scipy.sparse
import scipy.io

def read_df(counts_file):
    """
    tab separated file and returns a pandas dataframe
    :param counts_file: basestring
        Tab separated counts file where the first row indicates cell names and
        the first column contains gene ids
    :return df: Pandas.DataFrame()
    """
    print("reading in {}".format(counts_file))
    df = pd.read_table(counts_file, index_col=0)
    print("done reading {}".format(counts_file))
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
    df = df.ix[df[df > min_count].isnull().sum(axis=1) < (num_columns - min_columns)]
    return df

def create_new_counts_file(df, new_counts_file):
    df.to_csv(new_counts_file, sep='\t')

def filter_by_names(df, names_list):
    """
    Returns a filtered dataframe based on indices specified by names_list.

    :param df: pandas.DataFrame()
    :param names_list: list
    :return filtered_df: pandas.DataFrame
    """
    return df.ix[names_list]

def filter_counts(counts_file, names_file, min_columns, min_count, new_counts_file):
    """
    main function.

    :param mtx_file: string
    :param genes_file: string
    :param barcodes_file: string
    :return:
    """

    df = read_df(
        counts_file
    )
    if names_file is not None:
        names_list = [row[0] for row in
            csv.reader(open(names_file), delimiter="\t")
        ]
    else:
        names_list = list(df.index)

    print("dim: ", df.shape)
    dx = filter_by_names(df, names_list)
    print("dim after filtering names: ", dx.shape)
    dy = filter_by_count(dx, min_columns, min_count)
    print("dim after filtering counts: ", dy.shape)
    create_new_counts_file(
        dy, new_counts_file
    )

def main():
    """
    Filters an mtx file from cellranger given certain criteria.
    --mtx, --genes, and --barcodes are typically in a folder
    called outs/filtered_gene_bc_matrices/$SPECIES/

    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--counts",
        required=True,
        help="counts file from with cells as column names and genes as row names"
    )
    parser.add_argument(
        "--filtered_counts",
        required=True,
        help="output counts.filtered.tsv file"
    )
    parser.add_argument(
        "--names",
        required=False,
        default=None,
        help = "line-delimited names to filter (keep) in your matrix "
               "(default: None, keep all names)"
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

    counts_file = args.counts
    new_counts_file = args.filtered_counts
    names_file = args.names
    min_columns = args.min_columns
    min_count = args.min_count


    filter_counts(
        counts_file, names_file, min_columns, min_count, new_counts_file,
    )

if __name__ == "__main__":
    main()
