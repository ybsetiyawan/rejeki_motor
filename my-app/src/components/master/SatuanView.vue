<template>
  <v-card>
    <v-card-title>
      <v-btn text elevation="1">
          <span>
            MASTER SATUAN
          </span>
        </v-btn>
      <v-spacer></v-spacer>
      <v-text-field
        class="font"
        label="Cari Berdasarkan ID atau Nama Satuan"
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
      <thead class="header-container">
        <tr>
          <th class="text-left id-satuan">ID</th>
          <th class="text-left nama-satuan">NAMA</th>
          <th class="text-left nama-satuan">
            <v-btn
              small
              class="mt-1"
              @click="openAddDialog">Tambah</v-btn>
          </th>
        </tr>
      </thead>
    <!-- Dialog untuk Tambah Satuan -->
    <v-dialog v-model="dialog" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">Tambah Satuant</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field label="Nama Satuan" v-model="newSatuan.nama" required></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">Batal</v-btn>
          <v-btn color="blue darken-1" text @click="addOrUpdateSatuan">Simpan Perubahan</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- Tabel untuk Body dengan Scroll -->
      <tbody class="cart-body">
        <tr v-for="satuan in filteredSatuans" :key="satuan.id">
          <td class="id-satuan">{{ satuan.id }}</td>
          <td class="nama-satuan">{{ toUpperCase(satuan.nama) }}</td>
          <td class="nama-satuan">
            <v-btn
              icon
              color="success"
              size="small"
              class="font" @click="editSatuan(satuan.id)">
              <v-icon>mdi-pencil-box</v-icon>
            </v-btn>
            <v-btn
              icon
              color="error"
              size="small"
              class="font" @click="hapusSatuan(satuan.id)">
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
import { isUnique, toUpperCase, toUpperCaseFields  } from '../../mixins/FilterMixin';

export default {
  name: 'SatuanView',
  data() {
    return {
      satuans: [],
      newSatuan: {},
      dialog: false,
      search: '',
      isEditing: false, // Tambahkan ini untuk melacak apakah sedang edit atau tambah
      toUpperCase: toUpperCase
    }
  },
  computed: {
    filteredSatuans() {
      return this.satuans.filter(satuan => {
        const searchLower = this.search.toLowerCase();
        return (satuan.id && satuan.id.toString().toLowerCase().includes(searchLower)) || (satuan.nama && satuan.nama.toLowerCase().includes(searchLower));
      });
    }
  },
  mounted() {
    this.loadSatuans();
  },
  methods: {
    loadSatuans() {
      // axios.get('http://localhost:4000/m_satuan')
      api.get('/m_satuan')
      .then(response => {
        this.satuans = response.data;
      })
    },
 
    addSatuan(){
      if (!this.newSatuan.nama) {
        alert('Nama satuan tidak boleh kosong.');
        return;
      }
      toUpperCaseFields(this.newSatuan, ['nama']);
      if (!isUnique(this.satuans, 'nama', this.newSatuan.nama)) {
        alert('Nama satuan sudah ada.');
        return;
      }
      // axios.post('http://localhost:4000/m_satuan', this.newSatuan)
      api.post('/m_satuan', this.newSatuan)
      .then(response => {
        this.satuans.push(response.data);
        this.newSatuan = {}; // Kosongkan form setelah data berhasil ditambahkan
        this.dialog = false;
        alert('Data berhasil ditambahkan.');
        this.loadSatuans();
      })
    },

    openAddDialog() {
      this.newSatuan = {}; // Kosongkan form setiap kali dialog dibuka untuk menambah
      this.isEditing = false; // Tandai bahwa ini bukan sesi edit
      this.dialog = true;
    },
  
    editSatuan(id) {
      this.newSatuan = { ...this.satuans.find(satuan => satuan.id === id) };
      this.isEditing = true; // Tandai bahwa ini adalah sesi edit
      this.dialog = true;
    },
    updateSatuan() {
      if (!this.newSatuan.nama) {
        alert('Nama satuan tidak boleh kosong.');
        return;
      }
      toUpperCaseFields(this.newSatuan, ['nama']);
      if (!isUnique(this.satuans, 'nama', this.newSatuan.nama)) {
        alert('Nama satuan sudah ada.');
        return;
      }
      // axios.put(`http://localhost:4000/m_satuan/${this.newSatuan.id}`, this.newSatuan)
      api.put(`/m_satuan/${this.newSatuan.id}`, this.newSatuan)
        .then(response => {
          const index = this.satuans.findIndex(satuan => satuan.id === this.newSatuan.id);
          if (index !== -1) {
            this.satuans.splice(index, 1, response.data);
          }
          this.dialog = false;
          this.loadSatuans(); // Memanggil loadSatuans untuk memperbarui tampilan
          alert('Data berhasil diperbarui.');
        })
        .catch(error => {
          console.error('Terjadi kesalahan saat memperbarui data:', error);
          alert('Gagal memperbarui data: ' + error.message);
        });
    },
    addOrUpdateSatuan() {
      if (this.isEditing) {
        this.updateSatuan();
      } else {
        this.addSatuan();
      }
    },
    hapusSatuan(id) {
      if (confirm('Apakah Anda yakin ingin menghapus satuan ini?')) {
        // axios.delete(`http://localhost:4000/m_satuan/${id}`)
        api.delete(`/m_satuan/${id}`)
          .then(() => {
            this.satuans = this.satuans.filter(satuan => satuan.id !== id);
            // alert('Satuan berhasil dihapus.');
          })
          .catch(error => {
            console.error('Terjadi kesalahan saat menghapus satuan:', error);
            alert(error.response.data.message);
          });
      }
    }
  }
}
</script>
<style src="../../assets/css/master.css"></style>
