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
        <v-list dense class="py-2 px-2 rm-list">
          <template v-for="menu in filteredItems">
            <!-- Menu tanpa sub-item -->
            <v-list-item
              v-if="!menu.subItems || !menu.subItems.length"
              :key="'single-' + menu.title"
              :to="menu.link"
              exact
              active-class="rm-item-active"
              class="rm-nav-row mb-0.5"
            >
              <v-list-item-icon class="mr-3">
                <v-icon small class="rm-nav-icon">{{ menu.icon }}</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="rm-nav-text font-weight-bold">
                  {{ menu.title }}
                </v-list-item-title>
              </v-list-item-content>
              <span class="rm-active-dot"></span>
            </v-list-item>

            <!-- Menu dengan sub-item -->
            <v-list-group
              v-else
              :key="'group-' + menu.title"
              :value="true"
              active-class="rm-group-active"
              class="mb-0.5"
            >
              <template v-slot:activator>
                <v-list-item-icon class="mr-3">
                  <v-icon small class="rm-nav-icon">{{ menu.icon }}</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title class="rm-nav-text font-weight-bold">
                    {{ menu.title }}
                  </v-list-item-title>
                </v-list-item-content>
              </template>

              <v-list-item
                v-for="subItem in menu.subItems"
                :key="'sub-' + menu.title + '-' + subItem.title"
                :to="subItem.link"
                exact
                active-class="rm-item-active"
                class="rm-sub-row"
              >
                <v-list-item-icon class="mr-2">
                  <v-icon small class="rm-nav-icon">{{ subItem.icon }}</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title class="rm-sub-text">
                    {{ subItem.title }}
                  </v-list-item-title>
                </v-list-item-content>
                <span class="rm-active-dot"></span>
              </v-list-item>
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
   <!-- Footer: Hanya tampil setelah login -->
    <transition name="rm-fade">
      <v-footer
        v-if="user"
        app
        height="34"
        class="rm-clean-footer px-4"
      >
        <div class="d-flex align-center justify-end rm-footer-inner text-caption grey--text text--darken-2">
          <div class="d-flex align-center text-truncate rm-footer-right-group">
            <span class="rm-footer-pulse mr-2"></span>
            <v-icon x-small color="red darken-2" class="mr-1">mdi-monitor-multiple</v-icon>
            <span class="font-weight-bold red--text text--darken-3 mr-1">App Version : {{ appVersion }}</span>
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

export default {
  name: 'App',

  data: () => ({
    drawer: true,
    items: [
      { title: 'Beranda', icon: 'mdi-home', link: '/' },
      {
        title: 'Master',
        icon: 'mdi-key-chain',
        subItems: [
          { title: 'User', icon: 'mdi-account', link: '/users' },
          { title: 'Customer', icon: 'mdi-account-group', link: '/customer' },
          { title: 'Supplier', icon: 'mdi-home-group', link: '/supplier' },
          { title: 'Satuan', icon: 'mdi-box-shadow', link: '/satuan' },
          { title: 'Jenis Item', icon: 'mdi-shape', link: '/jenis_item' },
          { title: 'Item', icon: 'mdi-tools', link: '/items' },
        ],
      },
      {
        title: 'Transaksi',
        icon: 'mdi-invoice-text-multiple',
        subItems: [
          { title: 'Barang Masuk', icon: 'mdi-home-import-outline', link: '/pembelian' },
          { title: 'Barang Keluar', icon: 'mdi-home-export-outline', link: '/penjualan' },
        ],
      },
      {
        title: 'Retur',
        icon: 'mdi-arrow-oscillating',
        subItems: [
          { title: 'Retur Supplier', icon: 'mdi-format-align-top', link: '/retursupplier' },
          { title: 'Retur Customer', icon: 'mdi-format-align-bottom', link: '/returcustomer' },
        ],
      },
      {
        title: 'Laporan',
        icon: 'mdi-chart-line',
        subItems: [
          { title: 'Barang Masuk', icon: 'mdi-pencil-plus', link: '/report_pembelian' },
          { title: 'Barang Keluar', icon: 'mdi-pencil-minus', link: '/report_penjualan' },
          { title: 'Retur Supplier', icon: 'mdi-storefront-minus', link: '/report_retursupplier' },
          { title: 'Retur Customer', icon: 'mdi-account-multiple-plus', link: '/report_returcustomer' },
          { title: 'Stok Barang', icon: 'mdi-package-variant-closed-check', link: '/report_stokbarang' },
          { title: 'Stok Movement', icon: 'mdi-swap-horizontal', link: '/report_stokmovement' },
        ],
      },
    ],
    appVersion: packageInfo.version,
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
  },

  mounted() {
    if (this.user) {
      this.drawer = true;
    }
    window.addEventListener('mousemove', this.resetTimer);
    window.addEventListener('keydown', this.resetTimer);
    window.addEventListener('click', this.resetTimer);
  },

  beforeDestroy() {
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
  min-height: 38px !important;
  padding-left: 12px !important;
  padding-right: 12px !important;
  border-radius: 7px !important;
  transition: background-color 0.18s ease, transform 0.18s ease, padding-left 0.18s ease !important;
}

.rm-list .v-list-item__icon {
  margin-top: 8px !important;
  margin-bottom: 8px !important;
  min-width: 26px !important;
}

.rm-sub-row {
  padding-left: 28px !important;
  min-height: 35px !important;
}

.rm-nav-text {
  font-size: 13.5px !important;
  color: #1f2937;
  transition: color 0.18s ease;
}

.rm-sub-text {
  font-size: 13px !important;
  color: #374151;
  transition: color 0.18s ease;
}

.rm-nav-icon {
  transition: transform 0.2s ease, color 0.18s ease !important;
}

.rm-nav-row:hover,
.rm-sub-row:hover {
  background-color: #fff5f5 !important;
  transform: translateX(3px);
}

.rm-nav-row:hover .rm-nav-icon,
.rm-sub-row:hover .rm-nav-icon {
  transform: scale(1.12);
  color: #b91c1c !important;
}

.rm-active-dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background-color: transparent;
  transform: scale(0);
  transition: transform 0.22s cubic-bezier(0.34, 1.56, 0.64, 1), background-color 0.2s ease;
}

.rm-item-active {
  background-color: #fef2f2 !important;
}

.rm-item-active .rm-nav-text,
.rm-item-active .rm-sub-text,
.rm-item-active .v-icon {
  color: #b91c1c !important;
  font-weight: 700 !important;
}

.rm-item-active .rm-active-dot {
  background-color: #dc2626;
  transform: scale(1);
}

.rm-group-active {
  color: #b91c1c !important;
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

.rm-crafted-anim:hover .rm-key-icon {
  transform: translateY(-1px) rotate(-8deg);
  transition: transform 0.2s ease;
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
  .rm-active-dot,
  .rm-page-enter-active,
  .rm-page-leave-active,
  .rm-fade-enter-active,
  .rm-fade-leave-active {
    transition: none !important;
    animation: none !important;
  }
}

.rm-footer-right-group {
  transition: transform 0.2s ease;
}

.rm-footer-right-group:hover {
  transform: translateX(-2px);
}
.rm-footer-inner {
  width: 100%;
  margin-left: auto;
}
</style>