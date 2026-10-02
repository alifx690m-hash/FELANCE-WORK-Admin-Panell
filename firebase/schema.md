# Firestore schema

## admin_users/{uid}
role, permissions[], status, displayName, email, createdAt, lastLoginAt

## users/{uid}
displayName, username, email, country, accountType, verificationStatus, status

## services/{serviceId}
ownerId, title, description, categoryId, tags[], packages[], providerPrice, customerPrice, status, aiReviewId, createdAt, updatedAt

## orders/{orderId}
clientId, providerId, serviceId, amount, currency, platformRevenue, providerEarnings, paymentStatus, status, createdAt, updatedAt

## transactions/{transactionId}
orderId, userId, amount, currency, provider, status, createdAt

## payouts/{payoutId}
providerId, amount, currency, status, providerReference, createdAt, updatedAt

## ai_requests/{id}
requestedBy, serviceId, type, status, createdAt

## ai_results/{id}
serviceId, suggestions, flags, status, generatedBy, generatedAt

## reports/{id}
reporterId, targetType, targetId, reason, evidence, status, assignedTo, createdAt

## support_tickets/{id}
userId, subject, category, priority, status, assignedAdminId, createdAt, updatedAt

## audit_logs/{id}
adminId, action, targetId, reason, previousState, newState, createdAt

## pricing_rules/{id}
scope, fixedMarkup, percentageMarkup, minMarkup, maxMarkup, currency, active, updatedAt
