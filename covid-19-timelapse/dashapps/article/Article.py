import dash
import datetime
import dash_core_components as dcc  
import dash_html_components as html
import dash_bootstrap_components as dbc

app = dash.Dash(
    external_stylesheets=[dbc.themes.BOOTSTRAP]
)
def Article(an, articles):
    text = '### ' + articles.loc[articles['an'] == an, 'title'].values[0] + '\n\n' + \
        '**{}**'.format(articles.loc[articles['an'] == an, 'source_name'].values[0]) + '\n\n' + \
        articles.loc[articles['an'] == an, 'snippet'].values[0] + '\n\n' + \
        articles.loc[articles['an'] == an, 'body'].values[0] 

    return dcc.Markdown(text, id='article',className="markdown-text")

def Article_list(an_list, articles):

    return [
        dbc.Card([
            dbc.CardBody(
                [
                    html.H4(articles.loc[articles['an'] == an, 'title'].values[0], className="card-title"),
                    html.P('Published: ' + articles.loc[articles['an'] == an, 'publication_date'],className="article-date"),
                    dbc.Button("Open article", className="article-button",href='/article/'+an),                   
                ]
            ),
        ], className='article-card-list')
        for an in an_list
    ]