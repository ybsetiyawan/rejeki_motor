<template>
  <v-card>
    <v-card-title class="font">
      MASTER JENIS ITEM
      <v-spacer></v-spacer>
      <v-text-field
        class="font"
        label="Cari Berdasarkan Kode atau Nama Jenis Item"
        single-line
        hide-details
        v-model="search"
      >
      <template v-slot:prepend-inner>
        <v-icon>mdi-magnify</v-icon>
      </template>
    </v-text-field>
    </v-card-title>
    
    <!-- Tabel untuk Header -->
    <v-simple-table class="font">
      <thead>
        <tr>
          <th class="text-left kode-jenis">KODE JENIS ITEM</th>
          <th class="text-left nama-jenis">NAMA JENIS ITEM</th>
          <th class="text-left nama-jenis">
            <v-btn
              class="font"
              @click="openAddDialog">Tambah</v-btn>
          </th>
        </tr>
      </thead>
    </v-simple-table>
     <!-- Dialog untuk Tambah Satuan -->
     <v-dialog v-model="dialog" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">Tambah Jenis Item</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field label="Kode Jenis Item" v-model="newJenisItem.kode" required></v-text-field>
                <v-text-field label="Nama Jenis Item" v-model="newJenisItem.nama" required></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">Batal</v-btn>
          <v-btn color="blue darken-1" text @click="addOrUpdateJenisItem">Simpan Perubahan</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Tabel untuk Body dengan Scroll -->
    <v-simple-table class="scrollable-table font">
      <tbody>
        <tr v-for="jenis in filteredJeniss" :key="jenis.id">
          <td class="kode-jenis">{{ toUpperCase(jenis.kode) }}</td>
          <td class="nama-jenis">{{ toUpperCase(jenis.nama) }}</td>
          <td class="nama-jenis">
            <v-btn
              icon
              size="small"
              color="success"
              class="font"
              @click="editJenisItem(jenis.id)">
              <v-icon>mdi-pencil-box</v-icon>
            </v-btn>
            <v-btn
              icon
              color="error"
              size="small"
              class="font"
              @click="deleteJenisItem(jenis.id)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </td>
        </tr>
      </tbody>
    </v-simple-table>
  </v-card>
</template>
<script>
// import axios from 'axios';
import api from '../../services/api';
import { isUnique, toUpperCaseFields, toUpperCase,filterData } from '../../mixins/FilterMixin';

export default {
  name: 'JenisItemView',
  data() {
    return {
      jeniss: [],
      newJenisItem: {},
      dialog: false,
      search: '',
      isEditing: false,
      toUpperCase: toUpperCase
    }
  },
  computed: {
    filteredJeniss() {
      return filterData(this.jeniss, this.search);
    }
  },
  mounted() {
    this.loadJenisItem();
  },
  methods: {
    loadJenisItem(){
      // axios.get('http://localhost:4000/m_jenis_item')
      api.get('/m_jenis_item')
      .then(response => {
        this.jeniss = response.data;
      })
    },
    addJenisItem(){
      if(!this.newJenisItem.kode || !this.newJenisItem.nama){
        alert('Kode dan Nama Jenis Item tidak boleh kosong');
        return;
      }
      this.newJenisItem.kode = this.newJenisItem.kode.toUpperCase();
      this.newJenisItem.nama = this.newJenisItem.nama.toUpperCase();
      if (!isUnique(this.jeniss, 'kode', this.newJenisItem.kode) || !isUnique(this.jeniss, 'nama', this.newJenisItem.nama)) {
        alert('Kode Jenis Item atau nama sudah digunakan, Silahkan gunakan Kode lain');
        return;
      }
      // console.log('Adding new item'); // Log saat tambah baru
      // axios.post('http://localhost:4000/m_jenis_item', this.newJenisItem)
      api.post('/m_jenis_item', this.newJenisItem)
      .then(response => {
        this.jeniss.push(response.data);
        this.newJenisItem = {};
        this.dialog = false;
        alert('Data berhasil ditambahkan.');
        this.loadJenisItem();
      })
    },
    openAddDialog() {
      this.newJenisItem = {}; // Kosongkan form setiap kali dialog dibuka untuk menambah
      this.isEditing = false; // Tandai bahwa ini bukan sesi edit
      this.dialog = true;
    },
    editJenisItem(id){
      this.newJenisItem =  {...this.jeniss.find(jenis => jenis.id === id)};
      this.isEditing = true;
      this.dialog = true;
    },
    updateJenisItem() {
      if(!this.newJenisItem.kode || !this.newJenisItem.nama){
        alert('Kode dan Nama Jenis Item tidak boleh kosong');
        return;
      }
      if (this.isEditing && this.newJenisItem.kode !== this.jeniss.find(jenis => jenis.id === this.newJenisItem.id).kode) {
        if (!isUnique(this.jeniss, 'kode', this.newJenisItem.kode)) {
          alert('Kode Jenis Item Sudah digunakan');
          return;
        }
      }
      toUpperCaseFields(this.newJenisItem, ['kode', 'nama']);
      // axios.put(`http://localhost:4000/m_jenis_item/${this.newJenisItem.id}`, this.newJenisItem)
      api.put(`/m_jenis_item/${this.newJenisItem.id}`, this.newJenisItem)
        .then(response => {
          const index = this.jeniss.findIndex(jenis => jenis.id === this.newJenisItem.id);
          if (index !== -1) {
            this.jeniss.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadJenisItem();
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          alert('Gagal memperbarui data: ' + error.response.data.message);
        });
    },
    addOrUpdateJenisItem() {
      if (this.isEditing) {
        this.updateJenisItem();
      } else {
        this.addJenisItem();
      }
    },
    isKodeUnique(kode) {
      return !this.jeniss.some(jenis => jenis.kode === kode);
    },
    deleteJenisItem(id){
      if(confirm('Apakah Anda yakin ingin menghapus jenis item ini?')){
        // axios.delete('http://localhost:4000/m_jenis_item/' + id)
        api.delete('/m_jenis_item/' + id)
        .then(() => {
          this.loadJenisItem();
          alert('Data berhasil dihapus.');
        })
        .catch(error => {
          alert(error.response.data.message);
          console.error('Error deleting jenis item:', error);
        });
      }
    }
  }

}
</script>

