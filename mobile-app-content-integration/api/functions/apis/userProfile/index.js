const admin = require('firebase-admin');

const db = admin.firestore();

const userProfileHandler = async (req, res) => {
  const userCollection = db.collection('users');
  switch (req.method) {
    case 'GET':
      const { userId } = req.query;
      if (!userId) {
        return res.status(400).send('bad request: not user id found');
      }
      let usersDoc = userCollection.doc(userId);
      usersDoc.get()
      .then((doc) => {
        if (doc.exists) {
          return res.status(200).json(doc.data());
        } else {
          return res.status(404).send('No matching document');
        }
      });
      break;
    case 'POST':
      const data = req.body;
      const userData = data.user;
      if (!userData) {
        return res.status(400).send('bad request: not user found');
      }
      const { company } = data;
      if (!company) {
        return res.status(400).send('bad request: not company found');
      }
      const { username } = userData;
      if (!username) {
        return res.status(400).send('bad request: not username found');
      }
      const currUser = await userCollection.doc(username)
        .set({ 'user': userData }, { merge: true })
        .then(() => null)
        .catch((err) => err);
      if (!currUser) {
        return userCollection.doc(username)
          .get()
          .then((doc) => {
            const { companies } = doc.data();
            let availableCompanies;
            if (companies) {
              availableCompanies = companies;
            } else {
              availableCompanies = [];
            }
            const updatedCompanies = [...availableCompanies, company];
            userCollection.doc(username)
              .set({ 'companies': updatedCompanies }, { merge: true })
              .then(() => res.status(200).send('company stored'))
              .catch(err => res.status(err.status).send({
                'Not possible to store company': company,
                'error': err 
              }));
          }).catch((err) => res.status(err.status).send(err));
      } else {
        return res.status(err.status).send({
          'Not possible to store': data,
          'error': err 
        });
      }
  }
};

module.exports = userProfileHandler;
