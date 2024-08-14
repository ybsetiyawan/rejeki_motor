const pgqueri = require('./pqqueri');
const Pool = require('pg').Pool;
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'db_bengkel',
    password: 'pakepake',
    port: 5432,
});

//m_customer
const get_m_customer = (request, response) => {
    pool.query('SELECT * FROM m_customer ORDER BY id ASC', (err, result) => {
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
}

const add_m_customer = (request, response) => {
    const {nama, nopol, alamat, no_hp} = request.body;
    pool.query('INSERT INTO m_customer (nama, nopol, alamat, no_hp) VALUES ($1, $2, $3, $4)', [nama, nopol, alamat, no_hp], (err, result) => {
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
}

const update_m_customer = (request, response) => {
    const id = request.params.id;
    const {nama, nopol, alamat, no_hp} = request.body;
    pool.query('UPDATE m_customer SET nama = $1, nopol = $2, alamat = $3, no_hp = $4 WHERE id = $5', [nama, nopol, alamat, no_hp, id], (err, result) => {
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json({message: 'Data berhasil diubah'});
    });
}

const delete_m_customer = (request, response) => {
    const id = request.params.id;
    pool.query('DELETE FROM m_customer WHERE id = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            response.status(500).json({ message: 'Internal Server Error' });
        } else {
            response.status(200).json({ message: 'Data berhasil dihapus' });
        }
    });
}

//m_supplier
const get_m_supplier = (request, response) => {
    pool.query('SELECT * FROM m_supplier ORDER BY id ASC', (err, result) => {
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
}

const add_m_supplier = (request, response) => {
    const {nama, kode, alamat, no_hp, email} = request.body;
    pool.query('INSERT INTO m_supplier (nama, kode, no_hp, alamat, email) VALUES ($1, $2, $3, $4, $5)', [nama, kode, no_hp, alamat, email], (err, result) => {
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
}


const update_m_supplier = (request, response) => {
    const id = request.params.id;
    const {nama, kode, alamat, no_hp, email} = request.body;
    pool.query('UPDATE m_supplier SET nama = $1, kode = $2, alamat = $3, no_hp = $4, email = $5 WHERE id = $6', [nama, kode, alamat, no_hp, email, id], (err, result) => {
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json({message: 'Data berhasil diubah'});
    });
}

const delete_m_supplier = (request, response) => {
    const id = request.params.id;
    pool.query('DELETE FROM m_supplier WHERE id = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            response.status(500).json({ message: 'Internal Server Error' });
        } else {
            response.status(200).json({ message: 'Data berhasil dihapus' });
        }
    });
}

// m_satuan
const get_m_satuan = (request, response) =>{
    pool.query('SELECT * FROM m_satuan ORDER BY id ASC', (err, result) =>{
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
};

const create_m_satuan = (request, response) => {
    const nama = request.body.nama;
    pool.query('INSERT INTO m_satuan (nama) VALUES ($1)', [nama], (err, result) => {
        if (err) {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
};

const update_m_satuan = (request, response) => {
    const id = request.params.id;
    const nama = request.body.nama;
    pool.query('UPDATE m_satuan SET nama = $1 WHERE id = $2', [nama, id], (err, result) => {
        if (err) {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json({message: 'Data berhasil diubah'});
    });
};

const delete_m_satuan = (request, response) => {
    const id = request.params.id;

    // cek apakah ada id lain yang terkait di m_satuan
    pool.query('SELECT COUNT(*) FROM m_item WHERE id_satuan = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            return response.status(500).json({ message: 'Internal Server Error' });
        }

        const count = parseInt(result.rows[0].count, 10);
        if (count > 0) {
            return response.status(400).json({ message: 'Tidak dapat menghapus data,\nAda item yang terkait dengan satuan ini' });
        }

        // jika tidak ada item yang terkait, lanjutkan dengan penghapusan
        pool.query('DELETE FROM m_satuan WHERE id = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            response.status(500).json({ message: 'Internal Server Error' });
        } else {
            response.status(200).json({ message: 'Data berhasil dihapus' });
        }
        });
    });
};

//m_jenis_item
const get_m_jenis_item = (request, response) =>{
    pool.query('SELECT * FROM m_jenis_item ORDER BY nama ASC', (err, result) =>{
        if(err)
        {
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
};

const create_m_jenis_item = (request, response) => {
    const kode = request.body.kode
    const nama = request.body.nama;
    pool.query('INSERT INTO m_jenis_item (kode,nama) VALUES ($1,$2)', [kode,nama], (err, result) => {
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
};

const update_m_jenis_item = (request, response) => {
    const id = request.params.id;
    const kode = request.body.kode;
    const nama = request.body.nama;

    // Cek apakah ada item yang menggunakan id_jenis_item ini
    pool.query('SELECT COUNT(*) FROM m_item WHERE id_jenis_item = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            return response.status(500).json({ message: 'Internal Server Error' });
        }

        const count = parseInt(result.rows[0].count, 10);
        if (count > 0) {
            return response.status(400).json({ message: 'Tidak dapat mengubah, ada item yang terkait dengan jenis item ini' });
        }

        // Jika tidak ada item yang terkait, lanjutkan dengan pembaruan
        pool.query('UPDATE m_jenis_item SET kode = $1, nama = $2 WHERE id = $3', [kode, nama, id], (err, result) => {
            if (err) {
                console.log(err.message);
                return response.status(500).json({ message: 'Internal Server Error' });
            }
            response.status(200).json({ message: 'Data berhasil diubah' });
        });
    });
};

const delete_m_jenis_item = (request, response) => {
    const id = request.params.id;

    // Cek apakah ada item yang menggunakan id_jenis_item ini
    pool.query('SELECT COUNT(*) FROM m_item WHERE id_jenis_item = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            return response.status(500).json({ message: 'Internal Server Error' });
        }

        const count = parseInt(result.rows[0].count, 10);
        if (count > 0) {
            return response.status(400).json({ message: 'Tidak dapat menghapus data ,\nAda item yang terkait dengan jenis item ini' });
        }

        // Jika tidak ada item yang terkait, lanjutkan dengan penghapusan
        pool.query('DELETE FROM m_jenis_item WHERE id = $1', [id], (err, result) => {
            if (err) {
                console.log(err.message);
                return response.status(500).json({ message: 'Internal Server Error' });
            }
            response.status(200).json({ message: 'Data berhasil dihapus' });
        });
    });
};

//m_item
const get_all_item = (request, response) => {
    pool.query(pgqueri.get_all_m_item, (err, result) => {
        response.status(200).json(result.rows);
    });
};

const get_item_min5 = (request, response) => {
    pool.query(pgqueri.get_item_min5, (err, result) => {
        response.status(200).json(result.rows);
    });
};



const add_m_item = (request, response) => {
    const kode = request.body.kode;
    const nama = request.body.nama;
    const id_satuan = request.body.id_satuan;
    const id_jenis_item = request.body.id_jenis_item;
    const hpp = request.body.hpp;
    const stok = request.body.stok;
    const modal = request.body.modal;
    pool.query('INSERT INTO m_item (kode, nama, hpp, stok, id_satuan, id_jenis_item, modal) VALUES ($1,$2,$3,$4,$5,$6,$7)', [kode, nama, hpp, stok,id_satuan, id_jenis_item, modal], (err, result) => {
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
}

const update_m_item = (request, response) => {
    const id = request.params.id;
    const kode = request.body.kode;
    const nama = request.body.nama;
    const id_satuan = request.body.id_satuan;
    const id_jenis_item = request.body.id_jenis_item;
    const hpp = request.body.hpp;
    const stok = request.body.stok;
    const modal = request.body.modal
    pool.query('UPDATE m_item SET kode = $1, nama = $2, id_satuan = $3, id_jenis_item = $4, hpp = $5, stok = $6, modal = $7 WHERE id = $8', [kode,nama,id_satuan,id_jenis_item,hpp,stok,modal,id], (err, result) => {
        response.status(200).json({message: 'Data berhasil diubah'});
    });
}

const delete_m_item = (request, response) => {
    const id = request.params.id;
    pool.query('DELETE FROM m_item WHERE id = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            response.status(500).json({ message: 'Internal Server Error' });
        } else {
            response.status(200).json({ message: 'Data berhasil dihapus' });
        }
    });
}

//m_user
const get_m_user = (request, response) => {
    pool.query(pgqueri.get_all_user, (err, result) => {
        response.status(200).json(result.rows);
    });
}

const add_m_user = (request, response) => {
    const pegawai = request.body.pegawai;
    const username = request.body.username;
    const password = request.body.password;
    const id_role = request.body.id_role;
    pool.query('INSERT INTO m_user (pegawai,username,password,id_role) VALUES ($1,$2,$3,$4)', [pegawai,username,password,id_role], (err, result) => {
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
}

const update_m_user = (request, response) => {
    const id = request.params.id;
    const pegawai = request.body.pegawai;
    const username = request.body.username;
    const password = request.body.password;
    const id_role = request.body.id_role;
    pool.query('UPDATE m_user SET pegawai = $1, username = $2, password = $3, id_role = $4 WHERE id = $5', [pegawai,username,password,id_role,id], (err, result) => {
        response.status(200).json({message: 'Data berhasil diubah'});
    });
}

const delete_m_user = (request, response) => {
    const id = request.params.id;
    pool.query('DELETE FROM m_user WHERE id = $1', [id], (err, result) => {
        if (err) {
            console.log(err.message);
            response.status(500).json({ message: 'Internal Server Error' });
        } else {
            response.status(200).json({ message: 'Data berhasil dihapus' });
        }
    });
}

//m_role
const get_m_role = (request, response) => {
    pool.query('SELECT * FROM role ORDER BY id ASC', (err, result) => {
        response.status(200).json(result.rows);
    });
}

const add_m_role = (request, response) => {
    const {kode, nama} = request.body;
    pool.query('INSERT INTO role (kode, nama) VALUES ($1, $2)', [kode, nama], (err, result) => {
        if(err){
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(201).json({message: 'Data berhasil ditambahkan'});
    });
}

//login
const login = (request, response) => {
    const username = request.body.username;
    const password = request.body.password;
    pool.query('SELECT * FROM m_user WHERE username = $1 AND password = $2', [username, password], (err, result) => {
        if (result.rows.length === 1) {
            const user = result.rows[0];
            response.status(200).json({
                status: 'success',
                message: 'Login berhasil',
                data: {
                    user_id: user.id,
                    pegawai: user.pegawai,
                    username: user.username,
                    id_role: user.id_role,
                  },
            });
        }
        else{
            response.status(401).json({
                status: 'error',
                message: 'Username atau password salah',
                data: result.rows[0]
            });
        }
    });
}
// transaksi penjualan
const save_transaksi = async (req, res) => {
    try {
        const { tanggal, id_customer, keterangan, detail } = req.body;

        // Check if detail is defined and is an array
        if (!Array.isArray(detail)) {
            return res.status(400).json({ error: 'Detail transaksi tidak valid' });
        }

        // Langkah 1: Mulai transaksi di dalam database
        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            // Langkah 2: Insert ke tabel t_transaksi untuk mendapatkan id
            const queryTransaksi = `
                INSERT INTO t_transaksi (tanggal, id_customer, keterangan)
                VALUES ($1, $2, $3)
                RETURNING id, no_faktur`;
            
            const valuesTransaksi = [tanggal, id_customer, keterangan];
            const resultTransaksi = await client.query(queryTransaksi, valuesTransaksi);
            const transaksiId = resultTransaksi.rows[0].id;
            let noFaktur = resultTransaksi.rows[0].no_faktur;

            noFaktur = `${transaksiId.toString().padStart(5, '0')}`; // Example format: 00001
            await client.query('UPDATE t_transaksi SET no_faktur = $1 WHERE id = $2', [noFaktur, transaksiId]);

            // Langkah 4: Insert ke tabel t_transaksi_detail dan update stok di m_item
            for (let i = 0; i < detail.length; i++) {
                const { id_barang, qty, harga, modal } = detail[i];
                const subtotal = qty * harga;

                const queryDetail = `
                    INSERT INTO t_transaksi_detail (no_faktur, id_barang, qty, harga, subtotal, modal)
                    VALUES ($1, $2, $3, $4, $5, $6)`;
                const valuesDetail = [noFaktur, id_barang, qty, harga, subtotal, modal];
                await client.query(queryDetail, valuesDetail);

                // Update stok di m_item
                const queryUpdateStok = `
                    UPDATE m_item
                    SET stok = stok - $1
                    WHERE id = $2`;
                const valuesUpdateStok = [qty, id_barang];
                await client.query(queryUpdateStok, valuesUpdateStok);
            }

            // Langkah 5: Commit transaksi
            await client.query('COMMIT');
            res.status(200).json({ message: 'Transaksi berhasil disimpan', no_faktur: noFaktur });
        } catch (error) {
            await client.query('ROLLBACK');
            console.error('Error during transaction:', error); // Log error detail
            throw error;
        } finally {
            client.release();
        }
    } catch (error) {
        console.error('Error saat menyimpan transaksi:', error); // Log error detail
        res.status(500).json({ error: 'Gagal menyimpan transaksi' });
    }
}

// transaksi penerimaan
const trans_receipt = async (req, res) => {
    try {
        const { tanggal, keterangan, detail, id_supplier } = req.body;

        // Check if detail is defined and is an array
        if (!Array.isArray(detail)) {
            return res.status(400).json({ error: 'Detail transaksi tidak valid' });
        }

        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            const queryTransaksi = `
                INSERT INTO t_trans_receipt (tanggal, keterangan, id_supplier)
                VALUES ($1, $2, $3)
                RETURNING id, no_receipt`;
            
            const valuesTransaksi = [tanggal, keterangan, id_supplier];
            const resultTransaksi = await client.query(queryTransaksi, valuesTransaksi);
            const transaksiId = resultTransaksi.rows[0].id;
            let noReceipt = resultTransaksi.rows[0].no_receipt;

            noReceipt = `${transaksiId.toString().padStart(5, '0')}`;
            await client.query('UPDATE t_trans_receipt SET no_receipt = $1 WHERE id = $2', [noReceipt, transaksiId]);

            for (let i = 0; i < detail.length; i++) {
                const { id_item, qty } = detail[i];
                
                const queryDetail = `
                    INSERT INTO t_trans_receipt_detail (id_receipt, id_item, qty)
                    VALUES ($1, $2, $3)`;
                const valuesDetail = [noReceipt, id_item, qty];
                await client.query(queryDetail, valuesDetail);

                // Update stok di m_item
                const queryUpdateStok = `
                    UPDATE m_item
                    SET stok = stok + $1
                    WHERE id = $2`;
                const valuesUpdateStok = [qty, id_item];
                await client.query(queryUpdateStok, valuesUpdateStok);
            }

            await client.query('COMMIT');
            res.status(200).json({ message: 'Transaksi berhasil disimpan',no_receipt: noReceipt });
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    } catch (error) {
        console.error('Error saat menyimpan transaksi:', error);
        res.status(500).json({ error: 'Gagal menyimpan transaksi' });
    }
}

// transaksi retur dari penerimaan
const t_retur_receipt = async (req, res) => {
    try {
        const { tanggal, id_supplier, keterangan, detail } = req.body;

        // cek jika detail ditemukan dan berupa araay
        if (!Array.isArray(detail)) {
            return res.status(400).json({ error: 'Detail retur receipt tidak valid '});

        }

        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            const queryTransaksi = `
                INSERT INTO t_retur_receipt (tanggal, id_supplier, keterangan)
                VALUES ($1, $2, $3)
                RETURNING id, no_retur`;
            
                const valuesTransaksi = [tanggal, id_supplier, keterangan];
                const resultTransaksi = await client.query(queryTransaksi, valuesTransaksi);
                const transaksiId = resultTransaksi.rows[0].id;
                let no_returReceipt = resultTransaksi.rows[0].no_retur;

                no_returReceipt = `${transaksiId.toString().padStart(5, '0')}`; // Example format: 00001
                await client.query('UPDATE t_retur_receipt SET no_retur = $1 WHERE id = $2', [no_returReceipt, transaksiId]);

                for (let i = 0; i< detail.length; i++) {
                    const { id_item,qty } = detail[i];

                    const queryDetail = `
                        INSERT INTO t_retur_receipt_detail (id_retur_receipt, id_item, qty)
                        VALUES ($1, $2, $3)`;
                    
                        const valuesDetail = [no_returReceipt, id_item, qty];
                        await client.query(queryDetail, valuesDetail);

                        const queryUpdateStok = `
                            UPDATE m_item
                            SET stok = stok - $1
                            WHERE id = $2`;
                        const valuesUpdateStok = [qty, id_item];
                        await client.query(queryUpdateStok, valuesUpdateStok);
                }

                await client.query('COMMIT');
                res.status(200).json({ message: 'Transaksi Retur berhasil disimpan', no_retur : no_returReceipt});
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }   catch (error) {
        console.log('Error saat menyimpan transaksi retur:', error);
        res.status(500).json({ error: 'Gagal menyimpan transaksi'})

    }
}

// transaksi retur dari penjualan / customer
const t_retur_sales = async (req, res) => {
    try {
        const { tanggal, id_customer, keterangan, detail } = req.body;

        // cek jika detail ditemukan dan berupa araay
        if (!Array.isArray(detail)) {
            return res.status(400).json({ error: 'Detail retur sales tidak valid '});

        }

        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            const queryTransaksi = `
                INSERT INTO t_retur_sales (tanggal, id_customer, keterangan)
                VALUES ($1, $2, $3)
                RETURNING id, no_retur`;
            
                const valuesTransaksi = [tanggal, id_customer, keterangan];
                const resultTransaksi = await client.query(queryTransaksi, valuesTransaksi);
                const transaksiId = resultTransaksi.rows[0].id;
                let no_returSales = resultTransaksi.rows[0].no_retur;

                no_returSales = `${transaksiId.toString().padStart(5, '0')}`; // Example format: 00001
                await client.query('UPDATE t_retur_sales SET no_retur = $1 WHERE id = $2', [no_returSales, transaksiId]);

                for (let i = 0; i< detail.length; i++) {
                    const { id_item,qty } = detail[i];

                    const queryDetail = `
                        INSERT INTO t_retur_sales_detail (id_retur_sales, id_item, qty)
                        VALUES ($1, $2, $3)`;
                    
                        const valuesDetail = [no_returSales, id_item, qty];
                        await client.query(queryDetail, valuesDetail);

                        const queryUpdateStok = `
                            UPDATE m_item
                            SET stok = stok + $1
                            WHERE id = $2`;
                        const valuesUpdateStok = [qty, id_item];
                        await client.query(queryUpdateStok, valuesUpdateStok);
                }

                await client.query('COMMIT');
                res.status(200).json({ message: 'Transaksi Retur berhasil disimpan', no_retur : no_returSales});
        } catch (error) {
            await client.query('ROLLBACK');
            throw error;
        } finally {
            client.release();
        }
    }   catch (error) {
        console.log('Error saat menyimpan transaksi retur:', error);
        res.status(500).json({ error: 'Gagal menyimpan transaksi'})

    }
}

// report 
const get_report_transaksi = (request, response) => {
    pool.query(pgqueri.get_report_transaksi, (err, result) => {
        if(err){
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
};

const get_report_trans_receipt = (request, response) => {
    pool.query(pgqueri.get_report_trans_receipt, (err, result) => {
        if(err){
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
};

const get_report_returSupplier = (request, response) => {
    pool.query(pgqueri.get_report_returSuppllier, (err, result) => {
        if(err){
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
};

const get_report_returCustomer = (request, response) => {
    pool.query(pgqueri.get_report_returCustomer, (err, result) => {
        if(err){
            console.log(err);
            response.status(500).json({message: 'Internal Server Error'});
        }
        response.status(200).json(result.rows);
    });
};
module.exports = {
    get_m_customer,
    add_m_customer,
    update_m_customer,
    delete_m_customer,
    get_m_supplier,
    add_m_supplier,
    update_m_supplier,
    delete_m_supplier,
    get_m_satuan,
    create_m_satuan,
    update_m_satuan,
    delete_m_satuan,
    get_m_jenis_item,
    create_m_jenis_item,
    update_m_jenis_item,
    delete_m_jenis_item,
    get_all_item,
    add_m_item,
    update_m_item,
    delete_m_item,
    get_m_user,
    add_m_user,
    update_m_user,
    delete_m_user,
    get_m_role,
    add_m_role,
    login,
    save_transaksi,
    trans_receipt,
    t_retur_receipt,
    t_retur_sales,
    get_report_transaksi,
    get_report_trans_receipt,
    get_report_returSupplier,
    get_report_returCustomer,
    get_item_min5
};