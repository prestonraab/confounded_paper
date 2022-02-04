import pandas as pd
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("infile", help="Path to the input file")
parser.add_argument("outfile", help="Path to the output file")
args = parser.parse_args()

df = pd.read_csv(args.infile, header=None, names=["Digit"] + list(range(28**2)))
df = df.set_index("Digit")\
    .apply(lambda row: 1 - (row / 255.0))\
    .sort_values("Digit")\
    .reset_index()\
    .reset_index()\
    .rename(columns={"index": "Sample"})
df.to_csv(args.outfile, index=False)
