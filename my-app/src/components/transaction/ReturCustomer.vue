<template>
  <v-row dense class="pa-2">
    <!-- Kolom Kiri: Form Retur Barang From Customer -->
    <v-col cols="12" lg="6" class="mb-3 mb-lg-0">
      <v-card class="bengkel-card rounded-lg elevation-2 h-full">
        <!-- Header Form -->
        <div class="bengkel-header px-5 pt-4 pb-3">
          <div class="d-flex align-center justify-space-between">
            <div class="d-flex align-center">
              <v-avatar color="red lighten-5" size="40" class="mr-3 bengkel-avatar-ring">
                <v-icon color="red darken-2">mdi-backup-restore</v-icon>
              </v-avatar>
              <div>
                <div class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
                  Retur Barang From Customer
                </div>
                <div class="text-caption grey--text text--darken-1">
                  Input transaksi pengembalian barang dari customer
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
                  v-model="transaction.tanggal"
                  type="date"
                  outlined
                  dense
                  hide-details
                  color="red darken-2"
                  :disabled="!formActive"
                ></v-text-field>
              </v-col>

              <v-col cols="12" sm="7">
                <label class="field-label">Customer</label>
                <v-text-field
                  v-model="transaction.nama"
                  placeholder="Pilih customer..."
                  outlined
                  dense
                  hide-details
                  readonly
                  color="red darken-2"
                  :disabled="!formActive || isCustomerSearchDisabled()"
                  @click="!isCustomerSearchDisabled() && formActive ? openCustomerList() : null"
                >
                  <template v-slot:append>
                    <v-icon
                      small
                      :color="!formActive || isCustomerSearchDisabled() ? 'grey lighten-1' : 'red darken-2'"
                      style="cursor: pointer;"
                      @click="openCustomerList"
                    >
                      mdi-magnify
                    </v-icon>
                  </template>
                </v-text-field>
              </v-col>

              <v-col cols="12" sm="6" class="mt-2">
                <label class="field-label">Kode Customer</label>
                <v-text-field
                  v-model="transaction.kode"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" sm="6" class="mt-2">
                <label class="field-label">Nopol</label>
                <v-text-field
                  v-model="transaction.nopol"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" class="mt-2">
                <label class="field-label">Nama Item</label>
                <v-text-field
                  v-model="item.nama"
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

              <v-col cols="6" sm="3" class="mt-2">
                <label class="field-label">Kode Item</label>
                <v-text-field
                  v-model="item.kode"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="6" sm="3" class="mt-2">
                <label class="field-label">Qty</label>
                <v-text-field
                  v-model.number="item.qty"
                  type="number"
                  min="1"
                  outlined
                  dense
                  hide-details
                  color="red darken-2"
                  :disabled="!formActive"
                ></v-text-field>
              </v-col>

              <v-col cols="6" sm="3" class="mt-2">
                <label class="field-label">Stock</label>
                <v-text-field
                  v-model="item.stok"
                  type="number"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="6" sm="3" class="mt-2">
                <label class="field-label">Uom</label>
                <v-text-field
                  v-model="item.uom"
                  outlined
                  dense
                  hide-details
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" class="mt-2">
                <label class="field-label">Keterangan</label>
                <v-text-field
                  v-model="keterangan"
                  placeholder="Catatan retur barang dari customer..."
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

    <!-- Kolom Kanan: Cart Barang Retur -->
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
                    Daftar Barang Retur (Cart)
                  </span>
                  <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                    {{ cart.length }} Item
                  </v-chip>
                </div>
                <div class="text-caption grey--text text--darken-1">
                  Total Qty Retur: <strong class="grey--text text--darken-4">{{ totalCartQty }}</strong>
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
                  <th class="text-left" style="width: 105px;">KODE</th>
                  <th class="text-left">NAMA</th>
                  <th class="text-right" style="width: 75px;">QTY</th>
                  <th class="text-center" style="width: 80px;">UOM</th>
                  <th class="text-center" style="width: 60px;">AKSI</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(rowItem, index) in cart" :key="index" class="cart-row">
                  <td>
                    <span class="kode-red-pill">{{ rowItem.kode }}</span>
                  </td>
                  <td class="font-weight-bold grey--text text--darken-4">
                    {{ rowItem.nama }}
                  </td>
                  <td class="text-right font-weight-bold">
                    {{ rowItem.qty }}
                  </td>
                  <td class="text-center grey--text text--darken-2">
                    {{ rowItem.uom || '-' }}
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
            @click="cancelTransaction"
          >
            Cancel
          </v-btn>
          <v-btn
            small
            depressed
            color="red darken-2"
            class="white--text font-weight-medium text-none px-4"
            :disabled="!saveReceipt || cart.length === 0"
            @click="saveTransaction"
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
              v-for="rowItem in items"
              :key="rowItem.id"
              :disabled="isItemIncart(rowItem)"
              :class="['list-hover-red', { 'in-cart-item': isItemIncart(rowItem) }]"
              @click="!isItemIncart(rowItem) && selectItem(rowItem)"
            >
              <v-list-item-content>
                <v-list-item-title class="d-flex flex-wrap align-center">
                  <span class="kode-red-pill mr-2">{{ rowItem.kode }}</span>
                  <span class="font-weight-bold grey--text text--darken-4 mr-2">
                    {{ rowItem.nama }}
                  </span>

                  <v-chip
                    v-if="isItemIncart(rowItem)"
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

                  <v-chip x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                    Stok: {{ rowItem.stok }}
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

    <!-- Dialog Daftar Customer -->
    <v-dialog v-model="showCustomerList" max-width="700px">
      <v-card class="rounded-lg">
        <v-card-title class="modal-top-bar px-5 py-4">
          <div class="d-flex align-center">
            <v-avatar color="red lighten-5" size="36" class="mr-3 bengkel-avatar-ring">
              <v-icon color="red darken-2" small>mdi-account-search-outline</v-icon>
            </v-avatar>
            <span class="text-subtitle-1 font-weight-bold grey--text text--darken-4">
              Daftar Customer
            </span>
          </div>
          <v-spacer></v-spacer>
          <v-btn icon small color="grey darken-1" @click="closeCustomerList">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <div class="bengkel-stripe"></div>

        <v-card-text class="pa-5">
          <v-text-field
            v-model="searchCustomerQuery"
            label="Cari kode, nama, atau alamat customer..."
            outlined
            dense
            clearable
            hide-details
            color="red darken-2"
            class="mb-3"
          ></v-text-field>

          <v-list dense class="border-list rounded" style="max-height: 320px; overflow-y: auto;">
            <v-list-item
              v-for="customer in filteredCustomers"
              :key="customer.id"
              class="list-hover-red"
              @click="selectCustomer(customer)"
            >
              <v-list-item-content>
                <v-list-item-title class="d-flex flex-wrap align-center">
                  <span class="kode-red-pill mr-2">{{ customer.kode }}</span>
                  <span class="font-weight-bold grey--text text--darken-4 mr-2">{{ customer.nama }}</span>
                  <v-chip v-if="customer.nopol" x-small label color="red lighten-5" text-color="red darken-3" class="font-weight-bold">
                    {{ customer.nopol }}
                  </v-chip>
                </v-list-item-title>
                <v-list-item-subtitle v-if="customer.alamat" class="text-caption mt-1">
                  {{ customer.alamat }}
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card-text>

        <v-divider></v-divider>
        <v-card-actions class="px-5 py-3 grey lighten-5">
          <v-spacer></v-spacer>
          <v-btn text color="grey darken-2" class="text-none" @click="closeCustomerList">Tutup</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import api from '../../services/api';
import { loadCustomers, loadItems } from '../../utils/utils';

export default {
  name: 'ReturCustomerFormView',
  data() {
    return {
      keterangan: '',
      initialKeterangan: '',
      cart: [],
      formActive: false,
      showItemList: false,
      items: [],
      searchQuery: '',
      dialog: false,
      saveReceipt: false,
      customers: [],
      searchCustomerQuery: '',
      showCustomerList: false,
      noRetur: '',
      kodeRetur: '',
      savedTransaction: null,
      showInvoice: false,
      currentPage: 1,
      pageSize: 10,
      totalItems: 0,

      transaction: {
        id: '',
        idCustomer: '',
        nama: '',
        kode: '',
        nopol: '',
        tanggal: '',
        alamat: '',
        no_hp: '',
      },

      item: {
        id: '',
        nama: '',
        kode: '',
        uom: '',
        qty: 0,
        stok: '',
      },
    };
  },
  watch: {
    keterangan(newVal) {
      if (newVal) {
        this.keterangan = newVal.toUpperCase();
      }
    },
    cart(newCart) {
      if (!newCart.length) {
        this.saveReceipt = false;
      }
    },
  },
  computed: {
    filteredCustomers() {
      const q = (this.searchCustomerQuery || '').toLowerCase();
      return this.customers.filter(
        customer =>
          (customer.nama && customer.nama.toLowerCase().includes(q)) ||
          (customer.kode && customer.kode.toLowerCase().includes(q)) ||
          (customer.alamat && customer.alamat.toLowerCase().includes(q))
      );
    },
    pageCount() {
      return Math.max(1, Math.ceil(this.totalItems / this.pageSize));
    },
    totalCartQty() {
      return this.cart.reduce((sum, rowItem) => sum + (Number(rowItem.qty) || 0), 0);
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

    loadCustomers() {
      loadCustomers().then(customers => {
        this.customers = customers || [];
      });
    },

    async activateForm() {
      this.formActive = true;
      this.loadItems();
      this.loadCustomers();
      this.initialKeterangan = this.keterangan;
    },

    addToCart() {
      if (!this.transaction.tanggal || !this.item.nama) {
        alert('Tanggal belum diisi atau item belum dipilih');
        return;
      }
      if (!this.item.qty || Number(this.item.qty) <= 0) {
        alert('Qty harus lebih dari 0');
        return;
      }
      if (this.formActive) {
        this.cart.push({
          ...this.item,
          qty: Number(this.item.qty),
        });

        this.item = {
          id: '',
          nama: '',
          kode: '',
          uom: '',
          qty: 0,
          stok: '',
        };
        this.saveReceipt = true;
      }
    },

    isItemIncart(rowItem) {
      return this.cart.some(
        cartItem =>
          (cartItem.id && rowItem.id && cartItem.id === rowItem.id) ||
          (cartItem.kode && rowItem.kode && cartItem.kode === rowItem.kode)
      );
    },

    isCustomerSearchDisabled() {
      return this.cart.length > 0;
    },

    removeFromCart(index) {
      this.cart.splice(index, 1);
    },

    async saveTransaction() {
      const id_customer = this.transaction.idCustomer || this.transaction.id;
      const tanggal = this.transaction.tanggal;
      const keterangan = this.keterangan;
      const cart = this.cart.map(rowItem => ({
        id_item: rowItem.id,
        nama: rowItem.nama,
        kode: rowItem.kode,
        qty: Number(rowItem.qty),
        uom: rowItem.uom,
      }));

      try {
        const response = await api.post('/t_retur_sales', {
          id_customer: id_customer,
          tanggal: tanggal,
          keterangan: keterangan,
          detail: cart,
        });

        this.noRetur = response.data.no_retur;
        this.kodeRetur = this.noRetur;

        this.savedTransaction = {
          kodeRetur: this.kodeRetur,
          kodeCustomer: this.transaction.kode,
          namaCustomer: this.transaction.nama,
          alamatCustomer: this.transaction.alamat,
          nopolCustomer: this.transaction.nopol,
          noHpCustomer: this.transaction.no_hp,
          tanggal: this.transaction.tanggal,
          keterangan: this.keterangan,
          items: this.cart,
        };

        alert('Transaksi berhasil disimpan!');
        this.cancelTransaction();
      } catch (error) {
        console.error('Error saving transaction:', error);
        alert('Terjadi kesalahan saat menyimpan transaksi. Silakan coba lagi.');
      }
    },

    cancelTransaction() {
      this.cart = [];
      this.formActive = false;
      this.transaction = {
        id: '',
        idCustomer: '',
        nama: '',
        kode: '',
        nopol: '',
        tanggal: '',
        alamat: '',
        no_hp: '',
      };
      this.item = {
        id: '',
        nama: '',
        kode: '',
        uom: '',
        stok: '',
        qty: 0,
      };
      this.keterangan = '';
      this.saveReceipt = false;
    },

    selectItem(rowItem) {
      if (this.isItemIncart(rowItem)) return;
      this.item.id = rowItem.id;
      this.item.nama = rowItem.nama;
      this.item.kode = rowItem.kode;
      this.item.uom = rowItem.satuan_nama;
      this.item.stok = rowItem.stok;
      this.item.qty = 1;
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

    openCustomerList() {
      if (this.formActive && !this.isCustomerSearchDisabled()) {
        this.showCustomerList = true;
        this.loadCustomers();
      }
    },

    closeCustomerList() {
      this.showCustomerList = false;
    },

    selectCustomer(customer) {
      this.transaction.id = customer.id;
      this.transaction.idCustomer = customer.id;
      this.transaction.nama = customer.nama;
      this.transaction.kode = customer.kode;
      this.transaction.nopol = customer.nopol;
      this.transaction.no_hp = customer.no_hp;
      this.transaction.alamat = customer.alamat;
      this.showCustomerList = false;
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