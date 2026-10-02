const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

function requireAdmin(request, permission) {
  const token = request.auth?.token;
  if (!token || token.admin !== true) {
    throw new HttpsError("permission-denied", "Admin authorization required.");
  }
  const permissions = Array.isArray(token.permissions) ? token.permissions : [];
  if (permission && !permissions.includes("*") && !permissions.includes(permission)) {
    throw new HttpsError("permission-denied", "Required permission is missing.");
  }
  return token;
}

exports.calculateMarketplacePrice = onCall(async (request) => {
  requireAdmin(request, "settings.manage");
  const data = request.data || {};
  const providerPrice = Number(data.providerPrice);
  const fixedMarkup = Number(data.fixedMarkup || 0);
  const percentageMarkup = Number(data.percentageMarkup || 0);
  if (!Number.isFinite(providerPrice) || providerPrice < 0 ||
      !Number.isFinite(fixedMarkup) || fixedMarkup < 0 ||
      !Number.isFinite(percentageMarkup) || percentageMarkup < 0) {
    throw new HttpsError("invalid-argument", "Invalid pricing values.");
  }
  const markup = fixedMarkup + providerPrice * (percentageMarkup / 100);
  const customerPrice = Math.round((providerPrice + markup) * 100) / 100;
  return {
    providerPrice,
    markup: Math.round(markup * 100) / 100,
    customerPrice,
  };
});

exports.analyzeService = onCall(async (request) => {
  const admin = requireAdmin(request, "ai.manage");
  const serviceId = String(request.data?.serviceId || "");
  if (!serviceId) throw new HttpsError("invalid-argument", "serviceId is required.");
  const snap = await db.collection("services").doc(serviceId).get();
  if (!snap.exists) throw new HttpsError("not-found", "Service not found.");

  // Production: call your approved AI provider from this trusted backend.
  // Never put its private API key in the Flutter APK.
  const result = {
    serviceId,
    status: "draft",
    suggestions: {
      title: null,
      description: null,
      category: null,
      tags: [],
      pricing: null,
      deliveryTime: null,
    },
    flags: [],
    generatedAt: FieldValue.serverTimestamp(),
    generatedBy: admin.uid,
  };
  const ref = await db.collection("ai_results").add(result);
  return {id: ref.id, serviceId, status: "draft"};
});

exports.writeAuditLog = onCall(async (request) => {
  const admin = requireAdmin(request, "audit.write");
  const { action, targetId, reason } = request.data || {};
  if (!action || !targetId) throw new HttpsError("invalid-argument", "action and targetId are required.");
  const ref = await db.collection("audit_logs").add({
    adminId: admin.uid,
    action: String(action),
    targetId: String(targetId),
    reason: reason ? String(reason) : null,
    createdAt: FieldValue.serverTimestamp(),
  });
  return {id: ref.id};
});
