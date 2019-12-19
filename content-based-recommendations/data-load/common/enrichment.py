import pandas as pd
import tensorflow_hub as hub

embed = hub.load("https://tfhub.dev/google/universal-sentence-encoder/4")


def add_embedding(articles_df, field) -> pd.DataFrame:
    emb_items = embed(articles_df[field].tolist())
    articles_df[field + '_dv'] = [e_item.numpy() for e_item in emb_items]
    return articles_df
