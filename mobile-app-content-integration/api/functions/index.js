const admin = require('firebase-admin');
const functions = require('firebase-functions');
admin.initializeApp(functions.config().firebase);

const yahooHandler = require('./apis/yahoo');
const logosHandler = require('./apis/logos');
const userProfileHandler = require('./apis/userProfile');
const topStoriesHandler = require('./apis/topstories');
const { discoverCompanyHandler, searchCompanyHandler } = require('./apis/clearbit');

exports.retrieveTicker = functions.https.onRequest(yahooHandler);

exports.getTopNews = functions.https.onRequest(topStoriesHandler);

exports.getLogos = functions.https.onRequest(logosHandler);

exports.userProfile = functions.https.onRequest(userProfileHandler);

exports.getCompany = functions.https.onRequest(searchCompanyHandler);

exports.recommendCompany = functions.https.onRequest(discoverCompanyHandler);
