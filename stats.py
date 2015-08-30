#!/usr/bin/env python

import sys
import csv
from rasterstats import zonal_stats

def stats(features, raster, band=1, out='out.csv'):
    stats = zonal_stats(features, raster, stats='sum', copy_properties=True)
    with open(out, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, stats[0].keys())
        writer.writeheader()
        writer.writerows(stats)

if __name__ == "__main__":
    if len(sys.argv)<3:
        print "usage: python stats.py <features> <raster> [band] [outcsv]"
    stats(*sys.argv[1:])
