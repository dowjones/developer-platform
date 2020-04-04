import dash
import dash_auth
import dash_html_components as html
import dash_core_components as dcc
import dash_bootstrap_components as dbc
import config
import base64
from dash.dependencies import Input, Output
from dashapps.map.app import create_map, set_map_callback
from dashapps.article.app import create_article, set_article_callback
from dashapps.term_frequency.app import create_term_frequency, set_term_frequency_callback
from dashapps.bubble_chart.app import create_bubble_figure, set_bubble_callback
from dashapps.sunburst.app import create_sunburst, set_sunburst_callback
from dashapps.master_slider.app import create_slider, set_slider_callback

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css', dbc.themes.BOOTSTRAP,'static/style/style.css']
base64_message = 'cmM1NmRmY3MyNGdoYj0='
base64_bytes = base64_message.encode('ascii')
message_bytes = base64.b64decode(base64_bytes)
message = message_bytes.decode('ascii')
VALID_USERNAME_PASSWORD_PAIRS = {
    'dj-covid19-dashboard': message
}

app = dash.Dash(__name__, external_stylesheets=external_stylesheets, suppress_callback_exceptions=True)
auth = dash_auth.BasicAuth(
    app,
    VALID_USERNAME_PASSWORD_PAIRS
)
server = app.server

master_slider = create_slider()
world_map = create_map('3/6/20') # change to initial date in this format
articles = create_article()
frequency_terms = create_term_frequency('2020-03-06') # change to initial date in this format
bubble_chart = create_bubble_figure('2020/03/06') # change to initial date in this format
sunburst_chart = create_sunburst(0)

map_covid_dates = config.map_covid_dates


title_card = dbc.Card(
    dbc.CardBody(
        html.Div(
            className='header',
            children=html.H1('COVID-19 News Timelapse'),
        ),className="header-container"
    ),className="nav-header"
)

slider_card = dbc.Card(
    dbc.CardBody([
        html.Div(
            className='date_slider',
            children=master_slider
        ),
    ]),className="slider-container"
)

world_card = dbc.Card(
    dbc.CardBody([
        html.H5(" Disease Spread",className="card-header"),
        html.Div(
            children=dcc.Graph(
                    id='world_map',
                    figure=world_map
            ),
        ),
    ]),className="map-container"
)

term_frequency_card = dbc.Card(
    dbc.CardBody([
        html.Div(
            children=dcc.Graph(
                id='term_frequency',
                figure=frequency_terms
            )
        )
    ])
)

article_card = dbc.Card(
    dbc.CardBody([
        html.Div(
            children=[
                html.H3('News of the day',className="card-header"),
                articles
            ], className="articles-div"
        )
    ]),className="articles-container"
)

sunburst_card = dbc.Card(
    dbc.CardBody([
        html.Div(
            children=dcc.Graph(
                id='sunburst',
                figure=sunburst_chart
            ),
        )
    ]),
)

bubble_chart_card = dbc.Card(
    dbc.CardBody([
        html.Div(
            children=dcc.Graph(
                id='bubble_chart',
                figure=bubble_chart
            ), className="bubble-chart-div"
        )
    ]),
)

title_row = dbc.Row(dbc.Col(title_card, width=12))
slider_row = dbc.Row(dbc.Col(slider_card, width=12))
first_row_cards = dbc.Row([dbc.Col(world_card, width=6), dbc.Col(term_frequency_card, width=6)])
second_row_cards = dbc.Row([dbc.Col(article_card, width=4), dbc.Col(sunburst_card, width=4), dbc.Col(bubble_chart_card, width=4)])

app.layout = html.Div(
    children=[
        title_row,
        slider_row,
        first_row_cards,
        second_row_cards
    ],className="main-container"
)

set_slider_callback(app)
set_article_callback(app)
set_map_callback(app)
set_term_frequency_callback(app)
set_bubble_callback(app)
set_sunburst_callback(app)

if __name__ == '__main__':
    app.run_server(debug=True)
