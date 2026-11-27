<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Toolbar -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-wrench-clock</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Master Supplier
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ filteredSuppliers.length }} Supplier
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Data pemasok sparepart, oli &amp; kebutuhan operasional bengkel
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
            Tambah Supplier
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
        placeholder="Cari berdasarkan kode atau nama supplier..."
        prepend-inner-icon="mdi-magnify"
        @click:clear="search = ''"
      ></v-text-field>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Master Supplier -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header>
        <thead>
          <tr>
            <th class="text-left" style="width: 110px;">KODE</th>
            <th class="text-left" style="width: 22%;">NAMA SUPPLIER</th>
            <th class="text-left">ALAMAT</th>
            <th class="text-left" style="width: 145px;">NO HP</th>
            <th class="text-left" style="width: 20%;">EMAIL</th>
            <th class="text-center" style="width: 110px;">AKSI</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="supplier in paginatedSuppliers"
            :key="supplier.id"
            class="supplier-row"
          >
            <td>
              <span class="kode-red-pill">{{ supplier.kode || '-' }}</span>
            </td>
            <td class="font-weight-bold grey--text text--darken-4">
              {{ toUpperCase(supplier.nama) }}
            </td>
            <td class="grey--text text--darken-2">
              {{ toUpperCase(supplier.alamat) || '-' }}
            </td>
            <td class="font-weight-medium grey--text text--darken-3">
              {{ supplier.no_hp || '-' }}
            </td>
            <td class="grey--text text--darken-2">
              {{ toUpperCase(supplier.email) || '-' }}
            </td>
            <td class="text-center">
              <v-btn
                icon
                small
                color="red darken-2"
                class="mr-1"
                @click="editSupplier(supplier.id)"
                title="Edit Supplier"
              >
                <v-icon small>mdi-pencil-outline</v-icon>
              </v-btn>
              <v-btn
                icon
                small
                color="grey darken-2"
                @click="hapusSupplier(supplier.id)"
                title="Hapus Supplier"
              >
                <v-icon small>mdi-delete-outline</v-icon>
              </v-btn>
            </td>
          </tr>

          <tr v-if="!paginatedSuppliers || paginatedSuppliers.length === 0">
            <td colspan="6" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-account-off-outline</v-icon>
              <div>Tidak ada data supplier yang ditemukan.</div>
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
        <strong class="grey--text text--darken-4">{{ filteredSuppliers.length }}</strong> supplier
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

    <!-- Dialog Tambah / Edit Supplier -->
    <v-dialog v-model="dialog" persistent max-width="620px">
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
                {{ isEditing ? 'Edit Supplier' : 'Tambah Supplier' }}
              </div>
              <div class="text-caption grey--text text--darken-1">
                {{ isEditing ? 'Perbarui informasi kontak & alamat supplier' : 'Masukkan data pemasok baru ke sistem' }}
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
            <v-col cols="12" sm="4" v-if="isEditing">
              <v-text-field
                label="Kode"
                v-model="newSupplier.kode"
                color="red darken-2"
                outlined
                dense
                disabled
              ></v-text-field>
            </v-col>
            <v-col cols="12" :sm="isEditing ? 8 : 6">
              <v-text-field
                label="Nama Supplier *"
                v-model="newSupplier.nama"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" :sm="isEditing ? 6 : 6">
              <v-text-field
                label="No HP *"
                v-model="newSupplier.no_hp"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" :sm="isEditing ? 6 : 6">
              <v-text-field
                label="Email *"
                v-model="newSupplier.email"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12">
              <v-textarea
                label="Alamat *"
                v-model="newSupplier.alamat"
                color="red darken-2"
                outlined
                dense
                rows="2"
                auto-grow
                required
              ></v-textarea>
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
            @click="addOrUpdateSupplier"
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
import { isUnique, toUpperCase, toUpperCaseFields, filterData } from '../../mixins/FilterMixin';

export default {
  name: 'SupllierView',
  data() {
    return {
      suppliers: [],
      newSupplier: {},
      dialog: false,
      search: '',
      isEditing: false,
      toUpperCase: toUpperCase,
      currentPage: 1,
      pageSize: 10,
    };
  },
  computed: {
    filteredSuppliers() {
      return filterData(this.suppliers, this.search);
    },
    totalPagesSafe() {
      return Math.max(1, Math.ceil(this.filteredSuppliers.length / this.pageSize));
    },
    paginatedSuppliers() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredSuppliers.slice(start, start + this.pageSize);
    },
    startItemIndex() {
      if (!this.filteredSuppliers.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.filteredSuppliers.length) return 0;
      return Math.min(this.currentPage * this.pageSize, this.filteredSuppliers.length);
    },
  },
  watch: {
    search() {
      this.currentPage = 1;
    },
    filteredSuppliers(newList) {
      const maxPage = Math.max(1, Math.ceil(newList.length / this.pageSize));
      if (this.currentPage > maxPage) {
        this.currentPage = maxPage;
      }
    },
  },
  mounted() {
    this.loadSuppliers();
  },
  methods: {
    goToPage(page) {
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      this.currentPage = target;
    },

    loadSuppliers() {
      api.get('/m_supplier')
        .then(response => {
          this.suppliers = response.data;
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memuat data supplier:', error);
        });
    },

    addSupplier() {
      if (!this.newSupplier.nama || !this.newSupplier.no_hp || !this.newSupplier.alamat || !this.newSupplier.email) {
        alert('Nama Supplier, No HP, Alamat, dan Email tidak boleh kosong.');
        return;
      }
      this.newSupplier.no_hp = this.newSupplier.no_hp.replace(/\s+/g, '');
      toUpperCaseFields(this.newSupplier, ['nama', 'no_hp', 'alamat', 'email']);
      if (!isUnique(this.suppliers, 'email', this.newSupplier.email)) {
        alert('Email sudah ada.');
        return;
      }
      api.post('/m_supplier', this.newSupplier)
        .then(response => {
          this.suppliers.push(response.data);
          this.newSupplier = {};
          this.dialog = false;
          alert('Data berhasil ditambahkan.');
          this.loadSuppliers();
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat menambah data:', error);
          alert('Gagal menambah data: ' + error.message);
        });
    },

    openAddDialog() {
      this.newSupplier = {};
      this.isEditing = false;
      this.dialog = true;
    },

    editSupplier(id) {
      const found = this.suppliers.find(supplier => supplier.id === id);
      if (!found) return;
      this.newSupplier = { ...found };
      this.isEditing = true;
      this.dialog = true;
    },

    updateSupplier() {
      if (!this.newSupplier.nama) {
        alert('Nama Supplier tidak boleh kosong.');
        return;
      }
      this.newSupplier.no_hp = this.newSupplier.no_hp.replace(/\s+/g, '');
      toUpperCaseFields(this.newSupplier, ['nama', 'no_hp', 'alamat', 'email']);
      api.put(`/m_supplier/${this.newSupplier.id}`, this.newSupplier)
        .then(response => {
          const index = this.suppliers.findIndex(supplier => supplier.id === this.newSupplier.id);
          if (index !== -1) {
            this.suppliers.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadSuppliers();
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memperbarui data:', error);
          alert('Gagal memperbarui data: ' + error.message);
        });
    },

    addOrUpdateSupplier() {
      if (this.isEditing) {
        this.updateSupplier();
      } else {
        this.addSupplier();
      }
    },

    hapusSupplier(id) {
      if (confirm('Apakah Anda yakin ingin menghapus supplier ini?')) {
        api.delete(`/m_supplier/${id}`)
          .then(() => {
            this.suppliers = this.suppliers.filter(supplier => supplier.id !== id);
          })
          .catch(error => {
            console.error('Terjadi kesalahan saat menghapus supplier:', error);
            alert('Gagal menghapus supplier: ' + error.message);
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

.supplier-row {
  transition: background-color 0.14s ease;
}

.supplier-row td {
  font-size: 12px !important;
  height: 38px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.supplier-row:hover {
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