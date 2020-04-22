Content-Based Recommendations - Content Query
#############################################


Overview
=========

Sample code that shows how to query Elasticsearch, by using the embeddings calculated when the content was loaded using the code available the folder `data-load <https://github.com/dowjones/developer-platform/tree/master/content-based-recommendations/data-load>`_, to obtain a set of similar articles based on the Elasticsearch's cosine similarity function.

The sample queries need to be implemented within a UI project or API that intends to provide similar content given a sample item.

.. code-block:: python

    from elasticsearch import Elasticsearch

    les = Elasticsearch([_ELASTICSEARCH_HOST])

    index_item = les.get(index=_ELASTICSEARCH_INDEX, id=articleid)
    original_vector = index_item['_source']['all_embed']  # all_embed is a precalculated Dense vector 
    similar_query = {
                        "query": {
                            "script_score": {
                                "query": {
                                    "range": {
                                        "publication_date": {
                                            # Restricts query to items published within the last 7 days
                                            "gte": "now-7d/d"
                                        }
                                    }
                                },
                                # Script runs on top of 'query > range' results.
                                "script": {
                                    "source": "cosineSimilarity(params.query_vector, 'all_embed') + 1.0",
                                    "params": {
                                        "query_vector": original_vector
                                    }
                                }
                            }
                        }
                    }
    similars_list = les.search(index=_ELASTICSEARCH_INDEX, body=similar_query)
