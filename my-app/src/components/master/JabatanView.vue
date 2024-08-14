<template>
  <v-card>
    <v-card-title class="font">
      MASTER JABATAN
      <v-spacer></v-spacer>
      <v-text-field
        class="font"
        label="Search"
        single-line
        hide-details
        v-model="search"
      ></v-text-field>
    </v-card-title>
    <!-- Tabel untuk Header -->
    <v-simple-table class="font">
      <thead>
        <tr>
          <th class="text-left kode-lokasi">Kode Jabatan</th>
          <th class="text-left nama-lokasi">Nama Jabatan</th>
        </tr>
      </thead>
    </v-simple-table>
    <!-- Tabel untuk Body dengan Scroll -->
    <v-simple-table class="scrollable-table font">
      <tbody>
        <tr v-for="jabatan in filteredJabatans" :key="jabatan.id">
          <td class="kode-jabatan">{{ jabatan.jabatan_id }}</td>
          <td class="nama-jabatan">{{ jabatan.jabatan_name }}</td>
        </tr>
      </tbody>
    </v-simple-table>
  </v-card>
</template>
<script>
// import axios from 'axios';
import api from '../../services/api';
import { filterData } from '../../mixins/FilterMixin';


export default {
  name: 'DaftarJabatan',
  data() {
    return {
      jabatans: [],
      search: ''
    }
  },
  computed: {
    filteredJabatans() {
      return filterData(this.jabatans, this.search);
    }
  },
  mounted() {
    // axios.get('http://localhost:4000/jabatan')
    api.get('/jabatan')
      .then(response => {
        this.jabatans = response.data;
      })
  }
}
</script>
<style>
.scrollable-table {
  max-height: 350px; /* Atur sesuai kebutuhan */
  overflow-y: auto;
}
.kode-jabatan, .nama-jabatan {
  width: 20%; /* Sesuaikan lebar sesuai kebutuhan */
}
.nama-jabatan {
  width: 70%; /* Sesuaikan lebar sesuai kebutuhan */
} th{
  font-size: medium !important;
  
}.font {
  font-family: Calibri;
}
</style>
