<template>
  <v-card flat>
    <v-card-text>
      <h3>Laporan Pengeluaran Barang</h3>
      <hr style="border-top: 1px solid #ccc; width: 100%; " />
      &nbsp;
      <v-row align="center">
        <v-col>
          <v-row>
            <v-col>
              <label>From</label>
              <v-text-field
                v-model="dateFrom"
                type="date"
                variant="outlined"
                hide-details
                single-line
                style="max-width: 150px;"
                label="Tanggal Dari"
              ></v-text-field>
            </v-col>

            <v-col>
              <label>To</label>
              <v-text-field
                v-model="dateTo"
                type="date"
                variant="outlined"
                hide-details
                single-line
                style="max-width: 150px;"
                label="Tanggal Sampai"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-col>

          <!-- <v-text-field
          v-model="search"
          label="Cari Transaksi Penerimaan"
          prepend-inner-icon="mdi-magnify"
          variant="outlined"
          hide-details
          single-line
      ></v-text-field> -->
    <v-col>
      <v-btn
            class="mt-4" 
            @click="searchReport"
            :disabled="!dateFrom || !dateTo"
            variant="outlined"
            color="primary"
            title="Search"
          > <v-icon>mdi mdi-magnify</v-icon>
          </v-btn>
      <v-btn
            class="mt-4 ml-2"
            @click="exportToExcel"
            :disabled="desserts.length === 0"
            variant="outlined"
            color="success"
            title="Export to Excel"
          > <v-icon>mdi-microsoft-excel</v-icon>
      </v-btn>
    </v-col>
  </v-row>
  
    

    <v-data-table
      :headers="headers"
      :items="desserts"
      :search="search"
      item-value="nomor_faktur"
      :items-per-page="8"
    >
      <template v-slot:[`item.items`]="{ item }">
        <ul>
          <li v-for="(detail, index) in item.items" :key="index">
            {{ detail.nama_item }}
          </li>
        </ul>
      </template>
      
      <template v-slot:[`item.qty`]="{ item }">
        <ul>
          <li v-for="(detail, index) in item.qty" :key="index">
            {{ detail.qty_item }}
          </li>
        </ul>
      </template>

      <template v-slot:[`item.uom`]="{ item }">
        <ul>
          <li v-for="(detail, index) in item.uom" :key="index">
            {{ detail.uom }}
          </li>
        </ul>
      </template>

      <template v-slot:[`item.kode_item`]="{ item }">
        <ul>
          <li v-for="(detail, index) in item.kode_item" :key="index">
            {{ detail.kode_item }}
          </li>
        </ul>
      </template>


      <template v-slot:[`item.subtotal`]="{ item }">
        <strong>{{ formatHarga(item.subtotal) }}</strong>
      </template>
    </v-data-table>

    <v-dialog v-model="dialog" max-width="290">
        <v-card>
          <v-card-title class="headline">Data Tidak Ditemukan</v-card-title>
          <v-card-text>
            Tidak ada data yang ditemukan untuk rentang tanggal yang dipilih.
          </v-card-text>
          <v-card-actions>
            <v-btn color="primary" text @click="dialog = false">Tutup</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-card-text>
  </v-card>
</template>

<script>
// import axios from 'axios';
import api from '../../services/api';
import { formatHarga } from '@/mixins/FilterMixin';
import * as XLSX from 'xlsx';

export default {
  data () {
    return {
      search: '',
      dateFrom:'',
      dateTo:'',
      headers: [
        { text: 'Tanggal', align: 'start', sortable: false, value: 'tanggal' },
        { text: 'Nomor Receipt', value: 'no_receipt' },
        { text: 'Supplier', value: 'supplier' },
        { text: 'Item CD', value: 'kode_item' },
        { text: 'Items', value: 'items' },
        { text: 'Qty', value: 'qty' },
        { text: 'Uom', value: 'uom' },
      ],
      desserts: [],
      formatHarga,
      dialog: false,
    }
  },
  methods: {
    async searchReport() {
      await this.get_report_trans_receipt()
    },
    async get_report_trans_receipt() {
      try {
        const response = await api.get('/t_trans_receipt/report');
        const formatter = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: 'long', year: 'numeric' });
        
        const filteredData = response.data.filter(item => {
          const itemDate = new Date(item.tanggal);
          const fromDate = new Date(this.dateFrom).setHours(0, 0, 0, 0);
          const toDate = new Date(this.dateTo).setHours(23, 59, 59, 999);
          return (!this.dateFrom || itemDate >= fromDate) && (!this.dateTo || itemDate <= toDate);
        });

        if (filteredData.length === 0) {
          this.dialog = true;
        } else {
          this.dialog = false;
        }
        
        const mergedData = filteredData.reduce((acc, item) => {
          const existing = acc.find(i => i.no_receipt === item.no_receipt);
          if (existing) {
            existing.items.push({
              nama_item: item.nama_item,
            });
            existing.qty.push({
              qty_item: item.qty_item
            });
            existing.uom.push({
              uom: item.uom
            });
            existing.kode_item.push({
              kode_item: item.kode_item
            });
          } else {
            acc.push({
              no_receipt: item.no_receipt,
              tanggal: formatter.format(new Date(item.tanggal)),
              supplier: item.nama_supplier,
              items: [{
                nama_item: item.nama_item,
              }],
              qty: [{
                qty_item: item.qty_item
              }],
              uom: [{
                uom: item.uom
              }],
              kode_item: [{
                kode_item: item.kode_item
              }],
            });
          }
          return acc;
        }, []);
        
        this.desserts = mergedData;
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    },
    exportToExcel() {
      // Flatten the data structure
      const flattenedData = this.desserts.map(item => {
        const maxLength = Math.max(item.items.length, item.qty.length, item.uom.length);
        const rows = [];
        for (let i = 0; i < maxLength; i++) {
          rows.push({
            tanggal: item.tanggal,
            no_receipt: item.no_receipt,
            supplier: item.supplier,
            kode_item: item.kode_item[i] ? item.kode_item[i].kode_item : '',
            items: item.items[i] ? item.items[i].nama_item : '',
            qty: item.qty[i] ? item.qty[i].qty_item : '',
            uom: item.uom[i] ? item.uom[i].uom : '',
          });
        }
        return rows;
      }).flat();

      const ws = XLSX.utils.json_to_sheet(flattenedData);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Report");
      XLSX.writeFile(wb, "Rpt_penerimaan.xlsx");
    }
  }
}
</script>

<style scoped>
</style>