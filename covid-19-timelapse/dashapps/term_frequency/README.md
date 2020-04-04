### INFO

Article dataframe processing takes a while. About 5 minutes to convert all articles into a dataframe from the Snapshot files. In addition, it takes about ~15 minutes to extract bigrams.

Because of that, for the purpose of MVP, we can get bigrams directly from the file `results/bigrams.json`.

Date format is **YYYY-MM-DD**. 

This should not be a problem, since datetime is used in the map.

`utils.update_terms_figure('2020-03-20', terms_df)` is the chart update function that uses the date as the input that we discussed with Charley.

**Note**: When using Dash app, do not pass `terms_df` in the actual graph update function definition. Should be simply this: 

`def update_terms_figure(date)`

Instead, create the bigrams df in the global scope using the following:

`terms_df = utils.ngram_dataframe_from_file(r'results\bigrams.json', read_from_file=True)`

`update_terms_figure` expects this DF as well (date format YYYY-MM-DD)
