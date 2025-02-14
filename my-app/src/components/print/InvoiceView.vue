<template>
    <v-dialog v-model="dialog" max-width="800px">
      <v-container class="invoice-container">
        <v-row>
          <v-col cols="12">
            <v-card class="invoice-card">
              <v-card-title>
                <h5 class="title-mepet">Invoice</h5>
              </v-card-title>
              <v-card-text ref="invoiceContent">
                <div class="invoice-details">
                  <p class="center-invoice-code">FAKTUR</p>
                  <p class="center-invoice-code">{{ transaction.kodeInvoice }}</p>
                  <div class="flex-container">
                    <p><strong>Kode Customer:</strong> {{ transaction.kodeCustomer }}</p>
                    <p class="right-details">{{ formatDate(transaction.tanggal) }}</p>
                  </div>
                  <div class="flex-container">
                    <p><strong>Nama Customer:</strong> {{ transaction.namaCustomer }}</p>
                    <p class="right-details"><strong>No. Polisi:</strong> {{ transaction.nopolCustomer }}</p>
                  </div>
                  <div class="flex-container">
                    <p><strong>Alamat:</strong> {{ transaction.alamatCustomer }}</p>
                    <p class="right-details"><strong>No. HP:</strong> {{ transaction.noHpCustomer }}</p>
                  </div>
                  <p><strong>Keterangan:</strong> {{ transaction.keterangan }}</p>
                </div>
                <v-simple-table class="invoice-table">
                  <thead>
                    <tr>
                      <th>Nama Item</th>
                      <th>Harga</th>
                      <th>Qty</th>
                      <th>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(item, index) in transaction.items" :key="index">
                      <td>{{ item.nama }}</td>
                      <td>{{ formatHarga(item.hpp) }}</td>
                      <td>{{ item.qty }}</td>
                      <td>{{ formatHarga(item.hpp * item.qty) }}</td>
                    </tr>
                  </tbody>
                </v-simple-table>
                <div class="total">
                  <strong>SubTotal:</strong> {{ formatHarga(transaction.total) }}
                </div>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-dialog>
  </template>
  
  <script>
  import { formatHarga } from '@/mixins/FilterMixin';
  
  export default {
    props: {
      transaction: {
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
      formatHarga,
    
      closeDialogOnEsc(event) {
        if (event.key === 'Escape' && this.dialog) {
          this.dialog = false;
        }
      },
      saveTransaction() {
        // Simpan transaksi di sini
        // ...

        // Setelah menyimpan transaksi, panggil printInvoice
        this.printInvoice();
      },
      printInvoice() {
        const printContents = this.$refs.invoiceContent.innerHTML;
        const originalContents = document.body.innerHTML;

        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
        window.location.reload(); // Optional: Reload the page after printing
      },
    
    },
    mounted() {
      this.printInvoice();
      window.addEventListener('keydown', this.closeDialogOnEsc);
    },
    beforeDestroy() {
      window.removeEventListener('keydown', this.closeDialogOnEsc);
    }
  }
  </script>
  
  <style scoped>
.invoice-container {
  padding: 20px;
  background-color: #f9f9f9b9;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 1);
  border-radius: 10px;
}

.invoice-card {
  border-radius: 10px;
  background-color: #f0ecec76;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 1);
}

.invoice-details {
  font-family: 'NamaFontBaru', sans-serif;
  font-size: 14px;
}

.invoice-details p {
  margin: 5px 0;
}

.invoice-table {
  margin-top: 20px;
  width: 100%;
  border-collapse: collapse;
}

.invoice-table th, .invoice-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
  font-size: 0.80;
}

.invoice-table th {
  background-color: #f2f2f2;
  font-weight: bold;
}

.total {
  font-weight: bold;
  margin-top: 15px;
  color: rgb(53, 51, 51);
  text-align: right;
  font-size: 0.95em;
  border: 1px solid #ddd;
  padding: 5px;
  width: 100%; /* Make the total div the same width as the table */
  box-sizing: border-box; /* Include padding and border in the element's total width and height */
}

.center-invoice-code {
  text-align: center !important;
  width: 100%;
  font-weight: bold;
  margin: 0;
}

.right-invoice-date {
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
    size: 21.0cm 29.7cm !important; /* Ukuran A4 */
    margin: 1cm !important; /* Add margin to avoid content touching the edges */
  }
  body {
    margin: 0;
    transform: scale(1); /* Ensure no scaling is applied */
    transform-origin: top left;
  }
  .invoice-container {
    width: 100%;
    transform: scale(1); /* Ensure no scaling is applied */
    transform-origin: top left;
  }
}
</style>
