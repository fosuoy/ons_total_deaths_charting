#!/usr/bin/env bash
# This is a quick script to convert xls / xlsx data from the ONS about death
# data to CSVs so that we can process them in a separate script
# It's a bit messy but xls / xlsx is a messy format

DOWNLOAD_DIR="downloads"
CSV_DIR="csv"
XLSX_DIR="xlsx"
ONS_FILE_URL="https://www.ons.gov.uk/file"

declare -A file_to_year
file_to_year=(
    ["2016"]="publishedweek522016.xls"
    ["2017"]="publishedweek522017.xls"
    ["2018"]="publishedweek522018withupdatedrespiratoryrow.xls"
    ["2019"]="publishedweek522019.xls"
    ["2020"]="publishedweek192020.xlsx"
)

declare -A remove_rows
remove_rows=(
    ["2016"]="1,3d"
    ["2017"]="1,3d"
    ["2018"]="1,3d"
    ["2019"]="1,3d"
    ["2020"]="1,4d"
)

update_uri_string() {
    SLASH="%2f"
    URI_STRING="uri=${SLASH}peoplepopulationandcommunity${SLASH}"
    URI_STRING+="birthsdeathsandmarriages${SLASH}"
    URI_STRING+="deaths${SLASH}datasets${SLASH}"
    URI_STRING+="weeklyprovisionalfiguresondeathsregisteredinenglandandwales${SLASH}"
    URI_STRING+="${1}${SLASH}"
    URI_STRING+="${file_to_year[$1]}"
    echo "${URI_STRING}"
}

download_file() {
    # Argument $1 is the year to download data for
    # URI_STRING is generated in update_uri_string
    mkdir -p "${DOWNLOAD_DIR}"
    update_uri_string "$1"
    curl -o "${DOWNLOAD_DIR}/${file_to_year[$1]}" "${ONS_FILE_URL}?${URI_STRING}"
}

convert_to_xlsx() {
    libreoffice --convert-to xlsx \
        --outdir "${XLSX_DIR}" \
        "${DOWNLOAD_DIR}"/*.xls
    cp "${DOWNLOAD_DIR}"/*.xlsx "${XLSX_DIR}"
}

convert_to_csv() {
    mkdir -p "${CSV_DIR}"
    for i in $(ls ${XLSX_DIR}) ; do
        year=$(echo "$i" | egrep -o "20[0-9]{2}")
        xlsx2csv -n "Weekly figures ${year}" \
            "${XLSX_DIR}/${i}" \
            "${CSV_DIR}/${year}.csv"
    done
}

clean_up_csvs() {
    sed -i "${remove_rows[$1]}" "${CSV_DIR}/$1.csv"
}

for i in $(seq 2016 2020); do
    download_file "${i}"
done

convert_to_xlsx
convert_to_csv

for i in $(seq 2016 2020); do
    clean_up_csvs "${i}"
done
