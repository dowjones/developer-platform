Dow Jones DNA Audio News Website
###################################

Overview
=========

Sample Web Application in Flask, that renders a set of random articles from the public BigQuery news sample, and when reading the particular article, allows to listen an audio version.

The application is a Bootstrap template that implemets few front-end and back-end endpoints within the same file (app.py), and uses some external files emmulating the use of external services.

* **App**: Starting point, defines the Flask routes for front-end and back-end functionalities
* **news_storage**: Provides the news search functionality. For this case, the public BigQuery news sample is used.
* **news_repo**: Contains the methods that work as an interface to a Cloud Storage environment where the generated audio files are stored.
* **news_tts**: Methods to interact with a Text-To-Speech service. This can be easily reconfigured to use the services offered by the common Cloud providers.

.. image:: static/img/audionews-screenshot.png
   :align: center
   :scale: 50 %

Requirements
=============

The following steps asume the use of Google Cloud Platform (GCP) for both, Text-to-Speech and Cloud Storage. Step 1 asumes that a GCP project is created and active. For guidance about creating projects in GCP see the article `Creating and Managing Projects <https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project>`_.


1. Create a GCP Service Account
-------------------------------

This sample application uses the standard authentication method preferred for applications when using APIs. Follow the steps described in `Creating a service account <https://cloud.google.com/iam/docs/creating-managing-service-accounts>`_. If the creation process prompts to assign roles, assign the roles listed in the step 2. Then `generate the service account key <https://cloud.google.com/iam/docs/creating-managing-service-account-keys>`_ and save the JSON file containing the service account credentials to a path visible by the application (usually in the same machine, but for security reasons, not a subdirectory in the project).


2. Assign Permissions to the Service Account
--------------------------------------------

Follow the steps in `grant user roles <https://cloud.google.com/iam/docs/granting-roles-to-service-accounts>`_, and ensure to assign the following ones:
- BigQuery Data Viewer
- BigQuery Job User
- Storage Object Viewer


3. Enable the Text To Speech API
--------------------------------

Follow the steps described in the article `Enabling an API in GCP project <https://cloud.google.com/endpoints/docs/openapi/enable-api>`_, and ensure **Cloud Text-to-Speech API** is active. Commonly, the storage service APIs are enabled by default.


4. Create a Storage Bucket
--------------------------

The article `Creating storage buckets <https://cloud.google.com/storage/docs/creating-buckets>`_ shows how to create a storage repository to keep the generated audio files. Use a convenient name and a location near a geographic location where the code will run.


5. Create Environment Variables
-------------------------------

According to your operating system, create the environment variables **GOOGLE_APPLICATION_CREDENTIALS** and **SC_AUDIONEWS_BUCKET**. The first one should contain the path to the credentials JSON file downloaded in the step 1. The second variable should contain the name of the bucket where the audio files will be stored

.. code-block::

    export GOOGLE_APPLICATION_CREDENTIALS='/path/to/credentials.json'
    export SC_AUDIONEWS_BUCKET='my-audio-files'
