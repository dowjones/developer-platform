Load Dow Jones DNA Snapshot to Elasticsearch
############################################

Sample code to read data from snapshot files, enrich articles metadata, and import the output into Elasticsearch. It uses some methods created in a common library (`djdna_common <https://github.com/miballe/djdna_common>`_) included as a symbolic link.


djdna_common
============

Set of common methods that eases operations like reading DNA Snapshots AVRO files, calculating new features or interacting with Elasticsearch. These methods are for illustration purposes and don't have a robust coding to validate unexpected cases or handling exceptions. For this reason it is not distributed as a Python package. It is however used among multiple Dow Jones DNA examples.

To use these methods, clone this and the djdna_common repository to the same base directory, and (if necessary) create a symbolic link or copy the folder content. A sample sequence looks like this:

.. code-block::

    $ git clone https://github.com/miballe/djdna-snapshot2elasticsearch.git
    $ git clone https://github.com/miballe/djdna_common
    $ cd djdna-snapshot2elasticsearch
    $ ln -s ../djdna_common/ djdna_common


dna-es-mappings.json
====================

Mappings file to create a new index in Elasticsearch. This file contains a slightly modified field structure with some additional fields for embeddings (title and body). The following excerpt shows some of the highlights of this file.

.. code-block:: javascript

    "body": {
        "type": "text"
    },
    "body_dv": {
        "type": "dense_vector",
        "dims": 512
        },


A new index matching the DNA schema can be created by using this file and the following code. This code uses the Python Elasticsearch library.

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

This file has the main logic to read a Snapshot AVRO files and load their content to a pandas DataFrame. Then, it enriches the dataset with some embedding to the title and body fields, and finally, the final outcome is loaded to Elasticsearch.
