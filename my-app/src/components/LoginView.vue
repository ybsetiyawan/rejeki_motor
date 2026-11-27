<template>
  <v-container fluid fill-height class="split-login-bg pa-0">
    <v-row no-gutters class="fill-height w-full align-center justify-center pa-3 pa-sm-6">
      <v-col cols="12" md="10" lg="8" xl="7">
        <v-card class="split-card rounded-xl elevation-6 overflow-hidden">
          <v-row no-gutters>
            <!-- Panel Kiri: Identitas Bengkel & App Version -->
            <v-col
              cols="12"
              md="5"
              class="brand-panel d-flex flex-column justify-space-between pa-6 pa-sm-7 rm-left-slide"
            >
              <div>
                <div class="d-flex align-center mb-5">
                  <v-avatar color="red darken-2" size="42" class="mr-3 elevation-2 rm-gear-box">
                    <v-icon color="white" size="22" class="rm-gear-spin">mdi-wrench-cog</v-icon>
                  </v-avatar>
                  <div>
                    <div class="text-subtitle-1 font-weight-black grey--text text--darken-4">
                      REJEKI MOTOR
                    </div>
                    <div class="text-caption red--text text--darken-2 font-weight-bold">
                      WORKSHOP &amp; PARTS SYSTEM
                    </div>
                  </div>
                </div>

                <div class="text-h6 font-weight-bold grey--text text--darken-4 mb-2">
                  Satu Portal untuk Stok, Transaksi &amp; Laporan
                </div>
                <div class="text-body-2 grey--text text--darken-1 mb-6">
                  Kelola penerimaan barang, pengeluaran/faktur, retur, hingga pemantauan stok harian dengan cepat.
                </div>

                <div class="feature-list">
                  <div class="feature-item d-flex align-center mb-3">
                    <v-icon small color="red darken-2" class="mr-2">mdi-check-circle-outline</v-icon>
                    <span class="text-caption font-weight-medium grey--text text--darken-3">
                      Kontrol stok real-time &amp; riwayat keluar/masuk
                    </span>
                  </div>
                  <div class="feature-item d-flex align-center mb-3">
                    <v-icon small color="red darken-2" class="mr-2">mdi-check-circle-outline</v-icon>
                    <span class="text-caption font-weight-medium grey--text text--darken-3">
                      Penerimaan, pengeluaran &amp; cetak faktur otomatis
                    </span>
                  </div>
                  <div class="feature-item d-flex align-center">
                    <v-icon small color="red darken-2" class="mr-2">mdi-check-circle-outline</v-icon>
                    <span class="text-caption font-weight-medium grey--text text--darken-3">
                      Laporan retur customer &amp; supplier siap export
                    </span>
                  </div>
                </div>
              </div>

              <div class="pt-5 mt-6 brand-footer-line d-flex align-center justify-space-between">
                <span class="text-caption grey--text text--darken-1">
                  Akses internal staff &amp; admin
                </span>
                <span class="rm-version-chip">
                  <span class="rm-beacon mr-1"></span>
                  App Version {{ appVersion }}
                </span>
              </div>
            </v-col>

            <!-- Panel Kanan: Form Login & Copyright -->
            <v-col
              cols="12"
              md="7"
              class="form-panel d-flex flex-column justify-space-between pa-6 pa-sm-8 rm-right-slide"
            >
              <div>
                <div class="bengkel-stripe mb-5"></div>

                <div class="mb-5">
                  <span class="badge-pill mb-2 d-inline-block">SIGN IN</span>
                  <div class="text-h5 font-weight-bold grey--text text--darken-4">
                    Selamat Datang Kembali
                  </div>
                  <div class="text-caption grey--text text--darken-1">
                    Masukkan username dan password akun Anda untuk melanjutkan.
                  </div>
                </div>

                <v-form ref="form" v-model="valid" lazy-validation @submit.prevent="submitLogin">
                  <div class="mb-4">
                    <label class="field-label">Username</label>
                    <v-text-field
                      v-model="loginData.username"
                      placeholder="Masukkan username"
                      prepend-inner-icon="mdi-account-outline"
                      color="red darken-2"
                      :rules="[rules.required]"
                      outlined
                      dense
                      autocomplete="username"
                      :disabled="loading"
                      required
                    ></v-text-field>
                  </div>

                  <div class="mb-5">
                    <label class="field-label">Password</label>
                    <v-text-field
                      v-model="loginData.password"
                      placeholder="Masukkan password"
                      prepend-inner-icon="mdi-lock-outline"
                      :append-icon="showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                      :type="showPassword ? 'text' : 'password'"
                      color="red darken-2"
                      :rules="[rules.required]"
                      outlined
                      dense
                      autocomplete="current-password"
                      :disabled="loading"
                      required
                      @click:append="showPassword = !showPassword"
                    ></v-text-field>
                  </div>

                  <v-btn
                    type="submit"
                    block
                    depressed
                    height="42"
                    color="red darken-2"
                    class="white--text font-weight-bold text-none rounded-md rm-shimmer-btn"
                    :disabled="!valid || loading"
                    :loading="loading"
                  >
                    <v-icon left small>mdi-login</v-icon>
                    Masuk ke Sistem
                  </v-btn>
                </v-form>
              </div>

              <div class="rm-copyright-bar mt-6 pt-3 d-flex flex-wrap align-center justify-space-between text-caption grey--text">
                <span>&copy; 2025 REJEKI MOTOR. Hak cipta dilindungi.</span>
                <span class="d-flex align-center font-weight-medium grey--text text--darken-1">
              <span class="grey--text mr-1">Crafted by</span>
                  <v-icon x-small color="red darken-2" class="mr-1">mdi-laptop</v-icon>
                  ybsetiyawan
                </span>
              </div>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import api from '../services/api';
import Swal from 'sweetalert2';
import { mapActions } from 'vuex';
import packageInfo from '../../package.json';

export default {
  name: 'LoginView',
  data() {
    return {
      appVersion: packageInfo.version,
      valid: true,
      loading: false,
      showPassword: false,
      loginData: {
        username: '',
        password: '',
      },
      rules: {
        required: value => !!value || 'Wajib diisi.',
      },
    };
  },
  methods: {
    ...mapActions(['setUser', 'setUserRole']),
    submitLogin() {
      if (!this.$refs.form.validate()) return;

      this.loading = true;
      api
        .post('/login', this.loginData)
        .then(response => {
          const loginDetails = response.data;
          Swal.fire({
            position: 'top-right',
            icon: 'success',
            title: 'Login berhasil!',
            showConfirmButton: false,
            timer: 1500,
            toast: true,
            width: '400px',
          });
          this.setUser(loginDetails);
          this.setUserRole(loginDetails.data.id_role);
          this.$router.push(this.$route.query.redirect || '/');
        })
        .catch(error => {
          let message = 'Login gagal: Terjadi kesalahan';
          if (
            error.response &&
            error.response.data &&
            error.response.data.message === 'Invalid credentials'
          ) {
            message = 'Login gagal: Username atau password salah';
          } else if (error.response && error.response.data && error.response.data.message) {
            message = 'Login gagal: ' + error.response.data.message;
          }
          Swal.fire({
            position: 'top-right',
            icon: 'error',
            title: 'Login gagal',
            text: message,
            showConfirmButton: false,
            timer: 1500,
            toast: true,
            width: '400px',
          });
        })
        .finally(() => {
          this.loading = false;
        });
    },
  },
};
</script>

<style scoped>
.split-login-bg {
  min-height: 100vh;
  background: linear-gradient(135deg, #fff5f5 0%, #f8fafc 50%, #f1f5f9 100%);
}

.split-card {
  border: 1px solid #f1dcdc;
  background-color: #ffffff;
}

.brand-panel {
  background: linear-gradient(180deg, #fff1f2 0%, #fffafa 100%);
  border-right: 1px solid #f1dcdc;
}

.rm-left-slide {
  animation: rmSlideLeft 0.45s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.rm-right-slide {
  animation: rmSlideRight 0.45s cubic-bezier(0.22, 1, 0.36, 1) 0.06s both;
}

.rm-gear-box:hover .rm-gear-spin {
  transform: rotate(120deg);
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.rm-gear-spin {
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.feature-item {
  padding: 4px 6px;
  border-radius: 6px;
  transition: background-color 0.2s ease, transform 0.2s ease;
}

.feature-item:hover {
  background-color: rgba(254, 202, 202, 0.32);
  transform: translateX(4px);
}

.form-panel {
  background-color: #ffffff;
}

.bengkel-stripe {
  height: 3px;
  width: 64px;
  border-radius: 999px;
  background: linear-gradient(90deg, #c62828 0%, #ef5350 100%);
}

.badge-pill {
  background-color: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.08em;
  padding: 2px 8px;
  border-radius: 999px;
}

.rm-version-chip {
  display: inline-flex;
  align-items: center;
  background-color: #ffffff;
  color: #991b1b;
  border: 1px solid #fecaca;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 9px;
  border-radius: 999px;
}

.rm-beacon {
  width: 6px;
  height: 6px;
  border-radius: 999px;
  background-color: #dc2626;
  display: inline-block;
  animation: rmBeaconPing 1.8s infinite ease-in-out;
}

.field-label {
  display: block;
  font-size: 12px;
  font-weight: 700;
  color: #374151;
  margin-bottom: 6px;
}

.brand-footer-line {
  border-top: 1px dashed #fecaca;
}

.rm-copyright-bar {
  border-top: 1px solid #f1f5f9;
}

.rm-shimmer-btn {
  position: relative;
  overflow: hidden;
  transition: transform 0.18s ease, box-shadow 0.2s ease !important;
}

.rm-shimmer-btn::after {
  content: '';
  position: absolute;
  top: 0;
  left: -120%;
  width: 60%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.28),
    transparent
  );
  transform: skewX(-20deg);
  transition: left 0.55s ease;
}

.rm-shimmer-btn:hover:not(:disabled)::after {
  left: 140%;
}

.rm-shimmer-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 14px rgba(198, 40, 40, 0.25) !important;
}

@keyframes rmSlideLeft {
  0% {
    opacity: 0;
    transform: translateX(-14px);
  }
  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes rmSlideRight {
  0% {
    opacity: 0;
    transform: translateX(14px);
  }
  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes rmBeaconPing {
  0%, 100% {
    opacity: 0.4;
    transform: scale(0.85);
  }
  50% {
    opacity: 1;
    transform: scale(1.25);
  }
}

@media (prefers-reduced-motion: reduce) {
  .rm-left-slide,
  .rm-right-slide,
  .rm-gear-spin,
  .feature-item,
  .rm-beacon,
  .rm-shimmer-btn,
  .rm-shimmer-btn::after {
    animation: none !important;
    transition: none !important;
  }
}
</style>