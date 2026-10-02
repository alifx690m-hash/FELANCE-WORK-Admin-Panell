# FELANCE WORK Admin Panel

Separate Flutter Android admin application for FELANCE WORK.

## Security model
- Firebase Authentication identifies the operator.
- Admin authorization is enforced server-side with custom claims/roles.
- The APK never contains Firebase Admin SDK credentials, service-account keys, payment secrets, or private AI keys.
- Privileged mutations should call Cloud Functions/secure backend.
- Firestore rules deny normal users access to admin-only collections/actions.
- The client UI is permission-aware, but UI permissions are not a security boundary.

## Included architecture
- Admin login
- Role/permission model
- Dashboard
- Users, services, orders, finance, reports, support, AI, settings, audit sections
- Service moderation workflow
- Server-side pricing function
- AI-analysis function placeholder
- Audit-log function placeholder
- Firestore/Storage rules
- Indexes
- Deployment/configuration notes

## Roles
SUPER_ADMIN, ADMIN, MODERATOR, SUPPORT, FINANCE, AI_MANAGER

## Before production
1. Create a Firebase project.
2. Enable Email/Password Authentication.
3. Add Android app and run `flutterfire configure`.
4. Deploy Firestore rules/indexes and Cloud Functions.
5. Create the first admin through a controlled server-side bootstrap process.
6. Configure App Check, FCM, backups, monitoring and a real payment provider.
7. Test every privileged action with each role.
