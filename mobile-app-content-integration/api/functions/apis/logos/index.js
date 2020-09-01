const admin = require('firebase-admin');

const db = admin.firestore();

const logosHandler = async (req, res) => {
  let logosDBCollection = db.collection('logos')
  switch (req.method) {
    case 'GET':
    let companies = { data: [] };
    return logosDBCollection.get()
      .then((snapshot) => {
        if (snapshot.empty) {
          return res.status(404).send('No documents found');
        }
        snapshot.forEach((doc) => {
          const docData = doc.data();
          companies.data.push(docData);
        });
      })
      .catch(err => {
        return res.status(500).send(err);
      })
      .finally(() => res.status(200).json(companies));
    case 'POST':
      const company = req.body;
      let { name } = company;
      if (!name) {
        return res.status(400).send('bad request: not company name found');
      }
      return logosDBCollection
        .doc(name)
        .set(company)
        .then(() => res.status(200).json(company))
        .catch((err) => res.status(err.status)
        .send({ 'Not possible to store company': company, 'error': err }));
  }
};

module.exports = logosHandler;
