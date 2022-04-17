const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const API_KEY = "AIzaSyDsNDWloKgHeY_W2prK_qPOUXALiL390VY";

exports.sendNotification = functions.firestore.document("users/{user_id}/invites/{invitation_id}").onCreate((snap, context) => {
	const user_id = context.params.user_id;
	const invitation_id = context.params.invitation_id;
	console.log('Notification send to :', user_id);
	return admin.firestore().collection("users").doc(user_id).collection("invites").doc(invitation_id).get().then(result => {
        const placeId = result.data().place;
        const date = result.data().date;
        const time = result.data().time;
        const user = result.data().users[0];
		const firstName = user.firstName;
        const title = "You got an invite!";
        const body = firstName + " is inviting you to a place on " + date + " at " + time + ". Find out more in your inbox!";
        console.log(body);
		return admin.firestore().collection("users").doc(user_id).get().then(result => {
			const tokenId = result.data().token;
			console.log(tokenId);
			const message = {
				"token": tokenId,
				"data": {
					"title": title,
					"message": body,
				},
				"apns": {
					"payload": {
						"aps": {
							"alert": {
								"title": title,
								"body": body
							},
							"sound": "default",
							"mutable-content": 1
						}
					},
				}
			};
			return admin.messaging().send(message).then(response => {
				console.log("Notification sent!");
			});
		});
	});
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
