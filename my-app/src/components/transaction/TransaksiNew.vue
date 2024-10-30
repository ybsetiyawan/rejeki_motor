<template>
  <div class="container">
    <form @submit.prevent="addToCart" class="receipt-form">
      <div class="form-header">
        <h3>Form Pengeluaran Barang</h3>
        <button type="button" class="new-button" @click="activateForm" :disabled="formActive">New</button>
        <v-dialog v-model="showItemList" max-width="700px" class="customer-dialog">
          <v-card>
            <v-card-title>
              <span class="headline">Daftar Barang</span>
                </v-card-title>
                <v-card-text>
                  <!-- <v-text-field v-model="searchQuery" label="Search Item" clearable></v-text-field> -->
                  <v-text-field
                    class="font"
                    label="Cari Berdasarkan Kode atau Nama Item"
                    single-line
                    hide-details
                    v-model="searchQuery"
                    @input="loadItems">
                  </v-text-field>
                  
                  <v-list>
                    <v-list-item 
                      v-for="item in items" 
                      :key="item.id"
                      @click="selectItem(item)"
                      :disabled="isItemIncart(item) || item.stok <= 0"
                      >
                      <v-list-item-content>
                        <v-list-item-title class="customer-text">{{ item.kode + ' - ' + item.nama + ' - ' + formatHarga(item.modal) }}</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                  <v-pagination
                    class="custom-pagination"
                    v-model="currentPage"
                    :length="pageCount"
                    :total-visible="7"
                    @input="loadItems">
                  </v-pagination>
                </v-card-text>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="closeItemList">Close</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
        <v-dialog v-model="showCustomerList" max-width="700px" class="supplier-dialog">
          <v-card>
            <v-card-title>
              <span class="headline">Daftar Customer</span>
            </v-card-title>
            <v-card-text>
              <v-text-field v-model="searchCustomerQuery" label="Search Supplier" clearable></v-text-field>
              <v-list>
                <v-list-item 
                  v-for="customer in filteredCustomers" 
                  :key="customer.id"
                  @click="selectCustomer(customer)"
                >
                  <v-list-item-content>
                    <v-list-item-title class="supplier-text">{{ customer.kode + ' - ' + customer.nama + ' - ' + customer.alamat }}</v-list-item-title>
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
      </div>
      <div class="form-group flex-container">
        <div class="flex-item">
          <label for="tanggal">Tanggal</label>
          <input type="date" v-model="transaction.tanggal" :disabled="!formActive">
        </div>
      </div>
      <div class="form-group">
        <label for="supplier">Customer:</label>
        <div class="input-with-icon">
          <input class="input-item" type="text" id="supplier" v-model="transaction.nama" required disabled/>
          <v-icon 
            class="icon-item" 
            @click="openCustomerList" 
            :class="{ 'disabled-icon': isCustomerSearchDisabled() }"
            :disabled="isCustomerSearchDisabled() || !formActive"
          >mdi-magnify</v-icon>
        </div>
      </div>
      <div class="form-group flex-container">
        <div class="flex-item">
          <label for="alamat">Kode Customer:</label>
          <input type="text" id="alamat" v-model="transaction.kode" required disabled />
        </div>
        <div class="flex-item">
          <label for="alamat">Nopol:</label>
          <input type="text" id="alamat" v-model="transaction.nopol" required disabled />
        </div>
      </div>
      <div class="form-group">
        <label for="itemName">Nama Item:</label>
        <div class="input-with-icon">
          <input class="input-item" type="text" id="itemName" v-model="item.nama" required disabled />
          <v-icon class="icon-item" @click="openItemList" :disabled="!formActive">mdi-magnify</v-icon>
        </div>
      </div>
      <div class="form-group flex-container">
        <div class="flex-item">
          <label for="itemName">Kode Item:</label>
          <input type="text" id="itemCode" v-model="item.kode" required disabled />
        </div>
        <div class="flex-item">
          <label for="quantity">Qty:</label>
          <input type="number" id="quantity" min="1" :max="item.stok" v-model="item.qty" required :disabled="!formActive" />
        </div>
        <div class="flex-item">
          <label for="stock">Stock:</label>
          <input type="number" id="quantity" v-model="item.stok" required disabled />
        </div>
        <div class="flex-item">
          <label for="uom">Uom:</label>
          <input type="text" id="uom" v-model="item.uom" required disabled />
        </div>
      </div>
      <div class="form-group">
        <label for="keterangan">Keterangan:</label>
        <input type="text" id="keterangan" v-model="keterangan" required :disabled="!formActive" autocomplete="off"/>
      </div>
      <button type="submit" class="submit-button" :disabled="!formActive">Add to Cart</button>
    </form>

    <div class="cart">
      <h4>Cart</h4>
      <v-simple-table class="small-table">
        <thead>
          <tr>
            <th>Kode</th>
            <th>Nama</th>
            <th>Modal</th>
            <th>Hjl</th>
            <th>Uom</th>
            <th>Qty</th>
            <th class="delete-column"></th>
          </tr>
        </thead>
        <tbody class="cart-body">
          <tr v-for="(item, index) in cart" :key="index">
            <td>{{ item.kode }}</td>
            <td>{{ item.nama }}</td>
            <td>{{ item.modal }}</td>
            <!-- <td contenteditable="true" class="warning">{{ item.hpp }}</td> -->
            <td contenteditable="true" @input="updateHpp(index, $event)" class="warning">{{ item.hpp }}</td> <!-- Make hpp editable -->
            <td>{{ item.uom }}</td>
            <td>{{ item.qty }}</td>
            <td>
              <v-icon 
                @click="removeFromCart(index)"
                color="red"
                size="15px"
              >mdi-delete</v-icon>
            </td>
          </tr>
        </tbody>
      </v-simple-table>
      <div class="button-group" v-if="cart.length || formActive">
        <button @click="saveTransaction" class="save-button" :disabled="!saveReceipt">Save</button>
        <button v-show="formActive" @click="cancelTransaction" class="cancel-button">Cancel</button>
      </div>  
    </div>
    <InvoiceView v-if="showInvoice" :transaction="savedTransaction" :dialog="dialog" />
  </div>
</template>

<script>
import api from '../../services/api';
import { loadCustomers, loadItems,  } from '../../utils/utils';
import InvoiceView from '../print/InvoiceView.vue';
import { formatHarga } from '@/mixins/FilterMixin';


export default {
    components: { InvoiceView },
    data() {
        return {
            keterangan: '',
            initialKeterangan: '', // Add initialKeterangan here
            cart: [],
            formActive: false,
            showItemList: false,
            items: [],
            searchQuery: '',
            dialog: false,
            saveReceipt: false,
            customers:[],
            searchCustomerQuery: '',
            showCustomerList: '',
            noFaktur: '',
            kodeInvoice:'',
            savedTransaction: null,
            showInvoice: false,
            currentPage: 1,
            pageSize: 10,
            totalItems: 0, 


            transaction: {
              idCustomer: '',
              nama: '',
              kode: '',
              nopol: '',
              tanggal: ''
            },

            item: {
              id: '',
              nama: '',
              kode: '',
              modal: '',
              hpp: '',
              uom: '',
              qty: 0,
              stok: ''
            },
            formatHarga

        };
    },
    watch: {
        receipt: {
            handler(newVal) {
                if (newVal.keterangan) {
                    this.keterangan = newVal.keterangan.toUpperCase();
                }
            },
            deep: true
        }
    },
    // mounted() {
    //   this.loadItems()
    // },
    computed: {
        // filteredItems() {
        //     return this.items.filter(item => item.nama.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
        //         item.kode.toLowerCase().includes(this.searchQuery.toLowerCase()));
        // },
        filteredCustomers() {
            return this.customers.filter(customer => customer.nama.toLowerCase().includes(this.searchCustomerQuery.toLowerCase()) ||
                customer.kode.toLowerCase().includes(this.searchCustomerQuery.toLowerCase()));
        },
        pageCount() {
        return Math.ceil(this.totalItems / this.pageSize);
    }
    },
    methods: {
      // hpp adalah harga jual ke customer
      updateHpp(index, event) {
      const newValue = event.target.innerText.trim();
      // console.log(`Updating hpp for item at index ${index} to ${newValue}`);
      this.cart[index].hpp = newValue;
  },
       loadItems() {
        loadItems(this.currentPage, this.pageSize, this.searchQuery)
          .then(data => {
            this.items = data.items;
            this.totalItems = data.total
          })
          .catch(error => console.error('Error Loading Items:', error))
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
            this.initialKeterangan = this.keterangan; // Save initial keterangan
        },
        addToCart() {
          if (!this.transaction.tanggal || !this.item.nama ) {
            alert('Tanggal belum diisi atau item belum dipilih')
            return;
          }
            if (this.formActive) {
                this.cart.push({ ...this.item,
                  hpp: 0
                 });
             
                this.item = {
                  nama: '',
                  kode: '',
                  modal: '',
                  uom: '',
                  hpp: '',
                  qty: 0,
                }
                this.saveReceipt = true;
            }
        },
        isItemIncart(item) {
            return this.cart.some(cartItem => cartItem.kode === item.kode);
        },
        isCustomerSearchDisabled() {
            return this.cart.length > 0 ;
        },
        removeFromCart(index) {
            this.cart.splice(index, 1);
        },
        

        async saveTransaction() {
          const id_customer = this.transaction.id;
          const tanggal = this.transaction.tanggal;
          const keterangan = this.keterangan;
          const cart = this.cart.map(item => ({
            id_barang: item.id,
            nama: item.nama,
            kode: item.kode,
            qty: item.qty,
            uom: item.uom,
            harga: item.hpp,
            modal: item.modal,
          }));

          try {

            // console.log('Saving transaction with data:', {
            //   id_customer,
            //   tanggal,
            //   keterangan,
            //   cart
            // });

            const response = await api.post('/t_transaksi', {
              id_customer: id_customer,
              tanggal: tanggal,
              keterangan: keterangan,
              detail: cart
            });

            // console.log('API response:', response.data);

            this.noFaktur = response.data.no_faktur;
            this.kodeInvoice = this.noFaktur;

            // console.log('New kodeInvoice:', this.noFaktur);

            this.savedTransaction = {
              kodeInvoice: this.kodeInvoice,
              kodeCustomer: this.transaction.kode,
              namaCustomer: this.transaction.nama,
              alamatCustomer: this.transaction.alamat,
              nopolCustomer: this.transaction.nopol,
              noHpCustomer: this.transaction.no_hp,
              tanggal: this.transaction.tanggal,
              keterangan: this.keterangan,
              items: this.cart,
              total: this.cart.reduce((sum, item) => sum + (item.qty * item.hpp), 0) // Calculate total
            };

            // console.log('Saved Transaction:', this.savedTransaction);

            this.showInvoice = true;
            // console.log('showInvoice set to:', this.showInvoice);

            alert('Transaksi berhasil disimpan!');
            this.cancelTransaction();
          } catch (error) {
            // console.error('Error saving transaction:', error);
            alert('Terjadi kesalahan saat menyimpan transaksi. Silakan coba lagi.');
          }
        },

        cancelTransaction() {
            this.cart = [];
            this.formActive = false;
            this.transaction = {
              nama: '',
              kode: '',
              nopol: '',
              tanggal: ''
            }
            this.item = {
              nama: '',
              kode: '',
              uom: '',
              stok: '',
              qty: 0,
            }
            this.keterangan = '';
            this.saveReceipt = false;
        },
        selectItem(item) {
            this.item.id = item.item_id;
            this.item.nama = item.nama;
            this.item.kode = item.kode;
            this.item.modal = item.modal;
            this.item.hpp = item.hpp,
            this.item.uom = item.satuan_nama;
            this.item.stok = item.stok;
            this.showItemList = false;
        },
        closeItemList() {
            this.showItemList = false;
        },
        openItemList() {
            if (this.formActive) {
                this.showItemList = true;
            }
        },
        openCustomerList() {
            if (!this.isCustomerSearchDisabled()) {
                this.showCustomerList = true;
                // this.loadSuppliers();
                this.loadCustomers();
            }
        },
        closeCustomerList() {
            this.showSCustomerList = false;
        },
        // console.log('Selected Supplier:', supplier);
        selectCustomer(customer) {
          this.transaction.id = customer.id;
          this.transaction.nama = customer.nama;
          this.transaction.kode = customer.kode;
          this.transaction.nopol = customer.nopol;
          this.transaction.no_hp = customer.no_hp;
          this.transaction.alamat = customer.alamat;
          this.showCustomerList = false;
        }
    }
};

</script>

<style scoped>

.container {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  padding: 35px;
  height: 85vh;
}

.receipt-form, .cart {
  flex: 1;
  max-width: 50%;
  margin-top: -20px;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #f9f9f9;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: -10px;
  
}

.new-button {
  background-color: #28a745;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  padding: 5px 10px;
  margin-top: -10px;
  height: 25px;
  font-size: 12px;
}

.new-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.new-button:hover:enabled {
  background-color: #218838;
}

.form-group {
  margin-top: 15px;
  margin-bottom: 10px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  font-size: 12px; /* Adjust the font size */
  margin: 0; /* Adjust the margin */
}

.form-group input {
  width: 100%;
  padding: 4px; /* Adjust the padding */
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 12px; /* Adjust the font size */
  height: 25px; /* Adjust the height */
}


.input-with-icon v-icon {
  cursor: pointer;
  margin-left: 10px;
}

.input-with-icon v-icon:disabled {
  cursor: not-allowed;
  color: #cccccc;

}

.flex-container {
  display: flex;
  gap: 10px;
}

.flex-item {
  flex: 1;
}

.submit-button {
  width: 100%;
  padding: 2px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  height: 25px;
  font-size: 15px;

}

.submit-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.submit-button:hover:enabled {
  background-color: #0056b3;
}

.cart ul {
  list-style-type: none;
  padding: 0;
}

.cart li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.cart button {
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  padding: 5px 10px;
  width: 20%;
}

.cart button:hover:enabled {
  background-color: #35b63e;
}

h3{
  margin-top: -25px;
}

h4{
  margin-top: -15px;
  margin-left: -10px;
}

.input-item{
  width: 88% !important;
}

.icon-item{
  width: 7%;
  margin-left: 16px;
  
}

.button-group {
  display: flex;
  justify-content: space-between;
  gap: 0; /* Remove the gap */
  width: 30%;
  margin-top: 10px;
  height: 25px;
  font-size: 12px;
  padding: 0;
}

.button-group button {
  flex: 1;
  margin-right: 5px; /* Add a small margin to the right of each button */
}

.button-group button:last-child {
  margin-right: 0; /* Remove the margin from the last button */
}

.cancel-button {
  width: 100%;
  padding: 10px;
  background-color: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}


.save-button {
  background-color: #007bff; /* Biru */
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.save-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}


.small-table thead {
  background-color: rgb(213, 212, 212); /* Green background */
  color: white; /* White text */
  font-weight: bold;
  text-align: left;

}


.small-table thead th {
  height: 30px !important; /* Set a specific height */
  border-bottom: 2px solid #ddd;
  font-size: 15px !important;
}

/* Style for table body */
.small-table tbody {
  background-color: #fff;
}

.small-table tbody tr:nth-child(even) {
  background-color: #f2f2f2; /* Light grey background for even rows */
}

.small-table tbody tr:hover {
  background-color: #ddd; /* Darker grey background on hover */
}

.small-table tbody td {
  padding: 10px;
  border-bottom: 1px solid #ddd;
  
}

/* Add some padding and border radius to the table */
.small-table {
  width: 100%;
  border-collapse: collapse;
  border-radius: 5px;
  overflow: hidden;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

/* Add some margin to the table */
.small-table {
  margin-top: 20px;
  
}
.cart-body td{
  height: 28px !important;
  font-size: 11px !important;
  font-weight: bold !important;
}


.cart-body td {
  font-size: 0.9em;
}

.disabled-icon {
  pointer-events: none;
  color: #cccccc;
}
.customer-text {
  font-size: 1.0em; /* Ukuran font lebih kecil */
}
</style>