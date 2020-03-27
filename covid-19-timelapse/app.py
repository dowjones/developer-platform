import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output
from dashapps.default.app import create_graph
from dashapps.map.app import create_map
from dashapps.article.app import create_article, set_article_callback

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
server = app.server

confirmed_cases_source = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
confirmed_deaths_source = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'  

world_map = create_map(confirmed_cases_source, confirmed_deaths_source)
articles = create_article()

app.layout = html.Div([
    html.Div(
        html.H1('COVID-19'),
        style={
            'textAlign':'center'
        }
    ),
    html.Div(
        dcc.Graph(
            id="graph",
            figure=world_map
        ),
        style={
            'width': '50%',
            'height': '60px'
        },
    ),
    html.Div(
        dcc.Graph(
            id='example-graph',
            figure=create_graph()
        ),
        style={
            'width': '50%',
            'paddingLeft': '50%',
            'height': '60px'
        },
    ),
    html.Div(
        articles,
        style={
            'paddingTop': '20%',
            'float': 'left',
            'width': '25%',
            'height': '350px',
            'overflow': 'auto'
        },
    ),
    html.Div(
        dcc.Graph(
            id='example-graph-3',
            figure=create_graph()
        ),
        style={
            'paddingTop': '20%',
            'float': 'left',
            'width': '25%',
            'height': '50px'
        },
    ),
    html.Div(
        dcc.Graph(
            id='example-graph-4',
            figure=create_graph()
        ),
        style={
            'paddingTop': '20%',
            'float': 'left',
            'width': '50%',
            'height': '50px'
        },
    ),
])

set_article_callback(app)

if __name__ == '__main__':
    app.run_server(debug=True)
