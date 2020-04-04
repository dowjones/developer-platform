import collections
import json
import random
import re
from datetime import datetime

import fastavro
import nltk
import pandas as pd
import requests
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.util import ngrams

from .config import TERMS_TO_REMOVE

# nltk.download('stopwords')
# nltk.download('punkt')

def ngram_frequencies(n, articles, verbose=True, start_date=None, end_date=None):
    """
    Generate NGram frequencies from an article dataframe
    Args:
        n (int): The size of the ngram
        articles (pandas.DataFrame): Articles to process
        verbose (bool): Whether or not to print some useful information while the process is running.
    Returns:
        Frequencies (dict): Dict containing ngram counts by day.
    """

    if start_date:
        articles = articles[articles['publication_datetime'] >= start_date]
    if end_date:
        articles = articles[articles['publication_datetime'] < end_date]

    articles['publication_datetime'] = articles['publication_datetime'].dt.floor(
        'D')
    grouped_by_pub_date = articles.sort_values(
        by='publication_datetime').groupby(['publication_datetime'])

    if verbose:
        print('Number of groups (days): {}'.format(
            len(grouped_by_pub_date.groups)))

    sw = set(stopwords.words('english'))
    frequencies = {}

    for i, group in enumerate(grouped_by_pub_date.groups):
        articles = grouped_by_pub_date.get_group(group)

        article_tokens = [word.lower() for text in articles['full_articles']
                          for word in word_tokenize(text)
                          if (not word in sw) and word.isalnum()]

        ngrams_ = ngrams(article_tokens, n)
        counted = collections.Counter(ngrams_)
        most_common = {' '.join(list(k)): v for (
            k, v) in counted.most_common(100)}

        pub_date_str = datetime.strftime(group, '%Y-%m-%d')
        #pub_date_str = datetime.strftime(group, '%#m/%d/%Y')

        if group in frequencies.keys():
            frequencies[pub_date_str].update(most_common)
        else:
            frequencies[pub_date_str] = {}
            frequencies[pub_date_str].update(most_common)

        if verbose:
            if i > 0 and i % 5 == 0:
                print('Processed {} groups.'.format(i))

    return frequencies


def strip_split(value):
    return value.strip(',').split(',')


def strip_commas(value):
    return value.strip(',')


def clean_up_text(string):
    if string:
        return re.sub(r'[^A-Za-z0-9!?.,:;\' ]', ' ', string)
    return ''


def process_datetimes(value):
    return datetime.utcfromtimestamp(value / 1000)


def snapshot_files_to_dataframe(user_key, snapshot_id):
    '''
    Retrieve the files from a completed extraction
    Args: 
        user_key: Snapshots API user key.
        files: The file URI list retrieved from a completed snapshot job.
    '''
    headers = {
        'content-type': 'application/json',
        'user-key': user_key
    }

    article_dataframes = []
    job_url = 'https://api.dowjones.com/alpha/extractions/documents/{}'.format(
        snapshot_id)
    files = requests.get(job_url, headers=headers).json()[
        'data']['attributes']['files']

    for f in files:
        uri = f['uri']
        file_name = uri.split('/')[-1]
        if len(file_name) > 0:
            file_response = requests.get(
                uri, headers=headers, allow_redirects=True, stream=True)
            file_response.raw.decode_content = True
            records = fastavro.reader(file_response.raw)
            records_df = pd.DataFrame(records)
            article_dataframes.append(records_df)

    data = pd.concat(article_dataframes, ignore_index=True)
    return data


def reformat_dataframe(source_df):
    """
    Reformat dataframe to use in the graph.
    Args:
        source_df: DataFrame to reformat
    Returns:
        New dataframe: reformatted dataframe
    """
    new_df = pd.DataFrame(columns=['day', 'term', 'count'])
    for i in range(len(source_df)):
        for j in source_df.iloc[i].index:
            new_df = new_df.append({
                'day': source_df.iloc[i].name,
                'term': str(j),
                'count': source_df.iloc[i][j]
            }, ignore_index=True)
    return new_df


def generate_figure(source_df):
    """
    Generate figure with a slider
    Args:
        source_df: Dataframe with data to use for the figure
    Returns:
        Figure dict containing necessary parameters to pass to go.Figure()
    """
    # Define the figure
    fig_dict = {
        'data': [],
        'layout': {},
        'frames': []
    }

    days = []

    for day in source_df['day']:
        if day not in days:
            days.append(day)

    terms = []

    for term in source_df['term']:
        if term not in terms:
            terms.append(term)

    fig_dict['layout']['xaxis'] = {
        'range': [source_df['day'].min(), source_df['day'].max()],
        'title': 'Publication Date'
    }
    fig_dict['layout']['yaxis'] = {
        'range': [0, 4000],
        'title': 'Term Frequency'
    }

    fig_dict['layout']['title'] = 'COVID-19 - Term Evolution'
    fig_dict['layout']['hovermode'] = 'x'
    fig_dict['layout']['sliders'] = {
        'args': [
            'transition', {
                'duration': 0,
                'easing': 'linear'
            }
        ],
        'initialValue': days[0],
        'plotlycommand': 'animate',
        'values': days,
        'visible': True
    }

    sliders_dict = {
        'active': 0,
        'yanchor': 'top',
        'xanchor': 'left',
        'currentvalue': {
            'font': {
                'size': 12
            },
            'visible': True,
            'xanchor': 'right'
        },
        'transition': {
            'duration': 0,
            'easing': 'linear'
        },
        'pad': {
            'b': 10,
            't': 50
        },
        'len': 1.0,
        'steps': []
    }

    # Generate the first point in the display

    day_1 = days[0]

    for term in terms:
        dataset_by_day = source_df[source_df['day'] == day_1]
        dataset_by_day_and_term = dataset_by_day[dataset_by_day['term'] == term]

        data_dict = {
            'x': list(dataset_by_day_and_term['day']),
            'y': list(dataset_by_day_and_term['count']),
            'mode': 'lines',
            'text': list(dataset_by_day_and_term['term']),
            'name': term,
            'line': {
                'width': 3
            },
            'showlegend': True
        }

        fig_dict['data'].append(data_dict)

    all_x = []

    # Create frames
    for i, day in enumerate(days):
        all_x.append(day)
        frame = {'data': [], 'name': str(day)}
        for term in terms:
            dataset_by_day = source_df[source_df['day'] == day]
            dataset_by_day_and_term = dataset_by_day[dataset_by_day['term'] == term]

            all_counts = list(source_df[source_df['term'] == term]['count'])

            if i == 0:
                all_y = [all_counts[i]]
            else:
                all_y = all_counts[:i+1]

            data_dict = {
                'x': all_x,
                'y': all_y,
                'mode': 'lines',
                'text': list(dataset_by_day_and_term['term']),
                'name': term,
                'line': {
                    # 'color': term_color_dict[term]
                    'width': 3
                },
                'showlegend': True
            }

            frame['data'].append(data_dict)

        fig_dict['frames'].append(frame)

        slider_step = {
            'args': [
                [day],
                {
                    'frame': {
                        'duration': 0,
                        'redraw': False
                    },
                    'mode': 'immediate',
                    'transition': {
                        'duration': 0
                    }
                }
            ],
            'label': day,
            'method': 'animate'
        }
        sliders_dict['steps'].append(slider_step)

    fig_dict['layout']['sliders'] = [sliders_dict]
    return fig_dict


def update_terms_figure(date, terms_df):  
    """
    Generate a figure frame using the date.
    Args:
        date: The date until to generate the frame.
        terms_df: Dataframe to use.
    """
    filtered_df = terms_df[terms_df['day'] <= date]
    days = [day for day in filtered_df['day'].unique()]
    terms = [term for term in filtered_df['term'].unique()]   
    traces = []
    
    for term in terms:
        counts = list(filtered_df[filtered_df['term'] == term]['count'])
        data_dict = {
            'x': days,
            'y': counts,
            'mode': 'lines',
            'text': [term],
            'name': term,
            'line': {
                'width': 3
            }
        }
        traces.append(data_dict)
            
    return {
        'data': traces,
        'layout': dict(
            xaxis = {
                'range': [terms_df['day'].min(), terms_df['day'].max()],
                'title': 'Publication Date',
                'showgrid': False
            },
            yaxis = {
                'range': [0, 3500],
                'title': 'Term Frequency',
                'showgrid': False
            },
            hovermode = 'x',
            title = 'Bi-grams in the news',
            paper_bgcolor = '#39485A',
            plot_bgcolor = '#39485A',
            font = dict(color = 'white', family='SimplonRegular')
        )
    }


def ngram_dataframe_from_file(bigrams_or_path, read_from_file=False, start_date=None):
    """
    Generate the ngram dataframe to use in charts from a file.
    Args:
        bigrams_or_path (str): Either the bigrams to use for dataframe, or file path to read bigrams from.
        read_from_file (bool): Whether or not to read bigrams from file.
    Returns:
        Dataframe containing dates, bigrams, counts to use in the charts.
    """
    if read_from_file:
        bigrams = json.load(open(bigrams_or_path, 'rt', encoding='utf-8'))
    else:
        bigrams = bigrams_or_path

    bigram_df = pd.DataFrame.from_dict(bigrams).fillna(0)
    date_ind = bigram_df.swapaxes('index', 'columns', copy=True)
    date_ind = date_ind[date_ind.index >= '2020-03-06']
    date_ind = date_ind[date_ind.index <= '2020-04-01']

    to_remove = TERMS_TO_REMOVE
    top_ngrams = date_ind.sum().sort_values(ascending=False).head(100)
    top_ngrams = top_ngrams.keys().tolist()

    relevant_terms = set(top_ngrams) - set(to_remove)
    df_for_chart = date_ind[relevant_terms]
    
    return reformat_dataframe(df_for_chart)
