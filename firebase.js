// ============================================================
//  Sibaba Foundation — Firebase Initialization
//  Import this file in any page that needs Firebase services
// ============================================================
import { initializeApp } from "https://www.gstatic.com/firebasejs/12.12.0/firebase-app.js";
import { getAuth }        from "https://www.gstatic.com/firebasejs/12.12.0/firebase-auth.js";
import { getFirestore }   from "https://www.gstatic.com/firebasejs/12.12.0/firebase-firestore.js";

const firebaseConfig = {
  apiKey:            "AIzaSyC2UZjNiXGNpT7EszttVYQuI_zYYAFfddo",
  authDomain:        "sibaba-foundation.firebaseapp.com",
  projectId:         "sibaba-foundation",
  storageBucket:     "sibaba-foundation.firebasestorage.app",
  messagingSenderId: "563476505928",
  appId:             "1:563476505928:web:f98ddc458ebaf0e2643f7d",
  measurementId:     "G-6D9R47K29E"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db   = getFirestore(app);
