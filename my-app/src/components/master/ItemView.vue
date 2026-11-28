<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Toolbar -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-tools</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Master Item
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ totalItems }} Item
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Kelola katalog sparepart, oli, harga modal, HPP &amp; satuan barang bengkel
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
            Tambah Item
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
        placeholder="Cari berdasarkan kode atau nama item..."
        prepend-inner-icon="mdi-magnify"
        @keyup.enter="searchItems"
        @click:clear="clearSearch"
      >
        <template v-slot:append>
          <v-btn
            x-small
            depressed
            color="red darken-2"
            class="white--text text-none px-3"
            :disabled="!search"
            @click="searchItems"
          >
            Cari
          </v-btn>
        </template>
      </v-text-field>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Master Item -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header>
        <thead>
          <tr>
            <th class="text-left" style="width: 105px;">KODE</th>
            <th class="text-left">NAMA ITEM</th>
            <th class="text-left" style="width: 155px;">JENIS ITEM</th>
            <th class="text-right" style="width: 125px;">MODAL</th>
            <th class="text-right" style="width: 125px;">HPP</th>
            <th class="text-right" style="width: 95px;">STOK</th>
            <th class="text-center" style="width: 85px;">UOM</th>
            <th class="text-center" style="width: 110px;">AKSI</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="item in items"
            :key="item.id"
            class="item-row"
          >
            <td>
              <span class="kode-red-pill">{{ toUpperCase(item.kode) }}</span>
            </td>
            <td class="font-weight-bold grey--text text--darken-4">
              {{ toUpperCase(item.nama) }}
            </td>
            <td class="grey--text text--darken-2">
              {{ toUpperCase(item.jenis_item_nama) || '-' }}
            </td>
            <td class="text-right grey--text text--darken-3">
              {{ formatHarga(item.modal) }}
            </td>
            <td class="text-right font-weight-medium grey--text text--darken-4">
              {{ formatHarga(item.hpp) }}
            </td>
            <td class="text-right">
              <v-chip
                x-small
                label
                class="font-weight-bold"
                :color="getStokChipColor(item.stok)"
                :text-color="getStokTextColor(item.stok)"
              >
                {{ item.stok }}
              </v-chip>
            </td>
            <td class="text-center grey--text text--darken-1">
              {{ toUpperCase(item.satuan_nama) || '-' }}
            </td>
            <td class="text-center">
              <v-btn
                icon
                small
                color="red darken-2"
                class="mr-1"
                @click="editItem(item.id)"
                title="Edit Item"
              >
                <v-icon small>mdi-pencil-outline</v-icon>
              </v-btn>
              <v-btn
                icon
                small
                color="grey darken-2"
                @click="deleteItem(item.id)"
                title="Hapus Item"
              >
                <v-icon small>mdi-delete-outline</v-icon>
              </v-btn>
            </td>
          </tr>

          <tr v-if="!items || items.length === 0">
            <td colspan="8" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-package-variant-remove</v-icon>
              <div>Tidak ada data item yang ditemukan.</div>
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
        <strong class="grey--text text--darken-4">{{ totalItems }}</strong> item
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

    <!-- Dialog Tambah / Edit Item -->
    <v-dialog v-model="dialog" persistent max-width="520px">
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
                {{ isEditing ? 'Edit Item' : 'Tambah Item Baru' }}
              </div>
              <div class="text-caption grey--text text--darken-1">
                {{ isEditing ? 'Perbarui informasi barang, modal, HPP & kategori' : 'Masukkan data barang baru ke master item' }}
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
            <v-col cols="12" sm="4">
              <v-text-field
                label="Kode Item"
                v-model="newItem.kode"
                color="red darken-2"
                outlined
                dense
                disabled
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="8">
              <v-text-field
                label="Nama Item *"
                v-model="newItem.nama"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="6">
              <v-select
                label="Jenis Item *"
                v-model="newItem.jenis_item_id"
                :items="jenisItems"
                item-text="nama"
                item-value="id"
                color="red darken-2"
                outlined
                dense
                required
              ></v-select>
            </v-col>
            <v-col cols="12" sm="6">
              <v-select
                label="Satuan *"
                v-model="newItem.satuan_id"
                :items="satuanItems"
                item-text="nama"
                item-value="id"
                color="red darken-2"
                outlined
                dense
                required
              ></v-select>
            </v-col>
            <v-col cols="12" sm="4">
              <v-text-field
                label="Modal *"
                v-model="newItem.modal"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="4">
              <v-text-field
                label="HPP *"
                v-model="newItem.hpp"
                color="red darken-2"
                outlined
                dense
                required
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="4">
              <v-text-field
                label="Stok"
                v-model="newItem.stok"
                color="red darken-2"
                outlined
                dense
                disabled
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
            @click="addOrUpdateItem"
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
import { formatHarga, isUnique, toUpperCase, toUpperCaseFields } from '../../mixins/FilterMixin';

export default {
  name: 'ItemView',
  data() {
    return {
      items: [],
      newItem: {},
      dialog: false,
      search: '',
      isEditing: false,
      jenisItems: [],
      satuanItems: [],
      valid: true,
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,
      formatHarga,
      toUpperCase,
    };
  },
  computed: {
    pageCount() {
      return Math.ceil(this.totalItems / this.pageSize);
    },
    totalPagesSafe() {
      return Math.max(1, this.pageCount);
    },
    startItemIndex() {
      if (!this.totalItems || !this.items.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.totalItems || !this.items.length) return 0;
      return Math.min(this.currentPage * this.pageSize, this.totalItems);
    },
  },
  mounted() {
    this.loadItems();
    this.loadJenisItems();
    this.loadSatuanItems();
  },
  methods: {
    goToPage(page) {
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      if (target === this.currentPage) return;
      this.currentPage = target;
      this.loadItems();
    },

    getStokChipColor(stok) {
      const n = Number(stok);
      if (n <= 0) return 'red lighten-5';
      if (n <= 5) return 'amber lighten-4';
      return 'red lighten-5';
    },

    getStokTextColor(stok) {
      const n = Number(stok);
      if (n <= 0) return 'red darken-4';
      if (n <= 5) return 'amber darken-4';
      return 'red darken-2';
    },

    loadItems() {
      return api.get('/m_item', {
        params: {
          page: this.currentPage,
          pageSize: this.pageSize,
          search: this.search,
        },
      })
        .then(response => {
          this.items = response.data.items;
          this.totalItems = response.data.total;
        })
        .catch(error => {
          console.error('Error loading items:', error);
        });
    },

    loadJenisItems() {
      api.get('/m_jenis_item')
        .then(response => {
          this.jenisItems = response.data;
        })
        .catch(error => console.error('Error loading jenis items:', error));
    },

    loadSatuanItems() {
      api.get('/m_satuan')
        .then(response => {
          this.satuanItems = response.data;
        })
        .catch(error => console.error('Error loading satuan items:', error));
    },

    addItem() {
      if (!this.newItem.nama || !this.newItem.hpp || !this.newItem.modal) {
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      this.newItem.nama = this.newItem.nama.toUpperCase();
      if (!isUnique(this.items, 'kode', this.newItem.kode)) {
        alert('kode sudah digunakan, Silahkan gunakan lain');
        return;
      }
      toUpperCaseFields(this.newItem, ['kode']);
      if (!isUnique(this.items, 'kode', this.newItem.kode)) {
        alert('kode Item sudah digunakan, Silahkan gunakan lain');
        return;
      }

      api.post('/m_item', {
        nama: this.newItem.nama,
        id_jenis_item: this.newItem.jenis_item_id,
        modal: this.newItem.modal,
        hpp: this.newItem.hpp,
        stok: 0,
        id_satuan: this.newItem.satuan_id,
      })
        .then(response => {
          this.items.push(response.data);
          this.newItem = {};
          this.dialog = false;
          alert('Data berhasil ditambahkan');
          this.loadItems();
        })
        .catch(error => {
          console.error('Error adding item:', error);
          alert('Terjadi kesalahan saat menambah item.');
        });
    },

    openAddDialog() {
      this.newItem = { stok: 0 };
      this.isEditing = false;
      this.dialog = true;
    },

    editItem(id) {
      const found = this.items.find(item => item.id === id);
      if (!found) return;
      this.isEditing = true;
      this.newItem = {
        ...found,
        jenis_item_id: found.jenis_item_id || found.id_jenis_item,
        satuan_id: found.satuan_id || found.id_satuan,
      };
      this.dialog = true;
    },

    updateItem() {
      if (!this.newItem.nama || !this.newItem.hpp || !this.newItem.modal
        || !this.newItem.jenis_item_id || !this.newItem.satuan_id) {
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }

      toUpperCaseFields(this.newItem, ['kode', 'nama']);

      api.put(`/m_item/${this.newItem.id}`, {
        kode: this.newItem.kode,
        nama: this.newItem.nama,
        id_jenis_item: this.newItem.jenis_item_id,
        modal: this.newItem.modal,
        hpp: this.newItem.hpp,
        stok: this.newItem.stok,
        id_satuan: this.newItem.satuan_id,
      })
        .then(response => {
          const index = this.items.findIndex(item => item.id === this.newItem.id);
          if (index !== -1) {
            this.items.splice(index, 1, response.data);
          }
          this.newItem = {};
          this.dialog = false;
          alert('Data berhasil diperbarui');
          this.loadItems();
        })
        .catch(error => {
          console.error('Error updating item:', error);
          alert('Terjadi kesalahan saat memperbarui item.');
        });
    },

    addOrUpdateItem() {
      if (!this.isValidInteger(Number(this.newItem.hpp))
        || !this.isValidInteger(Number(this.newItem.modal))) {
        alert('HPP dan Modal harus berupa angka bulat.');
        return;
      }

      if (this.isEditing) {
        this.updateItem();
      } else {
        this.addItem();
      }
    },

    deleteItem(id) {
      if (confirm('Apakah Anda yakin ingin menghapus item ini?')) {
        api.delete(`/m_item/${id}`)
          .then(() => {
            this.items = this.items.filter(item => item.id !== id);
            alert('Data berhasil dihapus');
          })
          .catch(error => {
            console.error('Error deleting item:', error);
            alert('Data Item Tidak Bisa Dihapus: ' + error.message);
          });
      }
    },

    isUnique(kode) {
      return !this.items.some(item => item.kode === kode);
    },

    isValidInteger(value) {
      return Number.isInteger(value);
    },

    clearSearch() {
      this.search = '';
      this.currentPage = 1;
      this.loadItems();
    },

    searchItems() {
      this.currentPage = 1;
      this.loadItems().then(() => {
        if (this.items.length === 0) {
          alert('Tidak ada item yang ditemukan.');
        }
      });
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

.item-row {
  transition: background-color 0.14s ease;
}

.item-row td {
  font-size: 12px !important;
  height: 38px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.item-row:hover {
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