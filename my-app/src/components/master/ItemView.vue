<template>
  <v-card>
    <v-card-title class="font">
      MASTER ITEM
      <v-spacer></v-spacer>
      <v-text-field
        class="font"
        label="Cari Berdasarkan Kode atau Nama Item"
        single-line
        hide-details
        v-model="search"
      >
        <template v-slot:prepend-inner>
          <v-btn
          color="blue"
          elevation="8"
          @click="searchItems"
          :disabled="!search"
          class="font"
          x-small
           >
            <v-icon size="19px">mdi-magnify</v-icon>
          </v-btn>
        </template>
      </v-text-field>
    </v-card-title>
    <!-- Tabel untuk Header -->
    <v-simple-table class="font">
      <thead>
        <tr>
          <th class="text-left column-width">KODE ITEM</th>
          <th class="text-left column-width">NAMA ITEM</th>
          <th class="text-left column-width">JENIS ITEM</th>
          <th class="text-left column-width modal-column">MODAL</th>
          <th class="text-left column-width hpp-column">HPP</th>
          <th class="text-left column-width stok-column">STOK</th>
          <th class="text-left column-width uom-column">UOM</th>
          <th class="text-right column-width">
            <v-btn
              class="font"
              @click="openAddDialog">Tambah</v-btn>
          </th>
        </tr>
      </thead>
    </v-simple-table>
    <!-- Dialog untuk Tambah Satuan -->
    <v-dialog v-model="dialog" persistent max-width="400px">
      <v-card>
        <v-card-title class="headline">Tambah Item Baru</v-card-title>
        <v-card-text class="small-text">
          <v-container>
            <v-row>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Kode Item"
                  v-model="newItem.kode"
                  :disabled="isEditing"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Nama Item"
                  v-model="newItem.nama"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-select
                  label="Jenis Item"
                  v-model="newItem.jenis_item_id"
                  :items="jenisItems"
                  item-text="nama"
                  item-value="id"
                  required
                  dense
                ></v-select>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Modal"
                  v-model="newItem.modal"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Hpp"
                  v-model="newItem.hpp"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  label="Stok"
                  v-model="newItem.stok"
                  :disabled="isEditing"
                  required
                  dense
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-select
                  label="Satuan"
                  v-model="newItem.satuan_id"
                  :items="satuanItems"
                  item-text="nama"
                  item-value="id"
                  required
                  dense
                ></v-select>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">Batal</v-btn>
          <v-btn color="blue darken-1" text @click="addOrUpdateItem">Simpan</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
   
    <!-- Tabel untuk Body dengan Scroll -->
    <v-simple-table class="scrollable-table font">
      <tbody>
        <tr v-for="item in items" :key="item.id">
          <td class="text-left column-width">{{ toUpperCase(item.kode) }}</td>
          <td class="text-left column-width">{{ toUpperCase(item.nama) }}</td>
          <td class="text-left column-width">{{ toUpperCase(item.jenis_item_nama) }}</td>
          <td class="text-left column-width modal-column">{{ formatHarga(item.modal) }}</td>
          <td class="text-left column-width hpp-column">{{ formatHarga(item.hpp) }}</td>
          <td class="text-left column-width stok-column">{{ item.stok }}</td>
          <td class="text-left column-width uom-column">{{ toUpperCase(item.satuan_nama) }}</td>
          <td class="text-right column-width">
            <v-btn
              icon
              color="success"
              size="small"
              class="font" @click="editItem(item.item_id)">
              <v-icon>mdi-pencil-box</v-icon>
            </v-btn>
            <v-btn
              icon
              color="error"
              size="small"
              class="font" @click="deleteItem(item.item_id)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </td>
        </tr>
      </tbody>
    </v-simple-table>
    <v-pagination
    class="custom-pagination"
    v-model="currentPage"
    :length="pageCount"
    :total-visible="7"
    @input="loadItems"
></v-pagination>
  </v-card>
</template>
<script>
// import axios from 'axios';
import api from '../../services/api';
import { formatHarga, isUnique, toUpperCase, toUpperCaseFields } from '../../mixins/FilterMixin';
// import { loadItems } from '@/utils/utils';

export default {
  name: 'ItemView',
  data() {
    return {
      items: [],
      newItem: {},
      dialog: false,
      search: '',
      isEditing: false,
      jenisItems: [], // Data untuk jenis item
      satuanItems: [], // Data untuk satuan
      valid: true,
      currentPage: 1,
      pageSize: 10,
      totalItems: 0, 
      formatHarga,
      toUpperCase,
    }
  },
  computed: {
    // filteredItems() {
    //   return filterData(this.items, this.search);
    // },
    // filteredItems() {
    //     return filterData(this.items, this.search);
    // },
    pageCount() {
        return Math.ceil(this.totalItems / this.pageSize);
    }
  
  },
  mounted() {
    this.loadItems();
    this.loadJenisItems();
    this.loadSatuanItems();
  },
  methods: {
    loadItems() {
      return api.get('/m_item', {
        params: {
          page: this.currentPage,
          pageSize: this.pageSize,
          search: this.search, // Kirimkan filter pencarian
        },
      })
      .then(response => {
        this.items = response.data.items; // Data item
        this.totalItems = response.data.total; // Total item dari backend
      })
      .catch(error => {
        console.error('Error loading items:', error);
      });
    },
    loadJenisItems() {
      // axios.get('http://localhost:4000/m_jenis_item')
      api.get('/m_jenis_item')
        .then(response => {
          this.jenisItems = response.data;
        })
        .catch(error => console.error('Error loading jenis items:', error));
    },
    loadSatuanItems() {
      // axios.get('http://localhost:4000/m_satuan')
      api.get('/m_satuan')
        .then(response => {
          this.satuanItems = response.data;
        })
        .catch(error => console.error('Error loading satuan items:', error));
    },
    addItem(){
      if(!this.newItem.kode || !this.newItem.nama || !this.newItem.stok || !this.newItem.hpp|| !this.newItem.modal){
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      this.newItem.kode = this.newItem.kode.toUpperCase();
      this.newItem.nama = this.newItem.nama.toUpperCase();
      if (!isUnique(this.items, 'kode', this.newItem.kode) || !isUnique(this.items, 'nama', this.newItem.nama)) {
        alert('Kode Item atau nama sudah digunakan, Silahkan gunakan Kode lain');
        return;
      }
      toUpperCaseFields(this.newItem, ['kode', 'nama']);
      if (!isUnique(this.items, 'kode', this.newItem.kode)) {
        alert('Kode Item sudah digunakan, Silahkan gunakan Kode lain');
        return;
      }
      
      // console.log('Jenis Item ID:', this.newItem.jenis_item_id); // Debug Jenis Item ID
      // console.log('Satuan ID:', this.newItem.satuan_id); // Debug Satuan ID
      // console.log('Adding new item'); // Log saat tambah baru
      // axios.post('http://localhost:4000/m_item', {
      api.post('/m_item', {
        kode: this.newItem.kode,
        nama: this.newItem.nama,
        id_jenis_item: this.newItem.jenis_item_id,  // Pastikan hanya ID yang dikirim
        modal: this.newItem.modal,
        hpp: this.newItem.hpp,
        stok: this.newItem.stok,
        id_satuan: this.newItem.satuan_id  // Pastikan hanya ID yang dikirim
      })
      .then(response => {
        this.items.push(response.data);
        this.newItem = {}; // Kosongkan form setelah data berhasil disimpan
        this.dialog = false;
        alert('Data berhasil ditambahkan');
        this.loadItems(); // Muat ulang item untuk memperbarui tampilan
      })
      .catch(error => {
        console.error('Error adding item:', error);
        alert('Terjadi kesalahan saat menambah item.');
      });
    },

    openAddDialog() {
      this.newItem = {}; // Kosongkan form setiap kali dialog dibuka untuk menambah
      this.isEditing = false; // Tandai bahwa ini bukan sesi edit
      this.dialog = true;
    },

    editItem(id){
      this.isEditing = true;
      this.newItem = {...this.items.find(item => item.item_id === id)};
      this.dialog = true;
    },


    updateItem() {
      if (!this.newItem.nama || !this.newItem.kode || !this.newItem.hpp || !this.newItem.stok || !this.newItem.modal
        || !this.newItem.jenis_item_id || !this.newItem.satuan_id) {
        alert('Ada data yang kosong, Silahkan isi data dengan benar');
        return;
      }
      toUpperCaseFields(this.newItem, ['kode', 'nama']);
      // axios.put(`http://localhost:4000/m_item/${this.newItem.item_id}`, {
      api.put(`/m_item/${this.newItem.item_id}`, {
        kode: this.newItem.kode,
        nama: this.newItem.nama,
        id_jenis_item: this.newItem.jenis_item_id,  // Pastikan hanya ID yang dikirim
        modal: this.newItem.modal,
        hpp: this.newItem.hpp,
        stok: this.newItem.stok,
        id_satuan: this.newItem.satuan_id  // Pastikan hanya ID yang dikirim
      })
      .then(response => {
        const index = this.items.findIndex(item => item.item_id === this.newItem.item_id);
        if (index !== -1) {
          this.items.splice(index, 1, response.data);
        }
        this.newItem = {}; // Kosongkan form setelah data berhasil diperbarui
        this.dialog = false;
        alert('Data berhasil diperbarui');
        this.loadItems(); // Muat ulang item untuk memperbarui tampilan
      })
      .catch(error => {
        console.error('Error updating item:', error);
        alert('Terjadi kesalahan saat memperbarui item.');
      });
    },
    addOrUpdateItem(){
      // Validasi nilai hpp dan stok harus integer
      if (!this.isValidInteger(Number(this.newItem.hpp)) || !this.isValidInteger(Number(this.newItem.stok)) 
      || !this.isValidInteger(Number(this.newItem.modal))) {
        alert('HPP dan Modal harus berupa angka bulat.');
        return;
      }

      if(this.isEditing){
        this.updateItem();
      }else{
        this.addItem();
      }
    },
    deleteItem(item_id){
      if(confirm('Apakah Anda yakin ingin menghapus item ini?')){
      // axios.delete(`http://localhost:4000/m_item/${item_id}`)
      api.delete(`/m_item/${item_id}`)
      .then(() => {
        this.items = this.items.filter(item => item.item_id !== item_id);
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
    searchItems() {
      this.currentPage = 1;
      this.loadItems().then(() => {
        if (this.items.length === 0) {
          alert('Tidak ada item yang ditemukan.');
        }
      });
    }
  }
}
</script>

<style scoped>

.column-width {
  width: 16.90%;
}

.hpp-column, .stok-column, .modal-column {
  width: 10%; /* Atur lebar kolom HPP sesuai kebutuhan */
}
.uom-column {
  width: 2%; /* Atur lebar kolom HPP sesuai kebutuhan */
}
.custom-pagination {
  font-size: 0.2rem; /* Adjust the font size as needed */
  padding: 3px; /* Adjust padding to reduce size */
  font-family: calibri;
}

</style>