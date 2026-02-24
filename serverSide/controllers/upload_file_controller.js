const express = require('express');
const router = express.Router();
const { initializeApp } = require('firebase/app');
const { getStorage, ref, getDownloadURL, uploadBytesResumable } = require('firebase/storage');
const multer = require('multer');
const config = require('../config/firebase.config');

const app = initializeApp(config.firebaseConfig);
const storage = getStorage(app);
const upload = multer({storage: multer.memoryStorage()}); 

const requiredFirebaseKeys = [
    'apiKey',
    'authDomain',
    'projectId',
    'storageBucket',
    'messagingSenderId',
    'appId',
];

const missingFirebaseKeys = () => {
    return requiredFirebaseKeys.filter((key) => !config.firebaseConfig[key]);
};

router.get("/health", (req, res) => {
    const missing = missingFirebaseKeys();
    if (missing.length > 0) {
        return res.status(500).json({
            ok: false,
            stage: 'firebase_config',
            missingKeys: missing,
            message: 'Firebase config is incomplete in serverSide/.env',
        });
    }

    return res.status(200).json({
        ok: true,
        stage: 'firebase_config',
        projectId: config.firebaseConfig.projectId,
        storageBucket: config.firebaseConfig.storageBucket,
    });
});

router.post("/", upload.single("filename"), async (req, res) => {
    try {
        const missing = missingFirebaseKeys();
        if (missing.length > 0) {
            return res.status(500).json({
                ok: false,
                stage: 'firebase_config',
                missingKeys: missing,
                message: 'Firebase config is incomplete in serverSide/.env',
            });
        }

        if (!req.file) {
            return res.status(400).json({
                ok: false,
                stage: 'request_validation',
                message: 'No file received. Expected multipart field: filename',
            });
        }

        const dateTime = giveCurrentDateTime();

        const storageRef = ref(storage, `files/${req.file.originalname + "       " + dateTime}`);

        // Create file metadata including the content type
        const metadata = {
            contentType: req.file.mimetype,
        };

        // Upload the file in the bucket storage
        const snapshot = await uploadBytesResumable(storageRef, req.file.buffer, metadata);

        // Grab the public url
        const downloadURL = await getDownloadURL(snapshot.ref);

        console.log('File successfully uploaded.');
        return res.status(200).json({
            ok: true,
            stage: 'upload_success',
            message: 'file uploaded to firebase storage',
            name: req.file.originalname,
            type: req.file.mimetype,
            downloadURL: downloadURL
        });
    } catch (error) {
        return res.status(400).json({
            ok: false,
            stage: 'firebase_upload',
            message: error.message,
            code: error.code || 'unknown',
        });
    }
});

const giveCurrentDateTime = () => {
    const today = new Date();
    const date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
    const time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
    const dateTime = date + ' ' + time;
    return dateTime;
}

module.exports = router;
