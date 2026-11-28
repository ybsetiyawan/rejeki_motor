const crypto = require("crypto");
const jwt = require("jsonwebtoken");

const resolveJwtSecret = () => {
  if (process.env.JWT_SECRET && process.env.JWT_SECRET.trim() !== "") {
    return process.env.JWT_SECRET;
  }

  if (process.env.NODE_ENV === "production") {
    throw new Error("JWT_SECRET environment variable wajib diset di production.");
  }

  console.warn(
    "[auth] JWT_SECRET belum diset di environment; menggunakan secret acak sementara untuk sesi non-production."
  );
  return crypto.randomBytes(32).toString("hex");
};

const JWT_SECRET = resolveJwtSecret();
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || "1d";
const AUTH_COOKIE_NAME = process.env.AUTH_COOKIE_NAME || "rejeki_motor_token";

const DEFAULT_ADMIN_ROLES = ["admin", "administrator", "superadmin", "super admin", "owner", "adm"];

/**
 * Mengonversi durasi JWT (mis. "1d", "12h", "30m", "3600") menjadi milidetik untuk cookie maxAge.
 */
const parseDurationToMs = (duration) => {
  if (typeof duration === "number" && Number.isFinite(duration)) {
    return duration * 1000;
  }
  const match = /^(\d+)\s*([smhd])?$/i.exec(String(duration || "").trim());
  if (!match) {
    return 24 * 60 * 60 * 1000;
  }
  const value = Number(match[1]);
  const unit = (match[2] || "s").toLowerCase();
  const multipliers = {
    s: 1000,
    m: 60 * 1000,
    h: 60 * 60 * 1000,
    d: 24 * 60 * 60 * 1000,
  };
  return value * (multipliers[unit] || 1000);
};

/**
 * Menentukan opsi cookie HttpOnly untuk autentikasi.
 */
const getAuthCookieOptions = (req, includeMaxAge = true) => {
  const sameSite = (process.env.COOKIE_SAMESITE || "lax").toLowerCase();
  const isHttpsRequest = Boolean(
    req && (req.secure || req.headers["x-forwarded-proto"] === "https")
  );
  const secure =
    process.env.COOKIE_SECURE !== undefined
      ? process.env.COOKIE_SECURE === "true"
      : sameSite === "none" || isHttpsRequest;

  const options = {
    httpOnly: true,
    sameSite,
    secure,
    path: "/",
  };

  if (includeMaxAge) {
    options.maxAge = parseDurationToMs(JWT_EXPIRES_IN);
  }

  return options;
};

/**
 * Menyimpan JWT pada cookie HttpOnly.
 */
const setAuthCookie = (req, res, token) => {
  res.cookie(AUTH_COOKIE_NAME, token, getAuthCookieOptions(req, true));
};

/**
 * Menghapus cookie HttpOnly autentikasi.
 */
const clearAuthCookie = (req, res) => {
  res.clearCookie(AUTH_COOKIE_NAME, getAuthCookieOptions(req, false));
};

/**
 * Mem-parse header Cookie menjadi pasangan key-value.
 */
const parseCookies = (cookieHeader = "") => {
  const cookies = {};
  if (!cookieHeader) return cookies;

  for (const part of cookieHeader.split(";")) {
    const idx = part.indexOf("=");
    if (idx === -1) continue;
    const key = part.slice(0, idx).trim();
    const val = part.slice(idx + 1).trim();
    if (!key) continue;
    try {
      cookies[key] = decodeURIComponent(val);
    } catch (e) {
      cookies[key] = val;
    }
  }

  return cookies;
};

/**
 * Mengambil daftar role yang dianggap memiliki hak akses admin.
 * Dapat dikustomisasi melalui env ADMIN_ROLES (dipisah koma, mis: "admin,owner,1").
 */
const getAllowedRolesList = (customRoles) => {
  if (Array.isArray(customRoles) && customRoles.length > 0) {
    return customRoles.map((r) => String(r).trim().toLowerCase()).filter(Boolean);
  }
  if (process.env.ADMIN_ROLES) {
    return process.env.ADMIN_ROLES.split(",")
      .map((r) => r.trim().toLowerCase())
      .filter(Boolean);
  }
  return DEFAULT_ADMIN_ROLES;
};

/**
 * Membuat JWT token dari payload user.
 */
const signToken = (payload) => {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
};

/**
 * Middleware autentikasi: memverifikasi JWT dari cookie HttpOnly atau header Authorization Bearer.
 */
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers.authorization || "";
  const [scheme, bearerToken] = authHeader.split(" ");
  const cookies = parseCookies(req.headers.cookie);
  const cookieToken = cookies[AUTH_COOKIE_NAME];

  const token = scheme === "Bearer" && bearerToken ? bearerToken : cookieToken;

  if (!token) {
    return res.status(401).json({
      status: "error",
      message: "Unauthorized: Token autentikasi tidak ditemukan",
    });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    return next();
  } catch (err) {
    if (err.name === "TokenExpiredError") {
      return res.status(401).json({
        status: "error",
        message: "Unauthorized: Token sudah kedaluwarsa",
      });
    }
    return res.status(401).json({
      status: "error",
      message: "Unauthorized: Token tidak valid",
    });
  }
};

/**
 * Middleware otorisasi: membatasi akses berdasarkan role user pada JWT.
 * Mencocokkan terhadap role_kode, role_nama, atau id_role.
 */
const authorizeRoles = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        status: "error",
        message: "Unauthorized: User belum terautentikasi",
      });
    }

    const allowed = getAllowedRolesList(allowedRoles);

    const candidates = [
      req.user.role_kode,
      req.user.role_nama,
      req.user.id_role !== undefined && req.user.id_role !== null
        ? String(req.user.id_role)
        : null,
    ]
      .filter((val) => val !== undefined && val !== null && String(val).trim() !== "")
      .map((val) => String(val).trim().toLowerCase());

    const hasAccess = candidates.some((candidate) => allowed.includes(candidate));
    if (!hasAccess) {
      return res.status(403).json({
        status: "error",
        message: "Forbidden: Anda tidak memiliki izin untuk mengakses endpoint ini",
      });
    }

    return next();
  };
};

const requireAdmin = authorizeRoles();

module.exports = {
  AUTH_COOKIE_NAME,
  signToken,
  setAuthCookie,
  clearAuthCookie,
  authenticateToken,
  authorizeRoles,
  requireAdmin,
};
