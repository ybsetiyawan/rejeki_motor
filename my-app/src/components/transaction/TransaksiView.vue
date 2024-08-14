<template>
  <v-container class="transaksi-container">
    <v-row>
      <v-col cols="12" md="6">
          <v-card-title>
            <h5 class="title-mepet">Transaksi Penjualan</h5>
          </v-card-title>
          <v-card-text>
            <v-btn @click="startNewTransaction" :disabled="customerSelected" :class="{'new-button': true, 'disabled-button': customerSelected}" block>New</v-btn>
            <v-dialog v-model="showCustomerList" max-width="700px" class="customer-dialog">
              <v-card>
                <v-card-title>
                  <span class="headline">Daftar Customer</span>
                </v-card-title>
                <v-card-text>
                  <v-text-field v-model="searchQuery" label="Search Customer" clearable></v-text-field>
                  <v-list>
                    <v-list-item v-for="customer in filteredCustomers" :key="customer.id" @click="selectCustomer(customer)">
                      <v-list-item-content>
                        <v-list-item-title class="customer-text">{{ customer.kode + ' - ' + customer.nama + ' - '+ customer.alamat }}</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card-text>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="closeCustomerList">Close</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
            <v-form>
              <v-text-field v-model="kodeCustomer" label="Kode Customer" :disabled="!isNewTransaction || customerSelected"></v-text-field>
              <v-text-field v-model="namaCustomer" label="Nama Customer" :disabled="!isNewTransaction || customerSelected"></v-text-field>
              <v-tooltip bottom v-if="isKeteranganTooLong">
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    v-model="keterangan"
                    label="Keterangan"
                    :disabled="!customerSelected && !isNewTransaction"
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <span>Panjang keterangan tidak boleh lebih dari 255 karakter</span>
              </v-tooltip>
              <v-text-field
                v-else
                v-model="keterangan"
                label="Keterangan"
                :disabled="!customerSelected && !isNewTransaction"
              ></v-text-field>
              <v-btn @click="openItemList" :disabled="!customerSelected" block>Pilih Item</v-btn>
              <v-dialog v-model="showItemList" max-width="700px" class="item-dialog">
                <v-card>
                  <v-card-title>
                    <span class="headline">Daftar Item</span>
                  </v-card-title>
                  <v-card-text>
                    <v-text-field v-model="searchQueryItem" label="Search Item" clearable></v-text-field>
                    <v-list>
                      <v-list-item v-for="item in filteredItems" :key="item.id" @click="selectItem(item)">
                        <v-list-item-content>
                          <v-list-item-title class="item-text">{{ item.kode + ' - ' + item.nama }}</v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                    </v-list>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeItemList">Close</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
              <br>
              <v-btn @click="addItemToCart" class="small-button" block :disabled="!isNewTransaction || !selectedItem">Add</v-btn>
            </v-form>
          </v-card-text>
      </v-col>
      <v-col cols="12" md="6">
        <div class="cart-card">
          <div class="cart-table-container">
            <v-simple-table class="small-table">
              <thead>
                <tr class="cart-header">
                  <th>Nama Item</th>
                  <th>Harga</th>
                  <th>Qty</th>
                  <th>Stok</th>
                  <th>Total</th>
                  <th class="delete-column"></th>
                </tr>
              </thead>
              <tbody class="cart-tbody">
                <tr v-for="(item, index) in cart" :key="index">
                  <td>{{ toUpperCase(item.nama) }}</td>
                  <td>{{ formatHarga(item.hpp) }}</td>
                  <td>
                    <v-tooltip bottom>
                      <template v-slot:activator="{ on, attrs }">
                        <input type="number" v-model.number="item.qty" :max="item.stok" min="1" class="qty-input" v-bind="attrs" v-on="on" @input="updateTotal" />
                      </template>
                      <span>Qty tidak bisa lebih besar dari stok</span>
                    </v-tooltip>
                  </td>
                  <td>{{ item.stok }}</td>
                  <td>{{ formatHarga(item.hpp * item.qty) }}</td>
                  <td>
                    <v-icon 
                      @click="deleteItemFromCart(index)"
                      color="red"
                      size="20px"
                    >mdi-delete</v-icon>
                  </td>
                </tr>
              </tbody>
            </v-simple-table>
          </div>
          <div class="total">
            SubTotal : {{ formatHarga(total) }}
          </div>
          <v-btn @click="cancelTransaction" :disabled="!customerSelected" class="cancel-button">Cancel</v-btn>
          <v-btn @click="saveTransaction" :disabled="!saveEnabled" class="save-button">Save</v-btn>
        </div>
      </v-col>
    </v-row>
    <InvoiceView v-if="showInvoice" :transaction="savedTransaction" :dialog="dialog" />
  </v-container>
</template>

<script>
// import axios from 'axios';
import api from '../../services/api';
import { loadCustomers, loadItems } from '../../utils/utils';
import { formatHarga, toUpperCase, filterData } from '../../mixins/FilterMixin';
import InvoiceView from '../print/InvoiceView.vue';

export default {
  components: {
    InvoiceView
  },
  data() {
    return {
      kodeCustomer: '',
      namaCustomer: '',
      alamatCustomer: '',
      nopolCustomer: '',
      noHpCustomer: '',
      selectedItem: null,
      items: [],
      cart: [],
      showCustomerList: false,
      customers: [],
      customerSelected: false,
      total: 0,
      searchQuery: '',
      showItemList: false,
      searchQueryItem: '',
      saveEnabled: false,
      keterangan: '',
      isNewTransaction: false,
      formatHarga,
      toUpperCase,
      showInvoice: false,
      savedTransaction: null,
      dialog: false,
      noFaktur: '',
      kodeInvoice: ''
    };
  },
  watch: {
    keterangan(newVal) {
      this.keterangan = toUpperCase(newVal);
    }
  },
  computed: {
    availableItems() {
      return this.items.filter(item => !this.cart.some(cartItem => cartItem.nama === item.nama));
    },
    filteredItems() {
      return this.availableItems.filter(item => 
        item.nama.toLowerCase().includes(this.searchQueryItem.toLowerCase())
      );
    },
  
    filteredCustomers() {
      return filterData(this.customers, this.searchQuery);
    },
    isKeteranganTooLong() {
      return this.keterangan.length > 255;
    }
  },
  mounted() {
    this.loadCustomers();
    this.loadItems();
  },
  methods: {
    loadCustomers() {
      loadCustomers().then(customers => {
        this.customers = customers || [];
      });
    },
    loadItems() {
      loadItems().then(items => {
        this.items = items || [];
      });
    },
    addItemToCart() {
      if (this.selectedItem) {
        const itemInCart = this.cart.find(item => item.id === this.selectedItem.id);
        if (itemInCart) {
          itemInCart.qty += 1;
        } else {
          this.cart.push({ ...this.selectedItem, qty: 1 });
        }
        this.updateTotal();
        this.selectedItem = null;
        this.saveEnabled = true;
      }
    },
    async startNewTransaction() {
      this.kodeCustomer = '';
      this.namaCustomer = '';
      this.alamatCustomer = '';
      this.nopolCustomer = '';
      this.noHpCustomer = '';
      this.showCustomerList = true;
      this.customerSelected = false;
      this.cart = [];
      this.total = 0;
      this.isNewTransaction = true;
      // await this.fetchLastNoFaktur();
    },
    // async fetchLastNoFaktur() {
    //   try {
    //     const response = await api.get('/t_transaksi/last_nofaktur');
    //     this.noFaktur = response.data.no_faktur;
    //     this.kodeInvoice = this.noFaktur;
    //     // console.log('New kodeInvoice:', this.kodeInvoice);
    //   } catch (error) {
    //     console.error('Error fetching new faktur:', error);
    //   }
    // },
    selectCustomer(customer) {
      this.kodeCustomer = customer.kode;
      this.namaCustomer = customer.nama;
      this.alamatCustomer = customer.alamat;
      this.nopolCustomer = customer.nopol;
      this.noHpCustomer = customer.no_hp;
      this.selectedCustomerId = customer.id;
      this.showCustomerList = false;
      this.customerSelected = true;
    },
    updateTotal() {
      this.total = this.cart.reduce((sum, item) => sum + (item.hpp * item.qty), 0);
    },
    cancelTransaction() {
      this.kodeCustomer = '';
      this.namaCustomer = '';
      this.alamatCustomer = '';
      this.nopolCustomer = '';
      this.noHpCustomer = '';
      this.customerSelected = false;
      this.cart = [];
      this.total = 0;
      this.saveEnabled = false;
      this.isNewTransaction = false;
      this.keterangan = '';
    },
    selectItem(item) {
      this.selectedItem = item;
      this.showItemList = false;
    },
    closeCustomerList() {
      this.showCustomerList = false;
      this.searchQuery = '';
    },
    async saveTransaction() {
      const customer_id = this.selectedCustomerId;
      const items = this.cart.map(item => ({
        id_barang: item.item_id,
        qty: item.qty,
        harga: item.hpp,
        subtotal: item.qty * item.hpp
      }));

      try {
        const response = await api.post('/t_transaksi', {
          id_customer: customer_id,
          tanggal: new Date(),
          keterangan: this.keterangan,
          detail: items
        });

        // Ambil kodeInvoice dari respons server
        this.noFaktur = response.data.no_faktur;
        this.kodeInvoice = this.noFaktur;
        
        console.log('New kodeInvoice:', this.noFaktur);

        alert('Transaksi berhasil disimpan!');
        this.savedTransaction = {
          kodeInvoice: this.kodeInvoice,
          kodeCustomer: this.kodeCustomer,
          namaCustomer: this.namaCustomer,
          alamatCustomer: this.alamatCustomer,
          nopolCustomer: this.nopolCustomer,
          noHpCustomer: this.noHpCustomer,
          tanggal: new Date(),
          keterangan: this.keterangan,
          items: this.cart,
          total: this.total
        };

        this.showInvoice = true;
        this.dialog = true;
        this.cancelTransaction();
      } catch (error) {
        console.error('Error saving transaction:', error);
      }
    },
    deleteItemFromCart(index) {
      this.cart.splice(index, 1);
      this.updateTotal();
    },
    openItemList() {
      this.showItemList = true;
    },
    closeItemList() {
      this.showItemList = false;
      this.searchQueryItem = '';
    }
  }
}
</script>

<style scoped>


.transaksi-container {
  max-width: 1000px;
  margin-top: 20px;
  padding: 20px;
  background-color: #f9f9f9b9;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 1);
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  height: 80vh;
}

.transaksi-card1, .cart-card {
  margin-top: -10px;
  margin-left: -10px;
  border-radius: 10px;
  background-color: #f0ecec76;
  position: relative;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 1);
  box-sizing: border-box;
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 75.6vh;
}

.cart-table-container {
  max-width: 97%;
  margin-top: 10px;
  margin-left: 7px;
}

.new-button {
  background-color: rgb(48, 162, 57) !important;
  color: white;
  margin-bottom: 20px;
}

.new-button.disabled-button {
  background-color: grey !important;
  cursor: not-allowed;
}

.qty-input {
  width: 40px;
  margin-left: 5px;
}

.total {
  font-weight: bold;
  margin-top: 20px;
  color: rgb(118, 115, 115);
  text-align: center;
  margin-left: 230px;
  font-size: 1.3em;

}

.cart-card ul {
  list-style-type: none;
  padding: 0;
}

.cart-card li {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.cart-card li span {
  margin-right: 10px;
}

.cart-card {
  font-size: 0.8em;
  font-family: Calibri;
}


.cancel-button {
  position: absolute;
  bottom: 15px;
  left: 18px;
  background-color: rgb(236, 68, 68) !important;
  color: white;
}

.save-button {
  position: absolute;
  bottom: 15px;
  left: 120px;
  background-color: rgb(42, 76, 225) !important;
  color: white;
}

.total{
  margin-right: 20px;
  color: grey;
}

.small-table {
  border-radius: 5px;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.3);
  max-height: 330px;
  overflow-y: auto;
}

.small-button {
  background-color: rgb(52, 173, 151) !important;
  color: white;
}

.qty-input {
  width: 50px;
  margin-left: 5px;
}

.title-mepet {
  margin-top: -18px;
  margin-left: -10px;
}

.customer-dialog .v-card {
  width: 100%;
  max-width: 700px;
  height: 400px;
}

.customer-text {
  font-size: 0.9em;
}

.cart-tbody td {
  font-size: 0.9em !important;
}

.cart-header th {
  font-size: 1.2em !important;
}

.item-dialog .v-card {
  width: 100%;
  max-width: 700px;
  height: 400px;
}

.item-text {
  font-size: 0.9em;
}
</style>