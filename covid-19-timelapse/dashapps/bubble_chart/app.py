import requests
import os
import json
import time
import re

import pandas as pd
import datetime

import plotly.express as px
import plotly.graph_objs as go
from plotly.subplots import make_subplots

from dash.dependencies import Input, Output

import colorlover as cl

import numpy as np
import config

map_covid_dates = config.map_covid_dates
cases_counts_filtered = pd.read_csv('dashapps/bubble_chart/cases_counts_filtered.csv')

cases_counts_filtered['DateTime'] = cases_counts_filtered['DateTime'].apply(
    lambda x: datetime.datetime.strptime(x, '%Y-%m-%d')
)

def create_bubble_figure(the_date):
    cases_counts_filtered_date = cases_counts_filtered[
        cases_counts_filtered['DateTime'] <= datetime.datetime.strptime(the_date, '%Y/%m/%d')]

    cases_counts_filtered_date_last = cases_counts_filtered_date[
        (cases_counts_filtered_date['DateTime'] == cases_counts_filtered_date['DateTime'].max()) &
        (cases_counts_filtered_date['Deaths'].sum() != 0)
    ]


    scatterdata = []
    bubbledata = []
    bardata = []

    for country, clr in zip(cases_counts_filtered['Country'].unique(), cl.scales['9']['qual']['Set1']):
        if country in cases_counts_filtered_date_last['Country'].unique():
            scatterdata.append(
                go.Scatter(
                    x = cases_counts_filtered_date.loc[
                        cases_counts_filtered_date['Country'] == country, 'Article Count'],
                    y = cases_counts_filtered_date.loc[
                        cases_counts_filtered_date['Country'] == country, 'Deaths'],
                    mode = 'lines',
                    line={
                        'color': clr
                    },
                    name = country
                )
            )
            bubbledata.append(
                go.Scatter(
                    x = cases_counts_filtered_date_last.loc[
                        cases_counts_filtered_date_last['Country'] == country, 'Article Count'],
                    y = cases_counts_filtered_date_last.loc[
                        cases_counts_filtered_date_last['Country'] == country, 'Deaths'],

                    mode = 'markers',
                    marker = {
                        'color': clr,
                        'size': cases_counts_filtered_date_last.loc[
                            cases_counts_filtered_date_last['Country'] == country, 'Cases'],
                        "sizeref": 100,
                        "sizemode": "area"
                    },
                    name = country,
                    showlegend=False
                )
            )

    bardata = go.Bar(
        y = cases_counts_filtered_date_last.sort_values('Article Count')['Country'],
        x = cases_counts_filtered_date_last.sort_values('Article Count')['Article Count'],
        marker = {
            'color': '#394859'
        },
        orientation = 'h',
        showlegend=False
    )


    scatterdata.extend(bubbledata)
    
    fig = make_subplots(
        rows=2, cols=1, shared_xaxes=True, vertical_spacing=0.1
    )

    for trace in scatterdata:
        fig.add_trace(trace, row=1, col=1)

    fig.add_trace(bardata, row=2, col=1)

    fig['layout']['plot_bgcolor'] = '#39485A'
    fig['layout']['paper_bgcolor'] = '#39485A'
    fig['layout']['font'] = dict(color = '#F8F9FB', family="SimplonRegular")

    fig['layout']['xaxis2']['title']['text'] = 'Article Count'
    fig['layout']['yaxis1']['title']['text'] = 'Deaths'

    fig['layout']['xaxis1']['type'] = 'log'
    fig['layout']['xaxis1']['showgrid'] = False
    fig['layout']['xaxis2']['type'] = 'log'
    fig['layout']['xaxis2']['showgrid'] = False
    fig['layout']['yaxis1']['type'] = 'log'
    fig['layout']['yaxis1']['showgrid'] = False

    fig['layout']['xaxis1']['range'] = [1,np.log10(cases_counts_filtered['Article Count'].max())*1.2]
    fig['layout']['xaxis2']['range'] = [1,np.log10(cases_counts_filtered['Article Count'].max())*1.2]
    fig['layout']['yaxis1']['range'] = [1,np.log10(cases_counts_filtered['Deaths'].max())*1.2]
    fig['layout']['title'] = 'News Coverage'

    return fig

def set_bubble_callback(app):
    @app.callback(
        Output('bubble_chart', 'figure'),
        [Input('date-slider', 'value')])
    def update_bubble(selected_date):
        '''
            Retrieve the articles based on the selected_date
            Args: 
                selected_date: Range number (0-26).
        '''
        official_date = re.sub(r'\b-\b', '/', map_covid_dates[selected_date]['value'])
        return create_bubble_figure(official_date)
