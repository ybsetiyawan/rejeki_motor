<template>
  <v-row dense class="pa-2">
    <!-- Kolom Kiri: Form Penerimaan Barang -->
    <v-col cols="12" lg="6" class="mb-3 mb-lg-0">
      <v-card class="bengkel-card rounded-lg elevation-2 h-full">
        <!-- Header Form -->
        <div class="bengkel-header px-5 pt-4 pb-3">
          <div class="d-flex align-center justify-space-between">
            <div class="d-flex align-center">
              <v-avatar color="red lighten-5" size="40" class="mr-3 bengkel-avatar-ring">
                <v-icon color="red darken-2">mdi-truck-plus-outline</v-icon>
              </v-avatar>
              <div>
                <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
                  Form Penerimaan Barang
                </div>
                <div class="text-caption grey--text text--darken-1">
                  Input transaksi barang masuk dari supplier
                </div>
              </div>
            </div>

            <v-btn
              small
              depressed
              color="red darken-2"
              class="white--text font-weight-medium text-none px-4"
              :disabled="formActive"
              @click="activateForm"
            >
              <v-icon left small>mdi-plus</v-icon>
              New
            </v-btn>
          </div>
        </div>

        <div class="bengkel-stripe"></div>

        <!-- Isi Form -->
        <v-card-text class="pa-5">
          <form @submit.prevent="addToCart">
            <v-row dense>
              <v-col cols="12" sm="5">
                <label class="field-label">Tanggal</label>
                <v-text-field
                  v-model="receipt.tanggal"
                  type="date"
                  outlined
                  dense
                  hide-details
                  color="red darken-2"
                  :disabled="!formActive"
                ></v-text-field>
              </v-col>

              <v-col cols="12" sm="7">
                <label class="field-label">Supplier</label>
                <v-text-field
                  v-model="receipt.supplier"
                  placeholder="Pilih supplier..."
                  outlined
                  dense
                  hide-details
                  readonly
                  color="red darken-2"
                  :disabled="!formActive || isSupplierSearchDisabled()"
                  @click="!isSupplierSearchDisabled() && formActive ? openSupplierList() : null"
                >
                  <template v-slot:append>
                    <v-icon
                      small
                      :color="!formActive || isSupplierSearchDisabled() ? 'grey lighten-1' : 'red darken-2'"
                      style="cursor: pointer;"
                      @click="openSupplierList"
                    >
                      mdi-magnify
                    </v-icon>
                  </template>
                </v-text-field>
              </v-col>

              <v-col cols="12" class="mt-2">
                <label class="field-label">Alamat Supplier</label>
                <v-text-field
                  v-model="receipt.alamat"
                  placeholder="Alamat otomatis terisi..."
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" class="mt-2">
                <label class="field-label">Nama Item</label>
                <v-text-field
                  v-model="receipt.itemName"
                  placeholder="Cari & pilih item..."
                  outlined
                  dense
                  hide-details
                  readonly
                  color="red darken-2"
                  :disabled="!formActive"
                  @click="formActive ? openItemList() : null"
                >
                  <template v-slot:append>
                    <v-icon
                      small
                      :color="!formActive ? 'grey lighten-1' : 'red darken-2'"
                      style="cursor: pointer;"
                      @click="openItemList"
                    >
                      mdi-magnify
                    </v-icon>
                  </template>
                </v-text-field>
              </v-col>

              <v-col cols="12" sm="4" class="mt-2">
                <label class="field-label">Kode Item</label>
                <v-text-field
                  v-model="receipt.itemCode"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="6" sm="4" class="mt-2">
                <label class="field-label">Qty</label>
                <v-text-field
                  v-model.number="receipt.quantity"
                  type="number"
                  min="1"
                  outlined
                  dense
                  hide-details
                  color="red darken-2"
                  :disabled="!formActive"
                ></v-text-field>
              </v-col>

              <v-col cols="6" sm="4" class="mt-2">
                <label class="field-label">Uom</label>
                <v-text-field
                  v-model="receipt.uom"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" class="mt-2">
                <label class="field-label">Keterangan</label>
                <v-text-field
                  v-model="receipt.keterangan"
                  placeholder="Catatan penerimaan barang..."
                  outlined
                  dense
                  hide-details
                  color="red darken-2"
                  autocomplete="off"
                  :disabled="!formActive"
                ></v-text-field>
              </v-col>

              <v-col cols="12" class="mt-4">
                <v-btn
                  type="submit"
                  block
                  small
                  depressed
                  color="red darken-2"
                  class="white--text font-weight-medium text-none py-4"
                  :disabled="!formActive"
                >
                  <v-icon left small>mdi-cart-plus</v-icon>
                  Add to Cart
                </v-btn>
              </v-col>
            </v-row>
          </form>
        </v-card-text>
      </v-card>
    </v-col>

    <!-- Kolom Kanan: Cart Barang Diterima -->
    <v-col cols="12" lg="6">
      <v-card class="bengkel-card rounded-lg elevation-2 h-full d-flex flex-column">
        <div class="bengkel-header px-5 pt-4 pb-3">
          <div class="d-flex align-center justify-space-between">
            <div class="d-flex align-center">
              <v-avatar color="red lighten-5" size="40" class="mr-3 bengkel-avatar-ring">
                <v-icon color="red darken-2">mdi-cart-check</v-icon>
              </v-avatar>
              <div>
                <div class="d-flex align-center">
                  <span class="text-subtitle-1 font-weight-bold grey--text text--darken-4 mr-2">
                    Daftar Barang Diterima (Cart)
                  </span>
                  <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                    {{ cart.length }} Item
                  </v-chip>
                </div>
                <div class="text-caption grey--text text--darken-1">
                  Total Qty Masuk: <strong class="grey--text text--darken-4">{{ totalCartQty }}</strong>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="bengkel-stripe"></div>

        <v-card-text class="pa-4 flex-grow-1">
          <div class="table-scroll-wrapper">
            <v-simple-table class="bengkel-table" fixed-header>
              <thead>
                <tr>
                  <th class="text-left" style="width: 110px;">KODE</th>
                  <th class="text-left">NAMA ITEM</th>
                  <th class="text-center" style="width: 80px;">UOM</th>
                  <th class="text-right" style="width: 80px;">QTY</th>
                  <th class="text-center" style="width: 60px;">AKSI</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in cart" :key="index" class="cart-row">
                  <td>
                    <span class="kode-red-pill">{{ item.itemCode }}</span>
                  </td>
                  <td class="font-weight-bold grey--text text--darken-4">
                    {{ item.itemName }}
                  </td>
                  <td class="text-center grey--text text--darken-2">
                    {{ item.uom || '-' }}
                  </td>
                  <td class="text-right font-weight-bold">
                    {{ item.quantity }}
                  </td>
                  <td class="text-center">
                    <v-btn
                      icon
                      x-small
                      color="red darken-2"
                      @click="removeFromCart(index)"
                      title="Hapus dari Cart"
                    >
                      <v-icon small>mdi-delete-outline</v-icon>
                    </v-btn>
                  </td>
                </tr>

                <tr v-if="cart.length === 0">
                  <td colspan="5" class="text-center py-10 grey--text">
                    <v-icon large color="red lighten-3" class="mb-2">mdi-cart-off</v-icon>
                    <div>Belum ada item di dalam cart.</div>
                  </td>
                </tr>
              </tbody>
            </v-simple-table>
          </div>
        </v-card-text>

        <v-divider></v-divider>

        <!-- Tombol Simpan / Batal -->
        <div v-if="cart.length || formActive" class="pagination-bar px-5 py-3 d-flex justify-end">
          <v-btn
            v-show="formActive"
            small
            outlined
            color="grey darken-2"
            class="text-none font-weight-medium mr-2"
            @click="cancelReceipt"
          >
            Cancel
          </v-btn>
          <v-btn
            small
            depressed
            color="red darken-2"
            class="white--text font-weight-medium text-none px-4"
            :disabled="!saveReceipt || cart.length === 0"
            @click="submitReceipt"
          >
            <v-icon left small>mdi-content-save-outline</v-icon>
            Save
          </v-btn>
        </div>
      </v-card>
    </v-col>

    <!-- Dialog Daftar Barang -->
    <v-dialog v-model="showItemList" max-width="760px">
      <v-card class="rounded-lg">
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="36" class="mr-3 bengkel-avatar-ring">
              <v-icon color="red darken-2" small>mdi-package-variant</v-icon>
            </v-avatar>
            <div>
              <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
                Daftar Barang
              </div>
              <div class="text-caption grey--text text--darken-1">
                Item yang sudah masuk ke cart otomatis ditandai &amp; dinonaktifkan
              </div>
            </div>
          </div>
          <v-spacer></v-spacer>
          <v-btn icon small color="grey darken-1" @click="closeItemList">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <div class="bengkel-stripe"></div>

        <v-card-text class="pa-5">
          <v-text-field
            v-model="searchQuery"
            label="Cari berdasarkan kode atau nama item..."
            outlined
            dense
            clearable
            hide-details
            color="red darken-2"
            class="mb-3"
            @keyup.enter="searchItems"
            @click:clear="clearItemSearch"
          >
            <template v-slot:append>
              <v-btn
                x-small
                depressed
                color="red darken-2"
                class="white--text text-none px-3"
                :disabled="!searchQuery"
                @click="searchItems"
              >
                Cari
              </v-btn>
            </template>
          </v-text-field>

          <v-list dense class="border-list rounded" style="max-height: 360px; overflow-y: auto;">
            <v-list-item
              v-for="item in items"
              :key="item.id"
              :disabled="isItemIncart(item)"
              :class="['list-hover-red', { 'in-cart-item': isItemIncart(item) }]"
              @click="!isItemIncart(item) && selectItem(item)"
            >
              <v-list-item-content>
                <v-list-item-title class="d-flex flex-wrap align-center">
                  <span class="kode-red-pill mr-2">{{ item.kode }}</span>
                  <span class="font-weight-bold grey--text text--darken-4 mr-2">
                    {{ item.nama }}
                  </span>

                  <v-chip
                    v-if="isItemIncart(item)"
                    x-small
                    label
                    color="red darken-2"
                    text-color="white"
                    class="font-weight-bold mr-auto"
                  >
                    <v-icon x-small left>mdi-check</v-icon>
                    Di Cart
                  </v-chip>
                  <span v-else class="mr-auto"></span>

                  <span class="text-caption grey--text text--darken-2 mr-3">
                    Modal: <strong>{{ item.modal }}</strong>
                  </span>
                  <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                    Stok: {{ parseInt(item.stok) }}
                  </v-chip>
                </v-list-item-title>
              </v-list-item-content>
            </v-list-item>

            <v-list-item v-if="!items || items.length === 0">
              <v-list-item-content class="text-center py-6 grey--text">
                Tidak ada data barang yang ditemukan.
              </v-list-item-content>
            </v-list-item>
          </v-list>

          <!-- Paginasi Ringkas Merah Bengkel -->
          <div class="dialog-pagination-bar mt-3 px-3 py-2 rounded d-flex flex-wrap align-center justify-space-between">
            <div class="text-caption grey--text text--darken-2">
              Total <strong class="grey--text text--darken-4">{{ totalItems }}</strong> item
            </div>

            <div class="d-flex align-center">
              <v-btn
                icon
                x-small
                outlined
                color="red darken-2"
                class="mr-1 page-nav-btn"
                :disabled="currentPage <= 1"
                @click="goToItemPage(1)"
                title="Halaman Pertama"
              >
                <v-icon x-small>mdi-chevron-double-left</v-icon>
              </v-btn>

              <v-btn
                x-small
                outlined
                color="red darken-2"
                class="text-none font-weight-medium mr-1 page-step-btn"
                :disabled="currentPage <= 1"
                @click="goToItemPage(currentPage - 1)"
              >
                <v-icon left x-small>mdi-chevron-left</v-icon>
                Prev
              </v-btn>

              <div class="page-indicator-box mx-1">
                <span>Hal</span>
                <strong class="red--text text--darken-3 mx-1">{{ currentPage }}</strong>
                <span>/ {{ pageCount }}</span>
              </div>

              <v-btn
                x-small
                outlined
                color="red darken-2"
                class="text-none font-weight-medium ml-1 page-step-btn"
                :disabled="currentPage >= pageCount"
                @click="goToItemPage(currentPage + 1)"
              >
                Next
                <v-icon right x-small>mdi-chevron-right</v-icon>
              </v-btn>

              <v-btn
                icon
                x-small
                outlined
                color="red darken-2"
                class="ml-1 page-nav-btn"
                :disabled="currentPage >= pageCount"
                @click="goToItemPage(pageCount)"
                title="Halaman Terakhir"
              >
                <v-icon x-small>mdi-chevron-double-right</v-icon>
              </v-btn>
            </div>
          </div>
        </v-card-text>

        <v-divider></v-divider>
        <v-card-actions class="px-5 py-3 grey lighten-5">
          <v-spacer></v-spacer>
          <v-btn text color="grey darken-2" class="text-none" @click="closeItemList">Tutup</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Dialog Daftar Supplier -->
    <v-dialog v-model="showSupplierList" max-width="680px">
      <v-card class="rounded-lg">
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="36" class="mr-3 bengkel-avatar-ring">
              <v-icon color="red darken-2" small>mdi-truck-outline</v-icon>
            </v-avatar>
            <span class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
              Daftar Supplier
            </span>
          </div>
          <v-spacer></v-spacer>
          <v-btn icon small color="grey darken-1" @click="closeSupplierList">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <div class="bengkel-stripe"></div>

        <v-card-text class="pa-5">
          <v-text-field
            v-model="searchSupplierQuery"
            label="Cari kode atau nama supplier..."
            outlined
            dense
            clearable
            hide-details
            color="red darken-2"
            class="mb-3"
          ></v-text-field>

          <v-list dense class="border-list rounded" style="max-height: 320px; overflow-y: auto;">
            <v-list-item
              v-for="supplier in filteredSuppliers"
              :key="supplier.id"
              class="list-hover-red"
              @click="selectSupplier(supplier)"
            >
              <v-list-item-content>
                <v-list-item-title class="d-flex align-center">
                  <span class="kode-red-pill mr-2">{{ supplier.kode }}</span>
                  <span class="font-weight-bold grey--text text--darken-4">{{ supplier.nama }}</span>
                </v-list-item-title>
                <v-list-item-subtitle v-if="supplier.alamat" class="text-caption mt-1">
                  {{ supplier.alamat }}
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card-text>

        <v-divider></v-divider>
        <v-card-actions class="px-5 py-3 grey lighten-5">
          <v-spacer></v-spacer>
          <v-btn text color="grey darken-2" class="text-none" @click="closeSupplierList">Tutup</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <ReceiptDocView v-if="showReceiptDoc" :receipt="submitReceiptData" :dialog="dialog" />
  </v-row>
</template>

<script>
import api from '../../services/api';
import { loadItems, loadSuppliers } from '../../utils/utils';
import ReceiptDocView from '../print/ReceiptDocView.vue';

export default {
  name: 'ReceiptFormView',
  components: { ReceiptDocView },
  data() {
    return {
      receipt: {
        itemName: '',
        itemCode: '',
        idItem: '',
        uom: '',
        quantity: 0,
        supplier: '',
        idSupplier: '',
        alamat: '',
        keterangan: '',
        kodeSupplier: '',
        no_hp: '',
        email: '',
        tanggal: '',
      },
      initialKeterangan: '',
      cart: [],
      formActive: false,
      showItemList: false,
      items: [],
      searchQuery: '',
      showSupplierList: false,
      suppliers: [],
      searchSupplierQuery: '',
      showReceiptDoc: false,
      dialog: false,
      submitReceiptData: {},
      kodeReceipt: '',
      noReceipt: '',
      saveReceipt: false,
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,
    };
  },
  watch: {
    receipt: {
      handler(newVal) {
        if (newVal.keterangan) {
          this.receipt.keterangan = newVal.keterangan.toUpperCase();
        }
      },
      deep: true,
    },
    cart(newCart) {
      if (!newCart.length) {
        this.saveReceipt = false;
      }
    },
  },
  computed: {
    filteredSuppliers() {
      const q = (this.searchSupplierQuery || '').toLowerCase();
      return this.suppliers.filter(
        supplier =>
          (supplier.nama && supplier.nama.toLowerCase().includes(q)) ||
          (supplier.kode && supplier.kode.toLowerCase().includes(q))
      );
    },
    pageCount() {
      return Math.max(1, Math.ceil(this.totalItems / this.pageSize));
    },
    totalCartQty() {
      return this.cart.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
    },
  },
  methods: {
    loadItems() {
      return loadItems(this.currentPage, this.pageSize, this.searchQuery)
        .then(data => {
          this.items = data.items;
          this.totalItems = data.total;
        })
        .catch(error => console.error('Error Loading Items:', error));
    },
    goToItemPage(page) {
      const target = Math.min(Math.max(1, page), this.pageCount);
      if (target === this.currentPage) return;
      this.currentPage = target;
      this.loadItems();
    },
    loadSuppliers() {
      loadSuppliers().then(suppliers => {
        this.suppliers = suppliers || [];
      });
    },
    async activateForm() {
      this.formActive = true;
      this.loadItems();
      this.loadSuppliers();
      this.initialKeterangan = this.receipt.keterangan;
    },
    addToCart() {
      if (!this.receipt.tanggal || !this.receipt.itemName) {
        alert('Tanggal belum diisi atau item belum dipilih');
        return;
      }
      if (!this.receipt.quantity || Number(this.receipt.quantity) <= 0) {
        alert('Qty harus lebih dari 0');
        return;
      }
      if (this.formActive) {
        this.cart.push({ ...this.receipt });
        this.receipt = {
          itemName: '',
          itemCode: '',
          idItem: '',
          uom: '',
          quantity: 0,
          supplier: this.receipt.supplier,
          alamat: this.receipt.alamat,
          keterangan: this.receipt.keterangan,
          email: this.receipt.email,
          no_hp: this.receipt.no_hp,
          kodeSupplier: this.receipt.kodeSupplier,
          idSupplier: this.receipt.idSupplier,
          tanggal: this.receipt.tanggal,
        };
        this.saveReceipt = true;
      }
    },
    isItemIncart(item) {
      return this.cart.some(
        cartItem =>
          (cartItem.idItem && item.id && cartItem.idItem === item.id) ||
          (cartItem.itemCode && item.kode && cartItem.itemCode === item.kode)
      );
    },
    isSupplierSearchDisabled() {
      return this.cart.length > 0;
    },
    removeFromCart(index) {
      this.cart.splice(index, 1);
    },
    async submitReceipt() {
      const id_supplier = this.receipt.idSupplier;
      const tanggal = this.receipt.tanggal;
      const keterangan = this.receipt.keterangan;
      const cart = this.cart.map(item => ({
        id_item: item.idItem,
        qty: item.quantity,
        uom: item.uom,
        itemCode: item.itemCode,
        itemName: item.itemName,
      }));

      try {
        const response = await api.post('/t_trans_receipt', {
          id_supplier: id_supplier,
          tanggal: tanggal,
          keterangan: keterangan,
          detail: cart,
        });

        this.noReceipt = response.data.no_receipt;
        this.kodeReceipt = this.noReceipt;

        alert('Data berhasil disimpan');
        this.submitReceiptData = {
          kodeReceipt: this.noReceipt,
          kodeSupplier: this.receipt.kodeSupplier,
          keterangan: this.receipt.keterangan,
          namaSupplier: this.receipt.supplier,
          alamat: this.receipt.alamat,
          no_hp: this.receipt.no_hp,
          email: this.receipt.email,
          tanggal: this.receipt.tanggal,
          items: cart,
        };
        this.showReceiptDoc = true;
        this.dialog = true;
        this.cancelReceipt();
      } catch (error) {
        console.error(error);
        alert('Gagal menyimpan data penerimaan barang.');
      }
    },
    cancelReceipt() {
      this.cart = [];
      this.formActive = false;
      this.receipt = {
        itemName: '',
        itemCode: '',
        idItem: '',
        uom: '',
        quantity: 0,
        supplier: '',
        alamat: '',
        keterangan: this.initialKeterangan,
        idSupplier: '',
        kodeSupplier: '',
        no_hp: '',
        email: '',
        tanggal: '',
      };
      this.saveReceipt = false;
    },
    selectItem(item) {
      if (this.isItemIncart(item)) return;
      this.receipt.idItem = item.id;
      this.receipt.itemName = item.nama;
      this.receipt.itemCode = item.kode;
      this.receipt.uom = item.satuan_nama;
      this.showItemList = false;
    },
    closeItemList() {
      this.showItemList = false;
    },
    openItemList() {
      if (this.formActive) {
        this.showItemList = true;
        this.loadItems();
      }
    },
    openSupplierList() {
      if (this.formActive && !this.isSupplierSearchDisabled()) {
        this.showSupplierList = true;
        this.loadSuppliers();
      }
    },
    closeSupplierList() {
      this.showSupplierList = false;
    },
    selectSupplier(supplier) {
      this.receipt.supplier = supplier.nama;
      this.receipt.alamat = supplier.alamat;
      this.receipt.idSupplier = supplier.id;
      this.receipt.kodeSupplier = supplier.kode;
      this.receipt.no_hp = supplier.no_hp;
      this.receipt.email = supplier.email;
      this.showSupplierList = false;
    },
    searchItems() {
      this.currentPage = 1;
      this.loadItems().then(() => {
        if (this.items.length === 0) {
          alert('Tidak ada item yang ditemukan.');
        }
      });
    },
    clearItemSearch() {
      this.searchQuery = '';
      this.currentPage = 1;
      this.loadItems();
    },
  },
};
</script>

<style scoped>
.bengkel-card {
  border: 1px solid #f1dcdc;
  background-color: #ffffff;
}

.bengkel-header {
  background: linear-gradient(180deg, #fff6f6 0%, #ffffff 100%);
}

.bengkel-avatar-ring {
  border: 1px solid #fecaca;
}

.bengkel-stripe {
  height: 3px;
  background: linear-gradient(90deg, #c62828 0%, #ef5350 60%, #ffcdd2 100%);
}

.field-label {
  display: block;
  font-size: 11px;
  font-weight: 700;
  color: #4b5563;
  margin-bottom: 4px;
}

.table-scroll-wrapper {
  max-height: 360px;
  overflow-y: auto;
}

.bengkel-table th {
  font-size: 11px !important;
  font-weight: 700 !important;
  letter-spacing: 0.04em;
  color: #7f1d1d !important;
  background-color: #fef2f2 !important;
  border-bottom: 1px solid #fecaca !important;
  height: 36px !important;
}

.cart-row td {
  font-size: 12px !important;
  height: 36px !important;
  border-bottom: 1px solid #f5ebeb !important;
}

.cart-row:hover {
  background-color: #fff5f5 !important;
}

.kode-red-pill {
  display: inline-block;
  padding: 2px 7px;
  border-radius: 5px;
  background-color: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
  font-family: monospace;
  font-size: 11px;
  font-weight: 700;
}

.pagination-bar,
.dialog-pagination-bar {
  background-color: #fffafa;
  border-top: 1px solid #f1dcdc;
}

.dialog-pagination-bar {
  border: 1px solid #f1dcdc;
}

.page-indicator-box {
  background-color: #ffffff;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 3px 9px;
  font-size: 11px;
  color: #4b5563;
}

.page-step-btn {
  border-radius: 6px !important;
  background-color: #ffffff !important;
}

.page-nav-btn {
  border-radius: 6px !important;
  background-color: #ffffff !important;
  width: 24px !important;
  height: 24px !important;
}

.modal-top-bar {
  background-color: #ffffff;
}

.border-list {
  border: 1px solid #f1dcdc;
}

.list-hover-red:hover {
  background-color: #fff5f5 !important;
  cursor: pointer;
}

.in-cart-item {
  background-color: #fafafa !important;
  opacity: 0.65;
  cursor: not-allowed !important;
}
</style>