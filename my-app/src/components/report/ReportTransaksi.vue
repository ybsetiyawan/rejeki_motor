<template>
  <v-card flat>
    <v-card-text>
      <h3>Laporan Pengeleuaran Barang</h3>
      <hr style="border-top: 1px solid #ccc; width: 100%; my-4;" />
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
        class="table"
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

        <template v-slot:[`item.modal`]="{ item }">
          <ul>
            <li v-for="(detail, index) in item.modal" :key="index">
              {{ detail.modal }}
            </li>
          </ul>
        </template>

        <template v-slot:[`item.hpp`]="{ item }">
          <ul>
            <li v-for="(detail, index) in item.hpp" :key="index">
              {{ detail.hpp }}
            </li>
          </ul>
        </template>

        <template v-slot:[`item.totalmodal`]="{ item }">
          <ul>
            <li v-for="(detail, index) in item.totalmodal" :key="index">
              {{ detail.totalmodal }}
            </li>
          </ul>
        </template>

        <template v-slot:[`item.totalhpp`]="{ item }">
          <ul>
            <li v-for="(detail, index) in item.totalhpp" :key="index">
              {{ detail.totalhpp }}
            </li>
          </ul>
        </template>

        <template v-slot:[`item.laba`]="{ item }">
          <ul>
            <li v-for="(detail, index) in item.laba" :key="index">
              {{ detail.laba }}
            </li>
          </ul>
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
      dateFrom: '',
      dateTo: '',
      headers: [
        { text: 'Tanggal', align: 'start', value: 'tanggal' },
        { text: 'Nomor Faktur', value: 'nomor_faktur' },
        { text: 'Customer', value: 'customer' },
        { text: 'Items', value: 'items' },
        { text: 'Qty', value: 'qty' },
        { text: 'Uom', value: 'uom' },
        { text: 'Modal', value: 'modal'},
        { text: 'Hpp', value: 'hpp' },
        { text: 'Total Modal', value: 'totalmodal' },
        { text: 'Total Hpp', value: 'totalhpp' },
        { text: 'Laba', value: 'laba' },
      ],
      desserts: [],
      formatHarga,
      dialog: false, // Tambahkan properti dialog
    }
  },
  
  methods: {
    async searchReport() {
      await this.get_report_transaksi();
    },
    
    async get_report_transaksi() {
      try {
        const response = await api.get('/t_transaksi/report');
        const filteredData = response.data.filter(item => {
          const itemDate = new Date(item.tanggal);
          const fromDate = new Date(this.dateFrom).setHours(0, 0, 0, 0);
          const toDate = new Date(this.dateTo).setHours(23, 59, 59, 999);
          return (!this.dateFrom || itemDate >= fromDate) && (!this.dateTo || itemDate <= toDate);
        });

        if (filteredData.length === 0) {
          this.dialog = true; // Tampilkan dialog jika tidak ada data
        }

        const formatter = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: 'long', year: 'numeric' });
        
        const mergedData = filteredData.reduce((acc, item) => {
          const labaItem = ((item.qty_item * item.hpp) - (item.qty_item * item.modal)); // Hitung labaItem
          const existing = acc.find(i => i.nomor_faktur === item.nomor_faktur);
          
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
            existing.modal.push({
              modal: formatHarga(item.modal)
            });
            existing.hpp.push({
              hpp: formatHarga(item.hpp)
            });
            existing.totalmodal.push({
              totalmodal: formatHarga(item.qty_item * item.modal)
            });
            existing.totalhpp.push({
              totalhpp: formatHarga(item.qty_item * item.hpp)
            });
            existing.laba[0].laba += labaItem; // Tambahkan labaItem ke total laba
          } else {
            acc.push({
              nomor_faktur: item.nomor_faktur,
              tanggal: formatter.format(new Date(item.tanggal)),
              customer: item.nama_customer,
              items: [{
                nama_item: item.nama_item,
              }],
              qty: [{
                qty_item: item.qty_item
              }],
              uom: [{
                uom: item.uom
              }],
              modal: [{
                modal: formatHarga(item.modal)
              }],
              hpp: [{
                hpp: formatHarga(item.hpp)
              }],
              totalmodal: [{
                totalmodal: formatHarga(item.qty_item * item.modal)
              }],
              totalhpp: [{
                totalhpp: formatHarga(item.qty_item * item.hpp)
              }],
              laba: [{ laba: formatHarga(labaItem) }], // Simpan labaItem pertama
            });
          }
          return acc;
        }, []);
        
        this.desserts = mergedData;
        this.totalLaba = formatHarga(mergedData.reduce((sum, item) => sum + item.laba[0].laba, 0)); // Hitung total laba berdasarkan nomor faktur
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    },
    exportToExcel() {
      // Flatten the data structure
      const flattenedData = this.desserts.map(item => {
        const maxLength = Math.max(item.items.length, item.qty.length,
                                    item.uom.length, item.modal.length,
                                    item.hpp.length, item.totalhpp.length,
                                    item.totalmodal.length, item.laba.length );
        const rows = [];
        for (let i = 0; i < maxLength; i++) {
          rows.push({
            tanggal: item.tanggal,
            nomor_faktur: item.nomor_faktur,
            customer: item.customer,
            items: item.items[i] ? item.items[i].nama_item : '',
            qty: item.qty[i] ? item.qty[i].qty_item : 0, // Pastikan ini adalah angka
            uom: item.uom[i] ? item.uom[i].uom : '',
            modal: item.modal[i] ? parseFloat(item.modal[i].modal.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            hpp: item.hpp[i] ? parseFloat(item.hpp[i].hpp.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            totalhpp: item.totalhpp[i] ? parseFloat(item.totalhpp[i].totalhpp.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            totalmodal: item.totalmodal[i] ? parseFloat(item.totalmodal[i].totalmodal.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            laba: i === maxLength - 1 ? (item.laba.length > 0 ? parseFloat(item.laba[0].laba.replace(/\./g, '').replace(',', '.')) : 0) : '' // Pastikan ini adalah angka
          });
        }
        return rows;
      }).flat();

      const ws = XLSX.utils.json_to_sheet(flattenedData);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Report");
      XLSX.writeFile(wb, "Rpt_penjualan.xlsx");
    }
  }
}
</script>

<style scoped>

</style>