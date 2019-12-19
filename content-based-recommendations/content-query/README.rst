Content-Based Recommendations - Content Query
#############################################


Overview
=========

Sample code that shows how to query Elasticsearch, by using the embeddings calculated when the content was loaded using the code available the folder `data-load <https://github.com/dowjones/developer-platform/tree/master/content-based-recommendations/data-load>`_, to obtain a set of similar articles based on the Elasticsearch's cosine similarity function.

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
