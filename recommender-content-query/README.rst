Dow Jones DNA Content-Based Recommender
#######################################

Overview
=========

Sample code that shows how to query Elasticsearch, by using the embeddings calculated when the content was loaded `snapshots2elasticsearch <https://github.com/dowjones/developer-platform/snapshot2elasticsearch>`_, to obtain a set of similar articles based on the Elasticsearch's cosine similarity function.

The sample queries need to be implemented within a UI project or API that intends to provide similar content given a sample item.

.. code-block:: javascript

    {
        "script_score": {
            "query": {"match_all": {}},
            "script": {
            "source": "cosineSimilarity(params.query_vector, doc['fulltext_vector']) + 1.0",
            "params": {"query_vector": query_vector}
            }
        }
    }
