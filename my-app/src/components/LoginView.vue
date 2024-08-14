<template>
  <v-container fill-height>
    <v-row justify="center" align="center">
      <v-col cols="12" sm="8" md="4">
        <v-card class="custom-card">
          <v-card-title class="text-h5">Login</v-card-title>
          <v-card-text>
            <v-form ref="form" v-model="valid" lazy-validation>
              <v-text-field
                label="Username"
                prepend-icon="mdi-account"
                v-model="loginData.username"
                :rules="[rules.required]"
                required
              ></v-text-field>
              <v-text-field
                label="Password"
                prepend-icon="mdi-lock"
                v-model="loginData.password"
                :rules="[rules.required]"
                type="password"
                required
              ></v-text-field>
              <v-btn :disabled="!valid" color="#ea5252" @click="submitLogin">Login</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
// import axios from 'axios';
import api from '../services/api';
import Swal from 'sweetalert2';
import { mapActions } from 'vuex';

export default {
  data() {
    return {
      valid: true,
      loginData: {
        username: '',
        password: ''
      },
      rules: {
        required: value => !!value || 'Required.'
      }
    };
  },
  methods: {
    ...mapActions(['setUser', 'setUserRole']),
    submitLogin() {
      if (this.$refs.form.validate()) {
        api.post('/login', this.loginData)
          .then(response => {
            const loginDetails = response.data;
            Swal.fire({
              position: 'top-right',
              icon: 'success',
              title: 'Login berhasil!',
              showConfirmButton: false,
              timer: 1500,
              toast: true,
              width: '400px'
            });
            // console.log('Login Details:', loginDetails);
            this.setUser(loginDetails);
            this.setUserRole(loginDetails.data.id_role);
            this.$router.push(this.$route.query.redirect || '/');
          })
          .catch(error => {
            let message = 'Login gagal: Terjadi kesalahan';
            if (error.response && error.response.data && error.response.data.message === 'Invalid credentials') {
              message = 'Login gagal: Username atau password salah';
            } else if (error.response && error.response.data) {
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
              width: '400px'
            });
          });
      }
    }
  }
}
</script>

<style scoped>
.custom-card {
  max-width: 400px;
  transform: translateY(60%);
  box-shadow: 0 4px 8px rgba(0,0,0,2.5) !important;
}
</style>