#!/usr/bin/env python

"""
Re-formats the output from Loupe in a way that the gene list can be
used to filter using filter_cellranger_mtx.py.
"""

import argparse
import pandas as pd


def format_genes_list(df, list_id):
    """
    Takes a pandas dataframe and returns just the column containing the
    gene id, within the specified list num

    :param df: pandas.DataFrame
    :param list_num: string
    :return:
    """
    return df[df['List']==list_id][['Ensembl']]

def format_expression_table(df):
    """
    Takes a pandas dataframe and returns just the column containing gene id.
    :param df: pandas.DataFrame
    :return:
    """
    return df[['EnsemblID']]

def format_list(loupe_export, output, export_type, list_id):
    df = pd.read_table(loupe_export, sep=',')
    if export_type == 1:
        df = format_expression_table(df)
    elif export_type == 2:
        df = format_genes_list(df, list_id)
    else:
        print("Warning: export type invalid")
        return 1

    df.to_csv(output, header=False, index=False)

def main():
    """
    Reformats loupe export files for filter_cellranger_mtx.py usage.

    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--loupe_export",
        required=True,
        help="export file from loupe"
    )
    parser.add_argument(
        "--output",
        required=True,
        help="output gene list"
    )
    parser.add_argument(
        "--export_type",
        required=False,
        type=int,
        help="either [1] gene_expression_table.csv or [2] genes_list.csv "
             "(default: 1)",
        default=1
    )
    parser.add_argument(
        "--list_id",
        required=False,
        help="if export_type is 1, you can specify the list # (default: List1)",
        default="List1"
    )

    args = parser.parse_args()

    loupe_export = args.loupe_export
    output = args.output
    export_type = args.export_type
    list_id = args.list_id

    format_list(loupe_export, output, export_type, list_id)

if __name__ == "__main__":
    main()
