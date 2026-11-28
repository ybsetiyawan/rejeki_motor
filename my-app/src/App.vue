<template>
  <v-app class="rm-clean-app">
    <!-- Top Bar: Hanya tampil setelah login -->
    <transition name="rm-fade">
      <v-app-bar
        v-if="user"
        app
        flat
        height="56"
        class="rm-clean-topbar"
      >
        <v-btn
          icon
          color="red darken-3"
          class="mr-2 rm-btn-anim"
          @click.stop="toggleDrawer"
          title="Menu"
        >
          <v-icon>mdi-menu</v-icon>
        </v-btn>

        <div class="d-flex align-center rm-brand-anim">
          <v-img
            alt="Rejeki Motor Logo"
            class="shrink mr-2"
            contain
            src="../src/assets/css/logo.png"
            transition="scale-transition"
            width="34"
            height="34"
          />
          <span class="text-subtitle-1 font-weight-black grey--text text--darken-4">
            REJEKI MOTOR
          </span>
        </div>

        <v-spacer></v-spacer>

        <span class="text-body-2 font-weight-bold red--text text--darken-3 mr-3 rm-greeting-anim">
          Hallo, {{ pegawaiName }}
        </span>

        <v-btn
          icon
          color="red darken-3"
          class="rm-btn-anim mr-1"
          @click="toggleFullscreen"
          :title="isFullscreen ? 'Keluar Fullscreen' : 'Fullscreen'"
        >
          <v-icon>{{ isFullscreen ? 'mdi-fullscreen-exit' : 'mdi-fullscreen' }}</v-icon>
        </v-btn>

        <v-btn
          icon
          color="red darken-3"
          class="rm-btn-anim"
          @click="logout"
          title="Logout"
        >
          <v-icon>mdi-logout</v-icon>
        </v-btn>
      </v-app-bar>
    </transition>

    <!-- Sidebar: Hanya tampil setelah login -->
    <transition name="rm-fade">
      <v-navigation-drawer
        v-if="user"
        v-model="drawer"
        app
        width="244"
        class="rm-clean-drawer"
      >
        <v-list dense class="py-3 px-2 rm-list">
          <template v-for="menu in filteredItems">
            <!-- Menu tanpa sub-item -->
            <v-list-item
              v-if="!menu.subItems || !menu.subItems.length"
              :key="'single-' + menu.title"
              :to="menu.link"
              exact
              active-class="rm-item-active"
              class="rm-nav-row mb-1"
            >
              <v-list-item-icon class="mr-3">
                <v-icon size="20" class="rm-nav-icon">{{ menu.icon }}</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="rm-nav-text font-weight-bold">
                  {{ menu.title }}
                </v-list-item-title>
              </v-list-item-content>
            </v-list-item>

            <!-- Menu dengan sub-item -->
            <v-list-group
              v-else
              :key="'group-' + menu.title"
              :value="true"
              active-class="rm-group-active"
              class="mb-1 rm-group-block"
            >
              <template v-slot:activator>
                <v-list-item-icon class="mr-3">
                  <v-icon size="20" class="rm-nav-icon">{{ menu.icon }}</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title class="rm-nav-text font-weight-bold">
                    {{ menu.title }}
                  </v-list-item-title>
                </v-list-item-content>
              </template>

              <div class="rm-sub-group-wrap">
                <v-list-item
                  v-for="subItem in menu.subItems"
                  :key="'sub-' + menu.title + '-' + subItem.title"
                  :to="subItem.link"
                  exact
                  active-class="rm-item-active"
                  class="rm-sub-row"
                >
                  <v-list-item-icon class="mr-2.5">
                    <v-icon size="17" class="rm-sub-icon">{{ subItem.icon }}</v-icon>
                  </v-list-item-icon>
                  <v-list-item-content>
                    <v-list-item-title class="rm-sub-text">
                      {{ subItem.title }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </div>
            </v-list-group>
          </template>
        </v-list>
      </v-navigation-drawer>
    </transition>

    <!-- Konten Utama -->
    <v-main class="rm-clean-main">
      <v-container fluid :class="user ? 'pa-3 pa-sm-4' : 'pa-0 fill-height'">
        <transition name="rm-page" mode="out-in">
          <router-view :key="$route.fullPath" />
        </transition>
      </v-container>
    </v-main>

    <!-- Footer: Hanya tampil setelah login -->
    <transition name="rm-fade">
      <v-footer
        v-if="user"
        app
        height="36"
        class="rm-clean-footer px-4"
      >
        <div class="d-flex align-center justify-space-between rm-footer-inner text-caption grey--text text--darken-2">
          <!-- Track Animasi Motor Laki-Laki Merah + Sorot Lampu Kuning + Asap Knalpot -->
          <div class="rm-moto-track d-none d-sm-block mr-3" aria-hidden="true">
            <div class="rm-road-line"></div>

            <!-- Motor Laki-Laki Merah -->
            <div class="rm-moto-mover rm-moto-sport">
              <svg class="rm-moto-svg" viewBox="0 0 96 34" width="80" height="28">
                <defs>
                  <linearGradient id="rmYellowBeamGrad" x1="0%" y1="50%" x2="100%" y2="50%">
                    <stop offset="0%" stop-color="#facc15" stop-opacity="0.82" />
                    <stop offset="50%" stop-color="#eab308" stop-opacity="0.46" />
                    <stop offset="100%" stop-color="#fef08a" stop-opacity="0.04" />
                  </linearGradient>
                  <radialGradient id="rmYellowBulbGlow" cx="50%" cy="50%" r="50%">
                    <stop offset="0%" stop-color="#fef08a" stop-opacity="0.95" />
                    <stop offset="55%" stop-color="#facc15" stop-opacity="0.55" />
                    <stop offset="100%" stop-color="#eab308" stop-opacity="0" />
                  </radialGradient>
                </defs>

                <g class="rm-exhaust-smoke">
                  <circle cx="20" cy="22" r="2.8" fill="#334155" class="rm-smoke-puff rm-smoke-1" />
                  <circle cx="15" cy="20" r="3.4" fill="#475569" class="rm-smoke-puff rm-smoke-2" />
                  <circle cx="10" cy="18" r="3.8" fill="#64748b" class="rm-smoke-puff rm-smoke-3" />
                </g>

                <g class="rm-moto-chassis">
                  <g class="rm-wheel-spin">
                    <circle cx="34" cy="25" r="6" fill="none" stroke="#1f2937" stroke-width="2.6" />
                    <circle cx="34" cy="25" r="2" fill="#dc2626" />
                    <line x1="34" y1="20.5" x2="34" y2="29.5" stroke="#64748b" stroke-width="1" />
                    <line x1="29.5" y1="25" x2="38.5" y2="25" stroke="#64748b" stroke-width="1" />
                  </g>
                  <g class="rm-wheel-spin">
                    <circle cx="68" cy="25" r="6" fill="none" stroke="#1f2937" stroke-width="2.6" />
                    <circle cx="68" cy="25" r="2" fill="#dc2626" />
                    <line x1="68" y1="20.5" x2="68" y2="29.5" stroke="#64748b" stroke-width="1" />
                    <line x1="63.5" y1="25" x2="72.5" y2="25" stroke="#64748b" stroke-width="1" />
                  </g>

                  <path d="M 24 23 L 43 23 L 45 21 L 25 21 Z" fill="#334155" />
                  <rect x="44" y="17" width="11" height="6" rx="1.5" fill="#475569" />
                  <path d="M 34 25 L 44 16 L 59 16 L 68 25" fill="none" stroke="#334155" stroke-width="2" stroke-linejoin="round" />
                  <path d="M 33 15 Q 40 13 46 15 L 45 18 L 32 18 Z" fill="#1f2937" />
                  <path d="M 46 14 Q 53 10 60 13 L 58 17 L 46 17 Z" fill="#dc2626" />
                  <path d="M 30 15 L 36 15 L 33 19 L 29 17 Z" fill="#b91c1c" />
                  <path d="M 59 16 L 58 10 L 62 9" fill="none" stroke="#1f2937" stroke-width="2" stroke-linecap="round" />

                  <!-- Sorot Lampu Kuning Lebar & Jelas -->
                  <polygon points="65,11 93,2.5 93,24.5 65,15.5" fill="url(#rmYellowBeamGrad)" />
                  <circle cx="64.5" cy="13" r="6.5" fill="url(#rmYellowBulbGlow)" class="rm-lamp-glow" />
                  <circle cx="64" cy="13" r="2.4" fill="#facc15" stroke="#ca8a04" stroke-width="0.9" />

                  <circle cx="49" cy="6.5" r="3" fill="#dc2626" />
                  <path d="M 45 10 Q 49 9 53 12 L 58 11" fill="none" stroke="#334155" stroke-width="2.2" stroke-linecap="round" />
                  <path d="M 46 10 L 42 15 L 46 21" fill="none" stroke="#1f2937" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" />
                </g>
              </svg>
            </div>
          </div>

          <div class="d-flex align-center text-truncate rm-footer-right-group">
            <span class="rm-footer-pulse mr-2"></span>
            <v-icon x-small color="red darken-2" class="mr-1">mdi-monitor-multiple</v-icon>
            <span class="font-weight-bold red--text text--darken-3 mr-1">App Version : {{ appVersion }}</span>
            <span class="mx-2 grey--text text--lighten-1">|</span>
            <span class="font-weight-bold red--text text--darken-3 mr-1">Last Updated : {{ lastUpdated }}</span>
            <span class="mx-2 grey--text text--lighten-1">|</span>
            <span class="d-none d-sm-inline mr-2">&copy; 2025 REJEKI MOTOR</span>
            <span class="d-none d-md-inline mx-2 grey--text text--lighten-1">|</span>
            <span class="d-flex align-center rm-crafted-anim">
              <span class="grey--text mr-1">Crafted by</span>
              <v-icon x-small color="red darken-2" class="mr-1 rm-key-icon">mdi-laptop</v-icon>
              <span class="font-weight-bold red--text text--darken-3">ybsetiyawan</span>
            </span>
          </div>
        </div>
      </v-footer>
    </transition>
  </v-app>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import packageInfo from '../package.json';
import api from './services/api';

const FULLSCREEN_EVENTS = [
  'fullscreenchange',
  'webkitfullscreenchange',
  'mozfullscreenchange',
  'MSFullscreenChange',
];

export default {
  name: 'App',

  data: () => ({
    drawer: true,
    isFullscreen: false,
    items: [
      {
        title: 'Beranda',
        icon: 'mdi-home-outline',
        link: '/',
      },
      {
        title: 'Master',
        icon: 'mdi-folder-cog-outline',
        subItems: [
          { title: 'User', icon: 'mdi-account-outline', link: '/users' },
          { title: 'Customer', icon: 'mdi-account-group-outline', link: '/customer' },
          { title: 'Supplier', icon: 'mdi-storefront-outline', link: '/supplier' },
          { title: 'Satuan', icon: 'mdi-cube-outline', link: '/satuan' },
          { title: 'Jenis Item', icon: 'mdi-tag-outline', link: '/jenis_item' },
          { title: 'Item', icon: 'mdi-hammer-wrench', link: '/items' },
        ],
      },
      {
        title: 'Transaksi',
        icon: 'mdi-cash-register',
        subItems: [
          { title: 'Barang Masuk', icon: 'mdi-arrow-down-bold-box-outline', link: '/pembelian' },
          { title: 'Barang Keluar', icon: 'mdi-arrow-up-bold-box-outline', link: '/penjualan' },
        ],
      },
      {
        title: 'Retur',
        icon: 'mdi-cached',
        subItems: [
          { title: 'Retur Supplier', icon: 'mdi-keyboard-return', link: '/retursupplier' },
          { title: 'Retur Customer', icon: 'mdi-backup-restore', link: '/returcustomer' },
        ],
      },
      {
        title: 'Laporan',
        icon: 'mdi-clipboard-text-outline',
        subItems: [
          { title: 'Barang Masuk', icon: 'mdi-file-plus-outline', link: '/report_pembelian' },
          { title: 'Barang Keluar', icon: 'mdi-file-minus-outline', link: '/report_penjualan' },
          { title: 'Retur Supplier', icon: 'mdi-file-export-outline', link: '/report_retursupplier' },
          { title: 'Retur Customer', icon: 'mdi-file-import-outline', link: '/report_returcustomer' },
          { title: 'Stok Barang', icon: 'mdi-package-variant', link: '/report_stokbarang' },
          { title: 'Stok Movement', icon: 'mdi-sync', link: '/report_stokmovement' },
        ],
      },
    ],
    appVersion: packageInfo.version,
    lastUpdated: packageInfo.lastUpdated,
  }),

  computed: {
    ...mapGetters(['user']),
    pegawaiName() {
      return (
        (this.user && this.user.data && (this.user.data.pegawai || this.user.data.username)) ||
        'User'
      );
    },
    filteredItems() {
      if (this.user && this.user.data && this.user.data.id_role === 2) {
        return this.items.filter(item => item.title === 'Laporan');
      }
      return this.items;
    },
  },

  watch: {
    user(newUser) {
      if (!newUser) {
        this.drawer = false;
      } else {
        this.drawer = true;
        this.onUserLoggedIn();
      }
    },
  },

  methods: {
    ...mapActions(['resetLogoutTimer']),
    onUserLoggedIn() {},
    logout() {
      this.$store.dispatch('logout');
    },
    resetTimer() {
      this.resetLogoutTimer();
    },
    toggleDrawer() {
      if (this.user) {
        this.drawer = !this.drawer;
      }
    },
    getFullscreenElement() {
      return (
        document.fullscreenElement ||
        document.webkitFullscreenElement ||
        document.mozFullScreenElement ||
        document.msFullscreenElement ||
        null
      );
    },
    syncFullscreenState() {
      this.isFullscreen = Boolean(this.getFullscreenElement());
    },
    async toggleFullscreen() {
      const fullscreenElement = this.getFullscreenElement();

      try {
        if (!fullscreenElement) {
          const el = document.documentElement;
          const requestMethod =
            el.requestFullscreen ||
            el.webkitRequestFullscreen ||
            el.mozRequestFullScreen ||
            el.msRequestFullscreen;
          if (requestMethod) {
            await requestMethod.call(el);
          }
        } else {
          const exitMethod =
            document.exitFullscreen ||
            document.webkitExitFullscreen ||
            document.mozCancelFullScreen ||
            document.msExitFullscreen;
          if (exitMethod) {
            await exitMethod.call(document);
          }
        }
      } catch (err) {
        console.error('Gagal mengubah mode fullscreen:', err);
      } finally {
        this.syncFullscreenState();
      }
    },
  },

  mounted() {
    if (this.user) {
      this.drawer = true;
      // Verifikasi sesi cookie HttpOnly ke backend saat aplikasi dimuat.
      api.get('/me').catch(() => {});
    }
    this.syncFullscreenState();
    FULLSCREEN_EVENTS.forEach(eventName => {
      document.addEventListener(eventName, this.syncFullscreenState);
    });
    window.addEventListener('mousemove', this.resetTimer);
    window.addEventListener('keydown', this.resetTimer);
    window.addEventListener('click', this.resetTimer);
  },

  beforeDestroy() {
    FULLSCREEN_EVENTS.forEach(eventName => {
      document.removeEventListener(eventName, this.syncFullscreenState);
    });
    window.removeEventListener('mousemove', this.resetTimer);
    window.removeEventListener('keydown', this.resetTimer);
    window.removeEventListener('click', this.resetTimer);
  },
};
</script>

<style scoped>
.rm-clean-app {
  background-color: #f8fafc !important;
}

.rm-clean-topbar {
  background-color: #ffffff !important;
  border-bottom: 2px solid #dc2626 !important;
}

.rm-btn-anim {
  transition: transform 0.18s ease, background-color 0.18s ease !important;
}

.rm-btn-anim:hover {
  transform: scale(1.08);
  background-color: #fef2f2 !important;
}

.rm-btn-anim:active {
  transform: scale(0.95);
}

.rm-brand-anim {
  transition: transform 0.2s ease;
}

.rm-brand-anim:hover {
  transform: translateX(2px);
}

.rm-greeting-anim {
  transition: opacity 0.25s ease, transform 0.25s ease;
}

.rm-clean-drawer {
  background-color: #ffffff !important;
  border-right: 1px solid #e5e7eb !important;
}

.rm-list .v-list-item {
  min-height: 36px !important;
  padding-left: 12px !important;
  padding-right: 12px !important;
  border-radius: 9px !important;
  transition: background-color 0.18s ease, transform 0.18s ease !important;
}

.rm-list .v-list-item__icon {
  margin-top: 7px !important;
  margin-bottom: 7px !important;
  min-width: 26px !important;
}

.rm-sub-group-wrap {
  margin: 2px 0 4px 18px;
  padding-left: 8px;
  border-left: 1.5px solid #fee2e2;
}

.rm-sub-row {
  padding-left: 10px !important;
  min-height: 33px !important;
  border-radius: 8px !important;
}

.rm-nav-text {
  font-size: 13px !important;
  color: #1f2937;
  transition: color 0.18s ease;
}

.rm-sub-text {
  font-size: 12.5px !important;
  color: #374151;
  transition: color 0.18s ease;
}

.rm-nav-icon {
  color: #b91c1c !important;
  transition: transform 0.2s ease, color 0.18s ease !important;
}

.rm-sub-icon {
  color: #6b7280 !important;
  transition: transform 0.2s ease, color 0.18s ease !important;
}

.rm-nav-row:hover,
.rm-sub-row:hover {
  background-color: #fff5f5 !important;
  transform: translateX(2px);
}

.rm-nav-row:hover .rm-nav-icon,
.rm-sub-row:hover .rm-sub-icon {
  transform: scale(1.08);
  color: #991b1b !important;
}

.rm-item-active {
  background-color: #fee2e2 !important;
  box-shadow: inset 3px 0 0 #dc2626;
}

.rm-item-active .rm-nav-text,
.rm-item-active .rm-sub-text,
.rm-item-active .v-icon {
  color: #991b1b !important;
  font-weight: 700 !important;
}

.rm-group-active {
  color: #991b1b !important;
}

.rm-clean-main {
  background-color: #f8fafc !important;
}

.rm-clean-footer {
  background-color: #ffffff !important;
  border-top: 1px solid #e5e7eb !important;
}

.rm-footer-pulse {
  width: 7px;
  height: 7px;
  border-radius: 999px;
  background-color: #dc2626;
  display: inline-block;
  animation: rmPulseDot 2.2s infinite ease-in-out;
}

.rm-lamp-glow {
  transform-box: fill-box;
  transform-origin: center;
  animation: rmLampPulse 1.3s ease-in-out infinite alternate;
}

.rm-crafted-anim:hover .rm-key-icon {
  transform: translateY(-1px) rotate(-8deg);
  transition: transform 0.2s ease;
}

@keyframes rmLampPulse {
  0% {
    opacity: 0.78;
    transform: scale(0.94);
  }
  100% {
    opacity: 1;
    transform: scale(1.16);
  }
}

@keyframes rmPulseDot {
  0%, 100% {
    opacity: 0.45;
    transform: scale(0.85);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

/* Transisi halaman */
.rm-page-enter-active,
.rm-page-leave-active {
  transition: opacity 0.18s ease, transform 0.18s ease;
}

.rm-page-enter,
.rm-page-leave-to {
  opacity: 0;
  transform: translateY(6px);
}

/* Transisi bar & drawer */
.rm-fade-enter-active,
.rm-fade-leave-active {
  transition: opacity 0.22s ease;
}

.rm-fade-enter,
.rm-fade-leave-to {
  opacity: 0;
}

@media (prefers-reduced-motion: reduce) {
  .rm-btn-anim,
  .rm-brand-anim,
  .rm-greeting-anim,
  .rm-list .v-list-item,
  .rm-nav-icon,
  .rm-sub-icon,
  .rm-page-enter-active,
  .rm-page-leave-active,
  .rm-fade-enter-active,
  .rm-fade-leave-to,
  .rm-moto-mover,
  .rm-moto-chassis,
  .rm-wheel-spin,
  .rm-smoke-puff,
  .rm-lamp-glow {
    transition: none !important;
    animation: none !important;
  }
}

.rm-footer-right-group {
  flex-shrink: 0;
  transition: transform 0.2s ease;
}

.rm-footer-right-group:hover {
  transform: translateX(-2px);
}
.rm-footer-inner {
  width: 100%;
}

.rm-moto-track {
  position: relative;
  flex: 1;
  min-width: 0;
  height: 28px;
  overflow: hidden;
}

.rm-road-line {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 2px;
  height: 1px;
  background: repeating-linear-gradient(
    90deg,
    #fecaca 0px,
    #fecaca 8px,
    transparent 8px,
    transparent 16px
  );
}

.rm-moto-mover {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  animation: rmMotoDrive 12s linear infinite;
}

.rm-moto-sport {
  animation-delay: 0s;
}

.rm-moto-svg {
  position: absolute;
  left: -80px;
  bottom: 0;
  overflow: visible;
}

.rm-moto-chassis {
  animation: rmMotoBounce 0.45s ease-in-out infinite alternate;
}

.rm-wheel-spin {
  transform-box: fill-box;
  transform-origin: center;
  animation: rmWheelSpin 0.48s linear infinite;
}

.rm-smoke-puff {
  transform-box: fill-box;
  transform-origin: center;
  animation: rmExhaustSmoke 1.05s ease-out infinite;
}

.rm-smoke-2 {
  animation-delay: 0.35s;
}

.rm-smoke-3 {
  animation-delay: 0.7s;
}

@keyframes rmMotoDrive {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(calc(100% + 90px));
  }
}

@keyframes rmMotoBounce {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(-1.2px);
  }
}

@keyframes rmWheelSpin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@keyframes rmExhaustSmoke {
  0% {
    opacity: 0.95;
    transform: translate(0, 0) scale(0.6);
  }
  60% {
    opacity: 0.65;
    transform: translate(-12px, -4.5px) scale(1.3);
  }
  100% {
    opacity: 0;
    transform: translate(-22px, -9px) scale(1.75);
  }
}
</style>