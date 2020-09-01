const yahooFinance = require('yahoo-finance');

const yahooHanlder = async (req, res) => {
  const formatDate = (date) => {
    let month = '' + (date.getMonth() + 1),
    day = '' + date.getDate(),
    year = date.getFullYear();
    if (month.length < 2) {
      month = '0' + month;
    }
    if (day.length < 2) {
      day = '0' + day;
    }

    return [year, month, day].join('-');
  }

  const requestedTicker = req.query.ticker;
  if (!requestedTicker) {
    return res.status(400).send('bad request: not ticker found');
  }
  const today = new Date();
  var endDate = formatDate(new Date());
  let newYear = (today.getMonth() < 1) ? today.getFullYear() -1  : today.getFullYear();
  let newMonth = (today.getMonth() < 1) ? 12 : today.getMonth() -1;
  let startDate = formatDate(new Date(newYear, newMonth, today.getDate()));
  
  yahooFinance.historical({
    symbol: requestedTicker,
    from: startDate,
    to: endDate,
    period: 'd'
  }).then((quotes) => {
    tickers = quotes.map((quote) => {
      ticker = {};
      ticker.date = formatDate(new Date(quote.date));
      ticker.close = quote.close;
      ticker.open = quote.open;
      ticker.high = quote.high;
      ticker.low = quote.low;

      return ticker;
    });
    res.json(tickers);
  });
};

module.exports = yahooHanlder;
