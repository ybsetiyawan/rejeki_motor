const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const morgan = require("morgan");
const app = express();
const db = require("./queries.js")

app.use(morgan("tiny"));
app.use(cors());
app.use(bodyParser.json());
app.get("/", (req, res) => {
  res.json(
    { message: "Hello World"
    });
});

app.get("/m_customer", db.get_m_customer);
app.post("/m_customer", db.add_m_customer);
app.put("/m_customer/:id", db.update_m_customer);
app.delete("/m_customer/:id", db.delete_m_customer);

app.get("/m_supplier", db.get_m_supplier);
app.post("/m_supplier", db.add_m_supplier);
app.put("/m_supplier/:id", db.update_m_supplier);
app.delete("/m_supplier/:id", db.delete_m_supplier);

app.get("/m_satuan", db.get_m_satuan);
app.post("/m_satuan", db.create_m_satuan);
app.put("/m_satuan/:id", db.update_m_satuan);
app.delete("/m_satuan/:id", db.delete_m_satuan);

app.get("/m_jenis_item", db.get_m_jenis_item);
app.post("/m_jenis_item", db.create_m_jenis_item);
app.put("/m_jenis_item/:id", db.update_m_jenis_item);
app.delete("/m_jenis_item/:id", db.delete_m_jenis_item);

app.get("/m_item", db.get_all_item);
app.post("/m_item", db.add_m_item);
app.put("/m_item/:id", db.update_m_item);
app.delete("/m_item/:id", db.delete_m_item);

app.get("/m_item_lessthan5", db.get_item_min5);


app.get("/m_user", db.get_m_user);
app.post("/m_user", db.add_m_user);
app.put("/m_user/:id", db.update_m_user);
app.delete("/m_user/:id", db.delete_m_user);

app.get("/role", db.get_m_role);
app.post("/role", db.add_m_role);
// Endpoint for user login
app.post("/login", db.login);

app.post("/t_transaksi", async (req, res) => {
  await db.save_transaksi(req, res);
});

app.post("/t_trans_receipt", async (req, res) => {
  await db.trans_receipt(req, res);
});

app.post("/t_retur_receipt", async (req, res) => {
  await db.t_retur_receipt(req, res);
});

app.post("/t_retur_sales", async (req, res) => {
  await db.t_retur_sales(req, res);
})

// app.get("/t_transaksi/last_nofaktur", db.get_last_nofaktur);
// app.get("/t_trans_receipt/last_noreceipt", db.get_last_noreceipt);
app.get("/t_transaksi/report", db.get_report_transaksi);
app.get("/t_trans_receipt/report", db.get_report_trans_receipt);
app.get("/t_retur_supplier/report", db.get_report_returSupplier);
app.get("/t_retur_customer/report", db.get_report_returCustomer);


const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});


