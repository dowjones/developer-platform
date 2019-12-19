import common.snapshots as css
import common.elasticsearch as ces
import common.enrichment as ceh

# This code asumes no authentication is enabled in ES.
# Ensure the folder path where the AVRO files are located is correct.
# Double-check the Elasticsearch instance URL and port.
# Change the index name according to your preference.
articles_folder = "../articles-avro/"
es_url = 'http://localhost:9200'
es_index = 'dnaarticles'

# Loads multiple AVRO file articles to a single Pandas DataFrame.
sample_articles = css.read_folder(articles_folder, only_stats=False)

# Enrich by adding an embedding to the title and body fields.
enriched_articles = ceh.add_embedding(sample_articles, 'title')
enriched_articles = ceh.add_embedding(enriched_articles, 'body')

# Loads articles to Elasticsearch.
total_saved = ces.save_articles(es_url, es_index, sample_articles)
print('Saved {} articles to the index {}, located in the server {}'.format(
  total_saved, es_index, es_url))
