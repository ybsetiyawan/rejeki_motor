<template>
  <v-card>
    <v-card-title>
      <v-btn text elevation="1">
          <span>
            MASTER CUSTOMER
          </span>
        </v-btn>
      <v-spacer></v-spacer>
      <v-text-field
        class="font"
        label="Cari Berdasarkan Kode atau Nama Customer"
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
    <v-simple-table class="small-table">
      <thead class="header-container">
        <tr class="font">
          <th class="text-left kode-customer column-width">KODE CUSTOMER</th>
          <th class="text-left nama-customer column-width">NAMA CUSTOMER</th>
          <th class="text-left nomor-polisi column-width">NOMOR POLISI</th>
          <th class="text-left alamat column-width">ALAMAT</th>
          <th class="text-left no-hp column-width">NO HP</th>
          <th class="text-left action column-width">
            <v-btn
              small
              class="mt-2"
              @click="openAddDialog">Tambah</v-btn>
          </th>
        </tr>
      </thead>
    <!-- Dialog untuk Tambah Satuan -->
    <v-dialog v-model="dialog" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">Tambah Customer</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12" md="6">
                <v-text-field label="Nama Customer" v-model="newCustomer.nama" required></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field label="Nomor Polisi" v-model="newCustomer.nopol" required></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field label="Alamat" v-model="newCustomer.alamat" required></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field label="No Hp" v-model="newCustomer.no_hp" required></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">Batal</v-btn>
          <v-btn color="blue darken-1" text @click="addOrUpdateCustomer">Simpan Perubahan</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Tabel untuk Body dengan Scroll -->
      <tbody class="cart-body">
        <tr v-for="customer in filteredCustomers" :key="customer.id">
          <td>{{ customer.kode }}</td>
          <td>{{ toUpperCase(customer.nama) }}</td>
          <td>{{ toUpperCase(customer.nopol) }}</td>
          <td>{{ toUpperCase(customer.alamat) }}</td>
          <td>{{ customer.no_hp }}</td>
          <td>
            <v-btn
              icon
              color="success"
              size="small"
              class="font" @click="editCustomer(customer.id)">
              <v-icon>mdi-pencil-box</v-icon>
            </v-btn>
            <v-btn
              icon
              color="error"
              size="small"
              class="font" @click="hapusCustomer(customer.id)">
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
  name: 'CustomerView',
  data() {
    return {
      customers: [],
      newCustomer: {},
      dialog: false,
      search: '',
      isEditing: false, // Tambahkan ini untuk melacak apakah sedang edit atau tambah
      toUpperCase: toUpperCase
    }
  },
  computed: {
    filteredCustomers() {
      return filterData(this.customers, this.search);
    }
  },
  mounted() {
    this.loadCustomers();
  },
  methods: {
    loadCustomers() {
      // axios.get('http://localhost:4000/m_customer')
      api.get('/m_customer')
      .then(response => {
        this.customers = response.data;
      })
    },
 
    addCustomer(){
      if (!this.newCustomer.nama || !this.newCustomer.nopol || !this.newCustomer.alamat || !this.newCustomer.no_hp) {
        alert('Nama Customer, Nomor Polisi, Alamat, dan No Hp tidak boleh kosong.');
        return;
      }
      this.newCustomer.nopol = this.newCustomer.nopol.replace(/\s+/g, ''); // Hilangkan spasi
      toUpperCaseFields(this.newCustomer, ['nama', 'nopol', 'alamat']);
      if(!isUnique(this.customers, 'nopol', this.newCustomer.nopol)){
        alert('Nomor Polisi sudah ada.');
        return;
      }
      // axios.post('http://localhost:4000/m_customer', this.newCustomer)
      api.post('/m_customer', this.newCustomer)
      .then(response => {
        this.customers.push(response.data);
        this.newCustomer = {}; // Kosongkan form setelah data berhasil ditambahkan
        this.dialog = false; 
        alert('Data berhasil ditambahkan.');
        this.loadCustomers();
      })
    },

    openAddDialog() {
      this.newCustomer = {}; // Kosongkan form setiap kali dialog dibuka untuk menambah
      this.isEditing = false; // Tandai bahwa ini bukan sesi edit
      this.dialog = true;
    },
  
    editCustomer(id) {
      this.newCustomer = { ...this.customers.find(customer => customer.id === id) };
      this.isEditing = true; // Tandai bahwa ini adalah sesi edit
      this.dialog = true;
    },
    updateCustomer() {
      if (!this.newCustomer.nama) {
        alert('Nama Customer tidak boleh kosong.');
        return;
      }
      this.newCustomer.nopol = this.newCustomer.nopol.replace(/\s+/g, ''); // Hilangkan spasi
      toUpperCaseFields(this.newCustomer, ['nama', 'nopol', 'alamat']);
      // axios.put(`http://localhost:4000/m_customer/${this.newCustomer.id}`, this.newCustomer)
      api.put(`/m_customer/${this.newCustomer.id}`, this.newCustomer)
        .then(response => {
          const index = this.customers.findIndex(customer => customer.id === this.newCustomer.id);
          if (index !== -1) {
            this.customers.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadCustomers(); // Memanggil loadSatuans untuk memperbarui tampilan
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memperbarui data:', error);
          alert('Gagal memperbarui data: ' + error.message);
        });
    },
    addOrUpdateCustomer() {
      if (this.isEditing) {
        this.updateCustomer();
      } else {
        this.addCustomer();
      }
    },
    hapusCustomer(id) {
      if (confirm('Apakah Anda yakin ingin menghapus customer ini?')) {
        // axios.delete(`http://localhost:4000/m_customer/${id}`)
        api.delete(`/m_customer/${id}`)
          .then(() => {
            this.customers = this.customers.filter(customer => customer.id !== id);
            // alert('Satuan berhasil dihapus.');
          })
          .catch(error => {
            console.error('Terjadi kesalahan saat menghapus customer:', error);
            alert('Data Customer Tidak Bisa Dihapus: ' + error.message);
          });
      }
    }
  }
}
</script>
