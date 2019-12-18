from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk


def save_articles(es_url, es_index, articles_df):
    """Saves the Pandas Dataframe content to Elasticsearch
    Parameters
    ----------
    es_url : str
        URL of the Elasticsearch server. E.g. http://localhost:9200
    es_index : str
        Name of the index to save the articles in Elasticsearch. The index is created if it doesn't exists.
        If the index exists, articles are appended.
    articles_df : pandas.Dataframe
        Dataframe containing the articles to be saved
    Returns
    -------
    int
        Number of successfully inserted items in Elasticsearch
    """
    es_chunk_size = 50
    es_max_retries = 2
    total_saved = 0
    les = Elasticsearch([es_url])
    bulk_array = []
    for index, row in articles_df.iterrows():
        artjson = row.to_json()
        bulk_array.append(artjson)
        if index % 1000 == 0:
            success, _ = bulk(les, bulk_array, index=es_index, chunk_size=es_chunk_size, max_retries=es_max_retries)
            total_saved += success
            bulk_array.clear()
    success, _ = bulk(les, bulk_array, index=es_index, chunk_size=es_chunk_size, max_retries=es_max_retries)
    total_saved += success
    bulk_array.clear()
    return total_saved
