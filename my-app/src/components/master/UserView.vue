<template>
  <v-card>
    <v-card-title class="font">
      MASTER USER
      <v-spacer></v-spacer>

    </v-card-title>
    <!-- Tabel untuk Header -->
    <v-simple-table class="font">
      <thead>
        <tr>
          <th style="width: 20%;">NAMA USER</th>
          <th style="width: 20%;">USERNAME</th>
          <th style="width: 20%;">PASSWORD</th>
          <th style="width: 20%;">RULES</th>
          <th style="width: 20%;" class="text-right">
            <v-btn
              class="font"
              @click="openAddDialog">Tambah</v-btn>
          </th>
        </tr>
      </thead>
    </v-simple-table>
    <!-- Dialog untuk Tambah Satuan -->
    <v-dialog v-model="dialog" persistent max-width="400px">
      <v-card>
        <v-card-title class="headline">Tambah User Baru</v-card-title>
        <v-card-text class="small-text">
          <v-container>
            <v-row>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Nama User"
                  v-model="newUser.pegawai"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Username"
                  v-model="newUser.username"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  type="password"
                  label="Password"
                  v-model="newUser.password"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-select
                  label="Rules"
                  v-model="newUser.id_role"
                  :items="rules"
                  item-text="nama"
                  item-value="id"
                  required
                  dense
                ></v-select>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">Batal</v-btn>
          <v-btn color="blue darken-1" text @click="addOrUpdateUser">Simpan</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
   
    <!-- Tabel untuk Body dengan Scroll -->
    <v-simple-table class="scrollable-table font">
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td style="width: 20%;">{{ toUpperCase(user.pegawai) }}</td>
          <td style="width: 20%;">{{ (user.username) }}</td>
          <td style="width: 20%;">{{ maskedPassword(user.password) }}</td>
          <td style="width: 20%;">{{ toUpperCase(user.role_nama) }}</td>
          <td style="width: 20%;" class="text-right">
            <v-btn
              icon
              color="success"
              size="small"
              class="font" @click="editUser(user.user_id)">
              <v-icon>mdi-pencil-box</v-icon>
            </v-btn>
            <v-btn
              icon
              color="error"
              size="small"
              class="font" @click="deleteUser(user.user_id)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </td>
        </tr>
      </tbody>
    </v-simple-table>
  </v-card>
</template>
<script>
// import axios from 'axios';
import api from '../../services/api';
import { maskedPassword, isUnique, toUpperCase, toUpperCaseFields } from '../../mixins/FilterMixin';

export default {
  name: 'UserView',
  data() {
    return {
      users: [],
      newUser: {},
      dialog: false,
      search: '',
      isEditing: false,
      rules: [], // Data untuk rules
      valid: true,
      maskedPassword,
      toUpperCase,
    }
  },
  
  mounted() {
    this.loadUsers();
    this.loadRules();  
  },
  methods: {
    loadUsers() {
      // axios.get('http://localhost:4000/m_user')
      api.get('/m_user')
      .then(response => {
        this.users = response.data;
      })
    },
    loadRules() {
      // axios.get('http://localhost:4000/role')
      api.get('/role')
        .then(response => {
          this.rules = response.data;
        })
        .catch(error => console.error('Error loading rules:', error));
    },
    addUser(){
      if(!this.newUser.pegawai || !this.newUser.username || !this.newUser.password ){
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      if (!isUnique(this.users , 'username', this.newUser.username)) {
        alert('Username sudah digunakan, Silahkan gunakan Username lain');
        return;
      }
      toUpperCaseFields(this.newUser, ['pegawai',]);
    

      // axios.post('http://localhost:4000/m_user',{
      api.post('/m_user',{
        pegawai: this.newUser.pegawai,
        username: this.newUser.username,
        password: this.newUser.password,
        id_role: this.newUser.id_role
      })
      .then(response => {
        this.users.push(response.data);
        this.newUser = {};
        this.dialog = false;
        alert('Data berhasil ditambahkan');
        this.loadUsers();
      })
      .catch(error => {
        console.error('Error adding user:', error);
        alert('Terjadi kesalahan saat menambah user.');
      });
    },

    openAddDialog() {
      this.newUser = {}; // Kosongkan form setiap kali dialog dibuka untuk menambah
      this.isEditing = false; // Tandai bahwa ini bukan sesi edit
      this.dialog = true;
    },

    editUser(id){
      this.isEditing = true;
      this.newUser = {...this.users.find(user => user.user_id === id)};
      this.dialog = true;
    },

    updateUser(){
      toUpperCaseFields(this.newUser, ['pegawai']);
      // axios.put(`http://localhost:4000/m_user/${this.newUser.user_id}`,{
      api.put(`/m_user/${this.newUser.user_id}`,{
        pegawai: this.newUser.pegawai,
        username: this.newUser.username,
        password: this.newUser.password,
        id_role: this.newUser.id_role
      })
      .then(response => {
        const index = this.users.findIndex(user => user.user_id === this.newUser.user_id);
        if (index !== -1) {
          this.users.splice(index, 1, response.data);
        }
        this.newUser = {};
        this.dialog = false;
        alert('Data berhasil diperbarui');
        this.loadUsers();
      })
      .catch(error => {
        console.error('Error updating user:', error);
        alert('Terjadi kesalahan saat memperbarui user.');
      });
    },
    addOrUpdateUser(){
      if(!this.newUser.pegawai || !this.newUser.username || !this.newUser.password || !this.newUser.id_role){
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      if(this.isEditing){
        this.updateUser();
      }else{
        this.addUser();
      }
    },
    deleteUser(user_id){
      if(confirm('Apakah Anda yakin ingin menghapus user ini?')){
      // axios.delete(`http://localhost:4000/m_user/${user_id}`)
      api.delete(`/m_user/${user_id}`)
      .then(() => {
        this.users = this.users.filter(user => user.user_id !== user_id);
      })
      .catch(error => {
        console.error('Error deleting user:', error.message);
          alert('Terjadi kesalahan saat menghapus user.');
        });
      }
    },
   
    isKodeUnique(username) {
      return !this.users.some(user => user.username === username);
    },
   
  }
}
</script>


<style scoped>
.font {
  font-size: 16px;
}
.small-text {
  font-size: 14px;
}
.scrollable-table {
  max-height: 400px;
  overflow-y: auto;
}
</style>