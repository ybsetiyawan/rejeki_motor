<template>
  <v-card style="height: 664.5px; overflow: hidden;">
      <v-card-title>
        Laporan Stok Barang
        <v-spacer>
        </v-spacer>
        <v-btn
        class="mt-4 mr-15"
            @click="exportToPDF"
            variant="outlined"
            color="orange"
            title="Export to PDF"
          > <v-icon size="30">mdi-file-pdf-box</v-icon>
          </v-btn>
      <v-row align="center" justify="space-between">
        <v-col cols="12">
          <v-text-field
            label="Cari Berdasarkan Kode atau Nama Item"
            single-line
            hide-details
            v-model="search"
            class="mr-2"
          >
            <template v-slot:prepend-inner>
              <v-icon>mdi-magnify</v-icon>
            </template>
          </v-text-field>
          <v-checkbox
            v-model="lessThanFive"
            label="Tampilkan Item dengan Stok Kurang dari 5"
          ></v-checkbox>
        </v-col>
      </v-row>
    </v-card-title>
    <v-simple-table>
      <thead class="th">
        <tr>
        <th>Kode</th>
        <th>Nama</th>
        <th>Jenis Item</th>
        <th>Stok</th>
        <th>Uom</th>
      </tr>
    </thead>
    </v-simple-table>
      
    <v-simple-table class="scrollable-table">
    <tbody>
      <tr v-for="item in filteredItems" :key="item.id">
        <td>{{ item.kode }}</td>
        <td>{{ item.nama }}</td>
        <td>{{ item.jenis_item_nama }}</td>
        <td>{{ item.stok }}</td>
        <td>{{ item.satuan_nama }}</td>
      </tr>
    </tbody>
  </v-simple-table>
</v-card>
</template>

<script>
import api from '../../services/api';
import { filterData } from '../../mixins/FilterMixin';
import jsPDF from 'jspdf'; // Import jsPDF
import 'jspdf-autotable'; // Import jsPDF autoTable

export default {
  data() {
    return {
      items: [],
      search: '',
      stockFilter: null,
      lessThanFive: false
    }
  },
  computed: {
    filteredItems() {
      let filtered = filterData(this.items, this.search);
      if (this.stockFilter !== null) {
        filtered = filtered.filter(item => item.stok <= this.stockFilter);
      }
      if (this.lessThanFive) {
        filtered = filtered.filter(item => item.stok < 5);
      }
      return filtered;
    }
  },
  
  mounted() {
    this.loadItems();
  },
  methods: {
    loadItems() {
      // axios.get('http://localhost:4000/m_item')
      api.get('/m_item')
      .then(response => {
        this.items = response.data;
      })
    },
    formatDate(date) {
      const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
      return new Intl.DateTimeFormat('id-ID', options).format(date).replace(/ /g, '/'); // Mengganti spasi dengan '/'
    },
    
    exportToPDF() {
      const doc = new jsPDF();
      doc.setFont("Calibri"); // Mengatur font menjadi Calibri
      doc.setFontSize(10); // Mengatur ukuran font

      const currentDate = this.formatDate(new Date()); // Mendapatkan tanggal saat ini dengan format baru
      doc.text("Laporan Stok Barang Rejeki Motor", 10, 10);
      doc.text(`Tanggal Download: ${currentDate}`, 10, 20); // Menambahkan tanggal ekspor
      
      // Menambahkan tabel ke PDF
      const tableData = this.filteredItems.map(item => [
        item.kode,
        item.nama,
        item.jenis_item_nama,
        item.stok,
        item.satuan_nama
      ]);

      doc.autoTable({
        head: [['Kode', 'Nama', 'Jenis Item', 'Stok', 'Uom']],
        body: tableData,
        startY: 30, // Posisi Y untuk tabel
        styles: { font: "Calibri", fontSize: 8 }, // Mengatur font dan ukuran untuk tabel
      });

      doc.save('laporan_stok_barang.pdf'); // Menyimpan file PDF
    },
  }
}
</script>

<style>
.filter-select {
  min-width: 150px;
}

.stok{
  height: 20vh;
}

</style>