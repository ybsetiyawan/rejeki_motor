<template>
  <v-app>
    <v-navigation-drawer
      app
      v-model="drawer"
      :permanent="false"
      color="#e08686"
      class="custom-drawer"
      :disabled="!user"
    >
      <!-- Konten dari navigation drawer -->
      <v-list dense>
        <v-list-item v-for="item in items" :key="item.title" :to="item.link">
          <v-list-item-icon>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
          <v-list-group v-if="item.subItems" no-action sub-group>
            <template v-slot:activator>
            </template>
            <v-list-item v-for="subItem in item.subItems" :key="subItem.title" :to="subItem.link" class="sub-item-indent">
              <v-list-item-icon>
                <v-icon>{{ subItem.icon }}</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title>{{ subItem.title }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list-group>
        </v-list-item>
      </v-list> <!-- Tambahkan ini jika belum ada -->
    </v-navigation-drawer>

    <v-app-bar
      app
      color="#cc494b"
      dark
    >
      <!-- Tambahkan tombol untuk mengontrol navigation drawer -->
      <v-btn icon @click.stop="toggleDrawer" class="custom-btn" :disabled="!user">
        <v-icon>mdi-menu</v-icon>
      </v-btn>
      <div class="d-flex align-center">
        <v-img
          alt="Vuetify Logo"
          class="shrink mr-2"
          contain
          src="../src/assets/css/logo.png"
          transition="scale-transition"
          width="50"
        />
        <span class="span-smal">WELCOME TO REJEKI MOTOR</span>
      </div>

      <v-spacer></v-spacer>

      <v-btn
        target="_blank"
        text
      > 
      <span v-if="user">Hallo {{ user.data.pegawai }}</span>
      </v-btn>
      <!-- Tambahkan tombol logout -->
      <v-btn icon @click="logout" class="custom-btn" :disabled="!user">
        <v-icon
          title="Logout"
        >mdi-logout</v-icon>
      </v-btn>
    </v-app-bar>
    <v-content>
      <v-container fluid>
        <!-- Konten utama aplikasi di sini -->
        <router-view/>
      </v-container>
    </v-content>
    <!-- Footer -->
    <v-footer color="#ea3a3a" app class="footer-small">
      <div class="scrolling-text">
        <span class="white--text">&copy; 2024 Rejeki Motor. Hak Cipta Dilindungi. This program was created with seriousness by YBS and Cursor AI</span>
      </div>
    </v-footer>
  </v-app>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'App',
  
  data: () => ({
    drawer: false, // Menambahkan state untuk mengontrol visibilitas navigation drawer
    items: [
      { title:"Beranda", icon:"mdi-home", link:"/"},
      { 
        title: "Master", 
        icon: "mdi-key-chain", 
        subItems: [
          { title: "User", icon: "mdi-account", link: "/users" },
          { title: "Customer", icon: "mdi-account-group", link: "/customer" },
          { title: "Supplier", icon: "mdi-home-group", link: "/supplier" },
          { title: "Satuan", icon: "mdi-box-shadow", link: "/satuan" },
          { title: "Jenis Item", icon: "mdi-shape", link: "/jenis_item" },
          { title: "Item", icon: "mdi-tools", link: "/items" },
        ]
      },
      { 
        title:"Transaksi", 
        icon:"mdi-invoice-text-multiple", 
        subItems: [
          { title: "Barang Masuk", icon: "mdi-home-import-outline", link: "/pembelian" },
          // { title: "Barang Keluar", icon: "mdi-home-export-outline", link: "/penjualan" },
          { title: "Barang Keluar", icon: "mdi-home-export-outline", link: "/penjualan" },
        ]
      },
      {
        title:"Retur",
        icon:"mdi mdi-arrow-oscillating",
        subItems: [
          { title: "Retur Supllier", icon: "mdi mdi-format-align-top", link: "/retursupplier"},
          { title: "Retur Customer", icon: "mdi mdi-format-align-bottom", link: "/returcustomer"},
        ]
      },
      { 
        title:"Laporan", 
        icon:"mdi-chart-line", 
        subItems: [
          { title: "Barang Masuk", icon: "mdi-pencil-plus", link: "/report_pembelian" },
          { title: "Barang Keluar", icon: "mdi-pencil-minus", link: "/report_penjualan" },
          { title: "Retur Supplier", icon: "mdi-storefront-minus", link: "/report_retursupplier" },
          { title: "Retur Customer", icon: "mdi-account-multiple-plus", link: "/report_returcustomer" },
          { title: "Stok Barang", icon: "mdi-package-variant-closed-check", link: "/report_stokBarang" },
        ]
      },
    
    ],
  
  }),
  computed: {
    ...mapGetters(['user']), // Ambil data user dari Vuex
    drawerEnabled() {
      return !!this.user;
    }
  },
  watch: {
    user(newUser) {
      if (!newUser) {
        this.drawer = false; // Matikan drawer jika user logout
      }
      if (newUser) {
        this.onUserLoggedIn();
      }
    }
  },
  methods: {
    ...mapActions(['logout', 'resetLogoutTimer']),
    onUserLoggedIn() {
      // console.log('User:', this.user.data.pegawai, '\n', this.user.data.id_role);
      // Tambahkan logika lain yang ingin dijalankan setelah login di sini
    },
    logout() {
      this.$store.dispatch('logout'); // Contoh: memanggil action logout di Vuex
    },
    resetTimer() {
      this.resetLogoutTimer(); // Reset timer logout saat ada aktivitas
    },
    toggleDrawer() {
      if (this.user) {
        this.drawer = !this.drawer;
      }
    }
  },
  mounted() {
    // Tambahkan event listener untuk mendeteksi aktivitas pengguna
    window.addEventListener('mousemove', this.resetTimer);
    window.addEventListener('keydown', this.resetTimer);
    window.addEventListener('click', this.resetTimer);
  },
  beforeDestroy() {
    // Hapus event listener saat komponen dihancurkan
    window.removeEventListener('mousemove', this.resetTimer);
    window.removeEventListener('keydown', this.resetTimer);
    window.removeEventListener('click', this.resetTimer);
  }
};
</script>

<style scoped>
.custom-drawer .v-list-item,
.custom-drawer .v-list-item-title,
.custom-btn
.custom-drawer .v-icon {
  color:#212121!important; /* Menggunakan !important untuk memastikan aturan ini memiliki prioritas tertinggi */
}

.sub-item-indent {
  padding-left: 5px !important; /* Atur sesuai kebutuhan */
}

.footer-small {
  padding: 5px 10px; /* Mengurangi padding untuk membuat footer lebih tipis */
  font-size: 14px; /* Mengatur ukuran font lebih kecil */
  overflow: hidden; /* Menyembunyikan teks yang keluar dari area footer */
}

</style>