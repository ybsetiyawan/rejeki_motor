<template>
  <v-dialog
    v-model="internalDialog"
    max-width="820px"
    content-class="retur-dialog-content"
    @click:outside="closeAndReload"
    @keydown.esc.prevent="closeAndReload"
  >
    <v-card class="retur-dialog-card rounded-lg">
      <!-- Top Bar -->
      <v-toolbar
        flat
        color="white"
        class="retur-toolbar px-4"
      >
        <v-avatar color="red lighten-5" size="36" class="mr-3">
          <v-icon color="red darken-2" small>mdi-backup-restore</v-icon>
        </v-avatar>
        <div>
          <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
            Bukti Retur Barang
          </div>
          <div class="text-caption grey--text text--darken-1">
            {{ receipt.kodeRetur || '-' }}
          </div>
        </div>

        <v-spacer></v-spacer>

        <v-btn
          small
          depressed
          color="red darken-2"
          class="white--text font-weight-medium text-none mr-2"
          @click="printRetur"
        >
          <v-icon left small>mdi-printer</v-icon>
          Cetak Retur
        </v-btn>

        <v-btn
          icon
          small
          color="grey darken-2"
          aria-label="Tutup dialog"
          title="Tutup & Refresh (Esc)"
          @click="closeAndReload"
        >
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>

      <v-divider></v-divider>

      <!-- Area Retur -->
      <v-card-text class="retur-sheet-wrapper pa-5">
        <div id="retur-print-area" ref="returContent" class="retur-sheet">
          <!-- Header Retur -->
          <div class="retur-header d-flex flex-wrap justify-space-between align-start pb-4 mb-4">
            <div>
              <div class="retur-badge">RETUR SUPPLIER</div>
              <h2 class="retur-title mt-1">REJEKI MOTOR</h2>
              <div class="retur-subtitle">Bengkel &amp; Suku Cadang Kendaraan</div>
            </div>

            <div class="text-sm-right mt-2 mt-sm-0">
              <div class="retur-meta-label">No. Retur</div>
              <div class="retur-code">{{ receipt.kodeRetur || '-' }}</div>
              <div class="retur-date mt-1">
                Tanggal: <strong>{{ formatDate(receipt.tanggal) }}</strong>
              </div>
            </div>
          </div>

          <!-- Info Supplier -->
          <div class="retur-info-grid mb-4">
            <div class="retur-info-box">
              <div class="info-row">
                <span class="info-label">Kode Supplier</span>
                <span class="info-sep">:</span>
                <span class="info-val font-weight-bold">{{ receipt.kodeSupplier || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Nama Supplier</span>
                <span class="info-sep">:</span>
                <span class="info-val font-weight-bold">{{ receipt.namaSupplier || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Alamat</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ receipt.alamat || '-' }}</span>
              </div>
            </div>

            <div class="retur-info-box">
              <div class="info-row">
                <span class="info-label">Email</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ receipt.email || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">No. HP</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ receipt.no_hp || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">Keterangan</span>
                <span class="info-sep">:</span>
                <span class="info-val">{{ receipt.keterangan || '-' }}</span>
              </div>
            </div>
          </div>

          <!-- Tabel Item -->
          <div class="retur-table-wrapper">
            <table class="retur-table">
              <thead>
                <tr>
                  <th class="text-center" style="width: 46px;">No</th>
                  <th class="text-left" style="width: 130px;">Kode Item</th>
                  <th class="text-left">Nama Item</th>
                  <th class="text-center" style="width: 85px;">Uom</th>
                  <th class="text-right" style="width: 85px;">Qty</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in (receipt.items || [])" :key="index">
                  <td class="text-center grey--text text--darken-1">{{ index + 1 }}</td>
                  <td class="item-code">{{ item.itemCode || '-' }}</td>
                  <td class="font-weight-medium">{{ item.itemName || '-' }}</td>
                  <td class="text-center">{{ item.uom || '-' }}</td>
                  <td class="text-right font-weight-bold">{{ item.qty }}</td>
                </tr>
                <tr v-if="!receipt.items || receipt.items.length === 0">
                  <td colspan="5" class="text-center py-4 grey--text">Tidak ada item retur.</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Ringkasan & Catatan -->
          <div class="retur-summary-row mt-4">
            <div class="retur-note">
              Dokumen ini sah sebagai bukti pengembalian/retur barang ke supplier oleh <strong>Rejeki Motor</strong>. Harap lampirkan saat proses klaim atau serah terima barang.
            </div>
            <div class="retur-total-box">
              <div class="d-flex justify-space-between align-center">
                <span class="total-label">Total Qty</span>
                <span class="total-value">{{ totalQty }}</span>
              </div>
            </div>
          </div>
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: 'ReturView',
  props: {
    value: {
      type: Boolean,
      default: undefined,
    },
    dialog: {
      type: Boolean,
      default: undefined,
    },
    receipt: {
      type: Object,
      required: true,
      default: () => ({
        kodeRetur: '',
        kodeSupplier: '',
        namaSupplier: '',
        alamat: '',
        email: '',
        no_hp: '',
        keterangan: '',
        tanggal: '',
        items: [],
      }),
    },
  },
  data() {
    return {
      internalDialog: true,
    };
  },
  computed: {
    totalQty() {
      if (!Array.isArray(this.receipt.items)) return 0;
      return this.receipt.items.reduce((sum, item) => sum + (Number(item.qty) || 0), 0);
    },
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
    formatDate(date) {
      if (!date) return '-';
      const d = new Date(date);
      if (Number.isNaN(d.getTime())) return date;
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return d.toLocaleDateString('id-ID', options);
    },
    handleEscapeKey(event) {
      if ((event.key === 'Escape' || event.keyCode === 27) && this.internalDialog) {
        event.preventDefault();
        event.stopPropagation();
        this.closeAndReload();
      }
    },
    closeAndReload() {
      this.internalDialog = false;
      this.$emit('input', false);
      this.$emit('update:dialog', false);
      this.$emit('close');
      window.location.reload();
    },
    printRetur() {
      const contentEl = this.$refs.returContent;
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
        .retur-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          border-bottom: 2px solid #c62828;
          padding-bottom: 12px;
          margin-bottom: 16px;
        }
        .retur-badge {
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
        .retur-title {
          font-size: 19px;
          font-weight: 800;
          color: #111827;
          margin: 4px 0 2px;
        }
        .retur-subtitle {
          font-size: 12px;
          color: #6b7280;
        }
        .text-sm-right {
          text-align: right;
        }
        .retur-meta-label {
          font-size: 10px;
          text-transform: uppercase;
          color: #6b7280;
        }
        .retur-code {
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
        .retur-date {
          font-size: 12px;
          color: #374151;
          margin-top: 4px;
        }
        .retur-info-grid {
          display: grid;
          grid-template-columns: repeat(2, minmax(0, 1fr));
          gap: 12px;
          margin-bottom: 16px;
        }
        .retur-info-box {
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
        .retur-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 12px;
        }
        .retur-table th {
          background: #fef2f2;
          color: #7f1d1d;
          font-weight: 700;
          font-size: 11px;
          text-transform: uppercase;
          padding: 8px 10px;
          border-top: 1px solid #fecaca;
          border-bottom: 1.5px solid #e57373;
        }
        .retur-table td {
          padding: 7px 10px;
          border-bottom: 1px solid #ece2e2;
          color: #1f2937;
        }
        .item-code {
          font-family: monospace;
          font-weight: 600;
          color: #7f1d1d;
        }
        .text-center { text-align: center; }
        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .font-weight-medium { font-weight: 600; }
        .font-weight-bold { font-weight: 700; }
        .retur-summary-row {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          gap: 16px;
          margin-top: 16px;
        }
        .retur-note {
          flex: 1;
          font-size: 11px;
          color: #6b7280;
          line-height: 1.5;
        }
        .retur-total-box {
          min-width: 200px;
          background: #fef2f2;
          border: 1px solid #fecaca;
          border-radius: 6px;
          padding: 9px 12px;
        }
        .retur-total-box > div {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .total-label {
          font-size: 12.5px;
          font-weight: 700;
          color: #7f1d1d;
        }
        .total-value {
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
            <title>Retur ${this.receipt.kodeRetur || ''}</title>
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
.retur-dialog-card {
  background-color: #ffffff;
  border: 1px solid #f1dcdc;
}

.retur-toolbar {
  border-bottom: 1px solid #f1dcdc;
}

.retur-sheet-wrapper {
  background-color: #faf7f7;
}

.retur-sheet {
  background-color: #ffffff;
  border: 1px solid #e5d4d4;
  border-radius: 8px;
  padding: 24px 28px;
  color: #1f2937;
}

.retur-header {
  border-bottom: 2px solid #c62828;
}

.retur-badge {
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

.retur-title {
  font-size: 20px;
  font-weight: 800;
  color: #111827;
  line-height: 1.2;
}

.retur-subtitle {
  font-size: 12px;
  color: #6b7280;
}

.retur-meta-label {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #6b7280;
}

.retur-code {
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

.retur-date {
  font-size: 12px;
  color: #374151;
}

.retur-info-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.retur-info-box {
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

.retur-table-wrapper {
  width: 100%;
  overflow-x: auto;
}

.retur-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12.5px;
}

.retur-table th {
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

.retur-table td {
  padding: 8px 10px;
  border-bottom: 1px solid #f3e8e8;
  color: #1f2937;
}

.retur-table tbody tr:hover {
  background-color: #fff9f9;
}

.item-code {
  font-family: monospace;
  font-weight: 600;
  color: #7f1d1d;
}

.retur-summary-row {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
}

.retur-note {
  flex: 1 1 320px;
  font-size: 11.5px;
  color: #6b7280;
  line-height: 1.5;
}

.retur-total-box {
  min-width: 210px;
  background-color: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 10px 14px;
}

.total-label {
  font-size: 13px;
  font-weight: 700;
  color: #7f1d1d;
}

.total-value {
  font-size: 15px;
  font-weight: 800;
  color: #b71c1c;
}

@media (max-width: 600px) {
  .retur-info-grid {
    grid-template-columns: 1fr;
  }

  .retur-sheet {
    padding: 16px;
  }

  .retur-total-box {
    width: 100%;
  }
}
</style>