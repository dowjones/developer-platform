import dash
import config
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
from .Article import Article, Article_list
import datetime

import pandas as pd

article_covid_dates = config.map_covid_dates
articles = pd.read_csv(
    'dashapps/article/articles_data.csv.gz',
        compression='gzip', dtype='unicode')
articles['publication_date'] = pd.to_datetime(articles['publication_date'], unit='ms').dt.to_period('D').copy()
articles['publication_date'] = articles['publication_date'].astype(str).copy()
articles.sort_values(by='publication_date', inplace=True)

def data_wrangling(selected_date):
    return articles.loc[articles['publication_date'] == selected_date, :].copy()


def create_article():
    return html.Div([
        dcc.Location(id='url', refresh=False),
        # Article(art_id, oauth_headers)
        html.Div(id='article-content')
        ])

def set_article_callback(app):
    @app.callback(Output('article-content', 'children'),
    [Input('url', 'pathname'), Input('date-slider', 'value')])
    def display_content(value, selected_date):
        '''
        Retrieve the articles based on the selected_date
        Args: 
            selected_date: Range number (0-26).
        '''
        current_date = article_covid_dates[selected_date]['value']
        tmp_date = '-'.join(map(str, tuple(map(int, current_date.split('-')))))

        official_date = datetime.datetime.strptime(tmp_date, '%Y-%m-%d').strftime('%Y-%m-%d')

        url_parts = value.split('/')
        major = url_parts[1]
        art_id = value.split('/')[-1]

        if major == 'article':
            return Article(art_id, data_wrangling(official_date))
        else:
            curr_articles = data_wrangling(official_date)[-10:] # Show only the first 10, for demo presentation
            return Article_list(curr_articles['an'], curr_articles)
