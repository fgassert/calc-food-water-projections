#!/usr/bin/env python

import pandas as pd

COUNTRYLIST = ['', 'CHN', 'IND', 'IDN', 'IRN', 'USA', 'BRA', 'PAK', 'THA', 'MEX', 'BGD']
WSCOL = 'ws4028cl'
BTCOL = 'bt4028cl'

def main():
    wsdf = pd.DataFrame()
    btdf = pd.DataFrame()
    for c in COUNTRYLIST:
        ws = pd.read_csv('irr_ws{}.csv'.format(c))
        if wsdf.index.name != WSCOL:
            wsdf[WSCOL] = ws[WSCOL]
            wsdf.set_index(WSCOL, inplace=True)
        ws.set_index(WSCOL, inplace=True)
        wsdf['ws{}'.format(c)] = ws['sum']
        
        bt = pd.read_csv('irr_bt{}.csv'.format(c))
        if btdf.index.name != BTCOL:
            btdf[BTCOL] = bt[BTCOL]
            btdf.set_index(BTCOL, inplace=True)
        bt.set_index(BTCOL, inplace=True)
        btdf['bt{}'.format(c)] = bt['sum']
    wsdf.to_csv('ws_countries.csv')
    btdf.to_csv('bt_countries.csv')

if __name__ == "__main__":
    main()
