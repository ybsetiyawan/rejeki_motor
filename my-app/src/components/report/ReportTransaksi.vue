<template>
  <v-card class="bengkel-card rounded-lg elevation-2">
    <!-- Top Header & Filter -->
    <div class="bengkel-header px-5 pt-5 pb-4">
      <div class="d-flex flex-wrap align-center justify-space-between mb-4">
        <div class="d-flex align-center">
          <v-avatar color="red lighten-5" size="42" class="mr-3 bengkel-avatar-ring">
            <v-icon color="red darken-2">mdi-cash-register</v-icon>
          </v-avatar>
          <div>
            <div class="d-flex align-center">
              <span class="text-h6 font-weight-bold grey--text text--darken-4 mr-2">
                Laporan Pengeluaran Barang
              </span>
              <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                {{ filteredDesserts.length }} Faktur
              </v-chip>
            </div>
            <div class="text-caption grey--text text--darken-1">
              Rekap transaksi barang keluar / penjualan, HPP, modal &amp; laba bengkel
            </div>
          </div>
        </div>

        <div class="d-flex align-center mt-2 mt-sm-0">
          <v-btn
            small
            depressed
            color="green darken-1"
            class="white--text font-weight-medium text-none mr-2"
            :disabled="desserts.length === 0"
            @click="exportToExcel"
          >
            <v-icon left small>mdi-microsoft-excel</v-icon>
            Excel
          </v-btn>

          <v-btn
            small
            depressed
            color="red darken-2"
            class="white--text font-weight-medium text-none"
            :disabled="desserts.length === 0"
            @click="exportToPDF"
          >
            <v-icon left small>mdi-file-pdf-box</v-icon>
            PDF
          </v-btn>
        </div>
      </div>

      <!-- Filter Tanggal & Pencarian -->
      <v-row dense align="center">
        <v-col cols="12" sm="3" md="2">
          <v-text-field
            v-model="dateFrom"
            type="date"
            label="Dari Tanggal"
            color="red darken-2"
            outlined
            dense
            hide-details
            background-color="white"
          ></v-text-field>
        </v-col>

        <v-col cols="12" sm="3" md="2">
          <v-text-field
            v-model="dateTo"
            type="date"
            label="Sampai Tanggal"
            color="red darken-2"
            outlined
            dense
            hide-details
            background-color="white"
          ></v-text-field>
        </v-col>

        <v-col cols="12" sm="6" md="5">
          <v-text-field
            v-model="search"
            label="Filter no. faktur, customer, kode, atau nama item..."
            prepend-inner-icon="mdi-magnify"
            color="red darken-2"
            outlined
            dense
            clearable
            hide-details
            background-color="white"
            @click:clear="search = ''"
          ></v-text-field>
        </v-col>

        <v-col cols="12" md="3" class="d-flex align-center">
          <v-btn
            small
            depressed
            color="red darken-2"
            class="white--text font-weight-medium text-none px-4"
            :disabled="!dateFrom || !dateTo"
            :loading="loading"
            @click="searchReport"
          >
            <v-icon left small>mdi-magnify</v-icon>
            Tampilkan
          </v-btn>
        </v-col>
      </v-row>
    </div>

    <div class="bengkel-stripe"></div>

    <!-- Ringkasan Cepat -->
    <div v-if="desserts.length > 0" class="px-5 py-3 grey lighten-5 border-bottom-light">
      <v-row dense>
        <v-col cols="12" sm="6" md="3">
          <div class="mini-stat-box">
            <div class="text-caption grey--text text--darken-1">Total Qty Keluar</div>
            <div class="text-subtitle-2 font-weight-bold grey--text text--darken-4">
              {{ subtotalTotalQty }}
            </div>
          </div>
        </v-col>
        <v-col cols="12" sm="6" md="3">
          <div class="mini-stat-box">
            <div class="text-caption grey--text text--darken-1">Total Modal</div>
            <div class="text-subtitle-2 font-weight-bold grey--text text--darken-4">
              {{ formatHarga(subtotalTotalModal) }}
            </div>
          </div>
        </v-col>
        <v-col cols="12" sm="6" md="3">
          <div class="mini-stat-box">
            <div class="text-caption grey--text text--darken-1">Total Harga Jual</div>
            <div class="text-subtitle-2 font-weight-bold grey--text text--darken-4">
              {{ formatHarga(subtotalTotalHpp) }}
            </div>
          </div>
        </v-col>
        <v-col cols="12" sm="6" md="3">
          <div class="mini-stat-box">
            <div class="text-caption grey--text text--darken-1">Total Laba</div>
            <div class="text-subtitle-2 font-weight-bold red--text text--darken-3">
              {{ formatHarga(subtotalLaba) }}
            </div>
          </div>
        </v-col>
      </v-row>
    </div>

    <!-- Tabel Laporan Pengeluaran -->
    <div class="table-scroll-wrapper">
      <v-simple-table class="bengkel-table" fixed-header height="460px">
        <thead>
          <tr>
            <th class="text-left" style="width: 100px;">TANGGAL</th>
            <th class="text-left" style="width: 115px;">NO. FAKTUR</th>
            <th class="text-left" style="width: 150px;">CUSTOMER</th>
            <th class="text-left">ITEMS</th>
            <th class="text-left" style="width: 90px;">KODE</th>
            <th class="text-right" style="width: 65px;">QTY</th>
            <th class="text-center" style="width: 70px;">UOM</th>
            <th class="text-right" style="width: 105px;">MODAL</th>
            <th class="text-right" style="width: 105px;">HARGA JUAL</th>
            <th class="text-right" style="width: 115px;">TOT. MODAL</th>
            <th class="text-right" style="width: 115px;">TOT. JUAL</th>
            <th class="text-right" style="width: 110px;">LABA</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="row in paginatedDesserts"
            :key="row.nomor_faktur"
            class="report-row"
          >
            <td class="faktur-meta-cell grey--text text--darken-3">{{ row.tanggal }}</td>
            <td class="faktur-meta-cell">
              <span class="kode-red-pill">{{ row.nomor_faktur }}</span>
            </td>
            <td class="faktur-meta-cell font-weight-bold grey--text text--darken-4">
              {{ row.customer || '-' }}
            </td>
            <td colspan="9" class="pa-0">
              <div
                v-for="(det, idx) in row.details"
                :key="idx"
                class="detail-subrow"
              >
                <div class="sub-item font-weight-medium grey--text text--darken-4">
                  {{ det.nama_item }}
                </div>
                <div class="sub-kode">
                  <span class="kode-mini">{{ det.kode_item || '-' }}</span>
                </div>
                <div class="sub-qty text-right font-weight-medium">
                  {{ det.qty_item }}
                </div>
                <div class="sub-uom text-center grey--text text--darken-1">
                  {{ det.uom || '-' }}
                </div>
                <div class="sub-money text-right grey--text text--darken-2">
                  {{ formatHarga(det.modal_num) }}
                </div>
                <div class="sub-money text-right grey--text text--darken-3">
                  {{ formatHarga(det.hpp_num) }}
                </div>
                <div class="sub-money-lg text-right grey--text text--darken-3">
                  {{ formatHarga(det.totalmodal_num) }}
                </div>
                <div class="sub-money-lg text-right grey--text text--darken-3">
                  {{ formatHarga(det.totalhpp_num) }}
                </div>
                <div class="sub-laba text-right font-weight-bold red--text text--darken-3">
                  {{ formatHarga(det.laba_num) }}
                </div>
              </div>
            </td>
          </tr>

          <tr v-if="!paginatedDesserts || paginatedDesserts.length === 0">
            <td colspan="12" class="text-center py-8 grey--text">
              <v-icon large color="red lighten-3" class="mb-2">mdi-file-chart-outline</v-icon>
              <div>Pilih rentang tanggal lalu klik <strong>Tampilkan</strong> untuk memuat laporan.</div>
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
        <strong class="grey--text text--darken-4">{{ filteredDesserts.length }}</strong> faktur
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

    <!-- Dialog Data Tidak Ditemukan -->
    <v-dialog v-model="dialog" max-width="380px">
      <v-card class="rounded-lg">
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="36" class="mr-3">
              <v-icon color="red darken-2" small>mdi-calendar-alert</v-icon>
            </v-avatar>
            <span class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
              Data Tidak Ditemukan
            </span>
          </div>
        </v-card-title>
        <div class="bengkel-stripe"></div>
        <v-card-text class="pa-5 text-body-2 grey--text text--darken-2">
          Tidak ada data pengeluaran barang untuk rentang tanggal yang dipilih.
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="px-5 py-3 grey lighten-5">
          <v-spacer></v-spacer>
          <v-btn depressed color="red darken-2" small class="white--text text-none px-4" @click="dialog = false">
            Tutup
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<script>
import api from '../../services/api';
import { formatHarga } from '@/mixins/FilterMixin';
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import 'jspdf-autotable';

export default {
  name: 'ReportPengeluaranView',
  data() {
    return {
      search: '',
      dateFrom: '',
      dateTo: '',
      desserts: [],
      loading: false,
      formatHarga,
      dialog: false,
      currentPage: 1,
      pageSize: 8,
    };
  },
  computed: {
    filteredDesserts() {
      const q = (this.search || '').toString().trim().toLowerCase();
      if (!q) return this.desserts;
      return this.desserts.filter(row => {
        const noFaktur = (row.nomor_faktur || '').toString().toLowerCase();
        const customer = (row.customer || '').toString().toLowerCase();
        const tanggal = (row.tanggal || '').toString().toLowerCase();
        const matchDetail = (row.details || []).some(
          d =>
            (d.kode_item || '').toString().toLowerCase().includes(q) ||
            (d.nama_item || '').toString().toLowerCase().includes(q)
        );
        return noFaktur.includes(q) || customer.includes(q) || tanggal.includes(q) || matchDetail;
      });
    },
    totalPagesSafe() {
      return Math.max(1, Math.ceil(this.filteredDesserts.length / this.pageSize));
    },
    paginatedDesserts() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredDesserts.slice(start, start + this.pageSize);
    },
    startItemIndex() {
      if (!this.filteredDesserts.length) return 0;
      return (this.currentPage - 1) * this.pageSize + 1;
    },
    endItemIndex() {
      if (!this.filteredDesserts.length) return 0;
      return Math.min(this.currentPage * this.pageSize, this.filteredDesserts.length);
    },
    allActiveDetails() {
      return this.filteredDesserts.reduce((acc, row) => {
        return acc.concat(row.details || []);
      }, []);
    },
    subtotalTotalQty() {
      return this.allActiveDetails.reduce((sum, d) => sum + (Number(d.qty_item) || 0), 0);
    },
    subtotalModal() {
      return this.allActiveDetails.reduce((sum, d) => sum + (Number(d.modal_num) || 0), 0);
    },
    subtotalHpp() {
      return this.allActiveDetails.reduce((sum, d) => sum + (Number(d.hpp_num) || 0), 0);
    },
    subtotalTotalModal() {
      return this.allActiveDetails.reduce((sum, d) => sum + (Number(d.totalmodal_num) || 0), 0);
    },
    subtotalTotalHpp() {
      return this.allActiveDetails.reduce((sum, d) => sum + (Number(d.totalhpp_num) || 0), 0);
    },
    subtotalLaba() {
      return this.allActiveDetails.reduce((sum, d) => sum + (Number(d.laba_num) || 0), 0);
    },
  },
  watch: {
    search() {
      this.currentPage = 1;
    },
    filteredDesserts(newList) {
      const maxPage = Math.max(1, Math.ceil(newList.length / this.pageSize));
      if (this.currentPage > maxPage) {
        this.currentPage = maxPage;
      }
    },
  },
  methods: {
    goToPage(page) {
      const target = Math.min(Math.max(1, page), this.totalPagesSafe);
      this.currentPage = target;
    },

    async searchReport() {
      await this.get_report_transaksi();
    },

    async get_report_transaksi() {
      this.loading = true;
      try {
        const response = await api.get('/t_transaksi/report');
        const fromDate = this.dateFrom ? new Date(this.dateFrom).setHours(0, 0, 0, 0) : null;
        const toDate = this.dateTo ? new Date(this.dateTo).setHours(23, 59, 59, 999) : null;

        const filteredData = response.data
          .filter(item => {
            const itemDate = new Date(item.tanggal);
            return (!fromDate || itemDate >= fromDate) && (!toDate || itemDate <= toDate);
          })
          .sort((a, b) => new Date(a.tanggal) - new Date(b.tanggal));

        this.dialog = filteredData.length === 0;

        const formatter = new Intl.DateTimeFormat('id-ID', {
          day: '2-digit',
          month: '2-digit',
          year: '2-digit',
        });

        const mergedData = filteredData.reduce((acc, item) => {
          const qty = Number(item.qty_item) || 0;
          const modalNum = Number(item.modal) || 0;
          const hppNum = Number(item.hpp) || 0;
          const totalModalNum = qty * modalNum;
          const totalHppNum = qty * hppNum;
          const labaNum = totalHppNum - totalModalNum;

          const detailObj = {
            nama_item: item.nama_item,
            kode_item: item.kode_item,
            qty_item: qty,
            uom: item.uom,
            jenis_item: item.jenis_item,
            modal_num: modalNum,
            hpp_num: hppNum,
            totalmodal_num: totalModalNum,
            totalhpp_num: totalHppNum,
            laba_num: labaNum,
          };

          const existing = acc.find(i => i.nomor_faktur === item.nomor_faktur);
          if (existing) {
            existing.details.push(detailObj);
          } else {
            acc.push({
              nomor_faktur: item.nomor_faktur,
              tanggal: formatter.format(new Date(item.tanggal)),
              customer: item.nama_customer,
              details: [detailObj],
            });
          }
          return acc;
        }, []);

        this.currentPage = 1;
        this.desserts = mergedData;
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        this.loading = false;
      }
    },

    exportToExcel() {
      const flattenedData = this.filteredDesserts
        .map(row =>
          (row.details || []).map(det => ({
            tanggal: row.tanggal,
            nomor_faktur: row.nomor_faktur,
            customer: row.customer,
            items: det.nama_item,
            kode: det.kode_item,
            qty: det.qty_item,
            uom: det.uom,
            jenis_item: det.jenis_item,
            modal: det.modal_num,
            hpp: det.hpp_num,
            totalmodal: det.totalmodal_num,
            totalhpp: det.totalhpp_num,
            laba: det.laba_num,
          }))
        )
        .flat();

      const subtotalRow = {
        tanggal: 'Subtotal',
        nomor_faktur: '',
        customer: '',
        items: '',
        kode: '',
        qty: this.subtotalTotalQty,
        uom: '',
        jenis_item: '',
        modal: this.subtotalModal,
        hpp: this.subtotalHpp,
        totalmodal: this.subtotalTotalModal,
        totalhpp: this.subtotalTotalHpp,
        laba: this.subtotalLaba,
      };
      flattenedData.push(subtotalRow);

      const formattedDateFrom = this.dateFrom
        ? new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateFrom))
        : '-';
      const formattedDateTo = this.dateTo
        ? new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateTo))
        : '-';

      const reportInfo = [
        {
          tanggal: `Tanggal Laporan: ${formattedDateFrom} - ${formattedDateTo}`,
          nomor_faktur: '',
          customer: '',
          items: '',
          kode: '',
          qty: '',
          uom: '',
          jenis_item: '',
          modal: '',
          hpp: '',
          totalmodal: '',
          totalhpp: '',
          laba: '',
        },
      ];

      const dataToExport = [...reportInfo, ...flattenedData];
      const ws = XLSX.utils.json_to_sheet(dataToExport);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, 'Report');
      XLSX.writeFile(wb, 'Rpt_penjualan.xlsx');
    },

    exportToPDF() {
      const flattenedData = this.filteredDesserts
        .map(row =>
          (row.details || []).map(det => ({
            tanggal: row.tanggal,
            nomor_faktur: row.nomor_faktur,
            customer: row.customer,
            items: det.nama_item,
            kode: det.kode_item,
            qty: det.qty_item,
            uom: det.uom,
            modal: formatHarga(det.modal_num),
            hpp: formatHarga(det.hpp_num),
            totalmodal: formatHarga(det.totalmodal_num),
            totalhpp: formatHarga(det.totalhpp_num),
            laba: formatHarga(det.laba_num),
          }))
        )
        .flat();

      const subtotalRow = [
        'Subtotal',
        '',
        '',
        '',
        '',
        this.subtotalTotalQty,
        '',
        formatHarga(this.subtotalModal),
        formatHarga(this.subtotalHpp),
        formatHarga(this.subtotalTotalModal),
        formatHarga(this.subtotalTotalHpp),
        formatHarga(this.subtotalLaba),
      ];

      const doc = new jsPDF({ orientation: 'landscape' });
      doc.setFontSize(10);
      doc.setFont('Arial', 'bold');

      const formattedDateFrom = this.dateFrom
        ? new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateFrom))
        : '-';
      const formattedDateTo = this.dateTo
        ? new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateTo))
        : '-';

      doc.text('Laporan Penjualan Rejeki Motor', 14, 10);
      doc.text(`Periode: ${formattedDateFrom} s/d ${formattedDateTo}`, 14, 16);

      doc.autoTable({
        startY: 20,
        head: [[
          'Tanggal',
          'Nomor Faktur',
          'Customer',
          'Items',
          'Kode',
          'Qty',
          'Uom',
          'Modal',
          'Harga Jual',
          'Total Modal',
          'Total Harga Jual',
          'Laba',
        ]],
        body: [
          ...flattenedData.map(item => [
            item.tanggal,
            item.nomor_faktur,
            item.customer,
            item.items,
            item.kode,
            item.qty,
            item.uom,
            item.modal,
            item.hpp,
            item.totalmodal,
            item.totalhpp,
            item.laba,
          ]),
          subtotalRow,
        ],
        styles: {
          font: 'Arial',
          fontSize: 8,
        },
      });

      doc.save('Rpt_penjualan.pdf');
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

.mini-stat-box {
  background-color: #ffffff;
  border: 1px solid #f1dcdc;
  border-radius: 8px;
  padding: 8px 12px;
}

/* Memastikan area scroll berada pada wrapper internal Vuetify & header tetap sticky */
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

.report-row ::v-deep td {
  font-size: 12px !important;
  vertical-align: top !important;
  border-bottom: 1px solid #f5ebeb !important;
}

/* Turunkan sedikit posisi Tanggal, No. Faktur & Customer agar tidak terlalu mepet ke atas */
.faktur-meta-cell {
  padding-top: 12px !important;
  padding-bottom: 8px !important;
}

.report-row:hover {
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

.detail-subrow {
  display: flex;
  align-items: center;
  padding: 7px 10px;
  border-bottom: 1px dashed #f3e5e5;
}

.detail-subrow:last-child {
  border-bottom: none;
}

.sub-item {
  flex: 1;
  min-width: 140px;
  padding-right: 10px;
}

.sub-kode {
  width: 90px;
  flex-shrink: 0;
}

.sub-qty {
  width: 65px;
  flex-shrink: 0;
}

.sub-uom {
  width: 70px;
  flex-shrink: 0;
}

.sub-money {
  width: 105px;
  flex-shrink: 0;
}

.sub-money-lg {
  width: 115px;
  flex-shrink: 0;
}

.sub-laba {
  width: 110px;
  flex-shrink: 0;
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