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
            const db = event.data.ref.firestore;
            
            // Get receiver's details and check if they're logged in
            const receiverQuery = await db
                .collection("users")
                .where("email", "==", message.receiver)
                .get();

            if (receiverQuery.empty) {
                console.log('No matching receiver found');
                return;
            }

            const receiverData = receiverQuery.docs[0].data();
            
            // Check if receiver is logged in and has FCM token
            if (!receiverData.isLoggedIn || !receiverData.fcmToken) {
                console.log('Receiver is not logged in or has no FCM token');
                return;
            }

            // Get sender's name
            const senderQuery = await db
                .collection("users")
                .where("email", "==", message.sender)
                .get();

            if (senderQuery.empty) {
                console.log('No matching sender found');
                return;
            }

            const senderName = senderQuery.docs[0].data().name;

            // Send notification only if receiver is logged in
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
                token: receiverData.fcmToken,
            };

            // Send notification
            await getMessaging().send(payload);
            console.log('Notification sent successfully to logged in user');
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }
);
