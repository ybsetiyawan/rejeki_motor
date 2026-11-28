const DEFAULT_WINDOW_MS = 15 * 60 * 1000; // 15 menit
const DEFAULT_MAX_ATTEMPTS = 10;

/**
 * Membuat middleware rate limiter in-memory sederhana berbasis IP.
 */
const createRateLimiter = ({
  windowMs = DEFAULT_WINDOW_MS,
  max = DEFAULT_MAX_ATTEMPTS,
  message = "Terlalu banyak percobaan. Silakan coba lagi nanti.",
} = {}) => {
  const hits = new Map();

  const cleanupTimer = setInterval(() => {
    const now = Date.now();
    for (const [key, entry] of hits.entries()) {
      if (now >= entry.resetAt) {
        hits.delete(key);
      }
    }
  }, windowMs);

  if (typeof cleanupTimer.unref === "function") {
    cleanupTimer.unref();
  }

  return (req, res, next) => {
    const now = Date.now();
    const key = req.ip || (req.socket && req.socket.remoteAddress) || "unknown";
    let entry = hits.get(key);

    if (!entry || now >= entry.resetAt) {
      entry = { count: 0, resetAt: now + windowMs };
      hits.set(key, entry);
    }

    entry.count += 1;

    const remaining = Math.max(0, max - entry.count);
    res.setHeader("X-RateLimit-Limit", String(max));
    res.setHeader("X-RateLimit-Remaining", String(remaining));

    if (entry.count > max) {
      const retryAfterSec = Math.max(1, Math.ceil((entry.resetAt - now) / 1000));
      res.setHeader("Retry-After", String(retryAfterSec));
      return res.status(429).json({
        status: "error",
        message,
      });
    }

    return next();
  };
};

const loginWindowMs = Number(process.env.LOGIN_RATE_LIMIT_WINDOW_MS) || DEFAULT_WINDOW_MS;
const loginMaxAttempts = Number(process.env.LOGIN_RATE_LIMIT_MAX) || DEFAULT_MAX_ATTEMPTS;

const loginRateLimiter = createRateLimiter({
  windowMs: loginWindowMs,
  max: loginMaxAttempts,
  message: "Terlalu banyak percobaan login. Silakan coba beberapa saat lagi.",
});

module.exports = {
  createRateLimiter,
  loginRateLimiter,
};
