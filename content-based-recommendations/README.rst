Content-Based Recommendations
#############################

This solution pattern identifies related content using text embeddings to create a content-based recommendation system. This pattern is applicable when developing mobile or web applications requiring personalization to increase productivity and engagement.

See `this solution pattern <https://developer.dowjones.com/solution-patterns/details/content-based-recommendations>`_ in our Developer Platform site.

The article `How to build a content-based movie recommender system with Natural Language Processing <https://towardsdatascience.com/how-to-build-from-scratch-a-content-based-movie-recommender-with-natural-language-processing-25ad400eb243>`_ can provide a good idea of the general concept applied in this solution.

This code for this pattern contains two parts: a data load task that enriches the dataset with embeddings to later be used for recommendations query, and a query sample that suggests how to query Elasticsearch using the built-in cosine similarity function.


data-load
=========

The files in this folder work to load articles from a Factiva Snapshot into a Elasticsearch index. To use it it's necessary to change the script variables according to the local environment, and run the script by using a Python 3 runtime.

.. code-block::

    $ python load-snapshot-data.py


content-query
=============

This is basically a sample query that can be used anywhere where the cosine similarity method is being used to obtain similar content items.
