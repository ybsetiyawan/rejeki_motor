<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Toolbar -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-package-variant-closed</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Laporan Stok Barang
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ totalItems }} Item
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Klik baris item untuk melihat riwayat transaksi keluar &amp; masuk
            </div>
          </div>
        </div>

        <div class="d-flex align-center mt-2 mt-sm-0">
          <v-btn
            small
            depressed
            color="amber lighten-4"
            class="amber--text text--darken-4 font-weight-medium mr-2 text-none"
            @click="exportToExcelMin5"
            title="Export Item dengan Stok ≤ 5"
          >
            <v-icon left small color="amber darken-4">mdi-alert-circle-outline</v-icon>
            Stok ≤ 5
          </v-btn>

          <v-btn
            small
            depressed
            color="green darken-1"
            class="white--text font-weight-medium text-none"
            @click="exportToExcel"
            title="Export Semua Data Stok ke Excel"
          >
            <v-icon left small>mdi-microsoft-excel</v-icon>
            Export Excel
          </v-btn>
        </div>
      </div>

      <!-- Search Bar -->
      <v-text-field
        v-model="searchQuery"
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
            :disabled="!searchQuery"
            @click="searchItems"
          >
            Cari
          </v-btn>
        </template>
      </v-text-field>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Utama Stok -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header>
        <thead>
          <tr>
            <th class="text-left" style="width: 110px;">KODE</th>
            <th class="text-left">NAMA ITEM</th>
            <th class="text-left" style="width: 170px;">KATEGORI</th>
            <th class="text-right" style="width: 120px;">STOK</th>
            <th class="text-center" style="width: 100px;">UOM</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="item in items"
            :key="item.id"
            class="stok-row"
            @click="openRiwayat(item)"
            title="Klik untuk melihat riwayat keluar & masuk"
          >
            <td>
              <span class="kode-red-pill">{{ item.kode }}</span>
            </td>
            <td class="font-weight-medium grey--text text--darken-4">
              {{ item.nama }}
            </td>
            <td class="grey--text text--darken-2">
              {{ item.jenis_item_nama || '-' }}
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
              {{ item.satuan_nama || '-' }}
            </td>
          </tr>

          <tr v-if="!items || items.length === 0">
            <td colspan="5" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-package-variant-remove</v-icon>
              <div>Belum ada data stok barang yang ditampilkan.</div>
            </td>
          </tr>
        </tbody>
      </v-simple-table>
    </div>

    <!-- Footer Pagination Nuansa Merah Bengkel -->
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

    <!-- Dialog Riwayat Keluar & Masuk Item -->
    <v-dialog v-model="riwayatDialog" max-width="1020px" scrollable>
      <v-card class="rounded-lg">
        <!-- Modal Header -->
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="40" class="mr-3 bengkel-avatar-ring">
              <v-icon color="red darken-2">mdi-history</v-icon>
            </v-avatar>
            <div>
              <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
                {{ selectedItem ? selectedItem.nama : 'Riwayat Item' }}
              </div>
              <div class="d-flex flex-wrap align-center mt-1" v-if="selectedItem">
                <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="mr-2 font-weight-bold">
                  Kode: {{ selectedItem.kode }}
                </v-chip>
                <v-chip
                  x-small
                  label
                  class="font-weight-bold"
                  :color="getStokChipColor(selectedItem.stok)"
                  :text-color="getStokTextColor(selectedItem.stok)"
                >
                  Stok Saat Ini: {{ selectedItem.stok }}
                </v-chip>
              </div>
            </div>
          </div>

          <v-spacer></v-spacer>
          <v-btn icon small color="grey darken-1" @click="riwayatDialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>

        <div class="bengkel-stripe"></div>

        <!-- Ringkasan Cepat -->
        <div v-if="!loadingRiwayat && !riwayatError && selectedItem" class="px-5 py-3 grey lighten-5 border-bottom-light">
          <v-row dense>
            <v-col cols="12" sm="4">
              <div class="mini-stat-box">
                <div class="text-caption grey--text text--darken-1">Total Qty Keluar</div>
                <div class="text-subtitle-2 font-weight-bold grey--text text--darken-4">{{ totalQtyKeluar }}</div>
              </div>
            </v-col>
            <v-col cols="12" sm="4">
              <div class="mini-stat-box">
                <div class="text-caption grey--text text--darken-1">Total Laba Keluar</div>
                <div class="text-subtitle-2 font-weight-bold red--text text--darken-3">{{ formatRupiah(totalLabaKeluar) }}</div>
              </div>
            </v-col>
            <v-col cols="12" sm="4">
              <div class="mini-stat-box">
                <div class="text-caption grey--text text--darken-1">Total Qty Masuk</div>
                <div class="text-subtitle-2 font-weight-bold grey--text text--darken-4">{{ totalQtyMasuk }}</div>
              </div>
            </v-col>
          </v-row>
        </div>

        <!-- Tabs -->
        <v-tabs v-model="activeTab" color="red darken-2" slider-size="3" grow>
          <v-tab href="#tab-keluar" class="text-none font-weight-medium">
            <v-icon left small color="red darken-2">mdi-arrow-top-right</v-icon>
            Keluar ({{ riwayatKeluar.length }})
          </v-tab>
          <v-tab href="#tab-masuk" class="text-none font-weight-medium">
            <v-icon left small color="grey darken-2">mdi-arrow-bottom-left</v-icon>
            Masuk ({{ riwayatMasuk.length }})
          </v-tab>
        </v-tabs>

        <v-divider></v-divider>

        <!-- Modal Body -->
        <v-card-text class="pa-5" style="max-height: 450px;">
          <div v-if="loadingRiwayat" class="text-center py-10">
            <v-progress-circular indeterminate color="red darken-2"></v-progress-circular>
            <div class="text-caption grey--text mt-3">Memuat riwayat transaksi item...</div>
          </div>

          <v-alert v-else-if="riwayatError" type="error" dense text class="my-2">
            {{ riwayatError }}
          </v-alert>

          <v-tabs-items v-else v-model="activeTab">
            <!-- Tab 1: Keluar -> No. Faktur, Kode, Tanggal, Qty, Harga Jual, Modal, Laba -->
            <v-tab-item value="tab-keluar">
              <v-simple-table dense v-if="riwayatKeluar.length > 0" class="detail-history-table">
                <thead>
                  <tr>
                    <th class="text-left">No. Faktur</th>
                    <th class="text-left">Kode</th>
                    <th class="text-left">Tanggal</th>
                    <th class="text-right">Qty</th>
                    <th class="text-right">Harga Jual</th>
                    <th class="text-right">Modal</th>
                    <th class="text-right">Laba</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="row in riwayatKeluar" :key="row.id">
                    <td class="font-weight-medium">{{ row.no_faktur || '-' }}</td>
                    <td><span class="kode-mini">{{ kodeItemAktif }}</span></td>
                    <td>{{ formatDate(row.tanggal) }}</td>
                    <td class="text-right font-weight-medium">{{ row.qty }}</td>
                    <td class="text-right">{{ formatRupiah(row.harga_jual) }}</td>
                    <td class="text-right grey--text text--darken-1">{{ formatRupiah(row.modal) }}</td>
                    <td class="text-right font-weight-bold red--text text--darken-3">
                      {{ formatRupiah(row.laba) }}
                    </td>
                  </tr>
                  <tr class="summary-total-row">
                    <td class="font-weight-bold grey--text text--darken-4">Total</td>
                    <td></td>
                    <td></td>
                    <td class="text-right font-weight-bold grey--text text--darken-4">{{ totalQtyKeluar }}</td>
                    <td></td>
                    <td></td>
                    <td class="text-right font-weight-bold red--text text--darken-4">
                      {{ formatRupiah(totalLabaKeluar) }}
                    </td>
                  </tr>
                </tbody>
              </v-simple-table>
              <div v-else class="text-center grey--text py-8">
                <v-icon large color="red lighten-3" class="mb-2">mdi-receipt-text-remove-outline</v-icon>
                <div>Belum ada riwayat transaksi keluar untuk item ini.</div>
              </div>
            </v-tab-item>

            <!-- Tab 2: Masuk -> No. Receipt, Kode, Tgl, Supplier, Qty, Modal, Sisa Barang -->
            <v-tab-item value="tab-masuk">
              <v-simple-table dense v-if="riwayatMasuk.length > 0" class="detail-history-table">
                <thead>
                  <tr>
                    <th class="text-left">No. Receipt</th>
                    <th class="text-left">Kode</th>
                    <th class="text-left">Tgl</th>
                    <th class="text-left">Supplier</th>
                    <th class="text-right">Qty</th>
                    <th class="text-right">Modal</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="row in riwayatMasuk" :key="row.id">
                    <td class="font-weight-medium">{{ row.no_receipt || '-' }}</td>
                    <td><span class="kode-mini">{{ kodeItemAktif }}</span></td>
                    <td>{{ formatDate(row.tanggal) }}</td>
                    <td class="font-weight-medium grey--text text--darken-3">{{ row.supplier || '-' }}</td>
                    <td class="text-right font-weight-medium">{{ row.qty }}</td>
                    <td class="text-right grey--text text--darken-1">{{ formatRupiah(row.modal) }}</td>
                  
                  </tr>
                  <tr class="summary-total-row">
                    <td class="font-weight-bold grey--text text--darken-4">Total Masuk</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td class="text-right font-weight-bold grey--text text--darken-4">{{ totalQtyMasuk }}</td>
                    <td></td>
                  </tr>
                </tbody>
              </v-simple-table>
              <div v-else class="text-center grey--text py-8">
                <v-icon large color="red lighten-3" class="mb-2">mdi-truck-remove-outline</v-icon>
                <div>Belum ada riwayat transaksi masuk untuk item ini.</div>
              </div>
            </v-tab-item>
          </v-tabs-items>
        </v-card-text>

        <v-divider></v-divider>
        <v-card-actions class="px-5 py-3 grey lighten-5">
          <v-spacer></v-spacer>
          <v-btn depressed color="red darken-2" class="white--text text-none px-4" @click="riwayatDialog = false">
            Tutup
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<script>
import { loadItems } from '../../utils/utils';
import api from '../../services/api';
import * as XLSX from 'xlsx';

export default {
  data() {
    return {
      items: [],
      searchQuery: '',
      stockFilter: null,
      lessThanFive: false,
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,

      // State dialog riwayat item
      riwayatDialog: false,
      activeTab: 'tab-keluar',
      loadingRiwayat: false,
      riwayatError: '',
      selectedItem: null,
      riwayatKeluar: [],
      riwayatMasuk: [],
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
    kodeItemAktif() {
      return (this.selectedItem && this.selectedItem.kode) || '-';
    },
    totalQtyKeluar() {
      return this.riwayatKeluar.reduce((sum, row) => sum + (Number(row.qty) || 0), 0);
    },
    totalLabaKeluar() {
      return this.riwayatKeluar.reduce((sum, row) => sum + (Number(row.laba) || 0), 0);
    },
    totalQtyMasuk() {
      return this.riwayatMasuk.reduce((sum, row) => sum + (Number(row.qty) || 0), 0);
    },
  },
  mounted() {
    this.loadItems();
  },
  methods: {
    loadItems() {
      return loadItems(this.currentPage, this.pageSize, this.searchQuery)
        .then(data => {
          this.items = data.items;
          this.totalItems = data.total;
        })
        .catch(error => console.error('Error Loading Items:', error));
    },

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
      return 'grey lighten-4';
    },

    getStokTextColor(stok) {
      const n = Number(stok);
      if (n <= 0) return 'red darken-4';
      if (n <= 5) return 'amber darken-4';
      return 'grey darken-4';
    },

    async openRiwayat(item) {
      if (!item || !item.id) return;

      this.selectedItem = item;
      this.activeTab = 'tab-keluar';
      this.riwayatKeluar = [];
      this.riwayatMasuk = [];
      this.riwayatError = '';
      this.loadingRiwayat = true;
      this.riwayatDialog = true;

      try {
        const res = await api.get(`/m_item/${item.id}/riwayat`);
        const data = res && res.data ? res.data : res;

        if (data.item) {
          this.selectedItem = { ...item, ...data.item };
        }
        this.riwayatKeluar = Array.isArray(data.keluar) ? data.keluar : [];
        this.riwayatMasuk = Array.isArray(data.masuk) ? data.masuk : [];
      } catch (err) {
        this.riwayatError =
          (err.response && err.response.data && err.response.data.message) ||
          err.message ||
          'Terjadi kesalahan saat mengambil data';
      } finally {
        this.loadingRiwayat = false;
      }
    },

    formatDate(date) {
      if (!date) return '-';
      const parsed = new Date(date);
      if (Number.isNaN(parsed.getTime())) return date;
      const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
      return new Intl.DateTimeFormat('id-ID', options).format(parsed).replace(/ /g, '/');
    },

    formatRupiah(value) {
      const num = Number(value);
      if (Number.isNaN(num)) return 'Rp 0';
      return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }).format(num);
    },

    searchItems() {
      this.currentPage = 1;
      this.loadItems().then(() => {
        if (this.items.length === 0) {
          alert('Tidak ada item yang ditemukan.');
        }
      });
    },

    clearSearch() {
      this.searchQuery = '';
      this.currentPage = 1;
      this.loadItems();
    },

    exportToExcel() {
      loadItems(1, 100000, '').then(data => {
        const worksheet = XLSX.utils.json_to_sheet(data.items);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Items');
        XLSX.writeFile(workbook, 'laporan_stok_barang.xlsx');
      }).catch(error => console.error('Error Loading All Items:', error));
    },

    exportToExcelMin5() {
      loadItems(1, 10000, '').then(data => {
        const filteredItems = data.items.filter(item => item.stok <= 5);
        const worksheet = XLSX.utils.json_to_sheet(filteredItems);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Items');
        XLSX.writeFile(workbook, 'laporan_stok_barang ≤ 5.xlsx');
      }).catch(error => console.error('Error Loading All Items:', error));
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

.border-bottom-light {
  border-bottom: 1px solid #f1dcdc;
}

.table-scroll-wrapper {
  max-height: 500px;
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

.stok-row {
  cursor: pointer;
  transition: background-color 0.14s ease;
}

.stok-row td {
  font-size: 12px !important;
  height: 36px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.stok-row:hover {
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

.kode-mini {
  display: inline-block;
  padding: 1px 6px;
  border-radius: 4px;
  background-color: #fef2f2;
  color: #991b1b;
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

.mini-stat-box {
  background-color: #ffffff;
  border: 1px solid #f1dcdc;
  border-radius: 8px;
  padding: 8px 12px;
}

.detail-history-table th {
  font-size: 11px !important;
  font-weight: 700 !important;
  color: #7f1d1d !important;
  background-color: #fef2f2 !important;
  border-bottom: 1px solid #fecaca !important;
}

.detail-history-table td {
  font-size: 12px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.summary-total-row td {
  background-color: #fff5f5 !important;
  border-top: 2px solid #fca5a5 !important;
}
</style>