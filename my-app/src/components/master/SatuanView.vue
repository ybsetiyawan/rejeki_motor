<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Toolbar -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-ruler-square</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Master Satuan
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ filteredSatuans.length }} Satuan
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Kelola unit satuan barang seperti PCS, LITER, BOTOL, SET &amp; DUS
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
            Tambah Satuan
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
        placeholder="Cari berdasarkan ID atau nama satuan..."
        prepend-inner-icon="mdi-magnify"
        @click:clear="search = ''"
      ></v-text-field>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Master Satuan -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header>
        <thead>
          <tr>
            <th class="text-left" style="width: 115px;">ID</th>
            <th class="text-left">NAMA SATUAN</th>
            <th class="text-center" style="width: 115px;">AKSI</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="satuan in paginatedSatuans"
            :key="satuan.id"
            class="satuan-row"
          >
            <td>
              <span class="kode-red-pill">{{ satuan.id }}</span>
            </td>
            <td class="font-weight-bold grey--text text--darken-4">
              {{ toUpperCase(satuan.nama) }}
            </td>
            <td class="text-center">
              <v-btn
                icon
                small
                color="red darken-2"
                class="mr-1"
                @click="editSatuan(satuan.id)"
                title="Edit Satuan"
              >
                <v-icon small>mdi-pencil-outline</v-icon>
              </v-btn>
              <v-btn
                icon
                small
                color="grey darken-2"
                @click="hapusSatuan(satuan.id)"
                title="Hapus Satuan"
              >
                <v-icon small>mdi-delete-outline</v-icon>
              </v-btn>
            </td>
          </tr>

          <tr v-if="!paginatedSatuans || paginatedSatuans.length === 0">
            <td colspan="3" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-ruler-square</v-icon>
              <div>Tidak ada data satuan yang ditemukan.</div>
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
        <strong class="grey--text text--darken-4">{{ filteredSatuans.length }}</strong> satuan
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

    <!-- Dialog Tambah / Edit Satuan -->
    <v-dialog v-model="dialog" persistent max-width="440px">
      <v-card class="rounded-lg">
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="38" class="mr-3">
              <v-icon color="red darken-2">
                {{ isEditing ? 'mdi-pencil' : 'mdi-plus-box-outline' }}
              </v-icon>
            </v-avatar>
            <div>
              <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
                {{ isEditing ? 'Edit Satuan' : 'Tambah Satuan' }}
              </div>
              <div class="text-caption grey--text text--darken-1">
                {{ isEditing ? 'Perbarui nama unit satuan barang' : 'Masukkan unit satuan barang baru' }}
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
          <v-text-field
            label="Nama Satuan *"
            v-model="newSatuan.nama"
            color="red darken-2"
            outlined
            dense
            required
            @keyup.enter="addOrUpdateSatuan"
          ></v-text-field>
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
            @click="addOrUpdateSatuan"
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
import { isUnique, toUpperCase, toUpperCaseFields } from '../../mixins/FilterMixin';

export default {
  name: 'SatuanView',
  data() {
    return {
      satuans: [],
      newSatuan: {},
      dialog: false,
      search: '',
      isEditing: false,
      toUpperCase: toUpperCase,
      currentPage: 1,
      pageSize: 10,
    };
  },
  computed: {
    filteredSatuans() {
      return this.satuans.filter(satuan => {
        const searchLower = (this.search || '').toLowerCase();
        return (
          (satuan.id && satuan.id.toString().toLowerCase().includes(searchLower)) ||
          (satuan.nama && satuan.nama.toLowerCase().includes(searchLower))
        );
      });
    },
    totalPagesSafe() {
      return Math.max(1, Math.ceil(this.filteredSatuans.length / this.pageSize));
    },
    paginatedSatuans() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredSatuans.slice(start, start + this.pageSize);
    },
    startItemIndex() {
      if (!this.filteredSatuans.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.filteredSatuans.length) return 0;
      return Math.min(this.currentPage * this.pageSize, this.filteredSatuans.length);
    },
  },
  watch: {
    search() {
      this.currentPage = 1;
    },
    filteredSatuans(newList) {
      const maxPage = Math.max(1, Math.ceil(newList.length / this.pageSize));
      if (this.currentPage > maxPage) {
        this.currentPage = maxPage;
      }
    },
  },
  mounted() {
    this.loadSatuans();
  },
  methods: {
    goToPage(page) {
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      this.currentPage = target;
    },

    loadSatuans() {
      api.get('/m_satuan')
        .then(response => {
          this.satuans = response.data;
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memuat data satuan:', error);
        });
    },

    addSatuan() {
      if (!this.newSatuan.nama) {
        alert('Nama satuan tidak boleh kosong.');
        return;
      }
      toUpperCaseFields(this.newSatuan, ['nama']);
      if (!isUnique(this.satuans, 'nama', this.newSatuan.nama)) {
        alert('Nama satuan sudah ada.');
        return;
      }
      api.post('/m_satuan', this.newSatuan)
        .then(response => {
          this.satuans.push(response.data);
          this.newSatuan = {};
          this.dialog = false;
          alert('Data berhasil ditambahkan.');
          this.loadSatuans();
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat menambah satuan:', error);
          alert('Gagal menambah satuan: ' + error.message);
        });
    },

    openAddDialog() {
      this.newSatuan = {};
      this.isEditing = false;
      this.dialog = true;
    },

    editSatuan(id) {
      const found = this.satuans.find(satuan => satuan.id === id);
      if (!found) return;
      this.newSatuan = { ...found };
      this.isEditing = true;
      this.dialog = true;
    },

    updateSatuan() {
      if (!this.newSatuan.nama) {
        alert('Nama satuan tidak boleh kosong.');
        return;
      }
      toUpperCaseFields(this.newSatuan, ['nama']);
      const current = this.satuans.find(satuan => satuan.id === this.newSatuan.id);
      if ((!current || current.nama !== this.newSatuan.nama) && !isUnique(this.satuans, 'nama', this.newSatuan.nama)) {
        alert('Nama satuan sudah ada.');
        return;
      }
      api.put(`/m_satuan/${this.newSatuan.id}`, this.newSatuan)
        .then(response => {
          const index = this.satuans.findIndex(satuan => satuan.id === this.newSatuan.id);
          if (index !== -1) {
            this.satuans.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadSatuans();
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memperbarui data:', error);
          alert('Gagal memperbarui data: ' + error.message);
        });
    },

    addOrUpdateSatuan() {
      if (this.isEditing) {
        this.updateSatuan();
      } else {
        this.addSatuan();
      }
    },

    hapusSatuan(id) {
      if (confirm('Apakah Anda yakin ingin menghapus satuan ini?')) {
        api.delete(`/m_satuan/${id}`)
          .then(() => {
            this.satuans = this.satuans.filter(satuan => satuan.id !== id);
          })
          .catch(error => {
            console.error('Terjadi kesalahan saat menghapus satuan:', error);
            alert(error.response && error.response.data ? error.response.data.message : error.message);
          });
      }
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

.satuan-row {
  transition: background-color 0.14s ease;
}

.satuan-row td {
  font-size: 12px !important;
  height: 38px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.satuan-row:hover {
  background-color: #fff5f5 !important;
}

.kode-red-pill {
  display: inline-block;
  padding: 2px 7px;
  border-radius: 5px;
  background-color: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  font-family: monospace;
  font-size: 11px;
  font-weight: 700;
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