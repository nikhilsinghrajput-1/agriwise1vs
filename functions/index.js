/* eslint-disable */
/* eslint-disable */
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');
const cors = require('cors')({ origin: true });
admin.initializeApp();

exports.createUserDocument = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection('users').doc(user.uid).set({
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    // Add other user details here, such as location and crop type
  });
});

exports.auth = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    if (req.method !== 'POST') {
      return res.status(405).send('Method Not Allowed');
    }

    const idToken = req.body.idToken;

    try {
      const decodedIdToken = await admin.auth().verifyIdToken(idToken);
      const user = await admin.auth().getUser(decodedIdToken.uid);

      // Store user data in Firestore if it doesn't exist
      const userRef = admin.firestore().collection('users').doc(user.uid);
      const doc = await userRef.get();
      if (!doc.exists) {
        await userRef.set({
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          // Add other user details here, such as location and crop type
        });
      }

      return res.status(200).send({ message: 'Authentication successful', user: user });
    } catch (error) {
      console.error('Error while verifying Firebase ID token:', error);
      return res.status(401).send('Authentication failed');
    }
  });
});

const authenticate = (req, res, next) => {
  if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
    res.status(403).send('Unauthorized');
    return;
  }
  const idToken = req.headers.authorization.split('Bearer ')[1];
  admin.auth().verifyIdToken(idToken)
    .then((decodedIdToken) => {
      req.user = decodedIdToken;
      next();
    })
    .catch((error) => {
      console.error('Error while verifying Firebase ID token:', error);
      res.status(403).send('Unauthorized');
    });
};

exports.getWeather = functions.https.onRequest(async (req, res) => {
  cors(req, res, () => {
    authenticate(req, res, async () => {
      const apiKey = ''; // Replace with your OpenWeather API key
      const city = req.query.city || 'San Francisco';
      try {
        const response = await axios.get(
          `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric`
        );
        res.send(response.data);
      } catch (error) {
        console.error(error);
        res.status(500).send('An error occurred');
      }
    });
  });
});

exports.getAdvisory = functions.https.onRequest(async (req, res) => {
  cors(req, res, () => {
    authenticate(req, res, () => {
      // Implement logic to fetch farming recommendations
      const advisory = {
        title: 'Rain Expected, Reduce Irrigation',
        content: 'Reduce irrigation by 50% due to expected rainfall.',
        category: 'Weather',
        createdAt: new Date().toISOString(),
      };
      res.send(advisory);
    });
  });
});

exports.getSoil = functions.https.onRequest(async (req, res) => {
  cors(req, res, () => {
    authenticate(req, res, () => {
      // Implement logic to fetch soil moisture & pH data
      const soilData = {
        moisture: 60,
        pHLevel: 6.5,
        temperature: 25,
        updatedAt: new Date().toISOString(),
      };
      res.send(soilData);
    });
  });
});
