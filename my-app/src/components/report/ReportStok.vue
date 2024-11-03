<template>
  <v-card>
      <v-card-title>
        <v-btn text elevation="1">
          <span>
            Laporan Stok Barang
          </span>
        </v-btn>
        <v-spacer>
        </v-spacer>
        <v-btn
            fab
            x-small
            class="mt-4 mr-4"
            @click="exportToExcel"
            variant="outlined"
            color="green"
            title="Export to Excel"
            elevation="9"
          > <v-icon size="23">mdi-microsoft-excel</v-icon>
          </v-btn>

          <v-btn
            fab
            x-small
            class="mt-4 mr-15"
            @click="exportToExcelMin5"
            variant="outlined"
            color="cyan"
            title="Export Item Max 5"
            elevation="9"

          > <v-icon size="23">mdi-rewind-5</v-icon>
          </v-btn>
      <v-row align="center" justify="space-between">
        <v-col cols="12">
          
          <v-text-field
              class="font"
              label="Cari Berdasarkan Kode atau Nama Item"
              single-line
              hide-details
              v-model="searchQuery"
              >
            <template v-slot:prepend-inner>
              <v-btn
                    fab
                    color="blue"
                    elevation="8"
                    @click="searchItems"
                    :disabled="!searchQuery"
                    class="mb-1"
                    x-small
                    >
                    <v-icon>mdi-magnify</v-icon>
                  </v-btn>
            </template>
          </v-text-field>
        </v-col>
      </v-row>
    </v-card-title>
    <v-simple-table class="small-table">
      <thead class="header-container">
        <tr>
        <th>KODE</th>
        <th>NAMA</th>
        <th>KATEGORI</th>
        <th>STOK</th>
        <th>Uom</th>
      </tr>
    </thead>
    <tbody class="cart-body">
      <tr v-for="item in items" :key="item.id">
        <td>{{ item.kode }}</td>
        <td>{{ item.nama }}</td>
        <td>{{ item.jenis_item_nama }}</td>
        <td>{{ item.stok }}</td>
        <td>{{ item.satuan_nama }}</td>
      </tr>
    </tbody>
  </v-simple-table>
    <v-pagination
      class="custom-pagination"
      v-model="currentPage"
      :length="pageCount"
      :total-visible="7"
      @input="loadItems">
    </v-pagination>
</v-card>
</template>

<script>
// import api from '../../services/api';
// import { filterData } from '../../mixins/FilterMixin';
// import jsPDF from 'jspdf'; // Import jsPDF
// import 'jspdf-autotable'; // Import jsPDF autoTable
import { loadItems,  } from '../../utils/utils';
import * as XLSX from 'xlsx';



export default {
  data() {
    return {
      items: [],
      searchQuery: '',
      stockFilter: null,
      lessThanFive: false,
      currentPage: 1,
      pageSize: 19,
      totalItems: 0, 
    }
  },
  computed: {
        pageCount() {
        return Math.ceil(this.totalItems / this.pageSize);
        }
  },
  
  mounted() {
    this.loadItems();
  },
  methods: {
    // loadItems() {
    //   // axios.get('http://localhost:4000/m_item')
    //   api.get('/m_item')
    //   .then(response => {
    //     this.items = response.data;
    //   })
    // },

    loadItems() {
       return loadItems(this.currentPage, this.pageSize, this.searchQuery)
          .then(data => {
            this.items = data.items;
            this.totalItems = data.total
          })
          .catch(error => console.error('Error Loading Items:', error))
       },

    formatDate(date) {
      const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
      return new Intl.DateTimeFormat('id-ID', options).format(date).replace(/ /g, '/'); // Mengganti spasi dengan '/'
    },
    searchItems() {
          this.currentPage = 1;
          this.loadItems().then(() => {
            if (this.items.length === 0) {
              alert('Tidak ada item yang ditemukan.');
            }
          });
        },
    
    // exportToPDF() {
    //   const doc = new jsPDF();
    //   doc.setFont("Calibri"); // Mengatur font menjadi Calibri
    //   doc.setFontSize(10); // Mengatur ukuran font

    //   const currentDate = this.formatDate(new Date()); // Mendapatkan tanggal saat ini dengan format baru
    //   doc.text("Laporan Stok Barang Rejeki Motor", 10, 10);
    //   doc.text(`Tanggal Download: ${currentDate}`, 10, 20); // Menambahkan tanggal ekspor
      
    //   // Menambahkan tabel ke PDF
    //   const tableData = this.filteredItems.map(item => [
    //     item.kode,
    //     item.nama,
    //     item.jenis_item_nama,
    //     item.stok,
    //     item.satuan_nama
    //   ]);

    //   doc.autoTable({
    //     head: [['Kode', 'Nama', 'Jenis Item', 'Stok', 'Uom']],
    //     body: tableData,
    //     startY: 30, // Posisi Y untuk tabel
    //     styles: { font: "Calibri", fontSize: 8 }, // Mengatur font dan ukuran untuk tabel
    //   });

    //   doc.save('laporan_stok_barang.pdf'); // Menyimpan file PDF
    // },

    exportToExcel() {
      // Memuat semua item sebelum mengekspor
      loadItems(1, 100000, '').then(data => { // Menggunakan pageSize yang besar untuk mengambil semua item
        const worksheet = XLSX.utils.json_to_sheet(data.items); // Mengonversi data items ke worksheet
        const workbook = XLSX.utils.book_new(); // Membuat workbook baru
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Items'); // Menambahkan worksheet ke workbook
        XLSX.writeFile(workbook, 'laporan_stok_barang.xlsx'); // Menyimpan file Excel
      }).catch(error => console.error('Error Loading All Items:', error));
    },

    exportToExcelMin5() {
      // Memuat semua item sebelum mengekspor
      loadItems(1, 10000, '').then(data => { // Menggunakan pageSize yang besar untuk mengambil semua item
        const filteredItems = data.items.filter(item => item.stok <= 5); // Memfilter item dengan stok = 5
        const worksheet = XLSX.utils.json_to_sheet(filteredItems); // Mengonversi data items yang sudah difilter ke worksheet
        const workbook = XLSX.utils.book_new(); // Membuat workbook baru
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Items'); // Menambahkan worksheet ke workbook
        XLSX.writeFile(workbook, 'laporan_stok_barang ≤ 5.xlsx'); // Menyimpan file Excel
      }).catch(error => console.error('Error Loading All Items:', error));
    },

  }
}
</script>

<style>




.header-container th{
    height: 20px !important;
    font-size: 12px !important;
    font-weight: bold !important; 
    color: rgb(247, 116, 116) !important;
    padding-bottom: 5px !important; /* menambahkan jarak antara header dan body table */
  }

  .cart-body td{
    height: 27px !important;
    font-size: 11px !important;
    /* font-weight: bold !important; */
  }

  .cart-body{
    max-height: 485px;
    /* Adjust the height as needed */
    overflow-y: auto;

  }
 
</style>