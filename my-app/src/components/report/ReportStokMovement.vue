<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Filter -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-swap-horizontal-bold</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Laporan Pergerakan Stok
              </span>
              <v-chip
                x-small
                label
                color="red lighten-5"
                text-color="red darken-3"
                class="font-weight-bold"
              >
                {{ totalItems }} Mutasi
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Kartu pergerakan stok per item (Penerimaan, Retur Customer, Penjualan, Retur Supplier)
            </div>
          </div>
        </div>

        <div class="mt-2 mt-sm-0" :title="exportDisabledReason">
          <v-btn
            small
            depressed
            color="green darken-1"
            class="white--text font-weight-medium text-none px-4"
            :disabled="!canExportExcel"
            @click="exportToExcel"
          >
            <v-icon left small>mdi-microsoft-excel</v-icon>
            Export Excel
          </v-btn>
        </div>
      </div>

      <!-- Alert jika ada error API atau validasi -->
      <v-alert
        v-if="errorMessage"
        type="error"
        dense
        outlined
        class="mb-3"
      >
        {{ errorMessage }}
      </v-alert>

      <!-- Filter Item, Jenis Mutasi, Tanggal & Tombol Tampilkan -->
      <v-row dense align="center">
        <v-col cols="12" sm="6" md="4">
          <v-autocomplete
            v-model="selectedItemId"
            :items="itemOptions"
            item-text="label"
            item-value="id"
            label="Pilih / Cari Item *"
            color="red darken-2"
            outlined
            dense
            clearable
            hide-details
            background-color="white"
            @change="onFilterParamChange"
          ></v-autocomplete>
        </v-col>

        <v-col cols="12" sm="6" md="2">
          <v-select
            v-model="jenisMutasi"
            :items="jenisOptions"
            item-text="text"
            item-value="value"
            label="Jenis Mutasi"
            color="red darken-2"
            outlined
            dense
            hide-details
            background-color="white"
          ></v-select>
        </v-col>

        <v-col cols="12" sm="4" md="2">
          <v-text-field
            v-model="dateFrom"
            type="date"
            label="Dari Tanggal *"
            color="red darken-2"
            outlined
            dense
            hide-details
            background-color="white"
            @change="onFilterParamChange"
          ></v-text-field>
        </v-col>

        <v-col cols="12" sm="4" md="2">
          <v-text-field
            v-model="dateTo"
            type="date"
            label="Sampai Tanggal *"
            color="red darken-2"
            outlined
            dense
            hide-details
            background-color="white"
            @change="onFilterParamChange"
          ></v-text-field>
        </v-col>

        <v-col cols="12" sm="4" md="2" class="d-flex align-center">
          <v-btn
            small
            depressed
            color="red darken-2"
            class="white--text font-weight-medium text-none px-4 mr-2"
            :loading="loading"
            :disabled="!canFetchMovements"
            @click="applyFilter"
          >
            <v-icon left small>mdi-magnify</v-icon>
            Tampilkan
          </v-btn>

          <v-btn
            icon
            small
            outlined
            color="grey darken-1"
            title="Reset Filter"
            @click="resetFilter"
          >
            <v-icon small>mdi-refresh</v-icon>
          </v-btn>
        </v-col>
      </v-row>

      <!-- Pencarian Teks -->
      <v-row dense class="mt-2">
        <v-col cols="12">
          <v-text-field
            v-model="search"
            label="Cari no. dokumen atau jenis mutasi pada item terpilih..."
            prepend-inner-icon="mdi-magnify"
            color="red darken-2"
            outlined
            dense
            clearable
            hide-details
            background-color="white"
            :disabled="!hasSearchedItem"
            @keyup.enter="applyFilter"
            @click:clear="clearSearch"
          ></v-text-field>
        </v-col>
      </v-row>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Tabel Pergerakan Stok -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header height="460px">
        <thead>
          <tr>
            <th class="text-left" style="width: 120px;">TANGGAL</th>
            <th class="text-left" style="width: 120px;">NO. DOKUMEN</th>
            <th class="text-left" style="width: 135px;">JENIS MUTASI</th>
            <th class="text-left" style="width: 90px;">KODE</th>
            <th class="text-left">NAMA ITEM</th>
            <th class="text-center" style="width: 75px;">SATUAN</th>
            <th class="text-right" style="width: 95px;">MASUK (+)</th>
            <th class="text-right" style="width: 95px;">KELUAR (-)</th>
            <th class="text-right" style="width: 105px;">SISA STOK</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(row, idx) in movements"
            :key="`${row.jenis_mutasi}-${row.no_dokumen}-${row.id_item}-${idx}`"
            class="movement-row"
          >
            <td class="grey--text text--darken-3">{{ formatDate(row.tgl_transaksi) }}</td>
            <td><span class="kode-red-pill">{{ row.no_dokumen || '-' }}</span></td>
            <td>
              <v-chip
                x-small
                label
                class="font-weight-bold"
                :color="getJenisColor(row.jenis_mutasi)"
                :text-color="getJenisTextColor(row.jenis_mutasi)"
              >
                {{ formatJenisLabel(row.jenis_mutasi) }}
              </v-chip>
            </td>
            <td><span class="kode-mini">{{ row.kode_item || '-' }}</span></td>
            <td class="font-weight-medium grey--text text--darken-4">{{ row.nama_item || '-' }}</td>
            <td class="text-center grey--text text--darken-1">{{ row.satuan_nama || '-' }}</td>
            <td class="text-right font-weight-bold green--text text--darken-3">
              {{ Number(row.qty_masuk) > 0 ? `+${row.qty_masuk}` : '-' }}
            </td>
            <td class="text-right font-weight-bold red--text text--darken-3">
              {{ Number(row.qty_keluar) > 0 ? `-${row.qty_keluar}` : '-' }}
            </td>
            <td class="text-right font-weight-bold grey--text text--darken-4">
              {{ row.sisa_stok }}
            </td>
          </tr>

          <tr v-if="!movements || movements.length === 0">
            <td colspan="9" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-swap-horizontal</v-icon>
              <div v-if="loading">Memuat data pergerakan stok...</div>
              <div v-else-if="!isDateOrderValid">
                <strong>Dari Tanggal</strong> tidak boleh lebih besar dari <strong>Sampai Tanggal</strong>.
              </div>
              <div v-else-if="!selectedItemId || !dateFrom || !dateTo || !hasSearchedItem">
                Pilih/cari <strong>Item</strong> dan isi <strong>Dari Tanggal</strong> serta <strong>Sampai Tanggal</strong>, lalu klik <strong>Tampilkan</strong>.
              </div>
              <div v-else>Tidak ada data pergerakan stok pada rentang tanggal yang dipilih.</div>
            </td>
          </tr>
        </tbody>
      </v-simple-table>
    </div>

    <!-- Footer Paginasi Server-Side -->
    <div class="pagination-bar px-5 py-3 d-flex flex-wrap align-center justify-space-between">
      <div class="text-caption grey--text text--darken-2">
        Menampilkan
        <strong class="red--text text--darken-3">{{ startItemIndex }}–{{ endItemIndex }}</strong>
        dari
        <strong class="grey--text text--darken-4">{{ totalItems }}</strong> mutasi
      </div>

      <div class="d-flex align-center">
        <v-btn
          icon
          small
          outlined
          color="red darken-2"
          class="mr-2 page-nav-btn"
          :disabled="currentPage <= 1 || loading || !hasSearchedItem"
          @click="goToPage(1)"
        >
          <v-icon small>mdi-chevron-double-left</v-icon>
        </v-btn>

        <v-btn
          small
          outlined
          color="red darken-2"
          class="text-none font-weight-medium mr-2 page-step-btn"
          :disabled="currentPage <= 1 || loading || !hasSearchedItem"
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
          :disabled="currentPage >= totalPagesSafe || loading || !hasSearchedItem"
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
          :disabled="currentPage >= totalPagesSafe || loading || !hasSearchedItem"
          @click="goToPage(totalPagesSafe)"
        >
          <v-icon small>mdi-chevron-double-right</v-icon>
        </v-btn>
      </div>
    </div>
  </v-card>
</template>

<script>
import { loadItems } from '../../utils/utils';
import api from '../../services/api';
import * as XLSX from 'xlsx';

export default {
  name: 'ReportStockMovementView',
  data() {
    return {
      selectedItemId: null,
      itemOptions: [],
      jenisMutasi: 'ALL',
      jenisOptions: [
        { text: 'Semua Mutasi', value: 'ALL' },
        { text: 'Penerimaan (+)', value: 'RECEIPT' },
        { text: 'Retur Customer (+)', value: 'RETUR_SALES' },
        { text: 'Penjualan (-)', value: 'SALES' },
        { text: 'Retur Supplier (-)', value: 'RETUR_RECEIPT' },
      ],
      dateFrom: '',
      dateTo: '',
      search: '',
      movements: [],
      totalItems: 0,
      hasSearchedItem: false,
      loading: false,
      errorMessage: '',
      currentPage: 1,
      pageSize: 20,
    };
  },
  computed: {
    totalPagesSafe() {
      return Math.max(1, Math.ceil(this.totalItems / this.pageSize));
    },
    startItemIndex() {
      if (!this.totalItems || !this.movements.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.totalItems || !this.movements.length) return 0;
      return Math.min((this.currentPage - 1) * this.pageSize + this.movements.length, this.totalItems);
    },
    hasRequiredFilters() {
      return Boolean(this.selectedItemId && this.dateFrom && this.dateTo);
    },
    isDateOrderValid() {
      if (!this.dateFrom || !this.dateTo) return true;
      return this.dateFrom <= this.dateTo;
    },
    canFetchMovements() {
      return !this.loading && this.hasRequiredFilters && this.isDateOrderValid;
    },
    canExportExcel() {
      return (
        !this.loading &&
        this.hasSearchedItem &&
        this.hasRequiredFilters &&
        this.isDateOrderValid &&
        this.movements.length > 0
      );
    },
    exportDisabledReason() {
      if (!this.selectedItemId) return 'Pilih/cari Item terlebih dahulu';
      if (!this.dateFrom || !this.dateTo) return 'Lengkapi Dari Tanggal dan Sampai Tanggal';
      if (!this.isDateOrderValid) return 'Dari Tanggal tidak boleh lebih besar dari Sampai Tanggal';
      if (!this.hasSearchedItem) return 'Klik Tampilkan untuk memuat data terlebih dahulu';
      if (this.movements.length === 0) return 'Tidak ada data mutasi untuk di-export';
      return 'Export Kartu Pergerakan Stok ke Excel';
    },
  },
  watch: {
    '$route.query.id_item': {
      immediate: false,
      async handler(newId) {
        if (newId) {
          this.selectedItemId = Number(newId);
          this.currentPage = 1;
          this.hasSearchedItem = false;
          if (this.hasRequiredFilters && this.isDateOrderValid) {
            await this.fetchMovements();
          }
        }
      },
    },
  },
  async mounted() {
    await this.loadItemOptions();
    if (this.$route && this.$route.query && this.$route.query.id_item) {
      this.selectedItemId = Number(this.$route.query.id_item);
      if (this.hasRequiredFilters && this.isDateOrderValid) {
        await this.fetchMovements();
      }
    }
  },
  methods: {
    async loadItemOptions() {
      try {
        let list = [];
        if (typeof loadItems === 'function') {
          const res = await loadItems(1, 5000, '');
          list = (res && (res.items || (res.data && res.data.items))) || [];
        }
        if (!list.length && api && typeof api.get === 'function') {
          const res = await api.get('/m_item', { params: { page: 1, pageSize: 5000 } });
          list = (res && res.data && (res.data.items || res.data)) || [];
        }
        if (Array.isArray(list)) {
          this.itemOptions = list.map((i) => ({
            id: i.id,
            label: `${i.kode} - ${i.nama}`,
          }));
        }
      } catch (e) {
        console.error('Gagal memuat daftar item:', e);
      }
    },

    onFilterParamChange() {
      this.movements = [];
      this.totalItems = 0;
      this.hasSearchedItem = false;
      this.currentPage = 1;
      if (!this.isDateOrderValid) {
        this.errorMessage = 'Dari Tanggal tidak boleh lebih besar dari Sampai Tanggal.';
      } else {
        this.errorMessage = '';
      }
    },

    getSelectedItemInfo() {
      const found = (this.itemOptions || []).find((i) => i.id === this.selectedItemId);
      if (!found) {
        return { kode: '-', nama: '-', label: '-' };
      }
      const parts = (found.label || '').split(' - ');
      return {
        kode: parts[0] || '-',
        nama: parts.slice(1).join(' - ') || found.label || '-',
        label: found.label,
      };
    },

    goToPage(page) {
      if (!this.hasSearchedItem || !this.canFetchMovements) return;
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      if (target === this.currentPage) return;
      this.currentPage = target;
      this.fetchMovements();
    },

    applyFilter() {
      this.errorMessage = '';
      if (!this.selectedItemId) {
        this.errorMessage = 'Silakan pilih/cari Item terlebih dahulu.';
        return;
      }
      if (!this.dateFrom || !this.dateTo) {
        this.errorMessage = 'Silakan lengkapi Dari Tanggal dan Sampai Tanggal.';
        return;
      }
      if (!this.isDateOrderValid) {
        this.errorMessage = 'Dari Tanggal tidak boleh lebih besar dari Sampai Tanggal.';
        return;
      }
      this.currentPage = 1;
      this.fetchMovements();
    },

    clearSearch() {
      this.search = '';
      if (this.hasSearchedItem && this.canFetchMovements) {
        this.currentPage = 1;
        this.fetchMovements();
      }
    },

    resetFilter() {
      this.selectedItemId = null;
      this.jenisMutasi = 'ALL';
      this.dateFrom = '';
      this.dateTo = '';
      this.search = '';
      this.movements = [];
      this.totalItems = 0;
      this.hasSearchedItem = false;
      this.errorMessage = '';
      this.currentPage = 1;
    },

    async fetchMovements() {
      if (!this.canFetchMovements) return;

      this.loading = true;
      this.errorMessage = '';
      try {
        const res = await api.get('/report_stockmovement', {
          params: {
            id_item: this.selectedItemId,
            jenis_mutasi: this.jenisMutasi !== 'ALL' ? this.jenisMutasi : undefined,
            dateFrom: this.dateFrom,
            dateTo: this.dateTo,
            search: this.search || undefined,
            page: this.currentPage,
            pageSize: this.pageSize,
            _t: Date.now(),
          },
        });

        const raw = res && res.data ? res.data : null;
        const rows = Array.isArray(raw)
          ? raw
          : Array.isArray(raw && raw.data)
          ? raw.data
          : [];

        this.movements = rows;
        this.totalItems =
          raw && !Array.isArray(raw) && raw.total !== undefined
            ? Number(raw.total) || 0
            : rows.length;
        this.hasSearchedItem = true;
      } catch (err) {
        console.error('Error fetch /report_stockmovement:', err);
        this.errorMessage =
          (err && err.response && err.response.data && (err.response.data.message || err.response.data.error)) ||
          err.message ||
          'Gagal mengambil data pergerakan stok.';
        this.movements = [];
        this.totalItems = 0;
        this.hasSearchedItem = false;
      } finally {
        this.loading = false;
      }
    },

    formatDate(date) {
      if (!date) return '-';
      const d = new Date(date);
      if (Number.isNaN(d.getTime())) return date;
      return new Intl.DateTimeFormat('id-ID', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
      })
        .format(d)
        .replace(/ /g, '/');
    },

    formatJenisLabel(jenis) {
      const map = {
        RECEIPT: 'Penerimaan',
        RETUR_SALES: 'Retur Customer',
        SALES: 'Penjualan',
        RETUR_RECEIPT: 'Retur Supplier',
      };
      return map[jenis] || jenis || '-';
    },

    getJenisColor(jenis) {
      if (jenis === 'RECEIPT' || jenis === 'RETUR_SALES') return 'green lighten-5';
      return 'red lighten-5';
    },

    getJenisTextColor(jenis) {
      if (jenis === 'RECEIPT' || jenis === 'RETUR_SALES') return 'green darken-3';
      return 'red darken-3';
    },

    async exportToExcel() {
      if (!this.canExportExcel) return;

      try {
        const res = await api.get('/report_stockmovement', {
          params: {
            id_item: this.selectedItemId,
            jenis_mutasi: this.jenisMutasi !== 'ALL' ? this.jenisMutasi : undefined,
            dateFrom: this.dateFrom,
            dateTo: this.dateTo,
            search: this.search || undefined,
            page: 1,
            pageSize: 100000,
          },
        });

        const allRows =
          (res && res.data && Array.isArray(res.data.data) && res.data.data) ||
          this.movements ||
          [];

        const itemInfo = this.getSelectedItemInfo();
        const periodeText = `${this.formatDate(this.dateFrom)} s/d ${this.formatDate(this.dateTo)}`;

        const metaRows = [
          ['KARTU PERGERAKAN STOK (STOCK MOVEMENT)', '', '', '', '', '', '', '', ''],
          ['Kode Item', itemInfo.kode, '', 'Periode', periodeText, '', '', '', ''],
          ['Nama Item', itemInfo.nama, '', 'Jenis Mutasi', this.formatJenisLabel(this.jenisMutasi), '', '', '', ''],
          ['', '', '', '', '', '', '', '', ''],
          [
            'Tanggal',
            'No. Dokumen',
            'Jenis Mutasi',
            'Kode Item',
            'Nama Item',
            'Satuan',
            'Masuk (+)',
            'Keluar (-)',
            'Sisa Stok',
          ],
        ];

        const detailRows = allRows.map((r) => [
          this.formatDate(r.tgl_transaksi),
          r.no_dokumen || '-',
          this.formatJenisLabel(r.jenis_mutasi),
          r.kode_item || '-',
          r.nama_item || '-',
          r.satuan_nama || '-',
          Number(r.qty_masuk) || 0,
          Number(r.qty_keluar) || 0,
          Number(r.sisa_stok) || 0,
        ]);

        const ws = XLSX.utils.aoa_to_sheet([...metaRows, ...detailRows]);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, 'KartuStok');

        const safeKode = (itemInfo.kode || 'item').replace(/[^a-zA-Z0-9_-]/g, '_');
        const fileName = `stock_movement_${safeKode}_${this.dateFrom}_to_${this.dateTo}.xlsx`;

        XLSX.writeFile(wb, fileName);
      } catch (e) {
        console.error('Gagal export Excel:', e);
        this.errorMessage = 'Gagal mengekspor data pergerakan stok ke Excel.';
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

.table-scroll-wrapper ::v-deep .v-data-table__wrapper {
  max-height: 460px;
  overflow-x: auto;
  overflow-y: auto;
}

.bengkel-table ::v-deep thead th {
  position: sticky !important;
  top: 0 !important;
  z-index: 3 !important;
  font-size: 11px !important;
  font-weight: 700 !important;
  letter-spacing: 0.04em;
  color: #7f1d1d !important;
  background-color: #fef2f2 !important;
  border-bottom: 1px solid #fecaca !important;
  height: 38px !important;
}

.movement-row ::v-deep td {
  font-size: 12px !important;
  height: 36px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.movement-row:hover {
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
</style>