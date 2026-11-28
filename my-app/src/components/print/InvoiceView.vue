<template>
  <v-dialog
    v-model="internalDialog"
    max-width="820px"
    content-class="faktur-dialog-content"
    @click:outside="closeDialog"
    @keydown.esc.prevent="closeDialog"
  >
    <v-card class="faktur-dialog-card rounded-lg">
      <!-- Top Bar -->
      <v-toolbar
        flat
        color="white"
        class="faktur-toolbar px-4"
      >
        <v-avatar color="red lighten-5" size="36" class="mr-3">
          <v-icon color="red darken-2" small>mdi-receipt-text-outline</v-icon>
        </v-avatar>
        <div>
          <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
            Preview Faktur Transaksi
          </div>
          <div class="text-caption grey--text text--darken-1">
            {{ transaction.kodeInvoice || '-' }}
          </div>
        </div>

        <v-spacer></v-spacer>

        <v-btn
          small
          depressed
          color="red darken-2"
          class="white--text font-weight-medium text-none mr-2"
          @click="printInvoice"
        >
          <v-icon left small>mdi-printer</v-icon>
          Cetak Faktur
        </v-btn>

        <v-btn
          icon
          small
          color="grey darken-2"
          aria-label="Tutup dialog"
          title="Tutup & Refresh (Esc)"
          @click="closeDialog"
        >
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>

      <v-divider></v-divider>

      <!-- Area Faktur -->
      <v-card-text class="faktur-sheet-wrapper pa-5">
        <div id="faktur-print-area" ref="invoiceContent" class="faktur-sheet">
          <!-- Header Faktur -->
          <div class="faktur-header d-flex flex-wrap justify-space-between align-start pb-4 mb-4">
            <div>
              <div class="faktur-badge">FAKTUR PENJUALAN</div>
              <h2 class="faktur-title mt-1">REJEKI MOTOR</h2>
              <div class="faktur-subtitle">Bengkel &amp; Suku Cadang Kendaraan</div>
            </div>

            <div class="text-sm-right mt-2 mt-sm-0">
              <div class="faktur-meta-label">No. Faktur</div>
              <div class="faktur-code">{{ transaction.kodeInvoice || '-' }}</div>
              <div class="faktur-date mt-1">
                Tanggal: <strong>{{ formatDate(transaction.tanggal) }}</strong>
              </div>
            </div>
          </div>

          <!-- Info Customer & Kendaraan -->
          <div class="faktur-info-grid mb-4">
            <div class="faktur-info-box">
              <div class="info-row">
                <span class="info-label">Kode Customer</span>
                <span class="info-sep">:</span>
                <span class="info-val font-weight-bold">{{ transaction.kodeCustomer || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Nama Customer</span>
                <span class="info-sep">:</span>
                <span class="info-val font-weight-bold">{{ transaction.namaCustomer || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Alamat</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ transaction.alamatCustomer || '-' }}</span>
              </div>
            </div>

            <div class="faktur-info-box">
              <div class="info-row">
                <span class="info-label">No. Polisi</span>
                <span class="info-sep">:</span>
                <span class="info-val nopol-pill">{{ transaction.nopolCustomer || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">No. HP</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ transaction.noHpCustomer || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Keterangan</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ transaction.keterangan || '-' }}</span>
              </div>
            </div>
          </div>

          <!-- Tabel Item -->
          <div class="faktur-table-wrapper">
            <table class="faktur-table">
              <thead>
                <tr>
                  <th class="text-center" style="width: 46px;">No</th>
                  <th class="text-left">Nama Item</th>
                  <th class="text-right" style="width: 135px;">Harga</th>
                  <th class="text-center" style="width: 75px;">Qty</th>
                  <th class="text-right" style="width: 150px;">Total</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in (transaction.items || [])" :key="index">
                  <td class="text-center grey--text text--darken-1">{{ index + 1 }}</td>
                  <td class="font-weight-medium">{{ item.nama || '-' }}</td>
                  <td class="text-right">{{ formatHarga(item.hpp) }}</td>
                  <td class="text-center">{{ item.qty }}</td>
                  <td class="text-right font-weight-medium">
                    {{ formatHarga((Number(item.hpp) || 0) * (Number(item.qty) || 0)) }}
                  </td>
                </tr>
                <tr v-if="!transaction.items || transaction.items.length === 0">
                  <td colspan="5" class="text-center py-4 grey--text">Tidak ada item transaksi.</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Ringkasan SubTotal -->
          <div class="faktur-summary-row mt-4">
            <div class="faktur-note">
              Terima kasih telah bertransaksi di <strong>Rejeki Motor</strong>. Barang yang sudah dibeli tidak dapat ditukar/dikembalikan kecuali ada perjanjian.
            </div>
            <div class="faktur-subtotal-box">
              <div class="d-flex justify-space-between align-center">
                <span class="subtotal-label">SubTotal</span>
                <span class="subtotal-value">{{ formatHarga(transaction.total) }}</span>
              </div>
            </div>
          </div>
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
import { formatHarga } from '@/mixins/FilterMixin';

export default {
  name: 'InvoiceView',
  props: {
    value: {
      type: Boolean,
      default: undefined,
    },
    dialog: {
      type: Boolean,
      default: undefined,
    },
    transaction: {
      type: Object,
      required: true,
      default: () => ({
        kodeInvoice: '',
        kodeCustomer: '',
        namaCustomer: '',
        alamatCustomer: '',
        nopolCustomer: '',
        noHpCustomer: '',
        keterangan: '',
        tanggal: '',
        items: [],
        total: 0,
      }),
    },
  },
  data() {
    return {
      internalDialog: true,
    };
  },
  watch: {
    value: {
      immediate: true,
      handler(val) {
        if (typeof val === 'boolean') {
          this.internalDialog = val;
        }
      },
    },
    dialog: {
      immediate: true,
      handler(val) {
        if (typeof val === 'boolean') {
          this.internalDialog = val;
        }
      },
    },
  },
  mounted() {
    window.addEventListener('keydown', this.handleEscapeKey, true);
  },
  beforeDestroy() {
    window.removeEventListener('keydown', this.handleEscapeKey, true);
  },
  methods: {
    handleEscapeKey(event) {
      if ((event.key === 'Escape' || event.keyCode === 27) && this.internalDialog) {
        event.preventDefault();
        event.stopPropagation();
        this.closeDialog();
      }
    },
    formatDate(date) {
      if (!date) return '-';
      const d = new Date(date);
      if (Number.isNaN(d.getTime())) return date;
      return d.toLocaleDateString('id-ID', {
        day: '2-digit',
        month: 'long',
        year: 'numeric',
      });
    },
    formatHarga,
    closeDialog() {
      this.internalDialog = false;
      this.$emit('input', false);
      this.$emit('update:dialog', false);
      this.$emit('close');
      window.location.reload();
    },
    printInvoice() {
      const contentEl = this.$refs.invoiceContent;
      if (!contentEl) return;

      const printStyle = `
        @page {
          size: A4 portrait;
          margin: 0;
        }
        * {
          box-sizing: border-box;
        }
        body {
          font-family: Arial, Helvetica, sans-serif;
          color: #1f2937;
          margin: 12mm;
          padding: 0;
          background: #ffffff;
        }
        .faktur-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          border-bottom: 2px solid #c62828;
          padding-bottom: 12px;
          margin-bottom: 16px;
        }
        .faktur-badge {
          display: inline-block;
          font-size: 10px;
          font-weight: 700;
          letter-spacing: 0.08em;
          color: #b71c1c;
          background: #ffebee;
          border: 1px solid #ffcdd2;
          padding: 2px 8px;
          border-radius: 4px;
        }
        .faktur-title {
          font-size: 19px;
          font-weight: 800;
          color: #111827;
          margin: 4px 0 2px;
        }
        .faktur-subtitle {
          font-size: 12px;
          color: #6b7280;
        }
        .text-sm-right {
          text-align: right;
        }
        .faktur-meta-label {
          font-size: 10px;
          text-transform: uppercase;
          color: #6b7280;
        }
        .faktur-code {
          font-family: monospace;
          font-size: 14px;
          font-weight: 700;
          color: #b71c1c;
          background: #fff5f5;
          border: 1px solid #fecaca;
          display: inline-block;
          padding: 2px 8px;
          border-radius: 5px;
          margin-top: 2px;
        }
        .faktur-date {
          font-size: 12px;
          color: #374151;
          margin-top: 4px;
        }
        .faktur-info-grid {
          display: grid;
          grid-template-columns: repeat(2, minmax(0, 1fr));
          gap: 12px;
          margin-bottom: 16px;
        }
        .faktur-info-box {
          background: #fffafa;
          border: 1px solid #e5d4d4;
          border-radius: 6px;
          padding: 10px 12px;
        }
        .info-row {
          display: flex;
          font-size: 12px;
          line-height: 1.5;
          margin-bottom: 3px;
        }
        .info-label {
          width: 105px;
          flex-shrink: 0;
          color: #6b7280;
        }
        .info-sep {
          width: 10px;
          flex-shrink: 0;
          color: #6b7280;
        }
        .info-val {
          flex: 1;
          color: #111827;
          word-break: break-word;
        }
        .nopol-pill {
          font-family: monospace;
          font-weight: 700;
          color: #991b1b;
          background: #fee2e2;
          padding: 1px 6px;
          border-radius: 4px;
        }
        .faktur-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 12px;
        }
        .faktur-table th {
          background: #fef2f2;
          color: #7f1d1d;
          font-weight: 700;
          font-size: 11px;
          text-transform: uppercase;
          padding: 8px 10px;
          border-top: 1px solid #fecaca;
          border-bottom: 1.5px solid #e57373;
        }
        .faktur-table td {
          padding: 7px 10px;
          border-bottom: 1px solid #ece2e2;
          color: #1f2937;
        }
        .text-center { text-align: center; }
        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .font-weight-medium { font-weight: 600; }
        .faktur-summary-row {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          gap: 16px;
          margin-top: 16px;
        }
        .faktur-note {
          flex: 1;
          font-size: 11px;
          color: #6b7280;
          line-height: 1.5;
        }
        .faktur-subtotal-box {
          min-width: 220px;
          background: #fef2f2;
          border: 1px solid #fecaca;
          border-radius: 6px;
          padding: 9px 12px;
        }
        .faktur-subtotal-box > div {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .subtotal-label {
          font-size: 12.5px;
          font-weight: 700;
          color: #7f1d1d;
        }
        .subtotal-value {
          font-size: 14.5px;
          font-weight: 800;
          color: #b71c1c;
        }
      `;

      const iframe = document.createElement('iframe');
      iframe.style.position = 'fixed';
      iframe.style.right = '0';
      iframe.style.bottom = '0';
      iframe.style.width = '0';
      iframe.style.height = '0';
      iframe.style.border = '0';
      document.body.appendChild(iframe);

      const doc = iframe.contentWindow.document;
      doc.open();
      doc.write(`
        <!DOCTYPE html>
        <html>
          <head>
            <title>Faktur ${this.transaction.kodeInvoice || ''}</title>
            <style>${printStyle}</style>
          </head>
          <body>
            ${contentEl.innerHTML}
          </body>
        </html>
      `);
      doc.close();

      iframe.contentWindow.focus();
      setTimeout(() => {
        iframe.contentWindow.print();
        setTimeout(() => {
          if (iframe.parentNode) {
            iframe.parentNode.removeChild(iframe);
          }
        }, 1000);
      }, 200);
    },
  },
};
</script>

<style scoped>
.faktur-dialog-card {
  background-color: #ffffff;
  border: 1px solid #f1dcdc;
}

.faktur-toolbar {
  border-bottom: 1px solid #f1dcdc;
}

.faktur-sheet-wrapper {
  background-color: #faf7f7;
}

.faktur-sheet {
  background-color: #ffffff;
  border: 1px solid #e5d4d4;
  border-radius: 8px;
  padding: 24px 28px;
  color: #1f2937;
}

.faktur-header {
  border-bottom: 2px solid #c62828;
}

.faktur-badge {
  display: inline-block;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.08em;
  color: #b71c1c;
  background-color: #ffebee;
  border: 1px solid #ffcdd2;
  padding: 2px 8px;
  border-radius: 4px;
}

.faktur-title {
  font-size: 20px;
  font-weight: 800;
  color: #111827;
  line-height: 1.2;
}

.faktur-subtitle {
  font-size: 12px;
  color: #6b7280;
}

.faktur-meta-label {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
}

.faktur-code {
  font-family: monospace;
  font-size: 15px;
  font-weight: 700;
  color: #b71c1c;
  background-color: #fff5f5;
  border: 1px solid #fecaca;
  display: inline-block;
  padding: 2px 8px;
  border-radius: 5px;
}

.faktur-date {
  font-size: 12px;
  color: #374151;
}

.faktur-info-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.faktur-info-box {
  background-color: #fffafa;
  border: 1px solid #f1dcdc;
  border-radius: 6px;
  padding: 12px 14px;
}

.info-row {
  display: flex;
  align-items: flex-start;
  font-size: 12.5px;
  line-height: 1.55;
  margin-bottom: 4px;
}

.info-row:last-child {
  margin-bottom: 0;
}

.info-label {
  width: 115px;
  flex-shrink: 0;
  color: #6b7280;
  font-weight: 500;
}

.info-sep {
  width: 12px;
  flex-shrink: 0;
  color: #6b7280;
}

.info-val {
  flex: 1;
  color: #111827;
  word-break: break-word;
}

.nopol-pill {
  font-family: monospace;
  font-weight: 700;
  color: #991b1b;
  background-color: #fee2e2;
  padding: 1px 6px;
  border-radius: 4px;
}

.faktur-table-wrapper {
  width: 100%;
  overflow-x: auto;
}

.faktur-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12.5px;
}

.faktur-table th {
  background-color: #fef2f2;
  color: #7f1d1d;
  font-weight: 700;
  font-size: 11.5px;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  padding: 9px 10px;
  border-top: 1px solid #fecaca;
  border-bottom: 1.5px solid #e57373;
}

.faktur-table td {
  padding: 8px 10px;
  border-bottom: 1px solid #f3e8e8;
  color: #1f2937;
}

.faktur-table tbody tr:hover {
  background-color: #fff9f9;
}

.faktur-summary-row {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
}

.faktur-note {
  flex: 1 1 320px;
  font-size: 11.5px;
  color: #6b7280;
  line-height: 1.5;
}

.faktur-subtotal-box {
  min-width: 240px;
  background-color: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 10px 14px;
}

.subtotal-label {
  font-size: 13px;
  font-weight: 700;
  color: #7f1d1d;
}

.subtotal-value {
  font-size: 15px;
  font-weight: 800;
  color: #b71c1c;
}

@media (max-width: 600px) {
  .faktur-info-grid {
    grid-template-columns: 1fr;
  }

  .faktur-sheet {
    padding: 16px;
  }

  .faktur-subtotal-box {
    width: 100%;
  }
}
</style>