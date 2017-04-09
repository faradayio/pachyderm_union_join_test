#!/bin/bash
#
# Generate the input files that we'll load into Pachyderm.  Requires
# https://github.com/BurntSushi/xsv

# Be paranoid about errors.
set -euo pipefail

# Clear our output directories.
rm -rf ./population ./latlon

# Fix terrible, terrible delimiters.
perl -pe 's/\s+$/\n/; s/[ \t]+/,/g' Gaz_zcta_national.txt > Gaz_zcta_national.csv

# Partition population data by 2-digit zip code prefix.
xsv select GEOID,POP10 Gaz_zcta_national.csv |
    xsv partition --filename='{}/population.csv' -p2 GEOID population

# Partition latlon data by 2-digit zip code prefix.
xsv select GEOID,INTPTLAT,INTPTLONG Gaz_zcta_national.csv |
    xsv partition --filename='{}/latlon.csv' -p2 GEOID latlon
