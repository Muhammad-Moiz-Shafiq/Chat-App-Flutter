const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");

// Initialize Firebase Admin
initializeApp();

exports.sendMessageNotification = onDocumentCreated(
    "messages/{messageId}",
    async (event) => {
        const message = event.data.data();
        
        try {
            // Get receiver's FCM token from users collection
            const db = event.data.ref.firestore;
            const userDoc = await db
                .collection("users")
                .where("email", "==", message.receiver)
                .get();

            if (userDoc.empty) {
                console.log('No matching user found');
                return;
            }

            const receiverData = userDoc.docs[0].data();
            const fcmToken = receiverData.fcmToken;

            if (!fcmToken) {
                console.log('No FCM token found for user');
                return;
            }

            // Get sender's name
            const senderDoc = await db
                .collection("users")
                .where("email", "==", message.sender)
                .get();

            if (senderDoc.empty) {
                console.log('No matching sender found');
                return;
            }

            const senderName = senderDoc.docs[0].data().name;

            // Prepare notification
            const payload = {
                notification: {
                    title: senderName,
                    body: message.text,
                },
                data: {
                    type: 'chat',
                    senderEmail: message.sender,
                    senderName: senderName,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                },
                token: fcmToken,
            };

            // Send notification
            await getMessaging().send(payload);
            console.log('Notification sent successfully');
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }
);
