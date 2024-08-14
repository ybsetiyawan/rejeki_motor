const get_all_m_item = `
    SELECT 
        i.id AS item_id,
        i.kode,
        i.nama,
        i.modal,
        i.hpp,
        i.stok,
        s.nama AS satuan_nama,
        j.nama AS jenis_item_nama,
        j.kode AS jenis_item_kode
    FROM 
        m_item i
    JOIN 
        m_satuan s ON i.id_satuan = s.id
    JOIN 
        m_jenis_item j ON i.id_jenis_item = j.id
    ORDER BY 
        i.nama ASC
`;

const get_all_user = `
    SELECT 
        i.id AS user_id,
        i.pegawai,
        i.username,
        i.password,
        s.id AS id_role,
        s.nama AS role_nama
    FROM 
        m_user i
    JOIN 
        role s ON i.id_role = s.id;
`;

const get_report_transaksi = `
    SELECT 
    t.no_faktur AS nomor_faktur,
    t.tanggal AS tanggal,
    mc.kode AS kode_customer,
    mc.nama AS nama_customer,
    mi.kode AS kode_item,
    mi.nama AS nama_item,
    td.qty AS qty_item,
    ms.nama AS uom,
    td.harga AS hpp,
    td.modal AS modal,
    td.subtotal AS total
    FROM 
    t_transaksi t
    JOIN 
    t_transaksi_detail td ON t.id = td.no_faktur
    JOIN 
    m_customer mc ON t.id_customer = mc.id
    JOIN 
    m_item mi ON td.id_barang = mi.id
    JOIN 
    m_satuan ms ON mi.id_satuan = ms.id
    ORDER BY 
    t.tanggal DESC;
`;

const get_report_trans_receipt = `
    SELECT
    tr.no_receipt AS no_receipt,
    tr.tanggal AS tanggal,
    ms.kode AS kode_supplier,
    ms.nama AS nama_supplier,
    mi.kode AS kode_item,
    mi.nama AS nama_item,
    trd.qty AS qty_item,
    msatuan.nama AS uom
    FROM
    t_trans_receipt tr
    JOIN
    t_trans_receipt_detail trd ON tr.id = trd.id_receipt
    JOIN
    m_supplier ms ON tr.id_supplier = ms.id
    JOIN
    m_item mi ON trd.id_item = mi.id
    JOIN
    m_satuan msatuan ON mi.id_satuan = msatuan.id
    ORDER BY
    tr.tanggal DESC;
`;

const get_report_returSuppllier = `
SELECT
    tr.no_retur AS no_retur,
    tr.tanggal AS tanggal,
    ms.kode AS kode_supplier,
    ms.nama AS nama_supplier,
    mi.kode AS kode_item,
    mi.nama AS nama_item,
    trd.qty AS qty_item,
    msatuan.nama AS uom
    FROM
    t_retur_receipt tr
    JOIN
    t_retur_receipt_detail trd ON tr.id = trd.id_retur_receipt
    JOIN
    m_supplier ms ON tr.id_supplier = ms.id
    JOIN
    m_item mi ON trd.id_item = mi.id
    JOIN
    m_satuan msatuan ON mi.id_satuan = msatuan.id
    ORDER BY
    tr.tanggal DESC;
    `;

const get_report_returCustomer = `
SELECT
    tr.no_retur AS no_retur,
    tr.tanggal AS tanggal,
    ms.kode AS kode_customer,
    ms.nama AS nama_customer,
    mi.kode AS kode_item,
    mi.nama AS nama_item,
    trd.qty AS qty_item,
    msatuan.nama AS uom
    FROM
    t_retur_sales tr
    JOIN
    t_retur_sales_detail trd ON tr.id = trd.id_retur_sales
    JOIN
    m_customer ms ON tr.id_customer = ms.id
    JOIN
    m_item mi ON trd.id_item = mi.id
    JOIN
    m_satuan msatuan ON mi.id_satuan = msatuan.id
    ORDER BY
    tr.tanggal DESC;
    `;

const inout_item = `
    -- Tampilkan aliran masuk barang
    SELECT 
        r.tanggal,
        d.id_item AS id_barang,
        i.nama,
        d.qty AS qty_masuk,
        0 AS qty_keluar,
        'Penerimaan' AS jenis_transaksi
    FROM t_trans_receipt_detail d
    JOIN t_trans_receipt r ON d.id_receipt = r.id
    JOIN m_item i ON d.id_item = i.id

    UNION ALL

    -- Tampilkan aliran keluar barang
    SELECT 
        t.tanggal,
        d.id_barang,
        i.nama,
        0 AS qty_masuk,
        d.qty AS qty_keluar,
        'Penjualan' AS jenis_transaksi
    FROM t_transaksi_detail d
    JOIN t_transaksi t ON d.no_faktur = t.id
    JOIN m_item i ON d.id_barang = i.id

    ORDER BY tanggal, id_barang;

`;

const get_item_min5 = `
    SELECT 
    i.id AS item_id,
    i.kode,
    i.nama,
    i.stok,
    s.nama AS satuan_nama,
    j.nama AS jenis_item_nama,
    j.kode AS jenis_item_kode
    FROM 
        m_item i
    JOIN 
        m_satuan s ON i.id_satuan = s.id
    JOIN 
        m_jenis_item j ON i.id_jenis_item = j.id
    WHERE
        i.stok <= 5
    ORDER BY 
        i.stok DESC
`;


module.exports = {
    get_all_m_item,
    get_all_user,
    get_report_transaksi,
    get_report_trans_receipt,
    get_report_returSuppllier,
    get_report_returCustomer,
    get_item_min5
};