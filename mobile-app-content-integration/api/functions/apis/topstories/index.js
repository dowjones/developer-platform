
const axios = require('axios');
const functions = require('firebase-functions');

const { topstories } = functions.config();
const CLIENT_ID = topstories.client_id;
const USERNAME = topstories.username;
const PASSWORD = topstories.password;
const CONTENT_COLLECTIONS_URL = 'https://api.dowjones.com/content-collections';

const authenticateApi = async() => {
  const authURL = 'https://accounts.dowjones.com/oauth2/v1/token';
  const tokenPayload = {
    'client_id': CLIENT_ID,
    'username': USERNAME,
    'grant_type': 'password',
    'connection': 'service-account',
    'scope': 'openid service_account_id',
    'password': PASSWORD
  };
  const authToken = await axios({
    method: 'post',
    url: authURL,
    data: tokenPayload })
    .then(({ data }) => data)
    .catch(error => error.response);
  // return error response
  if (!authToken['id_token']) {
    return authToken;
  }
  const idToken = authToken['id_token'];
  const accessToken = authToken['access_token'];
  const authz_token_payload = {
    'client_id': CLIENT_ID,
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'connection': 'service-account',
    'scope': 'openid pib',
    'access_token': accessToken,
    'assertion': idToken
  };
  const authzToken = await axios({
    method: 'post',
    url: authURL,
    data: authz_token_payload
  })
  .then(({ data }) => data)
  .catch(error => error.response);

  return authzToken;
};

const getNews = async(url) => {
  const authzResponse = await authenticateApi();
  // return error response
  if (!authzResponse['access_token']) {
    return authzResponse;
  }
  const authzToken = authzResponse['access_token'];
  const options = { 
    headers: { 
      Accept: '*/*',
      Authorization: `Bearer ${authzToken}`
    }
  };
  const response = await axios.get(url, options);

  return response;
};

const topStoriesHandler = async(req, res) => {
  if (req.query.id) {
    const articleURL = `${CONTENT_COLLECTIONS_URL}/${req.query.id}?prepub=true`;
    getNews(articleURL)
    .then(data => res.send(data.data.included[0]))
    .catch(err => res.send(err.response.data.errors));
  } else {
    getNews(CONTENT_COLLECTIONS_URL)
    .then(data => res.send(data.data.data))
    .catch(err => res.send(err.response.data.errors));
  }
};

module.exports = topStoriesHandler;
