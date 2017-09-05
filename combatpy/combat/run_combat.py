#!/usr/bin/env python

"""
basic module to use as an example.
"""
import argparse
import pandas as pd
from combat import combat

def run_combat(exprs, batches):
    """

    Args:
        a: int, first number to add
        b: int, second number to add
    Returns:
        c: int, addition between a and b
    """
    merged = pd.DataFrame()
    batch_count = 0
    lst = []
    for exp in exprs:
        batch_count += 1
        df = pd.read_table(exp, index_col=0)
        df.columns = [c + '_{}'.format(batch_count) for c in df.columns]
        print(df.head())

        print(merged.shape, df.shape)
        merged = pd.merge(merged, df, how='outer', left_index=True, right_index=True).fillna(0)
        lst = lst + ['batch_{}'.format(batch_count)] * df.shape[1]
    batches = pd.Series(lst)
    batches.index = merged.columns
    merged.to_csv('/home/bay001/projects/codebase/batch_correction/combatpy/combat/uncorrected.tsv', sep='\t')
    batch_corrected_df = combat(data=merged, batch=batches)
    return batch_corrected_df

def main():
    """
    Main program.

    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--counts",
        required=True,
        nargs='+'
    )
    parser.add_argument(
        "--batches",
        required=True,
        type=str,
    )
    parser.add_argument(
        "--outfile",
        required=True,
        type=str,
    )
    args = parser.parse_args()

    counts = args.counts
    batches = args.batches
    out_file = args.outfile

    batch_corrected_df = run_combat(counts, batches)
    batch_corrected_df.to_csv(out_file, sep='\t')
if __name__ == "__main__":
    main()
