import os, requests, json
import news_repo
import news_storage
import news_tts
from flask import Flask, render_template, url_for, abort

rootdir = os.path.join(os.path.dirname(os.path.abspath(__file__)))
app = Flask(__name__)


# ##### Front-End Requests #####

@app.route('/', methods=['GET'])
def render_news():
    return render_template('news.html.j2')


@app.route('/article/<articleid>')
def render_article(articleid):
    server_name = url_for('render_news', _external=True)
    req_url = server_name + 'api/article/' + articleid
    response = requests.get(req_url)
    if(response.status_code != 200):
        print("ERR Failed API Request for article {} using URL {}. \
            Returned HTTP status {}".format(articleid, req_url, response.status_code))
    else:
        article_obj = response.json()
        return render_template('viewarticle.html.j2', article=article_obj)
    print("ERR authsite:main:render_article: Returning 404!")
    return abort(404)


# ##### API Requests #####

@app.route('/api/news/random', methods=['GET'])
def req_api_news_random():
    return news_repo.get_random_news()


@app.route('/api/news/related', methods=['GET'])
def req_api_news_related():
    # When using Elasticsearch, run a Cosine Similarity Query
    # Checkout the project https://github.com/miballe/djdna-snapshot2elasticsearch
    return news_repo.get_random_news()


@app.route('/api/article/<articleid>')
def req_api_article_content(articleid):
    article_obj = news_repo.get_article_by_an(articleid)
    if article_obj is None:
        return abort(404)
    return article_obj


@app.route('/api/article/<articleid>/_audiofilename')
def req_api_article_audiofilename(articleid):
    temp_item = {}

    index_item_str = news_repo.get_article_by_an(articleid)
    if index_item_str is None:
        print("INFO The article {} doesn't exist. Returning 404 for _audiofilename.".format(articleid))
        temp_item['filename'] = "no-article.mp3"
        return json.dumps(temp_item)

    index_item = json.loads(index_item_str)
    filename = "{}.mp3".format(articleid)
    local_path = "{}/static/article-audio/{}".format(rootdir, filename)
    file_exists = news_storage.check_audio_file_exists(filename)
    if file_exists:
        print("INFO The file {} was successfully found in the CS bucket.".format(filename))
        temp_item['filename'] = filename
        return json.dumps(temp_item)

    print("INFO The file {} needs to be generated using Text-to-Speech.".format(filename))
    gen_filename = news_tts.generate_audio_file(index_item, local_path, filename)
    news_storage.upload_audio_file(local_path, gen_filename)

    temp_item['filename'] = gen_filename
    return json.dumps(temp_item)


if __name__ == '__main__':
    app.run(debug=True)
