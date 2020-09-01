const functions = require('firebase-functions');
const axios = require('axios');

const { companies } = functions.config();

const API_KEY = companies.api_key;
const COMPANY_CLEARBIT_URL = 'https://company.clearbit.com';
const DISCOVERY_CLEARBIT_URL = 'https://discovery.clearbit.com/v1/companies/search?query=similar';
const SUGGESTION_RANGE = 100;
const OPTIONS = {
  headers: { 
    Accept: '*/*',
    Authorization: `Bearer ${API_KEY}`
  }
};

const handleError = (response) => {
  if (response.status === 404 || response.status == 422 || response.status >= 500) {
    return true;
  }
};

const discoverCompanyHandler = async (req, res) => {
  const { domain } = req.query;
  if (!domain) {
    return res.status(400).send('bad request: not domain name found');
  }
  const discoveryUrl = `${DISCOVERY_CLEARBIT_URL}:${domain}&limit=${SUGGESTION_RANGE}&sort=raised_desc`;
  const response = await axios.get(discoveryUrl, OPTIONS);
  res.status(response.status);

  return !handleError(response) ? res.send(response.data) : res.send('No domain found');
};

const searchCompanyHandler = async (req, res) => {
  const { name } = req.query;
  if (!name) {
    return res.status(400).send('bad request: not company name found');
  }
  const domainResponse = await axios.get(`${COMPANY_CLEARBIT_URL}/v1/domains/find?name=${name}`, OPTIONS);
  if (handleError(domainResponse)) {
    return res.status(domainResponse.status).send('No company found');
  }
  const { data } = domainResponse;
  const companyResponse = await axios.get(`${COMPANY_CLEARBIT_URL}/v2/companies/find?domain=${data.domain}`, OPTIONS);
  res.status(companyResponse.status);
  
  return !handleError(companyResponse) ? res.send(companyResponse.data) : res.send('No domain found');
};


module.exports = {
    discoverCompanyHandler,
    searchCompanyHandler
};
