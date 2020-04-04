import pandas as pd
from datetime import date

f_date = date.today()
# Set the last day of a range of dates
l_date = date(2020, 4, 1)

delta = f_date - l_date
days_offset = delta.days

df = pd.read_csv('https://covid.ourworldindata.org/data/ecdc/total_cases.csv')

# Set the date range from N days before the l_date previously declared  (In this case 27 days earlier)
covid_dates = df['date'].unique().tolist()[-27 - days_offset :-days_offset]

# The map covid dates are used in the slider, the 'label' is used for the slider and 'value' -> Date is used for every dash app
map_covid_dates = { index: { 'label': str(date)[5:], 'value': str(date), 'style': {'fontSize': '10px' } } for (index, date) in enumerate(covid_dates) }
