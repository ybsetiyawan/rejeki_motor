<template>
  <div class="container">
    <form @submit.prevent="addToCart" class="receipt-form">
      <div class="form-header">
        <h3>Form Penerimaan Barang</h3>
        <button type="button" class="new-button" @click="activateForm" :disabled="formActive">New</button>
        <v-dialog v-model="showItemList" max-width="700px" class="dialog">
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
                      :disabled="isItemIncart(item)"
                      >
                      <v-list-item-content>
                        <v-list-item-title class="customer-text">{{ item.kode + ' - ' + item.nama + ' - ' + item.modal }}</v-list-item-title>
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
                  <v-btn color="blue darken-1" text @click="closeCustomerList">Close</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
        <v-dialog v-model="showSupplierList" max-width="700px" class="supplier-dialog">
          <v-card>
            <v-card-title>
              <span class="headline">Daftar Supplier</span>
            </v-card-title>
            <v-card-text>
              <v-text-field v-model="searchSupplierQuery" label="Search Supplier" clearable></v-text-field>
              <v-list>
                <v-list-item 
                  v-for="supplier in filteredSuppliers" 
                  :key="supplier.id"
                  @click="selectSupplier(supplier)"
                >
                  <v-list-item-content>
                    <v-list-item-title class="supplier-text">{{ supplier.kode + ' - ' + supplier.nama }}</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list>
              
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="closeSupplierList">Close</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
      <div class="form-group flex-container">
        <div class="flex-item">
          <label for="tanggal">Tanggal</label>
          <input type="date" v-model="receipt.tanggal" :disabled="!formActive">
        </div>
      </div>
      <div class="form-group">
        <label for="supplier">Supplier:</label>
        <div class="input-with-icon">
          <input class="input-item" type="text" id="supplier" v-model="receipt.supplier" required disabled/>
          <v-icon 
            class="icon-item" 
            @click="openSupplierList" 
            :class="{ 'disabled-icon': isSupplierSearchDisabled() }"
            :disabled="isSupplierSearchDisabled() || !formActive"
          >mdi-magnify</v-icon>
        </div>
      </div>
      <div class="form-group">
        <label for="alamat">Alamat:</label>
        <input type="text" id="alamat" v-model="receipt.alamat" required disabled />
      </div>
      <div class="form-group">
        <label for="itemName">Nama Item:</label>
        <div class="input-with-icon">
          <input class="input-item" type="text" id="itemName" v-model="receipt.itemName" required disabled />
          <v-icon class="icon-item" @click="openItemList" :disabled="!formActive">mdi-magnify</v-icon>
        </div>
      </div>
      <div class="form-group flex-container">
        <div class="flex-item">
          <label for="itemName">Kode Item:</label>
          <input type="text" id="itemCode" v-model="receipt.itemCode" required disabled />
        </div>
        <div class="flex-item">
          <label for="quantity">Qty:</label>
          <input type="number" id="quantity" min="1" v-model="receipt.quantity" required :disabled="!formActive" />
        </div> <div class="flex-item">
          <label for="uom">Uom:</label>
          <input type="text" id="uom" v-model="receipt.uom" required disabled />
        </div>
      </div>
      <div class="form-group">
        <label for="keterangan">Keterangan:</label>
        <input type="text" id="keterangan" v-model="receipt.keterangan" required :disabled="!formActive" autocomplete="off"/>
      </div>
      <button type="submit" class="submit-button" :disabled="!formActive">Add to Cart</button>
    </form>

    <div class="cart">
      <h4>Cart</h4>
      <v-simple-table class="small-table">
        <thead>
          <tr>
            <th>Kode Item</th>
            <th>Nama Item</th>
            <th>Uom</th>
            <th>Qty</th>
            <th class="delete-column"></th>
          </tr>
        </thead>
        <tbody class="cart-body">
          <tr v-for="(item, index) in cart" :key="index">
            <td>{{ item.itemCode }}</td>
            <td>{{ item.itemName }}</td>
            <td>{{ item.uom }}</td>
            <td>{{ item.quantity }}</td>
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
        <button @click="submitReceipt" class="save-button" :disabled="!saveReceipt">Save</button>
        <button v-show="formActive" @click="cancelReceipt" class="cancel-button">Cancel</button>
      </div>  
    </div>
    <ReceiptDocView v-if="showReceiptDoc" :receipt="submitReceiptData" :dialog="dialog" />
  </div>
</template>

<script>
import api from '../../services/api';
import { loadItems, loadSuppliers } from '../../utils/utils';
import ReceiptDocView from '../print/ReceiptDocView.vue';

export default {
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
                alamat: '', // Added alamat property
                keterangan: '',
                kodeSupplier: '',
                no_hp: '',
                email: '',
                tanggal: '',
            },
            initialKeterangan: '', // Add initialKeterangan here
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
            deep: true
        }
    },
    computed: {
        filteredItems() {
            return this.items.filter(item => item.nama.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                item.kode.toLowerCase().includes(this.searchQuery.toLowerCase()));
        },
        filteredSuppliers() {
            return this.suppliers.filter(supplier => supplier.nama.toLowerCase().includes(this.searchSupplierQuery.toLowerCase()) ||
                supplier.kode.toLowerCase().includes(this.searchSupplierQuery.toLowerCase()));
        },
        pageCount() {
        return Math.ceil(this.totalItems / this.pageSize);
        }
    },
    methods: {
       loadItems() {
        loadItems(this.currentPage, this.pageSize, this.searchQuery)
          .then(data => {
            this.items = data.items;
            this.totalItems = data.total
          })
          .catch(error => console.error('Error Loading Items:', error))
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
            this.initialKeterangan = this.receipt.keterangan; // Save initial keterangan
            // await this.fetchLastNoReceipt();
        },
        addToCart() {
          if (!this.receipt.tanggal || !this.receipt.itemName) {
            alert('Tanggal belum diisi atau item belum dipilih')
            return;
          }
            if (this.formActive) {
                this.cart.push({ ...this.receipt });
                this.receipt = {
                    itemName: '',
                    itemCode: '',
                    uom: '',
                    quantity: 0,
                    supplier: this.receipt.supplier, // Preserve current supplier
                    alamat: this.receipt.alamat, // Preserve current alamat
                    keterangan: this.receipt.keterangan, // Preserve current keterangan
                    email: this.receipt.email,
                    no_hp: this.receipt.no_hp,
                    kodeSupplier: this.receipt.kodeSupplier,
                    idSupplier: this.receipt.idSupplier,
                    tanggal: this.receipt.tanggal
                };
                this.saveReceipt = true;
                // Keep the form active to allow adding more items
                // console.log('Before submit data:', this.receipt);
            }
        },
        isItemIncart(item) {
            return this.cart.some(cartItem => cartItem.itemCode === item.kode);
        },
        isSupplierSearchDisabled() {
            return this.cart.length > 0 ;
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
                itemName: item.itemName
            }));

            try {
              
            console.log('Saving transaction with data:', {
              id_supplier,
              tanggal,
              keterangan,
              cart
            });

                const response = await api.post('/t_trans_receipt', {
                    id_supplier: id_supplier,
                    tanggal: tanggal,
                    keterangan: keterangan,
                    detail: cart,
                });

                // Log the response to check its structure
                // console.log('API Response:', response.data);

                this.noReceipt = response.data.no_receipt;
                this.kodeReceipt = this.noReceipt;
                // console.log('noReceipt:', this.noReceipt);
                // console.log('kodeReceipt:', this.kodeReceipt);
                // console.log('tanggal:', this.receipt.tanggal)

                alert('Data berhasil disimpan');
                this.submitReceiptData = {
                    kodeReceipt: this.noReceipt, // Use no_receipt for kodeReceipt
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
                alamat: '', // Reset alamat
                keterangan: this.initialKeterangan, // Restore initial keterangan
                date: '',
                idSupplier: '',
                tanggal: '',
            };
            this.saveReceipt = false;
        },
        selectItem(item) {
            this.receipt.idItem = item.id; // Set the id of the selected item
            this.receipt.itemName = item.nama;
            this.receipt.itemCode = item.kode;
            this.receipt.uom = item.satuan_nama;
            this.showItemList = false;
        },
        closeCustomerList() {
            this.showItemList = false;
        },

        
        openItemList() {
            if (this.formActive) {
                this.showItemList = true;
            }
        },
        openSupplierList() {
            if (!this.isSupplierSearchDisabled()) {
                this.showSupplierList = true;
                this.loadSuppliers();
            }
        },
        closeSupplierList() {
            this.showSupplierList = false;
        },
        selectSupplier(supplier) {
            this.receipt.supplier = supplier.nama;
            this.receipt.alamat = supplier.alamat; // Set the supplier's address
            this.receipt.idSupplier = supplier.id;
            this.receipt.kodeSupplier = supplier.kode;
            this.receipt.no_hp = supplier.no_hp;
            this.receipt.email = supplier.email;
            this.showSupplierList = false;
        // console.log('Selected Supplier:', supplier);
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
  width: 100%;
  padding: 10px;
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

.dialog {
  font-size: small;  
}

.customer-text {
  font-size: 1.0em; /* Ukuran font lebih kecil */
}
</style>