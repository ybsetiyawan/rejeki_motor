<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Toolbar -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-account-cog-outline</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Master User
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ filteredUsers.length }} User
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Kelola akun pengguna, kredensial &amp; hak akses (role) aplikasi bengkel
            </div>
          </div>
        </div>

        <div class="mt-2 mt-sm-0">
          <v-btn
            small
            depressed
            color="red darken-2"
            class="white--text font-weight-medium text-none px-4"
            @click="openAddDialog"
          >
            <v-icon left small>mdi-plus</v-icon>
            Tambah User
          </v-btn>
        </div>
      </div>

      <!-- Search Bar -->
      <v-text-field
        v-model="search"
        outlined
        dense
        clearable
        hide-details
        color="red darken-2"
        background-color="white"
        placeholder="Cari berdasarkan nama user, username, atau role..."
        prepend-inner-icon="mdi-magnify"
        @click:clear="search = ''"
      ></v-text-field>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Master User -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header>
        <thead>
          <tr>
            <th class="text-left">NAMA USER</th>
            <th class="text-left" style="width: 22%;">USERNAME</th>
            <th class="text-left" style="width: 22%;">ROLE</th>
            <th class="text-center" style="width: 115px;">AKSI</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="user in paginatedUsers"
            :key="user.user_id"
            class="user-row"
          >
            <td class="font-weight-bold grey--text text--darken-4">
              {{ toUpperCase(user.pegawai) }}
            </td>
            <td class="grey--text text--darken-2">
              <span class="username-pill">{{ user.username }}</span>
            </td>
            <td>
              <v-chip
                x-small
                label
                color="red lighten-5"
                text-color="red darken-3"
                class="font-weight-bold text-uppercase"
              >
                {{ user.role_nama || '-' }}
              </v-chip>
            </td>
            <td class="text-center">
              <v-btn
                icon
                small
                color="red darken-2"
                class="mr-1"
                @click="editUser(user.user_id)"
                title="Edit User"
              >
                <v-icon small>mdi-pencil-outline</v-icon>
              </v-btn>
              <v-btn
                icon
                small
                color="grey darken-2"
                @click="deleteUser(user.user_id)"
                title="Hapus User"
              >
                <v-icon small>mdi-delete-outline</v-icon>
              </v-btn>
            </td>
          </tr>

          <tr v-if="!paginatedUsers || paginatedUsers.length === 0">
            <td colspan="4" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-account-off-outline</v-icon>
              <div>Tidak ada data user yang ditemukan.</div>
            </td>
          </tr>
        </tbody>
      </v-simple-table>
    </div>

    <!-- Footer Paginasi Nuansa Merah Bengkel -->
    <div class="pagination-bar px-5 py-3 d-flex flex-wrap align-center justify-space-between">
      <div class="text-caption grey--text text--darken-2">
        Menampilkan
        <strong class="red--text text--darken-3">{{ startItemIndex }}–{{ endItemIndex }}</strong>
        dari
        <strong class="grey--text text--darken-4">{{ filteredUsers.length }}</strong> user
      </div>

      <div class="d-flex align-center">
        <v-btn
          icon
          small
          outlined
          color="red darken-2"
          class="mr-2 page-nav-btn"
          :disabled="currentPage <= 1"
          @click="goToPage(1)"
          title="Halaman Pertama"
        >
          <v-icon small>mdi-chevron-double-left</v-icon>
        </v-btn>

        <v-btn
          small
          outlined
          color="red darken-2"
          class="text-none font-weight-medium mr-2 page-step-btn"
          :disabled="currentPage <= 1"
          @click="goToPage(currentPage - 1)"
        >
          <v-icon left small>mdi-chevron-left</v-icon>
          Prev
        </v-btn>

        <div class="page-indicator-box mx-1">
          <span>Hal</span>
          <strong class="red--text text--darken-3 mx-1">{{ currentPage }}</strong>
          <span>/ {{ totalPagesSafe }}</span>
        </div>

        <v-btn
          small
          outlined
          color="red darken-2"
          class="text-none font-weight-medium ml-2 page-step-btn"
          :disabled="currentPage >= totalPagesSafe"
          @click="goToPage(currentPage + 1)"
        >
          Next
          <v-icon right small>mdi-chevron-right</v-icon>
        </v-btn>

        <v-btn
          icon
          small
          outlined
          color="red darken-2"
          class="ml-2 page-nav-btn"
          :disabled="currentPage >= totalPagesSafe"
          @click="goToPage(totalPagesSafe)"
          title="Halaman Terakhir"
        >
          <v-icon small>mdi-chevron-double-right</v-icon>
        </v-btn>
      </div>
    </div>

    <!-- Dialog Tambah / Edit User -->
    <v-dialog v-model="dialog" persistent max-width="460px">
      <v-card class="rounded-lg">
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="38" class="mr-3">
              <v-icon color="red darken-2">
                {{ isEditing ? 'mdi-account-edit-outline' : 'mdi-account-plus-outline' }}
              </v-icon>
            </v-avatar>
            <div>
              <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
                {{ isEditing ? 'Edit User' : 'Tambah User Baru' }}
              </div>
              <div class="text-caption grey--text text--darken-1">
                {{ isEditing ? 'Perbarui data pengguna & hak akses' : 'Masukkan akun pengguna baru untuk sistem' }}
              </div>
            </div>
          </div>
          <v-spacer></v-spacer>
          <v-btn icon small color="grey darken-1" @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>

        <div class="bengkel-stripe"></div>

        <v-card-text class="pa-5">
          <v-row dense>
            <v-col cols="12" sm="6">
              <v-text-field
                label="Nama User *"
                v-model="newUser.pegawai"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="6">
              <v-text-field
                label="Username *"
                v-model="newUser.username"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="6">
              <v-text-field
                :type="showPassword ? 'text' : 'password'"
                :label="isEditing ? 'Password (opsional)' : 'Password *'"
                v-model="newUser.password"
                color="red darken-2"
                outlined
                dense
                :required="!isEditing"
                :append-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
                @click:append="showPassword = !showPassword"
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="6">
              <v-select
                label="Role *"
                v-model="newUser.id_role"
                :items="rules"
                item-text="nama"
                item-value="id"
                color="red darken-2"
                outlined
                dense
                required
              ></v-select>
            </v-col>
          </v-row>
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions class="px-5 py-3 grey lighten-5">
          <v-spacer></v-spacer>
          <v-btn text color="grey darken-2" class="text-none mr-2" @click="dialog = false">
            Batal
          </v-btn>
          <v-btn
            depressed
            color="red darken-2"
            class="white--text text-none px-4"
            @click="addOrUpdateUser"
          >
            {{ isEditing ? 'Simpan Perubahan' : 'Simpan' }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<script>
import api from '../../services/api';
import { maskedPassword, isUnique, toUpperCase, toUpperCaseFields } from '../../mixins/FilterMixin';

export default {
  name: 'UserView',
  data() {
    return {
      users: [],
      newUser: {},
      dialog: false,
      showPassword: false,
      search: '',
      isEditing: false,
      rules: [],
      valid: true,
      maskedPassword,
      toUpperCase,
      currentPage: 1,
      pageSize: 10,
    };
  },
  computed: {
    filteredUsers() {
      const q = (this.search || '').toString().trim().toLowerCase();
      if (!q) return this.users;
      return this.users.filter(u => {
        const pegawai = (u.pegawai || '').toString().toLowerCase();
        const username = (u.username || '').toString().toLowerCase();
        const role = (u.role_nama || '').toString().toLowerCase();
        return pegawai.includes(q) || username.includes(q) || role.includes(q);
      });
    },
    totalPagesSafe() {
      return Math.max(1, Math.ceil(this.filteredUsers.length / this.pageSize));
    },
    paginatedUsers() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredUsers.slice(start, start + this.pageSize);
    },
    startItemIndex() {
      if (!this.filteredUsers.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.filteredUsers.length) return 0;
      return Math.min(this.currentPage * this.pageSize, this.filteredUsers.length);
    },
  },
  watch: {
    search() {
      this.currentPage = 1;
    },
    filteredUsers(newList) {
      const maxPage = Math.max(1, Math.ceil(newList.length / this.pageSize));
      if (this.currentPage > maxPage) {
        this.currentPage = maxPage;
      }
    },
  },
  mounted() {
    this.loadUsers();
    this.loadRules();
  },
  methods: {
    goToPage(page) {
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      this.currentPage = target;
    },

    loadUsers() {
      api.get('/m_user')
        .then(response => {
          this.users = response.data;
        })
        .catch(error => {
          console.error('Error loading users:', error);
        });
    },

    loadRules() {
      api.get('/role')
        .then(response => {
          this.rules = response.data;
        })
        .catch(error => console.error('Error loading rules:', error));
    },

    addUser() {
      if (!this.newUser.pegawai || !this.newUser.username || !this.newUser.password) {
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      if (!isUnique(this.users, 'username', this.newUser.username)) {
        alert('Username sudah digunakan, Silahkan gunakan Username lain');
        return;
      }
      toUpperCaseFields(this.newUser, ['pegawai']);

      api.post('/m_user', {
        pegawai: this.newUser.pegawai,
        username: this.newUser.username,
        password: this.newUser.password,
        id_role: this.newUser.id_role,
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
      this.newUser = {};
      this.showPassword = false;
      this.isEditing = false;
      this.dialog = true;
    },

    editUser(id) {
      const found = this.users.find(user => user.user_id === id);
      if (!found) return;
      this.isEditing = true;
      this.showPassword = false;
      this.newUser = { ...found, password: '' };
      this.dialog = true;
    },

    updateUser() {
      toUpperCaseFields(this.newUser, ['pegawai']);
      const payload = {
        pegawai: this.newUser.pegawai,
        username: this.newUser.username,
        id_role: this.newUser.id_role,
      };
      if (this.newUser.password && String(this.newUser.password).trim() !== '') {
        payload.password = this.newUser.password;
      }

      api.put(`/m_user/${this.newUser.user_id}`, payload)
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

    addOrUpdateUser() {
      if (
        !this.newUser.pegawai ||
        !this.newUser.username ||
        (!this.isEditing && !this.newUser.password) ||
        !this.newUser.id_role
      ) {
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      if (this.isEditing) {
        this.updateUser();
      } else {
        this.addUser();
      }
    },

    deleteUser(user_id) {
      if (confirm('Apakah Anda yakin ingin menghapus user ini?')) {
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
  },
};
</script>

<style scoped>
.bengkel-card {
  border: 1px solid #f1dcdc;
  background-color: #ffffff;
}

.bengkel-header {
  background: linear-gradient(180deg, #fff6f6 0%, #ffffff 100%);
}

.bengkel-avatar-ring {
  border: 1px solid #fecaca;
}

.bengkel-stripe {
  height: 3px;
  background: linear-gradient(90deg, #c62828 0%, #ef5350 60%, #ffcdd2 100%);
}

.table-scroll-wrapper {
  max-height: 480px;
  overflow-y: auto;
}

.bengkel-table th {
  font-size: 11px !important;
  font-weight: 700 !important;
  letter-spacing: 0.04em;
  color: #7f1d1d !important;
  background-color: #fef2f2 !important;
  border-bottom: 1px solid #fecaca !important;
  height: 38px !important;
}

.user-row {
  transition: background-color 0.14s ease;
}

.user-row td {
  font-size: 12px !important;
  height: 38px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.user-row:hover {
  background-color: #fff5f5 !important;
}

.username-pill {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 5px;
  background-color: #f9fafb;
  color: #374151;
  border: 1px solid #e5e7eb;
  font-family: monospace;
  font-size: 11px;
  font-weight: 600;
}

.pagination-bar {
  background-color: #fffafa;
  border-top: 1px solid #f1dcdc;
}

.page-indicator-box {
  background-color: #ffffff;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 4px 10px;
  font-size: 12px;
  color: #4b5563;
}

.page-step-btn {
  border-radius: 6px !important;
  background-color: #ffffff !important;
}

.page-nav-btn {
  border-radius: 6px !important;
  background-color: #ffffff !important;
  width: 28px !important;
  height: 28px !important;
}

.modal-top-bar {
  background-color: #ffffff;
}
</style>