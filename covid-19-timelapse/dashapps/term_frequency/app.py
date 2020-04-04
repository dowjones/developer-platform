import json
import plotly.graph_objects as go
import config
from dash.dependencies import Input, Output

from .utils import ngram_dataframe_from_file, generate_figure, update_terms_figure

memo = {}
terms_df = ngram_dataframe_from_file(r'dashapps/term_frequency/results/bigrams.json', read_from_file=True)
map_covid_dates = config.map_covid_dates

def create_term_frequency(date):    
    test_results = update_terms_figure(date, terms_df)
    return go.Figure(test_results)

def set_term_frequency_callback(app):
    @app.callback(
        Output('term_frequency', 'figure'),
        [Input('date-slider', 'value')])
    def update_term_frequency(selected_date):
        '''
            Retrieve the articles based on the selected_date
            Args: 
                selected_date: Range number (0-26).
        '''
        official_date = map_covid_dates[selected_date]['value']
        return create_term_frequency(official_date)
