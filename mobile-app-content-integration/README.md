# Mobile App Content Integration
This solution pattern showcases how to build a sample mobile trading app and embed portfolio news and recommendations using Dow Jones and third-party APIs.

A [high-level description](https://github.com/CoderJava/Flutter-News-App/blob/master/screenshots/output_app.png) of this solution pattern can be found in the Developer Platform.

The code for this solution pattern includes the following three components:

1. **User interface**

    Flutter's design patterns and Dow Jones's best practices are leveraged to create a frontend and present rich media in a user-friendly way. By using Flutter, the frontend is available for iOS, Android and web browsers.

2. **Run-time database**

    Firebase stores news-related data such as user preferences, portfolio information, and media links.

3. **Backend server**

    NodeJS is leveraged to retrieve portfolio content and statistics through API calls. Dow Jones Top Stories API and Firebase I/O provide such information. Additionally, both NodeJS and Firebase log content consumption for analytics purposes.

## Installing the App

**Important:** The project backend assumes a working firebase project setup.<br>
More insight on this subject can be found at [Official Firebase Docs](https://firebase.google.com/docs/?gclid=EAIaIQobChMIhL6Ztuyn6gIVSrzACh2F0AwlEAAYASAAEgLO3PD_BwE).

1. Register the app with Firebase. The code in this repository works for either Android or iOS. However, each app should register with Firebase project individually.<br>
**Note:** [Firebase documentation](https://firebase.google.com/docs/flutter/setup) provides a step-by-step guide to complete this task.

2. Add [Dow Jones Top Stories API](https://developer.dowjones.com/site/docs/newswires_apis/dow_jones_top_stories_api/index.gsp) and [Clearbit](https://clearbit.com/) credentials to the Firebase project.<br>
**Note:** These credentials are required by the External APIs that are leveraged to retrieve companies' information, news articles and stock values.<br>
The following snippet shows how to add the credentials to the Firebase project.<br>
```firebase functions:config:set topstories.client_id="ID" topstories.username="NAME" topstories.password="PASS" companies.api_key="CLEARBIT_API_KEY"```

3. Set the environment variables and then run the following command:<br>
```firebase deploy --only functions```<br>
**Note:** Visit [Firebase Environment Configuration](https://firebase.google.com/docs/functions/config-env) for more details on how to set up environment variables.

4. Get the flutter dependencies using `flutter pub get` command inside the flutter project.

## Running the App

1. To run the backend of the app, deploy the Firebase functions inside `/api` to Firebase Cloud Functions.

2. To run the actual app, use either a physical device or an emulator. Both Android Studio and XCode provide an emulator.<br>
**Note:** Visit the [Flutter Set Up Guide](https://flutter.dev/docs/get-started/editor) to begin setting up a text editor.

## App Workflow

The process to provide this solution initiates when the app is opened or refreshed.

A request is sent to Firebase to “pre” retrieve a list of companies.<br>
**Note:** Those companies appear in a Top Bar widget.

Subsequently, it includes the following actions:

1. The OS loads the app widget in the Main UI.<br>
**Note:** The news and stocks widgets follow the same process.
2. The loaded screen widgets’ Bloc classes identify the event type and send a request to the API Repository.
3. The API Repository has agnostic clients, and every client consumes from a specific API Provider.
4. The API Provider sends a request to Firebase.
5. Firebase consumes the four available APIs.
6. Firebase returns a response to the given API Provider method.
7. The API Provider returns the response to the API Repository client.
8. The API Repository loads information in the HomeBloc class.
9. Content is loaded in the widget that triggered the event.

More requests exist for further processes.
