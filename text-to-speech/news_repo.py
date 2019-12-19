import json
from google.cloud import bigquery


def get_random_news():
    bq_client = bigquery.Client()
    random_query = "SELECT an, title, Concat(snippet, body) as body, publication_date as publication_datetime, publisher_name \
                    FROM `dowjones-com.sample.news_archive` \
                    WHERE language_code = 'en' AND body is not null AND snippet is not null \
                        AND RAND() < 10/21086"
    bq_job = bq_client.query(random_query)
    bq_results = bq_job.to_dataframe()
    return bq_results.to_json(orient='records')


def get_article_by_an(articlean):
    bq_client = bigquery.Client()
    random_query = "SELECT an, title, Concat(snippet, body) as body, publication_date as publication_datetime, publisher_name \
                    FROM `dowjones-com.sample.news_archive` \
                    WHERE an='{}'".format(articlean)
    bq_job = bq_client.query(random_query)
    bq_results = bq_job.to_dataframe()
    if bq_results.shape[0] == 1:
        single_article = json.loads(bq_results.to_json(orient='records'))
        return json.dumps(single_article[0])
    return None
