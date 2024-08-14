<template>
  <v-dialog v-model="dialog" max-width="800px">
    <v-container class="bpb-container">
      <v-row>
        <v-col cols="12">
          <v-card class="bpb-card">
            <v-card-title>
              <h5 class="title-mepet">Bukti Retur Barang</h5>
            </v-card-title>
            <v-card-text ref="bpbContent">
              <div class="bpb-details">
                <p class="center-bpb-code">RETUR SUPLLIER</p>
                <p class="center-bpb-code">{{ receipt.kodeReceipt }}</p>
                <div class="flex-container">
                  <p><strong>Kode Supplier:</strong> {{ receipt.kodeSupplier }}</p>
                  <p class="right-details">{{ formatDate(receipt.tanggal) }}</p>
                </div>
                <div class="flex-container">
                  <p><strong>Nama Supplier:</strong> {{ receipt.namaSupplier }}</p>
                  <p class="right-details"><strong>Email:</strong> {{ receipt.email }}</p>
                </div>
                <div class="flex-container">
                  <p><strong>Alamat:</strong> {{ receipt.alamat }}</p>
                  <p class="right-details"><strong>No. HP:</strong> {{ receipt.no_hp }}</p>
                </div>
                <p><strong>Keterangan:</strong> {{ receipt.keterangan }}</p>
              </div>
              <v-simple-table class="bpb-table">
                <thead>
                  <tr>
                    <th>Kode Item</th>
                    <th>Nama Item</th>
                    <th>Uom</th>
                    <th>Qty</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, index) in receipt.items" :key="index">
                    <td>{{ item.itemCode }}</td>
                    <td>{{ item.itemName }}</td>
                    <td>{{ item.uom }}</td>
                    <td>{{ item.qty }}</td>
                  </tr>
                </tbody>
              </v-simple-table>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-dialog>
</template>

<script>

export default {
  props: {
    receipt: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      dialog: true
    };
  },
  methods: {
    formatDate(date) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(date).toLocaleDateString('id-ID', options);
    },
  
    closeDialogOnEsc(event) {
      if (event.key === 'Escape' && this.dialog) {
        this.dialog = false;
      }
    },
    submitReceipt() {
      // Simpan transaksi di sini
      // ...

      // Setelah menyimpan transaksi, panggil printInvoice
      this.printBpb();
    },
    printBpb() {
      const printContents = this.$refs.bpbContent.innerHTML;
      const originalContents = document.body.innerHTML;

      document.body.innerHTML = printContents;
      window.print();
      document.body.innerHTML = originalContents;
      window.location.reload(); // Optional: Reload the page after printing
    },
  
  },
  mounted() {
    // console.log('Receipt data Doc:', this.receipt); // Tambahkan log ini
    this.printBpb();
    window.addEventListener('keydown', this.closeDialogOnEsc);
  },
  beforeDestroy() {
    window.removeEventListener('keydown', this.closeDialogOnEsc);
  }
}
</script>

<style scoped>
.bpb-container {
padding: 20px;
background-color: #f9f9f9b9;
box-shadow: 0 0 10px 0 rgba(0, 0, 0, 1);
border-radius: 10px;
}

.bpb-card {
border-radius: 10px;
background-color: #f0ecec76;
box-shadow: 0 0 10px 0 rgba(0, 0, 0, 1);
}

.invoice-details p {
margin: 5px 0;
}

.bpb-table {
margin-top: 20px;
width: 100%;
border-collapse: collapse;
}

.bpb-table th, .bpb-table td {
border: 1px solid #ddd;
padding: 8px;
text-align: left;
}

.bpb-table th {
background-color: #f2f2f2;
font-weight: bold;
}

.total {
font-weight: bold;
margin-top: 20px;
color: rgb(118, 115, 115);
text-align: right;
font-size: 1em;
border: 1px solid #ddd;
padding: 10px;
border-radius: 10px;
width: 100%; /* Make the total div the same width as the table */
box-sizing: border-box; /* Include padding and border in the element's total width and height */
}

.center-bpb-code {
text-align: center !important;
width: 100%;
font-size: 1.2em;
font-weight: bold;
margin: 0;
}

.right-bpb-date {
text-align: right;
display: inline-block;
width: 50%;
}

.right-details {
text-align: right;
}

.flex-container {
display: flex;
justify-content: space-between;
}

@media print {
@page {
  size: 21.59cm 14.00cm;
  margin: 1cm; /* Add margin to avoid content touching the edges */
}
body {
  margin: 0;
  transform: scale(0.6); /* Adjust the scale as needed */
  transform-origin: top left;
}
.bpb-container {
  width: 100%;
  transform: scale(0.6); /* Adjust the scale as needed */
  transform-origin: top left;
}
}
</style>