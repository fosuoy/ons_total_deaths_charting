# Covid-19 death graphs
A script to download data from National Audit Office and create up to date
graphs showing the increase in death rate over the Coronavirus outbreak, data
from here:

https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales


Generates a graph that looks like this:

![Total Deaths](https://github.com/fosuoy/ons_total_deaths_charting/blob/master/total_deaths_2016_2020.png?raw=true)

# Requirements
Create a virutalenv:
```
virtualenv env
```
Install requirements:
```
source env/bin/activate
pip install -r requirements.txt
```
Run gather_data.sh to gather the requisite spreadsheets:
```
./gather_data.sh
```

Then run process_graph.py
```
./process_graph.py
```

Generates total_deaths_2016_2020.png
