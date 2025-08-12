import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import {getAuth} from "firebase-admin/auth";

initializeApp();

export const adminUpdateUserPassword = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "Debes iniciar sesión.");

  const claims = request.auth.token as Record<string, unknown>;
  if (claims["role"] !== "admin") {
    throw new HttpsError("permission-denied", "No tienes permisos para cambiar contraseñas.");
  }

  const data = (request.data ?? {}) as { uid?: string; newPassword?: string; revoke?: boolean };
  const { uid, newPassword, revoke } = data;

  if (!uid || typeof uid !== "string") {
    throw new HttpsError("invalid-argument", "uid es requerido y debe ser string.");
  }

  // ✅ coherente con el mensaje: mínimo 8
  if (!newPassword || typeof newPassword !== "string" || newPassword.length < 8) {
    throw new HttpsError("invalid-argument", "La contraseña debe tener al menos 8 caracteres.");
  }

  await getAuth().updateUser(uid, { password: newPassword });
  if (revoke === true) await getAuth().revokeRefreshTokens(uid);

  return { ok: true, message: "Contraseña actualizada." };
});

// ➕ NUEVO: asignar claim admin a un UID
export const setUserAsAdmin = onCall(async (req) => {
  if (!req.auth) throw new HttpsError("unauthenticated", "Login requerido");

  const uid = req.data?.uid as string | undefined;
  if (!uid) throw new HttpsError("invalid-argument", "uid requerido");

  await getAuth().setCustomUserClaims(uid, { role: "admin" });
  return { ok: true };
});
