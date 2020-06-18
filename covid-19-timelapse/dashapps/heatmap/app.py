import numpy as np
import pandas as pd
import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objects as go
import plotly.express as px
from dash.dependencies import Input, Output
from plotly.subplots import make_subplots

global_ndays_range = 27

# --- Start --- Reading base data for the Sunburst
industry_sentiment = pd.read_json('dashapps/sunburst/covidsm_agg_sentiment_industry.json.zip', orient='records')
industry_sentiment['published_at_date'] = pd.to_datetime(industry_sentiment['published_at_date'], unit='ms')
global_start_day = industry_sentiment['published_at_date'].max() - pd.DateOffset(days=global_ndays_range)
industries_hrchy = pd.read_csv('dashapps/sunburst/industries-hrchy.csv')
industries_hrchy = industries_hrchy.replace(np.nan, '', regex=True)
# --- End --- Reading base data for the Sunburst

# --- Start --- Load base Sunburst (no data)
fig_layout = dict(margin=dict(t=20, l=20, r=20, b=20),
    autosize=True,  paper_bgcolor='#FFFFFF', height=800,
    plot_bgcolor='#FFFFFF',
    font = dict(color = '#666666', family='SimplonRegular'),
#    grid= dict(columns=3, rows=1),
#    title = 'Industry Sentiment',
    uirevision = True,
    uniformtext = dict(minsize=12, mode='show'),
    #title='Industry Sentiment'
    #showlegend = True
    )

def create_heatmap(selected_date) -> go.Figure:
    end_date = global_start_day + pd.DateOffset(days=selected_date)
    start_date = end_date + pd.DateOffset(days=-30)
    filtered_sentiment = industry_sentiment[(industry_sentiment['published_at_date'] >= start_date) & (industry_sentiment['published_at_date'] <= end_date)]

#Food Production & Agriculture
    #custom_industry_list = ['i0','i01001','i03001','i0100144','i0100137','iseed','i05','iagtech']
    #filtered_sentiment = filtered_sentiment[filtered_sentiment.industry_code.isin(custom_industry_list)]


    fig = go.Figure(data=go.Heatmap(
                        z=filtered_sentiment['sentiment'],
                        x=filtered_sentiment['published_at_date'],
                        y=filtered_sentiment['industry_name'],
                        colorscale='Temps_r'),
                        layout=fig_layout
                    )
    return fig

slider_dates = pd.Series(industry_sentiment[industry_sentiment['published_at_date'] >= global_start_day]['published_at_date'].unique()).sort_values(ignore_index=True)

def set_heatmap_callback(app):
    # --- Start --- Sunburst Callback
    @app.callback(
        Output('heatmap', 'figure'),
        [Input('date-slider', 'value')])
    def update_figure(selected_date):
        '''
            Retrieve the articles based on the selected_date
            Args: 
                selected_date: Range number (0-26).
        '''
        return create_heatmap(selected_date)

