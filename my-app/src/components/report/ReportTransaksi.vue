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
          <v-btn
        class="mt-4 ml-2"
            @click="exportToPDF"
            :disabled="desserts.length === 0"
            variant="outlined"
            color="orange"
            title="Export to PDF"
          > <v-icon size="30">mdi-file-pdf-box</v-icon>
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

        <template v-slot:[`item.kode`]="{ item }">
          <ul>
            <li v-for="(detail, index) in item.kode" :key="index">
              {{ detail.kode_item }}
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
import jsPDF from 'jspdf'; // Import jsPDF
import 'jspdf-autotable'; // Import jsPDF autoTable

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
        { text: 'Kode', value: 'kode' },
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

        // Urutkan filteredData berdasarkan tanggal
        filteredData.sort((a, b) => new Date(a.tanggal) - new Date(b.tanggal));

        if (filteredData.length === 0) {
          this.dialog = true; // Tampilkan dialog jika tidak ada data
        }

        const formatter = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' });
        
        const mergedData = filteredData.reduce((acc, item) => {
          // const labaItem = ((item.qty_item * item.hpp) - (item.qty_item * item.modal)); // Hitung labaItem
          const existing = acc.find(i => i.nomor_faktur === item.nomor_faktur);
          
          if (existing) {
            existing.items.push({
              nama_item: item.nama_item,
            });
            existing.kode.push({
              kode_item: item.kode_item
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
            existing.laba.push({
              laba: formatHarga(((item.qty_item * item.hpp) - (item.qty_item * item.modal)))
            }); // Tambahkan labaItem ke total laba
          } else {
            acc.push({
              nomor_faktur: item.nomor_faktur,
              tanggal: formatter.format(new Date(item.tanggal)),
              customer: item.nama_customer,
              items: [{
                nama_item: item.nama_item,
              }],
              kode: [{
                kode_item: item.kode_item
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
              laba: [{
                laba: formatHarga((item.qty_item * item.hpp) - (item.qty_item * item.modal))  
              }], // Simpan labaItem pertama
            });
          }
          return acc;
        }, []);

        // // Hitung total laba untuk semua item dalam nomor faktur
        // mergedData.forEach(item => {
        //   item.totalLaba = item.laba.reduce((sum, laba) => sum + laba.laba, 0); // Hitung total laba
        // });

        this.desserts = mergedData;
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    },
    exportToExcel() {
      // Flatten the data structure
      const flattenedData = this.desserts.map(item => {
        const maxLength = Math.max(item.items.length, item.kode.length, item.qty.length,
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
            kode: item.kode[i] ? item.kode[i].kode_item : '',
            qty: item.qty[i] ? item.qty[i].qty_item : 0, // Pastikan ini adalah angka
            uom: item.uom[i] ? item.uom[i].uom : '',
            modal: item.modal[i] ? parseFloat(item.modal[i].modal.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            hpp: item.hpp[i] ? parseFloat(item.hpp[i].hpp.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            totalhpp: item.totalhpp[i] ? parseFloat(item.totalhpp[i].totalhpp.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            totalmodal: item.totalmodal[i] ? parseFloat(item.totalmodal[i].totalmodal.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
            laba: item.laba[i] ? parseFloat(item.laba[i].laba.replace(/\./g, '').replace(',', '.')) : 0, // Hapus formatHarga
          });
        }
        return rows;
      }).flat();

      const subtotalModal = this.desserts.reduce((total, item) => {
        return total + item.modal.reduce((sum, modal) => sum + parseFloat(modal.modal.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalLaba = this.desserts.reduce((total, item) => {
        return total + item.laba.reduce((sum, laba) => sum + parseFloat(laba.laba.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalTotalHpp = this.desserts.reduce((total, item) => {
        return total + item.totalhpp.reduce((sum, totalhpp) => sum + parseFloat(totalhpp.totalhpp.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalTotalModal = this.desserts.reduce((total, item) => {
        return total + item.totalmodal.reduce((sum, totalmodal) => sum + parseFloat(totalmodal.totalmodal.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalTotalQty = this.desserts.reduce((total, item) => {
        return total + item.qty.reduce((sum, qty) => sum + qty.qty_item, 0);
      }, 0);
      
      const subtotalHpp = this.desserts.reduce((total, item) => {
        return total + item.hpp.reduce((sum, hpp) => sum + parseFloat(hpp.hpp.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);
      
      const subtotalRow = {
        tanggal: 'Subtotal',
        nomor_faktur: '',
        customer: '',
        items: '',
        kode: '',
        qty: subtotalTotalQty, // Hitung subtotal qty
        uom: '',
        modal: subtotalModal,
        hpp: subtotalHpp,
        totalhpp: subtotalTotalHpp,
        totalmodal: subtotalTotalModal,
        laba: subtotalLaba,
      };
      flattenedData.push(subtotalRow); // Tambahkan subtotal ke data
      
      const formattedDateFrom = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateFrom));
      const formattedDateTo = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateTo));
      
      const reportInfo = [{
        tanggal: `Tanggal Laporan: ${formattedDateFrom} - ${formattedDateTo}`,
        nomor_faktur: '',
        customer: '',
        items: '',
        kode: '',
        qty: '',
        uom: '',
        modal: '',
        hpp: '',
        totalhpp: '',
        totalmodal: '',
        laba: '',
      }];
      
      const dataToExport = [...reportInfo, ...flattenedData];

      const ws = XLSX.utils.json_to_sheet(dataToExport);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Report");
      XLSX.writeFile(wb, "Rpt_penjualan.xlsx");
    },
    exportToPDF() {
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
            kode: item.kode[i] ? item.kode[i].kode_item : '',
            qty: item.qty[i] ? item.qty[i].qty_item : 0,
            uom: item.uom[i] ? item.uom[i].uom : '',
            modal: item.modal[i] ? item.modal[i].modal : 0,
            hpp: item.hpp[i] ? item.hpp[i].hpp : 0,
            totalhpp: item.totalhpp[i] ? item.totalhpp[i].totalhpp : 0,
            totalmodal: item.totalmodal[i] ? item.totalmodal[i].totalmodal : 0,
            laba: item.laba[i] ? item.laba[i].laba : 0,
          });
        }
        return rows;
      }).flat();

      // Hitung subtotal
      const subtotalModal = this.desserts.reduce((total, item) => {
        return total + item.modal.reduce((sum, modal) => sum + parseFloat(modal.modal.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalLaba = this.desserts.reduce((total, item) => {
        return total + item.laba.reduce((sum, laba) => sum + parseFloat(laba.laba.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalTotalHpp = this.desserts.reduce((total, item) => {
        return total + item.totalhpp.reduce((sum, totalhpp) => sum + parseFloat(totalhpp.totalhpp.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalTotalModal = this.desserts.reduce((total, item) => {
        return total + item.totalmodal.reduce((sum, totalmodal) => sum + parseFloat(totalmodal.totalmodal.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);

      const subtotalTotalQty = this.desserts.reduce((total, item) => {
        return total + item.qty.reduce((sum, qty) => sum + qty.qty_item, 0);
      }, 0);

      const subtotalHpp = this.desserts.reduce((total, item) => {
        return total + item.hpp.reduce((sum, hpp) => sum + parseFloat(hpp.hpp.replace(/\./g, '').replace(',', '.')), 0);
      }, 0);
      
      // Tambahkan subtotal ke flattenedData
      const subtotalRow = [
        'Subtotal',
        '',
        '',
        '',
        '',
        subtotalTotalQty, // Hitung subtotal qty
        '',
        formatHarga(subtotalModal),
        formatHarga(subtotalHpp),
        formatHarga(subtotalTotalHpp),
        formatHarga(subtotalTotalModal),
        formatHarga(subtotalLaba),
      ];
      flattenedData.push(subtotalRow); // Tambahkan subtotal ke data
      
      const doc = new jsPDF();
      
      // Tambahkan keterangan tanggal laporan
      doc.setFontSize(10); // Ukuran font untuk keterangan
      doc.setFont('Arial', 'bold'); // Mengatur font menjadi Arial dan bold
      
      const formattedDateFrom = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateFrom));
      const formattedDateTo = new Intl.DateTimeFormat('id-ID', { day: '2-digit', month: '2-digit', year: '2-digit' }).format(new Date(this.dateTo));
      
      doc.text('Laporan Penjualan Rejeki Motor', 14, 7); // Posisi keterangan
      

      doc.text(`Periode: ${formattedDateFrom} s/d ${formattedDateTo}`, 14, 12); // Posisi keterangan

      doc.autoTable({
        head: [['Tanggal', 'Nomor Faktur', 'Customer', 'Items', 'Kode', 'Qty', 'Uom', 'Modal', 'Harga Jual', 'Total Harga Jual', 'Total Modal', 'Laba']],
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
            item.totalhpp,
            item.totalmodal,
            item.laba,
          ]),
          subtotalRow // Pastikan subtotalRow ditambahkan di sini
        ],
        styles: {
          font: 'Arial',
          fontSize: 8,
        },
      });
      doc.save("Rpt_penjualan.pdf");
    }
  }
}
</script>

<style scoped>

</style>