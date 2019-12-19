Content-Based Recommendations - Data Load
#########################################

Sample code to read data from snapshot files (in AVRO format), enrich articles metadata, and import the output into Elasticsearch.

Before using, ensure all Python dependencies listed in the **requirements.txt** file, are installed.


common
======

Set of common methods that eases operations like reading Factiva Snapshots AVRO files, calculating new features or interacting with Elasticsearch. These methods are for illustration purposes and don't have a robust coding to validate unexpected cases or handling exceptions. For this reason it is not distributed as a Python package. It is however used among multiple Developer Platform examples.


dna-es-mappings.json
====================

Mappings file to create a new index in Elasticsearch. This file contains a slightly modified field structure than the original Snapshot, with some additional fields for embeddings (title and body). The following excerpt shows some of the highlights of this file.

.. code-block:: javascript

    "body": {
        "type": "text"
    },
    "body_dv": {
        "type": "dense_vector",
        "dims": 512
        },


A new index can be created by using this file and the following code. This code uses the Python Elasticsearch library.

.. code-block:: python

    import json
    from elasticsearch import Elasticsearch
    from elasticsearch.client import IndicesClient

    es_client = Elasticsearch(['http://localhost:9200'])
    ix_name = 'dnaarticles'

    with open('./dna-es-mappings.json') as ix_file:
        ix_map = json.load(ix_file)
    es_client.indices.create(index=ix_name, body=ix_map)


load-dna-data.py
================

This file has the main logic to read a Snapshot AVRO files and load their content to a pandas DataFrame. Then, it enriches the dataset with some embedding from the title and body fields. Finally, the outcome is loaded to Elasticsearch.
