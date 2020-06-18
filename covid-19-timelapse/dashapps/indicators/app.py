import pandas as pd
import os
import plotly.express as px
import plotly.graph_objs as go
import numpy as np
import re
import config
import datetime
from dash.dependencies import Input, Output

confirmed_cases_source = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
confirmed_deaths_source = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'
confirmed_recovers_source =  'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv'

map_covid_dates = config.map_covid_dates

def retrieve_indicator_data():
  '''
  Retrieve the data for populating the map from a completed extraction
  Args: 
      confirmed_cases_source: Cases confirmed.
      confirmed_deaths_source: Deaths confirmed.
      confirmed_recovers_source: Recovers confirmed.
  '''
#  try:
#    consolidated_df = pd.read_pickle('./covidmap.pickle')
#  except FileNotFoundError:

    # Confirmed Cases time series
  confirmed_df = pd.read_csv(confirmed_cases_source, error_bad_lines=True)

  # Confirmed Deaths time series
  deaths_df = pd.read_csv(confirmed_deaths_source, error_bad_lines=True)

  # Confirmed Recoveries time series
  recovered_df = pd.read_csv(confirmed_recovers_source, error_bad_lines=True)

  #Unique country names list
  #unique_countries = confirmed_df['Country/Region'].unique().copy()
  column_names = ['Country', 'Date', 'Confirmed', 'Deaths', 'Recovered', 'Lat', 'Long']
  group_confirmed_df = confirmed_df.groupby('Country/Region')
  group_death_df = deaths_df.groupby('Country/Region')
  group_recovered_df = recovered_df.groupby('Country/Region')
  consolidated_df = pd.DataFrame(columns=column_names)

  for name, group in group_confirmed_df:
          temp_consolidated_df = pd.DataFrame(columns=column_names)
          dates = group[group.columns[4:]].T.index.tolist()
          countryname = np.full(len(dates),name)
          deathgroup = group_death_df.get_group(name)
          recovered_group = group_recovered_df.get_group(name)
          if group['Province/State'].count() == 0:
              confirmed = group[group.columns[4:]].T.values.copy().flatten()
              deaths = deathgroup[deathgroup.columns[4:]].T.values.copy().flatten()
              recovered = recovered_group[recovered_group.columns[4:]].T.values.copy().flatten()
              latitudes = np.full(len(dates),group[group.columns[2]].T.values.copy())
              longitudes = np.full(len(dates),group[group.columns[3]].T.values.copy())
          else:
              confirmed = group[group.columns[4:]].sum().T.values.copy().flatten()
              deaths = deathgroup[deathgroup.columns[4:]].sum().T.values.copy().flatten()
              recovered = recovered_group[recovered_group.columns[4:]].sum().T.values.copy().flatten()
              if name == 'Australia':
                latitudes = np.full(len(dates),group['Lat'].iloc[0])
                longitudes = np.full(len(dates),group['Long'].iloc[0])
              elif name == 'China':
                latitudes = np.full(len(dates),group['Lat'].iloc[1])
                longitudes = np.full(len(dates),group['Long'].iloc[1])
              elif name == 'Denmark':
                latitudes = np.full(len(dates),group['Lat'].iloc[2])
                longitudes = np.full(len(dates),group['Long'].iloc[2])
              elif name == 'Netherlands':
                latitudes = np.full(len(dates),group['Lat'].iloc[3])
                longitudes = np.full(len(dates),group['Long'].iloc[3])
              elif name == 'Canada' or name == 'France':
                latitudes = np.full(len(dates),group['Lat'].iloc[9])
                longitudes = np.full(len(dates),group['Long'].iloc[9])
              else:
                latitudes = np.full(len(dates),group['Lat'].iloc[-1])
                longitudes = np.full(len(dates),group['Long'].iloc[-1])

          temp_consolidated_df['Country']=countryname
          temp_consolidated_df['Date']=dates
          temp_consolidated_df['Confirmed']=confirmed
          temp_consolidated_df['Deaths']=deaths
          temp_consolidated_df['Recovered']=recovered
          temp_consolidated_df['Lat']=latitudes
          temp_consolidated_df['Long']=longitudes
          pd.to_datetime(temp_consolidated_df['Date'])
          consolidated_df=consolidated_df.append(temp_consolidated_df, ignore_index=True)

  consolidated_df = consolidated_df.astype({'Confirmed': int, 'Deaths':int, 'Recovered':int})
  consolidated_df = consolidated_df.groupby(['Date']).agg({'Confirmed': "sum", 'Deaths': "sum",'Recovered': 'sum'})
  consolidated_df = consolidated_df.reset_index()

  return consolidated_df

def create_indicators(date):


  consolidated_df = retrieve_indicator_data()
  tmpconsolidated_df = consolidated_df.loc[consolidated_df['Date'] == date, :].copy()

  fig = go.Figure()
  fig.add_trace(go.Indicator(
      mode = "number",
      value = tmpconsolidated_df.iloc[0]['Confirmed'],
      number= {'font': {'color':'#ad2e2e','family':'SimplonRegular','size':40}},
      title = {"text": "<span style='font-family:SimplonRegular;font-size:1em;color:#666666'>Confirmed</span>"},
     # delta = {'reference': 400, 'relative': True},
     domain = {'x': [0,0.2], 'y': [0, 0]}
     ))
  fig.add_trace(go.Indicator(
      mode = "number",
      value = tmpconsolidated_df.iloc[0]['Deaths'],
      number= {'valueformat':'.1s','font': {'color':'#333333','family':'SimplonRegular','size':40}},
      title = {"text": "<span style='font-family:SimplonRegular;font-size:1em;color:#666666'>Fatalities</span>"},
     # delta = {'reference': 400, 'relative': True},
      domain = {'x': [0.4,0.6], 'y': [0,0]}
     ))
  fig.add_trace(go.Indicator(
      mode = "number",
      value = tmpconsolidated_df.iloc[0]['Recovered'],
      number= {'valueformat':'.1s','font': {'color':'#333333','family':'SimplonRegular','size':40}},
      title = {"text": "<span style='font-family:SimplonRegular;font-size:1em;color:#666666'>Recovered</span>"},
     # delta = {'reference': 400, 'relative': True},
      domain = {'x': [0.8,1], 'y': [0, 0]}
     ))

  fig.update_layout(autosize=True, height=130, margin=dict(t=40, b=0))

  #fig.update_layout(height=)

  return fig


def set_indicators_callback(app):
  @app.callback(
    Output('indicators', 'figure'),
    [Input('date-slider', 'value')])
  def update_indicators(selected_date):
    current_date = map_covid_dates[selected_date]['value']
    tmp_date = '/'.join(map(str, tuple(map(int, current_date.split('-')))))
    official_date = datetime.datetime.strptime(tmp_date, '%Y/%m/%d').strftime('%m/%d/%Y').lstrip('0').replace(' 0', ' ').replace('/0','/')[:-2]
    return create_indicators(official_date)
