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

def retrieve_data():
  '''
  Retrieve the data for populating the map from a completed extraction
  Args: 
      confirmed_cases_source: Cases confirmed.
      confirmed_deaths_source: Deaths confirmed.
      confirmed_recovers_source: Recovers confirmed.
  '''
  try:
    consolidated_df = pd.read_pickle('./covidmap.pickle')
  except FileNotFoundError:

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
  return consolidated_df

def create_map(date):
  consolidated_df = retrieve_data()
  tmpconsolidated_df = consolidated_df.loc[consolidated_df['Date'] == date, :].copy()
  if len(tmpconsolidated_df)==0:
      os.remove('./covidmap.pickle')
      consolidated_df = retrieve_data()
      tmpconsolidated_df = consolidated_df.loc[consolidated_df['Date'] == date, :].copy()
  #print(tmpconsolidated_df)
  list_hovertext = []
  for _, row in tmpconsolidated_df.iterrows():
      list_hovertext.append(f"<i>Cases confirmed: </i>{row['Confirmed']}<b><br>Deaths confirmed: </b>{row['Deaths']}<br>Recovered: {row['Recovered']}")

  consolidated_df.to_pickle('./covidmap.pickle')
  data = [go.Scattermapbox(
      lat=tmpconsolidated_df['Lat'],
      lon=tmpconsolidated_df['Long'],
      hovertext=list_hovertext,
      mode='markers',
      hoverinfo='text',
      name='COVID-19 Term Mapbox',
      marker_size=tmpconsolidated_df['Confirmed'],
      marker=dict(
          sizemin=2,
          sizemode='area',
          color='darkorange',
          opacity=.8,
          sizeref=200
      )
  )]
  layout = go.Layout(autosize=True,height=400,
                     mapbox=dict(accesstoken='pk.eyJ1Ijoic2UtY292aWQiLCJhIjoiY2s4OHNlMHM2MDlnazNlb2M2NHdjYmNoayJ9.GoiFCNVSkuN2Shk_hyt5yQ',
                                 bearing=0, pitch=0, zoom=0, center=dict(lat=0.0, lon=0.0), style='dark'), margin=dict(t=0, b=0, l=0, r=0))
  fig = dict(data=data, layout=layout)

  return fig

def set_map_callback(app):
  @app.callback(
    Output('world_map', 'figure'),
    [Input('date-slider', 'value')])
  def update_map(selected_date):
    '''
        Retrieve the articles based on the selected_date
        Args: 
            selected_date: Range number (0-26).
    '''
    current_date = map_covid_dates[selected_date]['value']
    tmp_date = '/'.join(map(str, tuple(map(int, current_date.split('-')))))
    official_date = datetime.datetime.strptime(tmp_date, '%Y/%m/%d').strftime('%m/%d/%Y').lstrip('0').replace(' 0', ' ').replace('/0','/')[:-2]
    return create_map(official_date)
