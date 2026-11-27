<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Toolbar -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-tag-multiple-outline</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Master Jenis Item
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ filteredJeniss.length }} Jenis
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Kelola kategori atau jenis barang sparepart &amp; perlengkapan bengkel
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
            Tambah Jenis Item
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
        placeholder="Cari berdasarkan kode atau nama jenis item..."
        prepend-inner-icon="mdi-magnify"
        @click:clear="search = ''"
      ></v-text-field>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Master Jenis Item -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header>
        <thead>
          <tr>
            <th class="text-left" style="width: 140px;">KODE</th>
            <th class="text-left">NAMA JENIS ITEM</th>
            <th class="text-center" style="width: 115px;">AKSI</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="jenis in paginatedJeniss"
            :key="jenis.id"
            class="jenis-row"
          >
            <td>
              <span class="kode-red-pill">{{ toUpperCase(jenis.kode) }}</span>
            </td>
            <td class="font-weight-bold grey--text text--darken-4">
              {{ toUpperCase(jenis.nama) }}
            </td>
            <td class="text-center">
              <v-btn
                icon
                small
                color="red darken-2"
                class="mr-1"
                @click="editJenisItem(jenis.id)"
                title="Edit Jenis Item"
              >
                <v-icon small>mdi-pencil-outline</v-icon>
              </v-btn>
              <v-btn
                icon
                small
                color="grey darken-2"
                @click="deleteJenisItem(jenis.id)"
                title="Hapus Jenis Item"
              >
                <v-icon small>mdi-delete-outline</v-icon>
              </v-btn>
            </td>
          </tr>

          <tr v-if="!paginatedJeniss || paginatedJeniss.length === 0">
            <td colspan="3" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-tag-off-outline</v-icon>
              <div>Tidak ada data jenis item yang ditemukan.</div>
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
        <strong class="grey--text text--darken-4">{{ filteredJeniss.length }}</strong> jenis item
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

    <!-- Dialog Tambah / Edit Jenis Item -->
    <v-dialog v-model="dialog" persistent max-width="480px">
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
                {{ isEditing ? 'Edit Jenis Item' : 'Tambah Jenis Item' }}
              </div>
              <div class="text-caption grey--text text--darken-1">
                {{ isEditing ? 'Perbarui kode & nama kategori barang' : 'Masukkan kategori atau jenis barang baru' }}
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
            <v-col cols="12" sm="5">
              <v-text-field
                label="Kode Jenis Item *"
                v-model="newJenisItem.kode"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="7">
              <v-text-field
                label="Nama Jenis Item *"
                v-model="newJenisItem.nama"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
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
            @click="addOrUpdateJenisItem"
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
import { isUnique, toUpperCaseFields, toUpperCase, filterData } from '../../mixins/FilterMixin';

export default {
  name: 'JenisItemView',
  data() {
    return {
      jeniss: [],
      newJenisItem: {},
      dialog: false,
      search: '',
      isEditing: false,
      toUpperCase: toUpperCase,
      currentPage: 1,
      pageSize: 10,
    };
  },
  computed: {
    filteredJeniss() {
      return filterData(this.jeniss, this.search);
    },
    totalPagesSafe() {
      return Math.max(1, Math.ceil(this.filteredJeniss.length / this.pageSize));
    },
    paginatedJeniss() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredJeniss.slice(start, start + this.pageSize);
    },
    startItemIndex() {
      if (!this.filteredJeniss.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.filteredJeniss.length) return 0;
      return Math.min(this.currentPage * this.pageSize, this.filteredJeniss.length);
    },
  },
  watch: {
    search() {
      this.currentPage = 1;
    },
    filteredJeniss(newList) {
      const maxPage = Math.max(1, Math.ceil(newList.length / this.pageSize));
      if (this.currentPage > maxPage) {
        this.currentPage = maxPage;
      }
    },
  },
  mounted() {
    this.loadJenisItem();
  },
  methods: {
    goToPage(page) {
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      this.currentPage = target;
    },

    loadJenisItem() {
      api.get('/m_jenis_item')
        .then(response => {
          this.jeniss = response.data;
        })
        .catch(error => {
          console.error('Error loading jenis item:', error);
        });
    },

    addJenisItem() {
      if (!this.newJenisItem.kode || !this.newJenisItem.nama) {
        alert('Kode dan Nama Jenis Item tidak boleh kosong');
        return;
      }
      this.newJenisItem.kode = this.newJenisItem.kode.toUpperCase();
      this.newJenisItem.nama = this.newJenisItem.nama.toUpperCase();
      if (!isUnique(this.jeniss, 'kode', this.newJenisItem.kode) || !isUnique(this.jeniss, 'nama', this.newJenisItem.nama)) {
        alert('Kode Jenis Item atau nama sudah digunakan, Silahkan gunakan Kode lain');
        return;
      }
      api.post('/m_jenis_item', this.newJenisItem)
        .then(response => {
          this.jeniss.push(response.data);
          this.newJenisItem = {};
          this.dialog = false;
          alert('Data berhasil ditambahkan.');
          this.loadJenisItem();
        })
        .catch(error => {
          console.error('Error adding jenis item:', error);
          alert('Terjadi kesalahan saat menambah jenis item.');
        });
    },

    openAddDialog() {
      this.newJenisItem = {};
      this.isEditing = false;
      this.dialog = true;
    },

    editJenisItem(id) {
      const found = this.jeniss.find(jenis => jenis.id === id);
      if (!found) return;
      this.newJenisItem = { ...found };
      this.isEditing = true;
      this.dialog = true;
    },

    updateJenisItem() {
      if (!this.newJenisItem.kode || !this.newJenisItem.nama) {
        alert('Kode dan Nama Jenis Item tidak boleh kosong');
        return;
      }
      const current = this.jeniss.find(jenis => jenis.id === this.newJenisItem.id);
      if (this.isEditing && current && this.newJenisItem.kode !== current.kode) {
        if (!isUnique(this.jeniss, 'kode', this.newJenisItem.kode)) {
          alert('Kode Jenis Item Sudah digunakan');
          return;
        }
      }
      toUpperCaseFields(this.newJenisItem, ['kode', 'nama']);
      api.put(`/m_jenis_item/${this.newJenisItem.id}`, this.newJenisItem)
        .then(response => {
          const index = this.jeniss.findIndex(jenis => jenis.id === this.newJenisItem.id);
          if (index !== -1) {
            this.jeniss.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadJenisItem();
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          alert('Gagal memperbarui data: ' + (error.response && error.response.data ? error.response.data.message : error.message));
        });
    },

    addOrUpdateJenisItem() {
      if (this.isEditing) {
        this.updateJenisItem();
      } else {
        this.addJenisItem();
      }
    },

    isKodeUnique(kode) {
      return !this.jeniss.some(jenis => jenis.kode === kode);
    },

    deleteJenisItem(id) {
      if (confirm('Apakah Anda yakin ingin menghapus jenis item ini?')) {
        api.delete('/m_jenis_item/' + id)
          .then(() => {
            this.loadJenisItem();
            alert('Data berhasil dihapus.');
          })
          .catch(error => {
            alert(error.response && error.response.data ? error.response.data.message : error.message);
            console.error('Error deleting jenis item:', error);
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

.jenis-row {
  transition: background-color 0.14s ease;
}

.jenis-row td {
  font-size: 12px !important;
  height: 38px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.jenis-row:hover {
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