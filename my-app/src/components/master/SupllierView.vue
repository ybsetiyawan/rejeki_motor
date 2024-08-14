<template>
  <v-card>
    <v-card-title class="font">
      MASTER SUPPLIER
      <v-spacer></v-spacer>
      <v-text-field
        class="font"
        label="Cari Berdasarkan Kode atau Nama Supplier"
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
        <tr class="font">
          <th class="text-left kode-customer column-width">KODE SUPPLIER</th>
          <th class="text-left nama-customer column-width">NAMA SUPPLIER</th>
          <th class="text-left alamat column-width">ALAMAT</th>
          <th class="text-left no-hp column-width">NO HP</th>
          <th class="text-left nomor-polisi column-width">EMAIL</th>
          <th class="text-left action column-width">
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
          <span class="headline">Tambah Supplier</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12" md="6">
                <v-text-field label="Nama Supplier" v-model="newSupplier.nama" required></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field label="No HP" v-model="newSupplier.no_hp" required></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field label="Alamat" v-model="newSupplier.alamat" required></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field label="Email" v-model="newSupplier.email" required></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">Batal</v-btn>
          <v-btn color="blue darken-1" text @click="addOrUpdateSupplier">Simpan Perubahan</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Tabel untuk Body dengan Scroll -->
    <v-simple-table class="scrollable-table font">
      <tbody>
        <tr v-for="supplier in filteredSuppliers" :key="supplier.id">
          <td class="text-left kode-customer column-width">{{ supplier.kode }}</td>
          <td class="text-left nama-customer column-width">{{ toUpperCase(supplier.nama) }}</td>
          <td class="text-left alamat column-width">{{ toUpperCase(supplier.alamat) }}</td>
          <td class="text-left no-hp column-width">{{ supplier.no_hp }}</td>
          <td class="text-left nomor-polisi column-width">{{ toUpperCase(supplier.email) }}</td>
          <td class="text-left action column-width">
            <v-btn
              icon
              color="success"
              size="small"
              class="font" @click="editSupplier(supplier.id)">
              <v-icon>mdi-pencil-box</v-icon>
            </v-btn>
            <v-btn
              icon
              color="error"
              size="small"
              class="font" @click="hapusSupplier(supplier.id)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </td>
        </tr>
      </tbody>
    </v-simple-table>
  </v-card>
</template>

<style scoped>
.column-width {
  width: 17.60%;
}
</style>

<script>
// import axios from 'axios';
import api from '../../services/api';
import { isUnique, toUpperCase, toUpperCaseFields, filterData } from '../../mixins/FilterMixin';

export default {
  name: 'SupllierView',
  data() {
    return {
      suppliers: [],
      newSupplier: {},
      dialog: false,
      search: '',
      isEditing: false, // Tambahkan ini untuk melacak apakah sedang edit atau tambah
      toUpperCase: toUpperCase
    }
  },
  computed: {
    
    filteredSuppliers() {
      return filterData(this.suppliers, this.search);
    }
  },
  mounted() {
    this.loadSuppliers();
  },
  methods: {
    loadSuppliers() {
      // axios.get('http://localhost:4000/m_supplier')
      api.get('/m_supplier')
      .then(response => {
        this.suppliers = response.data;
      })
    },
 
    addSupplier(){
      if (!this.newSupplier.nama || !this.newSupplier.no_hp || !this.newSupplier.alamat || !this.newSupplier.email) {
        alert('Nama Supplier, No HP, Alamat, dan Email tidak boleh kosong.');
        return;
      }
      this.newSupplier.no_hp = this.newSupplier.no_hp.replace(/\s+/g, ''); // Hilangkan spasi
      toUpperCaseFields(this.newSupplier, ['nama', 'no_hp', 'alamat', 'email']);
      if(!isUnique(this.suppliers, 'email', this.newSupplier.email)){
        alert('Email sudah ada.');
        return;
      }
      // axios.post('http://localhost:4000/m_supplier', this.newSupplier)
      api.post('/m_supplier', this.newSupplier)
      .then(response => {
        this.suppliers.push(response.data);
        this.newSupplier = {}; // Kosongkan form setelah data berhasil ditambahkan
        this.dialog = false; 
        alert('Data berhasil ditambahkan.');
        this.loadSuppliers();
      })
    },

    openAddDialog() {
      this.newSupplier = {}; // Kosongkan form setiap kali dialog dibuka untuk menambah
      this.isEditing = false; // Tandai bahwa ini bukan sesi edit
      this.dialog = true;
    },
  
    editSupplier(id) {
      this.newSupplier = { ...this.suppliers.find(supplier => supplier.id === id) };
      this.isEditing = true; // Tandai bahwa ini adalah sesi edit
      this.dialog = true;
    },
    updateSupplier() {
      if (!this.newSupplier.nama) {
        alert('Nama Supplier tidak boleh kosong.');
        return;
      }
      this.newSupplier.no_hp = this.newSupplier.no_hp.replace(/\s+/g, ''); // Hilangkan spasi
      toUpperCaseFields(this.newSupplier, ['nama', 'no_hp', 'alamat', 'email']);
      // axios.put(`http://localhost:4000/m_supplier/${this.newSupplier.id}`, this.newSupplier)
      api.put(`/m_supplier/${this.newSupplier.id}`, this.newSupplier)
        .then(response => {
          const index = this.suppliers.findIndex(supplier => supplier.id === this.newSupplier.id);
          if (index !== -1) {
            this.suppliers.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadSuppliers(); // Memanggil loadSuppliers untuk memperbarui tampilan
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memperbarui data:', error);
          alert('Gagal memperbarui data: ' + error.message);
        });
    },
    addOrUpdateSupplier() {
      if (this.isEditing) {
        this.updateSupplier();
      } else {
        this.addSupplier();
      }
    },
    hapusSupplier(id) {
      if (confirm('Apakah Anda yakin ingin menghapus supplier ini?')) {
        // axios.delete(`http://localhost:4000/m_supplier/${id}`)
        api.delete(`/m_supplier/${id}`)
          .then(() => {
            this.suppliers = this.suppliers.filter(supplier => supplier.id !== id);
            // alert('Satuan berhasil dihapus.');
          })
          .catch(error => {
            console.error('Terjadi kesalahan saat menghapus satuan:', error);
            alert('Gagal menghapus satuan: ' + error.message);
          });
      }
    }
  }
}
</script>
