
MAJORCROPSURL=https://earthstat2.s3.amazonaws.com/HarvestedAreaYield2000/HarvestedAreaYieldMajorCrops_NetCDF.zip
AQUEDUCTPROJURL=http://data.wri.org/Aqueduct/web/aqueduct_projections_20150309_shp.zip
IRRAEIURL=http://www.fao.org/nr/water/aquastat/irrigationmap/gmia_v5_aei_ha_asc.zip
IRRAAIURL=http://www.fao.org/nr/water/aquastat/irrigationmap/gmia_v5_aai_pct_aei_asc.zip
COUNTRYURL=https://raw.githubusercontent.com/wri/wri-bounds/master/dist/all_primary_countries.geojson

AQUEDUCTSHP=data/aqueduct_projections_20150309.shp
AEIRAS=data/gmia_v5_aei_ha.asc
AAIRAS=data/gmia_v5_aai_pct_aei.asc

CROPS=barley cassava cotton groundnut maize millet oilpalm potato rapeseed rice rye sorghum soybean sugarbeet sugarcane sunflower wheat

croppath=data/HarvestedAreaYieldMajorCrops_NetCDF/$(1)_HarvAreaYield_NetCDF/$(1)_AreaYieldProduction.nc
CROPSNC=$(foreach c,$(CROPS),$(croppath))

nochange='$(1) == "Near normal"'
deacrease='$(1).indexOf("decrease")>-1'
increase='$(1).indexOf("increase")>-1'

COUNTRIES=CHN IND IDN IRN USA BRA PAK THA MEX BGD

_=data/__tmp.shp
_2=data/__tmp2.shp
2=$(word 2,$^)
3=$(word 3,$^)
4=$(word 4,$^)


all: irrstats data/aai_ha_8bit.tif

data/aai_ha_8bit.tif: data/aai_ha.tif
	gdal_translate -scale -ot Byte -a_srs WGS84 -stats data/aai_ha.tif aai_ha_8bit.tif

top10irrigators:
	ogrinfo data/countries.geojson -geom=false -sql "SELECT ADM0_A3 FROM OGRGeoJSON WHERE fid in (77,32,182,134,76,79,111,169,15,23)"

irrstats: data/aai_ha.tif data/countries.geojson data/bt4028cl.shp data/ws4028cl.shp
	python stats.py $3 $< 1 irr_bt.csv
	python stats.py $4 $< 1 irr_ws.csv	
	$(foreach c,$(COUNTRIES),\
		echo $c; \
		mapshaper -i $2 -filter 'ADM0_A3=="$c"' -o $_ force; \
		mapshaper -i $3 -clip $_ -o $(_2) force; \
		python stats.py $(_2) $< 1 irr_bt$c.csv; \
		mapshaper -i $4 -clip $_ -o $(_2) force; \
		python stats.py $(_2) $< 1 irr_ws$c.csv; )
	python crumplecsvs.py

cropstats: data/dissolved.shp $(CROPSNC) crops
	$(foreach c,$(CROPS),python stats.py data/dissolved.shp $(call croppath,$c) 6 data/$c.csv; )

data/bt4028cl.shp: $(AQUEDUCTSHP)
	mapshaper $< -dissolve $(notdir $(basename $@)) -o $@ force

data/ws4028cl.shp: $(AQUEDUCTSHP)
	mapshaper $< -dissolve $(notdir $(basename $@)) -o $@ force

data/aai_ha.tif: $(AAIRAS) $(AEIRAS)
	gdal_calc.py -A $< -B $2 --calc='A*B' --outfile=$@

$(AAIRAS): irr_aai.zip
	unzip -o -d data $<

$(AEIRAS): irr_aei.zip
	unzip -o -d data $<

data/countries.geojson:
	curl -o $@ $(COUNTRYURL)

irr_aai.zip:
	curl -o $@ $(IRRAAIURL)

irr_aei.zip:
	curl -o $@ $(IRRAEIURL)

$(AQUEDUCTSHP): aqueductproj.zip
	unzip -o -d data $<

aqueductproj.zip:
	curl -o $@ $(AQUEDUCTPROJURL)

crops: majorcrops.zip
	unzip -o -d data $<

majorcrops.zip:
	curl -o $@ $(MAJORCROPSURL)

.PHONY: clean

.SECONDARY: *

clean:
	rm -rf data
