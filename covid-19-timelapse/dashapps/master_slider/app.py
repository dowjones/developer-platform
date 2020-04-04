import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import dash_daq as daq
import time

import pandas as pd
import config

covid_dates = config.covid_dates
map_covid_dates = config.map_covid_dates

def create_slider():
    return html.Div([
        html.P('COVID-19 Term Timeline', className="card-header"),
        html.Div([], id='interval-holder'),
        dcc.Slider(
            id='date-slider',
            min=0,
            max=len(covid_dates),
            value=0,
            marks=map_covid_dates,
            step=None
        ),
        daq.ToggleSwitch(id = 'play', value = False)
    ],
    style = { 'backgroundColor': '#39485A'})

def isInt(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

def set_slider_callback(app):
    @app.callback(
        Output('date-slider', 'value'),
        [Input('auto-stepper', 'n_intervals')]
    )
    def test(n_intervals):
        return n_intervals + 1


    @app.callback(
        Output('interval-holder', 'children'),
        [Input('date-slider', 'value'), Input('play', 'value')]
    )
    def return_interval(val, play):
        if play and val != (len(covid_dates) - 1):
            time.sleep(1)
            return dcc.Interval(
                id='auto-stepper',
                interval = 1*300,
                n_intervals = val,
                max_intervals = val
            )
        else:
            return ''
