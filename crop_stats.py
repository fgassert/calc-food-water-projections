#!/usr/bin/env python

import pandas as pd

# Input data http://faostat3.fao.org/download/FB/BC/E
# All countries
# Production, Supply, Stock Variation
# 2008-2012

INCSV = "crop_stats.csv"
OUTCSV = "crop_net.csv"

def main():
    df = pd.read_csv(INCSV)
    # average across 2008-2012
    avged = df.groupby(('AreaName','ElementName','ItemName')).mean()
    # sum across 2008-2012
    summed = avged.reset_index().groupby(('AreaName','ElementName')).sum()
    # give each element its own column
    calc = summed.unstack()["Value"]
    # consumption = supply-stock variation
    calc["Consumption"] = calc["Domestic supply quantity"] - calc["Stock Variation"]
    calc["Net exports"] = calc["Production"] - calc["Consumption"]
    out = calc.filter(("Production","Consumption","Net exports"))
    out.to_csv(OUTCSV)

if __name__=="__main__":
    main()
