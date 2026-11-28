<template>
  <div class="rm-home-minimal">
    <!-- Lapisan Animasi Spare Part & Elemen Bengkel (Tanpa Motor) -->
    <div class="rm-garage-anim-layer" aria-hidden="true">
      <!-- 1. Kiri Atas: Gir Sprocket Ganda -->
      <svg class="rm-garage-svg rm-p-tl rm-anti-a" viewBox="0 0 140 105">
        <g class="rm-spin-cw">
          <circle cx="44" cy="52" r="28" fill="rgba(255, 250, 250, 0.88)" stroke="#dc2626" stroke-width="2.6" />
          <circle cx="44" cy="52" r="13" fill="#ffffff" stroke="#b91c1c" stroke-width="2" />
          <circle cx="44" cy="52" r="4.8" fill="#991b1b" />
          <g stroke="#dc2626" stroke-width="3.6" stroke-linecap="round">
            <line x1="44" y1="17" x2="44" y2="23" />
            <line x1="44" y1="81" x2="44" y2="87" />
            <line x1="9" y1="52" x2="15" y2="52" />
            <line x1="73" y1="52" x2="79" y2="52" />
            <line x1="19.5" y1="27.5" x2="23.8" y2="31.8" />
            <line x1="64.2" y1="72.2" x2="68.5" y2="76.5" />
            <line x1="68.5" y1="27.5" x2="64.2" y2="31.8" />
            <line x1="23.8" y1="72.2" x2="19.5" y2="76.5" />
          </g>
        </g>

        <g class="rm-spin-ccw">
          <circle cx="98" cy="66" r="18" fill="rgba(254, 226, 226, 0.9)" stroke="#991b1b" stroke-width="2.4" />
          <circle cx="98" cy="66" r="7" fill="#ffffff" stroke="#b91c1c" stroke-width="1.8" />
          <g stroke="#991b1b" stroke-width="3" stroke-linecap="round">
            <line x1="98" y1="43" x2="98" y2="48" />
            <line x1="98" y1="84" x2="98" y2="89" />
            <line x1="75" y1="66" x2="80" y2="66" />
            <line x1="116" y1="66" x2="121" y2="66" />
          </g>
        </g>
      </svg>

      <!-- 2. Atas Tengah: Gauge RPM -->
      <svg class="rm-garage-svg rm-p-tc rm-anti-b" viewBox="0 0 110 88">
        <path
          d="M 21 66 A 33 33 0 1 1 87 66"
          fill="none"
          stroke="#fecaca"
          stroke-width="6"
          stroke-linecap="round"
        />
        <path
          d="M 21 66 A 33 33 0 0 1 74 26"
          fill="none"
          stroke="#dc2626"
          stroke-width="6"
          stroke-linecap="round"
        />
        <line
          x1="54"
          y1="54"
          x2="72"
          y2="30"
          stroke="#991b1b"
          stroke-width="3"
          stroke-linecap="round"
          class="rm-needle"
        />
        <circle cx="54" cy="54" r="5" fill="#1f2937" />
      </svg>

      <!-- 3. Atas Kanan-Tengah: Busi / Spark Plug -->
      <svg class="rm-garage-svg rm-p-tr rm-anti-c" viewBox="0 0 85 110">
        <g class="rm-plug-bob">
          <rect x="33" y="12" width="18" height="26" rx="4" fill="rgba(255, 255, 255, 0.92)" stroke="#991b1b" stroke-width="2" />
          <line x1="35" y1="20" x2="49" y2="20" stroke="#fca5a5" stroke-width="2" />
          <line x1="35" y1="27" x2="49" y2="27" stroke="#fca5a5" stroke-width="2" />
          <polygon points="28,38 56,38 59,48 25,48" fill="#fee2e2" stroke="#991b1b" stroke-width="2" />
          <rect x="35" y="48" width="14" height="20" fill="#cbd5e1" stroke="#475569" stroke-width="1.8" />
          <path d="M 42 68 L 42 79 L 52 79 L 52 71" fill="none" stroke="#991b1b" stroke-width="2.2" />
          <circle cx="42" cy="81" r="4.2" fill="#ef4444" class="rm-spark" />
        </g>
      </svg>

      <!-- 4. Kiri Bawah: Kunci Pas & Mur Hex -->
      <svg class="rm-garage-svg rm-p-bl rm-anti-b" viewBox="0 0 130 105">
        <g class="rm-wrench">
          <path
            d="M 34 14 C 24 14 16 22 16 32 C 16 39 20 45 26 48 L 26 86 C 26 91 30 95 34 95 C 38 95 42 91 42 86 L 42 48 C 48 45 52 39 52 32 C 52 22 44 14 34 14 Z"
            fill="rgba(254, 242, 242, 0.9)"
            stroke="#b91c1c"
            stroke-width="2.2"
          />
          <rect x="29" y="12" width="10" height="12" rx="2" fill="#ffffff" />
        </g>
        <g class="rm-spin-cw-nut">
          <polygon
            points="92,42 107,51 107,69 92,78 77,69 77,51"
            fill="rgba(255, 255, 255, 0.9)"
            stroke="#b91c1c"
            stroke-width="2.2"
          />
          <circle cx="92" cy="60" r="7.5" fill="rgba(254, 226, 226, 0.92)" stroke="#991b1b" stroke-width="1.8" />
        </g>
      </svg>

      <!-- 5. Bawah Tengah-Kiri: Ban Motor Berulir -->
      <svg class="rm-garage-svg rm-p-tire rm-anti-a" viewBox="0 0 120 120">
        <g class="rm-spin-cw-tire">
          <circle cx="60" cy="60" r="41" fill="none" stroke="#1f2937" stroke-width="10" />
          <circle
            cx="60"
            cy="60"
            r="46"
            fill="none"
            stroke="#4b5563"
            stroke-width="2.4"
            stroke-dasharray="6 6"
          />
          <circle
            cx="60"
            cy="60"
            r="36"
            fill="none"
            stroke="#fca5a5"
            stroke-width="1.8"
            stroke-dasharray="7 5"
          />
          <circle cx="60" cy="60" r="30" fill="rgba(255, 250, 250, 0.8)" stroke="#c62828" stroke-width="2" />
          <circle cx="60" cy="60" r="8" fill="#fee2e2" stroke="#991b1b" stroke-width="2" />
        </g>
      </svg>

      <!-- 6. Bawah Tengah: Botol Oli Mesin & Tetesan -->
      <svg class="rm-garage-svg rm-p-oil rm-anti-c" viewBox="0 0 95 115">
        <g class="rm-oil-tilt">
          <rect x="34" y="12" width="16" height="8" rx="2" fill="#991b1b" />
          <path d="M 33 20 L 51 20 L 59 34 L 25 34 Z" fill="rgba(254, 226, 226, 0.9)" stroke="#991b1b" stroke-width="2" />
          <rect x="23" y="34" width="38" height="48" rx="6.5" fill="rgba(255, 255, 255, 0.9)" stroke="#c62828" stroke-width="2.2" />
          <rect x="25" y="52" width="34" height="28" rx="4.5" fill="rgba(220, 38, 38, 0.24)" />
          <rect x="28" y="40" width="28" height="8" rx="2" fill="#fee2e2" stroke="#fca5a5" stroke-width="1" />
        </g>
        <circle cx="65" cy="44" r="3.2" fill="#dc2626" class="rm-drop-1" />
        <circle cx="68" cy="58" r="2.6" fill="#b91c1c" class="rm-drop-2" />
      </svg>

      <!-- 7. Bawah Tengah-Kanan: Cakram Rem -->
      <svg class="rm-garage-svg rm-p-disc rm-anti-b" viewBox="0 0 105 105">
        <g class="rm-spin-ccw-disc">
          <circle cx="52" cy="52" r="34" fill="rgba(255, 255, 255, 0.85)" stroke="#991b1b" stroke-width="2.8" stroke-dasharray="13 5" />
          <circle cx="52" cy="52" r="23" fill="rgba(254, 242, 242, 0.88)" stroke="#fca5a5" stroke-width="1.8" />
          <circle cx="52" cy="52" r="9.5" fill="#fee2e2" stroke="#c62828" stroke-width="2.2" />
          <circle cx="52" cy="52" r="3.4" fill="#991b1b" />
        </g>
      </svg>

      <!-- 8. Kanan Bawah: Twin Piston Naik-Turun -->
      <svg class="rm-garage-svg rm-p-br rm-anti-a" viewBox="0 0 130 110">
        <rect x="14" y="14" width="38" height="74" rx="5.5" fill="rgba(255, 255, 255, 0.88)" stroke="#cbd5e1" stroke-width="1.8" />
        <rect x="64" y="14" width="38" height="74" rx="5.5" fill="rgba(255, 255, 255, 0.88)" stroke="#cbd5e1" stroke-width="1.8" />

        <g class="rm-piston-1">
          <rect x="18" y="25" width="30" height="14" rx="3" fill="#dc2626" />
          <line x1="33" y1="39" x2="33" y2="94" stroke="#475569" stroke-width="3.6" stroke-linecap="round" />
        </g>

        <g class="rm-piston-2">
          <rect x="68" y="25" width="30" height="14" rx="3" fill="#b91c1c" />
          <line x1="83" y1="39" x2="83" y2="94" stroke="#475569" stroke-width="3.6" stroke-linecap="round" />
        </g>

        <rect x="10" y="92" width="96" height="10" rx="5" fill="rgba(255, 245, 245, 0.92)" stroke="#991b1b" stroke-width="2" />
      </svg>
    </div>

    <!-- Konten Utama Minimalis -->
    <div class="rm-minimal-inner">
      <div class="rm-minimal-left rm-minimal-enter">
        <div class="rm-minimal-tag mb-2">REJEKI MOTOR</div>

        <h1 class="rm-minimal-title mb-2">
          Selamat Datang di <span>Beranda</span>
        </h1>

        <p class="rm-minimal-desc mb-5">
          Gunakan menu di samping untuk mengakses data master, transaksi, retur, dan laporan.
        </p>

        <div class="rm-minimal-clock">
          <div class="rm-minimal-time">{{ formattedTime }}</div>
          <div class="rm-minimal-date">{{ formattedDate }}</div>
        </div>
      </div>

      <div class="rm-minimal-right rm-minimal-enter rm-anti-gravity-logo" aria-hidden="true">
        <div class="rm-minimal-logo-ring">
          <v-img
            src="../assets/css/logo.png"
            alt="Logo Rejeki Motor"
            width="216"
            height="216"
            contain
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomeView',
  data() {
    return {
      now: new Date(),
      timerId: null,
    };
  },
  computed: {
    formattedTime() {
      const options = {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false,
      };
      return this.now.toLocaleTimeString('id-ID', options).replace(/\./g, ':');
    },
    formattedDate() {
      const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      };
      return this.now.toLocaleDateString('id-ID', options);
    },
  },
  mounted() {
    this.timerId = setInterval(() => {
      this.now = new Date();
    }, 1000);
  },
  beforeDestroy() {
    if (this.timerId) {
      clearInterval(this.timerId);
    }
  },
};
</script>

<style scoped>
.rm-home-minimal {
  position: relative;
  min-height: 82vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #ffffff;
  border: 1px solid #ece5e5;
  border-radius: 14px;
  padding: 36px 40px;
  overflow: hidden;
}

.rm-garage-anim-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 1;
}

.rm-garage-svg {
  position: absolute;
  opacity: 0.56;
}

/* Sebaran 8 Gugus Logo Part di Sekitar Latar */
.rm-p-tl {
  top: 14px;
  left: 16px;
  width: 122px;
  height: 92px;
}

.rm-p-tc {
  top: 14px;
  left: 38%;
  width: 96px;
  height: 76px;
}

.rm-p-tr {
  top: 14px;
  right: 29%;
  width: 74px;
  height: 96px;
}

.rm-p-bl {
  bottom: 16px;
  left: 16px;
  width: 118px;
  height: 96px;
}

.rm-p-tire {
  bottom: 14px;
  left: 24%;
  width: 102px;
  height: 102px;
}

.rm-p-oil {
  bottom: 14px;
  left: 41%;
  width: 82px;
  height: 100px;
}

.rm-p-disc {
  bottom: 16px;
  right: 32%;
  width: 92px;
  height: 92px;
}

.rm-p-br {
  bottom: 16px;
  right: 18px;
  width: 116px;
  height: 98px;
}

.rm-minimal-inner {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 980px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 36px;
}

.rm-minimal-left {
  max-width: 460px;
}

.rm-minimal-tag {
  display: inline-block;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.1em;
  color: #b91c1c;
  border-bottom: 2px solid #dc2626;
  padding-bottom: 3px;
}

.rm-minimal-title {
  font-size: 1.78rem;
  font-weight: 900;
  color: #111827;
  line-height: 1.25;
}

.rm-minimal-title span {
  color: #c62828;
}

.rm-minimal-desc {
  font-size: 0.9rem;
  color: #4b5563;
  line-height: 1.6;
}

.rm-minimal-clock {
  padding-left: 14px;
  border-left: 3px solid #dc2626;
}

.rm-minimal-time {
  font-family: 'Courier New', Courier, monospace;
  font-size: 1.55rem;
  font-weight: 900;
  color: #111827;
  letter-spacing: 0.05em;
  font-variant-numeric: tabular-nums;
}

.rm-minimal-date {
  font-size: 0.82rem;
  font-weight: 600;
  color: #6b7280;
  margin-top: 2px;
}

/* Logo Utama Besar + Efek Anti-Gravity */
.rm-minimal-logo-ring {
  width: 284px;
  height: 284px;
  border-radius: 999px;
  background: radial-gradient(circle at 35% 30%, #ffffff 0%, #fff5f5 78%, #fee2e2 100%);
  border: 1.5px solid #f1dcdc;
  box-shadow: 0 22px 38px -14px rgba(185, 28, 28, 0.18), inset 0 2px 10px rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
}

.rm-anti-gravity-logo {
  animation: rmAntiGravityLogo 4.8s ease-in-out infinite;
}

.rm-anti-a {
  animation: rmPartFloatA 4.2s ease-in-out infinite;
}

.rm-anti-b {
  animation: rmPartFloatB 5s ease-in-out -1.1s infinite;
}

.rm-anti-c {
  animation: rmPartFloatA 5.8s ease-in-out -2.2s infinite;
}

.rm-minimal-enter {
  animation: rmMinFade 0.35s ease both;
}

.rm-spin-cw {
  transform-origin: 44px 52px;
  animation: rmSpinCW 8.5s linear infinite;
}

.rm-spin-ccw {
  transform-origin: 98px 66px;
  animation: rmSpinCCW 4.6s linear infinite;
}

.rm-spin-cw-nut {
  transform-origin: 92px 60px;
  animation: rmSpinCW 6.5s linear infinite;
}

.rm-spin-cw-tire {
  transform-origin: 60px 60px;
  animation: rmSpinCW 9s linear infinite;
}

.rm-spin-ccw-disc {
  transform-origin: 52px 52px;
  animation: rmSpinCCW 5.8s linear infinite;
}

.rm-wrench {
  transform-origin: 34px 32px;
  animation: rmWrenchSwing 2.5s ease-in-out infinite;
}

.rm-needle {
  transform-origin: 54px 54px;
  animation: rmNeedleSweep 3.2s ease-in-out infinite;
}

.rm-plug-bob {
  animation: rmPlugFloat 2.5s ease-in-out infinite;
}

.rm-spark {
  animation: rmSparkPop 1.4s ease-in-out infinite;
}

.rm-oil-tilt {
  transform-origin: 42px 50px;
  animation: rmOilTilt 3.4s ease-in-out infinite;
}

.rm-drop-1 {
  animation: rmDropFall 1.7s ease-in infinite;
}

.rm-drop-2 {
  animation: rmDropFall 1.7s ease-in 0.85s infinite;
}

.rm-piston-1 {
  animation: rmPistonStroke 1.2s ease-in-out infinite;
}

.rm-piston-2 {
  animation: rmPistonStroke 1.2s ease-in-out -0.6s infinite;
}

@keyframes rmMinFade {
  0% {
    opacity: 0;
    transform: translateY(6px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes rmAntiGravityLogo {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-14px) rotate(1.3deg);
  }
}

@keyframes rmPartFloatA {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-8px);
  }
}

@keyframes rmPartFloatB {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-9px) rotate(2deg);
  }
}

@keyframes rmSpinCW {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes rmSpinCCW {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(-360deg); }
}

@keyframes rmWrenchSwing {
  0%, 100% { transform: rotate(-10deg); }
  50% { transform: rotate(10deg); }
}

@keyframes rmNeedleSweep {
  0%, 100% { transform: rotate(-26deg); }
  45% { transform: rotate(22deg); }
  75% { transform: rotate(-6deg); }
}

@keyframes rmPlugFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-4px); }
}

@keyframes rmSparkPop {
  0%, 75%, 100% { opacity: 0.2; transform: scale(0.85); }
  15% { opacity: 1; transform: scale(1.3); }
}

@keyframes rmOilTilt {
  0%, 100% { transform: rotate(0deg); }
  50% { transform: rotate(13deg); }
}

@keyframes rmDropFall {
  0% {
    opacity: 0;
    transform: translateY(0) scale(0.75);
  }
  30% {
    opacity: 0.9;
  }
  100% {
    opacity: 0;
    transform: translateY(22px) scale(1.1);
  }
}

@keyframes rmPistonStroke {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(15px); }
}

@media (max-width: 1024px) {
  .rm-p-tc,
  .rm-p-tr,
  .rm-p-oil,
  .rm-p-disc {
    display: none;
  }

  .rm-minimal-logo-ring {
    width: 230px;
    height: 230px;
  }
}

@media (max-width: 820px) {
  .rm-home-minimal {
    padding: 24px 20px;
  }

  .rm-minimal-inner {
    flex-direction: column-reverse;
    text-align: center;
    gap: 24px;
  }

  .rm-minimal-clock {
    padding-left: 0;
    border-left: 0;
    border-top: 2px solid #fecaca;
    padding-top: 12px;
  }

  .rm-minimal-logo-ring {
    width: 180px;
    height: 180px;
  }

  .rm-p-tl,
  .rm-p-bl,
  .rm-p-tire,
  .rm-p-br {
    display: none;
  }
}

@media (prefers-reduced-motion: reduce) {
  .rm-minimal-enter,
  .rm-anti-gravity-logo,
  .rm-anti-a,
  .rm-anti-b,
  .rm-anti-c,
  .rm-spin-cw,
  .rm-spin-ccw,
  .rm-spin-cw-nut,
  .rm-spin-cw-tire,
  .rm-spin-ccw-disc,
  .rm-wrench,
  .rm-needle,
  .rm-plug-bob,
  .rm-spark,
  .rm-oil-tilt,
  .rm-drop-1,
  .rm-drop-2,
  .rm-piston-1,
  .rm-piston-2 {
    animation: none !important;
  }
}
</style>