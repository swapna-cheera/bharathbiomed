/**
 * One-off script: creates a single Medical Representative account for
 * Google Play reviewers to sign in with (this app requires sign-in before
 * any screen is usable — see lib/features/auth/login_screen.dart). Mirrors
 * the real createEmployee Cloud Function (Auth user + custom claim + Users
 * profile doc) but skips the mandatory first-login profile step so a
 * reviewer isn't blocked on uploading a photo.
 *
 * Run via the same Application Default Credentials as `firebase deploy`,
 * against whichever project the Firebase CLI is currently pointed at:
 *
 *   npm run create:reviewer
 */
import {initializeApp} from "firebase-admin/app";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {getAuth} from "firebase-admin/auth";

const EMAIL = "playstore.reviewer@bharathbiomedpharma.com";
const PASSWORD = "PlayReview2026!";
const USERNAME = "playstore_reviewer";

async function main(): Promise<void> {
  initializeApp({projectId: process.env.GOOGLE_CLOUD_PROJECT || process.env.GCLOUD_PROJECT});
  const auth = getAuth();
  const firestore = getFirestore();

  const existing = await firestore.collection("Users").where("username", "==", USERNAME).limit(1).get();
  if (!existing.empty) {
    console.log(`Reviewer account already exists (uid=${existing.docs[0].id}). Nothing to do.`);
    console.log(`Email: ${EMAIL}`);
    console.log(`Username: ${USERNAME}`);
    return;
  }

  const userRecord = await auth.createUser({
    email: EMAIL,
    password: PASSWORD,
    displayName: "Play Store Reviewer",
    emailVerified: true,
  });
  const uid = userRecord.uid;

  try {
    await auth.setCustomUserClaims(uid, {role: "mr"});
    await firestore.collection("Users").doc(uid).set({
      username: USERNAME,
      firstName: "Play Store",
      lastName: "Reviewer",
      displayName: "Play Store Reviewer",
      designation: "Medical Representative",
      areaName: "Play Store Review",
      mobileNumber: null,
      photoUrl: null,
      email: EMAIL,
      dateOfBirth: null,
      designationId: null,
      managerId: null,
      role: "mr",
      disabled: false,
      profileCompleted: true,
      createdAt: FieldValue.serverTimestamp(),
      createdBy: "createReviewerAccount.ts",
    });
  } catch (error) {
    console.error("Failed after Auth user was created, rolling back:", error);
    await auth.deleteUser(uid).catch((cleanupError) => console.error("Rollback also failed:", cleanupError));
    throw error;
  }

  console.log("Created reviewer account:");
  console.log(`  Email/Username field: ${EMAIL}`);
  console.log(`  Password: ${PASSWORD}`);
  console.log(`  uid: ${uid}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
