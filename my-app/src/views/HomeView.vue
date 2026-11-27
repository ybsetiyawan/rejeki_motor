<template>
  <div class="home">
    <!-- 1. Rangkaian Gir Sprocket (Kiri Atas) -->
    <svg
      class="rm-part-float rm-pos-top-left"
      viewBox="0 0 175 125"
      aria-hidden="true"
    >
      <g class="rm-gear-cw-slow">
        <circle cx="52" cy="60" r="32" fill="rgba(255, 245, 245, 0.72)" stroke="#c62828" stroke-width="3" />
        <circle cx="52" cy="60" r="17" fill="rgba(255, 255, 255, 0.8)" stroke="#dc2626" stroke-width="2" />
        <circle cx="52" cy="60" r="6" fill="#991b1b" />
        <g stroke="#c62828" stroke-width="4.2" stroke-linecap="round">
          <line x1="52" y1="22" x2="52" y2="28" />
          <line x1="52" y1="92" x2="52" y2="98" />
          <line x1="14" y1="60" x2="20" y2="60" />
          <line x1="84" y1="60" x2="90" y2="60" />
          <line x1="25" y1="33" x2="29" y2="37" />
          <line x1="75" y1="83" x2="79" y2="87" />
          <line x1="79" y1="33" x2="75" y2="37" />
          <line x1="29" y1="83" x2="25" y2="87" />
        </g>
      </g>

      <g class="rm-gear-ccw-fast">
        <circle cx="116" cy="76" r="21" fill="rgba(254, 226, 226, 0.76)" stroke="#991b1b" stroke-width="2.6" />
        <circle cx="116" cy="76" r="8.5" fill="rgba(255, 255, 255, 0.86)" stroke="#b91c1c" stroke-width="1.8" />
        <g stroke="#991b1b" stroke-width="3.4" stroke-linecap="round">
          <line x1="116" y1="50" x2="116" y2="55" />
          <line x1="116" y1="97" x2="116" y2="102" />
          <line x1="90" y1="76" x2="95" y2="76" />
          <line x1="137" y1="76" x2="142" y2="76" />
          <line x1="98" y1="58" x2="101" y2="61" />
          <line x1="131" y1="91" x2="134" y2="94" />
        </g>
      </g>
    </svg>

    <!-- 2. Gauge Jarum RPM (Tengah Atas) -->
    <svg
      class="rm-part-float rm-pos-top-center"
      viewBox="0 0 115 88"
      aria-hidden="true"
    >
      <path
        d="M 24 66 A 34 34 0 1 1 90 66"
        fill="none"
        stroke="#fecaca"
        stroke-width="6"
        stroke-linecap="round"
      />
      <path
        d="M 24 66 A 34 34 0 0 1 78 26"
        fill="none"
        stroke="#dc2626"
        stroke-width="6"
        stroke-linecap="round"
      />
      <line
        x1="57"
        y1="54"
        x2="76"
        y2="30"
        stroke="#991b1b"
        stroke-width="3"
        stroke-linecap="round"
        class="rm-gauge-sweep"
      />
      <circle cx="57" cy="54" r="5" fill="#1f2937" />
    </svg>

    <!-- 3. Busi / Spark Plug Berdenyut (Atas Tengah-Kanan) -->
    <svg
      class="rm-part-float rm-pos-spark-plug"
      viewBox="0 0 85 115"
      aria-hidden="true"
    >
      <g class="rm-plug-bob">
        <rect x="33" y="14" width="18" height="28" rx="4" fill="rgba(255, 255, 255, 0.88)" stroke="#991b1b" stroke-width="2" />
        <line x1="35" y1="22" x2="49" y2="22" stroke="#fca5a5" stroke-width="2" />
        <line x1="35" y1="29" x2="49" y2="29" stroke="#fca5a5" stroke-width="2" />
        <polygon points="28,42 56,42 59,52 25,52" fill="#fee2e2" stroke="#991b1b" stroke-width="2" />
        <rect x="35" y="52" width="14" height="22" fill="#cbd5e1" stroke="#475569" stroke-width="1.8" />
        <line x1="35" y1="58" x2="49" y2="58" stroke="#475569" stroke-width="1.5" />
        <line x1="35" y1="64" x2="49" y2="64" stroke="#475569" stroke-width="1.5" />
        <line x1="35" y1="70" x2="49" y2="70" stroke="#475569" stroke-width="1.5" />
        <path d="M 42 74 L 42 84 L 51 84 L 51 77" fill="none" stroke="#991b1b" stroke-width="2.2" />
        <circle cx="42" cy="86" r="4.5" fill="#ef4444" class="rm-plug-spark" />
      </g>
    </svg>

    <!-- 4. Botol Oli Mesin & Tetesan Oli (Atas Kanan-Tengah) -->
    <svg
      class="rm-part-float rm-pos-oil-bottle"
      viewBox="0 0 95 125"
      aria-hidden="true"
    >
      <g class="rm-oil-tilt">
        <!-- Tutup & Leher Botol -->
        <rect x="36" y="14" width="16" height="9" rx="2" fill="#991b1b" />
        <path d="M 35 23 L 53 23 L 62 38 L 26 38 Z" fill="rgba(254, 226, 226, 0.85)" stroke="#991b1b" stroke-width="2" />
        <!-- Badan Botol Oli -->
        <rect x="24" y="38" width="40" height="54" rx="7" fill="rgba(255, 255, 255, 0.85)" stroke="#c62828" stroke-width="2.2" />
        <!-- Level Cairan Oli -->
        <rect x="26" y="58" width="36" height="32" rx="5" fill="rgba(220, 38, 38, 0.24)" />
        <!-- Label Strip Oli -->
        <rect x="29" y="45" width="30" height="9" rx="2" fill="#fee2e2" stroke="#fca5a5" stroke-width="1" />
      </g>
      <!-- Tetesan Oli Jatuh -->
      <circle cx="68" cy="48" r="3.5" fill="#dc2626" class="rm-oil-drop-1" />
      <circle cx="71" cy="64" r="2.8" fill="#b91c1c" class="rm-oil-drop-2" />
    </svg>

    <!-- 5. Ban Motor Berulir (Tengah Kiri-Bawah / Samping) -->
    <svg
      class="rm-part-float rm-pos-tire"
      viewBox="0 0 130 130"
      aria-hidden="true"
    >
      <g class="rm-tire-spin">
        <!-- Ban Luar Tebal -->
        <circle cx="65" cy="65" r="46" fill="none" stroke="#1f2937" stroke-width="11" />
        <!-- Alur Kembang Ban -->
        <circle
          cx="65"
          cy="65"
          r="51.5"
          fill="none"
          stroke="#4b5563"
          stroke-width="2.5"
          stroke-dasharray="6 6"
        />
        <circle
          cx="65"
          cy="65"
          r="40.5"
          fill="none"
          stroke="#fca5a5"
          stroke-width="2"
          stroke-dasharray="8 5"
        />
        <!-- Bagian Dalam -->
        <circle cx="65" cy="65" r="34" fill="rgba(255, 250, 250, 0.72)" stroke="#c62828" stroke-width="2" />
        <circle cx="65" cy="65" r="9" fill="#fee2e2" stroke="#991b1b" stroke-width="2.2" />
      </g>
    </svg>

    <!-- 6. Velg Palang / Alloy Wheel Berputar (Tengah Bawah) -->
    <svg
      class="rm-part-float rm-pos-rim"
      viewBox="0 0 120 120"
      aria-hidden="true"
    >
      <g class="rm-rim-spin">
        <circle cx="60" cy="60" r="40" fill="rgba(255, 245, 245, 0.74)" stroke="#991b1b" stroke-width="4" />
        <circle cx="60" cy="60" r="34" fill="none" stroke="#dc2626" stroke-width="1.8" />
        <!-- 5 Palang Velg -->
        <g stroke="#b91c1c" stroke-width="4.5" stroke-linecap="round">
          <line x1="60" y1="60" x2="60" y2="26" />
          <line x1="60" y1="60" x2="92" y2="49" />
          <line x1="60" y1="60" x2="80" y2="88" />
          <line x1="60" y1="60" x2="40" y2="88" />
          <line x1="60" y1="60" x2="28" y2="49" />
        </g>
        <circle cx="60" cy="60" r="11" fill="#ffffff" stroke="#c62828" stroke-width="2.5" />
        <circle cx="60" cy="60" r="4" fill="#991b1b" />
      </g>
    </svg>

    <!-- 7. Kunci Pas Berayun (Pojok Kiri Bawah) -->
    <svg
      class="rm-part-float rm-pos-bottom-left"
      viewBox="0 0 85 125"
      aria-hidden="true"
    >
      <g class="rm-wrench-pivot">
        <path
          d="M 42 18 C 32 18 24 26 24 36 C 24 43 28 49 34 52 L 34 98 C 34 103 38 107 42 107 C 46 107 50 103 50 98 L 50 52 C 56 49 60 43 60 36 C 60 26 52 18 42 18 Z"
          fill="rgba(254, 226, 226, 0.85)"
          stroke="#991b1b"
          stroke-width="2.3"
        />
        <rect x="37" y="16" width="10" height="14" rx="2" fill="#ffffff" />
      </g>
    </svg>

    <!-- 8. Shockbreaker / Pegas Suspensi Memantul -->
    <svg
      class="rm-part-float rm-pos-shock"
      viewBox="0 0 80 125"
      aria-hidden="true"
    >
      <circle cx="40" cy="18" r="8" fill="#fee2e2" stroke="#991b1b" stroke-width="2.2" />
      <line x1="40" y1="26" x2="40" y2="96" stroke="#475569" stroke-width="4" stroke-linecap="round" />
      <g class="rm-spring-bounce">
        <path
          d="M 26 36 L 54 44 L 26 52 L 54 60 L 26 68 L 54 76"
          fill="none"
          stroke="#c62828"
          stroke-width="3.4"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </g>
      <rect x="28" y="84" width="24" height="18" rx="4" fill="rgba(255, 245, 245, 0.88)" stroke="#991b1b" stroke-width="2" />
      <circle cx="40" cy="108" r="6" fill="#fee2e2" stroke="#c62828" stroke-width="2" />
    </svg>

    <!-- 9. Cakram Rem & Kaliper Berputar -->
    <svg
      class="rm-part-float rm-pos-disc"
      viewBox="0 0 112 112"
      aria-hidden="true"
    >
      <g class="rm-disc-spin">
        <circle cx="56" cy="56" r="36" fill="rgba(255, 245, 245, 0.72)" stroke="#991b1b" stroke-width="3" stroke-dasharray="14 6" />
        <circle cx="56" cy="56" r="25" fill="rgba(255, 255, 255, 0.8)" stroke="#fca5a5" stroke-width="2" />
        <circle cx="56" cy="56" r="10" fill="#fee2e2" stroke="#c62828" stroke-width="2.2" />
        <circle cx="56" cy="56" r="3.5" fill="#991b1b" />
      </g>
      <path
        d="M 81 23 L 96 33 L 92 53 L 77 47 Z"
        fill="#dc2626"
        stroke="#991b1b"
        stroke-width="1.5"
      />
    </svg>

    <!-- 10. Twin Piston Naik-Turun (Kanan Bawah) -->
    <svg
      class="rm-part-float rm-pos-bottom-right"
      viewBox="0 0 150 155"
      aria-hidden="true"
    >
      <rect x="20" y="24" width="44" height="88" rx="6" fill="rgba(255, 255, 255, 0.8)" stroke="#cbd5e1" stroke-width="2" />
      <rect x="76" y="24" width="44" height="88" rx="6" fill="rgba(255, 255, 255, 0.8)" stroke="#cbd5e1" stroke-width="2" />

      <rect x="38" y="12" width="8" height="12" rx="2" fill="#991b1b" />
      <circle cx="42" cy="30" r="4" fill="#ef4444" class="rm-spark-a" />

      <rect x="94" y="12" width="8" height="12" rx="2" fill="#991b1b" />
      <circle cx="98" cy="30" r="4" fill="#ef4444" class="rm-spark-b" />

      <g class="rm-piston-a">
        <rect x="24" y="38" width="36" height="18" rx="3.5" fill="#dc2626" />
        <line x1="27" y1="44" x2="57" y2="44" stroke="#fecaca" stroke-width="1.5" />
        <line x1="42" y1="56" x2="42" y2="118" stroke="#475569" stroke-width="4" stroke-linecap="round" />
      </g>

      <g class="rm-piston-b">
        <rect x="80" y="38" width="36" height="18" rx="3.5" fill="#b91c1c" />
        <line x1="83" y1="44" x2="113" y2="44" stroke="#fecaca" stroke-width="1.5" />
        <line x1="98" y1="56" x2="98" y2="118" stroke="#475569" stroke-width="4" stroke-linecap="round" />
      </g>

      <rect x="18" y="116" width="104" height="12" rx="6" fill="rgba(255, 245, 245, 0.88)" stroke="#991b1b" stroke-width="2" />
      <circle cx="42" cy="122" r="4.5" fill="#c62828" />
      <circle cx="98" cy="122" r="4.5" fill="#c62828" />
    </svg>

    <!-- 11. Mur Hex Melayang-Berputar -->
    <svg
      class="rm-part-float rm-pos-mid-drift"
      viewBox="0 0 90 90"
      aria-hidden="true"
    >
      <g class="rm-nut-orbit">
        <polygon
          points="45,18 62,28 62,48 45,58 28,48 28,28"
          fill="rgba(254, 226, 226, 0.82)"
          stroke="#b91c1c"
          stroke-width="2.2"
        />
        <circle cx="45" cy="38" r="9" fill="rgba(255, 255, 255, 0.88)" stroke="#991b1b" stroke-width="1.8" />
      </g>
    </svg>

    <!-- 12. Bohlam / Lampu Sein Berdenyut -->
    <svg
      class="rm-part-float rm-pos-bulb"
      viewBox="0 0 80 95"
      aria-hidden="true"
    >
      <g class="rm-bulb-pulse">
        <circle cx="40" cy="38" r="20" fill="rgba(254, 226, 226, 0.82)" stroke="#c62828" stroke-width="2.2" />
        <path d="M 33 44 L 37 32 L 43 32 L 47 44" fill="none" stroke="#991b1b" stroke-width="2" />
        <rect x="32" y="58" width="16" height="12" rx="3" fill="#cbd5e1" stroke="#475569" stroke-width="1.8" />
        <line x1="34" y1="63" x2="46" y2="63" stroke="#475569" stroke-width="1.5" />
      </g>
    </svg>

    <!-- Panel Utama Beranda: Sambutan & Waktu Real-Time -->
    <section class="rm-welcome-panel rm-enter-anim" aria-label="Beranda Rejeki Motor">
      <div class="rm-badge-line mb-2">
        <span class="rm-pulse-led mr-2"></span>
        REJEKI MOTOR &bull; BENGKEL &amp; SUKU CADANG
      </div>

      <h1 class="rm-heading mb-1">
        Selamat Datang di <span class="rm-red-accent">Beranda</span>
      </h1>

      <p class="rm-subtext mb-4">
        Ini adalah halaman utama aplikasi kami. Kelola inventori, transaksi, retur, dan laporan bengkel melalui menu navigasi.
      </p>

      <div class="rm-clock-card">
        <div class="rm-clock-top">
          <v-icon x-small color="red darken-2" class="mr-1">mdi-clock-outline</v-icon>
          <span>WAKTU REAL-TIME</span>
        </div>
        <div class="rm-clock-digits">{{ formattedTime }}</div>
        <div class="rm-clock-date">{{ formattedDate }}</div>
      </div>
    </section>
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
.home {
  position: relative;
  display: flex;
  align-items: center;
  min-height: 85vh;
  background-image: url('../assets/css/logo.png');
  background-position: 100% 35%;
  background-repeat: no-repeat;
  background-color: #f0f4f8;
  padding: 28px 36px;
  overflow: hidden;
}

.rm-part-float {
  position: absolute;
  pointer-events: none;
  z-index: 1;
  opacity: 0.78;
}

/* Sebaran 12 Spare Part di Berbagai Posisi */
.rm-pos-top-left {
  top: 14px;
  left: 20px;
  width: 150px;
  height: 106px;
}

.rm-pos-top-center {
  top: 16px;
  left: 41%;
  width: 102px;
  height: 78px;
}

.rm-pos-spark-plug {
  top: 18px;
  left: 55%;
  width: 70px;
  height: 96px;
}

.rm-pos-oil-bottle {
  top: 22px;
  right: 26%;
  width: 82px;
  height: 108px;
}

.rm-pos-mid-drift {
  top: 42%;
  left: 38%;
  width: 72px;
  height: 72px;
}

.rm-pos-bulb {
  top: 44%;
  right: 27%;
  width: 68px;
  height: 80px;
}

.rm-pos-shock {
  bottom: 20px;
  left: 16%;
  width: 66px;
  height: 105px;
}

.rm-pos-bottom-left {
  bottom: 14px;
  left: 30px;
  width: 72px;
  height: 106px;
}

.rm-pos-tire {
  bottom: 16px;
  left: 28%;
  width: 108px;
  height: 108px;
}

.rm-pos-rim {
  bottom: 18px;
  left: 43%;
  width: 102px;
  height: 102px;
}

.rm-pos-disc {
  bottom: 16px;
  left: 56%;
  width: 96px;
  height: 96px;
}

.rm-pos-bottom-right {
  bottom: 14px;
  right: 22%;
  width: 136px;
  height: 140px;
}

/* Panel Utama */
.rm-welcome-panel {
  position: relative;
  z-index: 2;
  max-width: 445px;
  width: 100%;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(4px);
  border: 1px solid #f1dcdc;
  border-left: 4px solid #c62828;
  border-radius: 14px;
  padding: 22px 26px;
  box-shadow: 0 12px 26px rgba(15, 23, 42, 0.06);
}

.rm-enter-anim {
  animation: rmPanelIn 0.4s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.rm-badge-line {
  display: inline-flex;
  align-items: center;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  color: #991b1b;
  background-color: #fff5f5;
  border: 1px solid #fecaca;
  padding: 3px 10px;
  border-radius: 999px;
}

.rm-pulse-led {
  width: 6px;
  height: 6px;
  border-radius: 999px;
  background-color: #dc2626;
  display: inline-block;
  animation: rmLedPulse 1.8s infinite ease-in-out;
}

.rm-heading {
  font-size: 1.62rem;
  font-weight: 900;
  color: #111827;
  line-height: 1.2;
}

.rm-red-accent {
  color: #c62828;
}

.rm-subtext {
  font-size: 0.86rem;
  color: #4b5563;
  line-height: 1.5;
}

.rm-clock-card {
  background: linear-gradient(180deg, #fffafa 0%, #fff1f2 100%);
  border: 1px solid #fecaca;
  border-radius: 10px;
  padding: 11px 14px;
}

.rm-clock-top {
  display: flex;
  align-items: center;
  font-size: 9.5px;
  font-weight: 800;
  letter-spacing: 0.08em;
  color: #991b1b;
  margin-bottom: 3px;
}

.rm-clock-digits {
  font-family: 'Courier New', Courier, monospace;
  font-size: 1.28rem;
  font-weight: 900;
  color: #111827;
  letter-spacing: 0.05em;
  font-variant-numeric: tabular-nums;
  line-height: 1.2;
}

.rm-clock-date {
  font-size: 0.75rem;
  font-weight: 700;
  color: #374151;
  margin-top: 2px;
}

/* Animasi Spare Part */
.rm-gear-cw-slow {
  transform-origin: 52px 60px;
  animation: rmSpinCW 7.5s linear infinite;
}

.rm-gear-ccw-fast {
  transform-origin: 116px 76px;
  animation: rmSpinCCW 4.2s linear infinite;
}

.rm-piston-a {
  animation: rmPistonMove 1.1s ease-in-out infinite;
}

.rm-piston-b {
  animation: rmPistonMove 1.1s ease-in-out -0.55s infinite;
}

.rm-spark-a {
  animation: rmSparkPop 1.1s ease-in-out infinite;
}

.rm-spark-b {
  animation: rmSparkPop 1.1s ease-in-out -0.55s infinite;
}

.rm-disc-spin {
  transform-origin: 56px 56px;
  animation: rmSpinCW 5.5s linear infinite;
}

.rm-tire-spin {
  transform-origin: 65px 65px;
  animation: rmSpinCW 8s linear infinite;
}

.rm-rim-spin {
  transform-origin: 60px 60px;
  animation: rmSpinCCW 5s linear infinite;
}

.rm-wrench-pivot {
  transform-origin: 42px 36px;
  animation: rmWrenchRock 2.2s ease-in-out infinite;
}

.rm-gauge-sweep {
  transform-origin: 57px 54px;
  animation: rmNeedleSweep 3s ease-in-out infinite;
}

.rm-plug-bob {
  animation: rmPlugFloat 2.4s ease-in-out infinite;
}

.rm-plug-spark {
  animation: rmSparkPop 1.4s ease-in-out infinite;
}

.rm-oil-tilt {
  transform-origin: 44px 55px;
  animation: rmOilPour 3.2s ease-in-out infinite;
}

.rm-oil-drop-1 {
  animation: rmDropFall 1.6s ease-in infinite;
}

.rm-oil-drop-2 {
  animation: rmDropFall 1.6s ease-in 0.8s infinite;
}

.rm-spring-bounce {
  animation: rmSpringCompress 1.5s ease-in-out infinite;
}

.rm-nut-orbit {
  transform-origin: 45px 38px;
  animation: rmNutDrift 6.5s ease-in-out infinite;
}

.rm-bulb-pulse {
  transform-origin: 40px 38px;
  animation: rmBulbGlow 2s ease-in-out infinite;
}

@keyframes rmPanelIn {
  0% {
    opacity: 0;
    transform: translateX(-10px);
  }
  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes rmLedPulse {
  0%, 100% {
    opacity: 0.45;
    transform: scale(0.85);
  }
  50% {
    opacity: 1;
    transform: scale(1.25);
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

@keyframes rmPistonMove {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(20px); }
}

@keyframes rmSparkPop {
  0%, 78%, 100% { opacity: 0.15; transform: scale(0.8); }
  12% { opacity: 1; transform: scale(1.35); }
}

@keyframes rmWrenchRock {
  0%, 100% { transform: rotate(-12deg); }
  50% { transform: rotate(12deg); }
}

@keyframes rmNeedleSweep {
  0%, 100% { transform: rotate(-28deg); }
  45% { transform: rotate(22deg); }
  75% { transform: rotate(-5deg); }
}

@keyframes rmPlugFloat {
  0%, 100% { transform: translateY(0) rotate(-3deg); }
  50% { transform: translateY(-5px) rotate(3deg); }
}

@keyframes rmOilPour {
  0%, 100% { transform: rotate(0deg); }
  50% { transform: rotate(14deg); }
}

@keyframes rmDropFall {
  0% {
    opacity: 0;
    transform: translateY(0) scale(0.7);
  }
  30% {
    opacity: 0.9;
  }
  100% {
    opacity: 0;
    transform: translateY(24px) scale(1.1);
  }
}

@keyframes rmSpringCompress {
  0%, 100% { transform: scaleY(1); transform-origin: 40px 36px; }
  50% { transform: scaleY(0.84); transform-origin: 40px 36px; }
}

@keyframes rmNutDrift {
  0%, 100% { transform: translate(0, 0) rotate(0deg); }
  50% { transform: translate(6px, -6px) rotate(120deg); }
}

@keyframes rmBulbGlow {
  0%, 100% { transform: scale(0.96); opacity: 0.72; }
  50% { transform: scale(1.06); opacity: 1; }
}

@media (max-width: 1180px) {
  .rm-pos-oil-bottle,
  .rm-pos-bulb,
  .rm-pos-disc {
    display: none;
  }

  .rm-pos-bottom-right {
    right: 22%;
    width: 115px;
    height: 120px;
  }
}

@media (max-width: 959px) {
  .home {
    justify-content: center;
    padding: 20px 16px;
    background-position: 50% 97%;
    background-size: 160px auto;
  }

  .rm-pos-top-center,
  .rm-pos-spark-plug,
  .rm-pos-oil-bottle,
  .rm-pos-mid-drift,
  .rm-pos-bulb,
  .rm-pos-shock,
  .rm-pos-tire,
  .rm-pos-rim,
  .rm-pos-disc {
    display: none;
  }

  .rm-pos-top-left {
    top: 8px;
    left: 10px;
    width: 115px;
    height: 82px;
  }

  .rm-pos-bottom-left {
    bottom: 12px;
    left: 12px;
    width: 62px;
    height: 92px;
  }

  .rm-pos-bottom-right {
    bottom: 12px;
    right: 12px;
    width: 105px;
    height: 110px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .rm-enter-anim,
  .rm-pulse-led,
  .rm-gear-cw-slow,
  .rm-gear-ccw-fast,
  .rm-piston-a,
  .rm-piston-b,
  .rm-spark-a,
  .rm-spark-b,
  .rm-disc-spin,
  .rm-tire-spin,
  .rm-rim-spin,
  .rm-wrench-pivot,
  .rm-gauge-sweep,
  .rm-plug-bob,
  .rm-plug-spark,
  .rm-oil-tilt,
  .rm-oil-drop-1,
  .rm-oil-drop-2,
  .rm-spring-bounce,
  .rm-nut-orbit,
  .rm-bulb-pulse {
    animation: none !important;
    transition: none !important;
  }
}
</style>