# Dow Jones Developer Platform

Dow Jones Developer Platform repository index.

* **Audio News** ([/audionews](./audionews)): Example that shows how to display news from a repository, and highlights the option to listen to the news article. The audio reading option uses a storage repository and a speech-to-text cloud service. Implementation uses Google Cloud Platform (GCP) for those services. Check out the associated [Text to Speech Solution Pattern](https://developer.dowjones.com/).

* **Content-Based Recommender** ([/snapshots2elasticsearch](./snapshots2elasticsearch) and [/recommender-content-query](./recommender-content-query)): These two repositories belong to each of the two parts in the solution. First, to Load and enrich articles to Elasticsearch. Then to query the created index by using cosine similarity query within an end-user application. Check out the associated [Content-Based Recommendations Solution Pattern](https://developer.dowjones.com/).
