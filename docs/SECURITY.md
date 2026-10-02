# Security checklist

1. Use Firebase App Check for supported clients.
2. Use custom claims for server-enforced admin role/permissions.
3. Bootstrap the first SUPER_ADMIN through a controlled backend/admin script; never create admin privilege from the APK.
4. Keep AI/payment/external marketplace secrets only in server-side secret storage.
5. Use callable Cloud Functions for privileged mutations.
6. Add rate limits and abuse monitoring to auth and callable functions.
7. Enable Firestore/Storage rules and test them with the Firebase Emulator Suite.
8. Enable scheduled Firestore backups and define recovery procedures.
9. Audit financial operations and require confirmation/authorization.
10. Do not rely on hidden buttons or local role checks for security.
