import numpy as np
import pandas as pd
import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objects as go
from dash.dependencies import Input, Output

global_ndays_range = 27

# --- Start --- Reading base data for the Sunburst
industry_sentiment = pd.read_json('dashapps/sunburst/covidsm_agg_sentiment_industry.json.zip', orient='records')
industry_sentiment['published_at_date'] = pd.to_datetime(industry_sentiment['published_at_date'], unit='ms')
global_start_day = industry_sentiment['published_at_date'].max() - pd.DateOffset(days=global_ndays_range)
industries_hrchy = pd.read_csv('dashapps/sunburst/industries-hrchy.csv')
industries_hrchy = industries_hrchy.replace(np.nan, '', regex=True)
# --- End --- Reading base data for the Sunburst

# --- Start --- Load base Sunburst (no data)
fig_layout = dict(margin=dict(t=100, l=0, r=0, b=0),
    autosize=True, paper_bgcolor='#39485A',
    plot_bgcolor='#39485A',
    font = dict(color = '#F8F9FB', family='SimplonRegular'),
    title = 'Industry Sentiment')

def create_sunburst(selected_date) -> go.Figure:
    end_date = global_start_day + pd.DateOffset(days=selected_date)
    start_date = end_date + pd.DateOffset(days=-5)
    filtered_sentiment = industry_sentiment[(industry_sentiment['published_at_date'] >= start_date) & (industry_sentiment['published_at_date'] <= end_date)]
    # filtered_hrchy = industries_hrchy.copy()
    sentiment_avgs = filtered_sentiment.groupby(['industry_code'], as_index=False).agg({'sentiment': 'mean'})
    ind_with_sentiment = sentiment_avgs['industry_code'].to_list()
    filtered_hrchy = industries_hrchy[industries_hrchy['ind_fcode'].isin(ind_with_sentiment)]
    filtered_hrchy = filtered_hrchy.merge(sentiment_avgs, left_on='ind_fcode', right_on='industry_code')
    root_item_list = ['indroot', 'All Industries', '', 'indroot', filtered_hrchy[filtered_hrchy['parent'] == 'indroot']['sentiment'].mean()]
    root_item_df = pd.DataFrame([root_item_list], columns=['ind_fcode', 'name', 'parent', 'industry_code', 'sentiment'])
    filtered_hrchy = filtered_hrchy.append(root_item_df, ignore_index=True)

    fig = go.Figure(data=[go.Sunburst(
                            ids=filtered_hrchy['ind_fcode'],
                            labels=filtered_hrchy['name'],
                            parents=filtered_hrchy['parent'],
                            marker=dict(colors=filtered_hrchy['sentiment'], colorscale='RdBu', cmid=0),
                            hovertemplate='<b>(%{id})</b> %{label} <br>- Sentiment score: %{color:.2f}'
                        )],
                        layout=fig_layout
                    )
    return fig

slider_dates = pd.Series(industry_sentiment[industry_sentiment['published_at_date'] >= global_start_day]['published_at_date'].unique()).sort_values(ignore_index=True)

def set_sunburst_callback(app):
    # --- Start --- Sunburst Callback
    @app.callback(
        Output('sunburst', 'figure'),
        [Input('date-slider', 'value')])
    def update_figure(selected_date):
        '''
            Retrieve the articles based on the selected_date
            Args: 
                selected_date: Range number (0-26).
        '''
        return create_sunburst(selected_date)

