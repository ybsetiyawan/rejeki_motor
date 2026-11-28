const get_all_user = `
    SELECT 
        i.id AS user_id,
        i.pegawai,
        i.username,
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
	mj.nama AS jenis_item,
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
	JOIN m_jenis_item mj ON mi.id_jenis_item = mj.id
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
const get_riwayat_keluar_item = `
    SELECT
        td.id,
        t.id AS transaksi_id,
        t.no_faktur,
        t.tanggal,
        td.qty,
        COALESCE(td.harga, 0)::numeric(12,2) AS harga_jual,
        COALESCE(td.modal, i.modal, i.hpp, 0)::numeric(12,2) AS modal,
        (
            (COALESCE(td.harga, 0) - COALESCE(td.modal, i.modal, i.hpp, 0)) * COALESCE(td.qty, 0)
        )::numeric(12,2) AS laba
    FROM t_transaksi_detail td
    JOIN t_transaksi t ON td.no_faktur = CAST(t.no_faktur AS INTEGER)
    JOIN m_item i ON td.id_barang = i.id
    WHERE td.id_barang = $1
    ORDER BY t.tanggal DESC, td.id DESC;
`;

const get_riwayat_masuk_item = `
    WITH mutasi AS (
        SELECT
            'MASUK' AS tipe,
            trd.id AS detail_id,
            tr.id AS ref_id,
            tr.tanggal,
            trd.qty::bigint AS delta_qty
        FROM t_trans_receipt_detail trd
        JOIN t_trans_receipt tr ON trd.id_receipt = CAST(tr.no_receipt AS INTEGER)
        WHERE trd.id_item = $1

        UNION ALL

        SELECT
            'KELUAR' AS tipe,
            td.id AS detail_id,
            t.id AS ref_id,
            t.tanggal,
            (-td.qty)::bigint AS delta_qty
        FROM t_transaksi_detail td
        JOIN t_transaksi t ON td.no_faktur = CAST(t.no_faktur AS INTEGER)
        WHERE td.id_barang = $1

        UNION ALL

        SELECT
            'RETUR_SUPPLIER' AS tipe,
            rrd.id AS detail_id,
            rr.id AS ref_id,
            rr.tanggal,
            (-rrd.qty)::bigint AS delta_qty
        FROM t_retur_receipt_detail rrd
        JOIN t_retur_receipt rr ON rrd.id_retur_receipt = CAST(rr.no_retur AS INTEGER)
        WHERE rrd.id_item = $1

        UNION ALL

        SELECT
            'RETUR_CUSTOMER' AS tipe,
            rsd.id AS detail_id,
            rs.id AS ref_id,
            rs.tanggal,
            rsd.qty::bigint AS delta_qty
        FROM t_retur_sales_detail rsd
        JOIN t_retur_sales rs ON rsd.id_retur_sales = CAST(rs.no_retur AS INTEGER)
        WHERE rsd.id_item = $1
    ),
    mutasi_running AS (
        SELECT
            tipe,
            detail_id,
            ref_id,
            tanggal,
            delta_qty,
            SUM(delta_qty) OVER (
                ORDER BY tanggal ASC,
                CASE tipe
                    WHEN 'MASUK' THEN 1
                    WHEN 'RETUR_CUSTOMER' THEN 2
                    WHEN 'RETUR_SUPPLIER' THEN 3
                    WHEN 'KELUAR' THEN 4
                END ASC,
                detail_id ASC
            ) AS sisa_setelah_transaksi
        FROM mutasi
    )
    SELECT
        trd.id,
        tr.id AS receipt_id,
        tr.no_receipt,
        tr.tanggal,
        COALESCE(s.nama, '-') AS supplier,
        trd.qty,
        COALESCE(i.modal, i.hpp, 0)::numeric(12,2) AS modal,
        COALESCE(i.stok, 0) AS sisa_barang,
        COALESCE(mr.sisa_setelah_transaksi, i.stok, 0) AS sisa_setelah_transaksi
    FROM t_trans_receipt_detail trd
    JOIN t_trans_receipt tr ON trd.id_receipt = CAST(tr.no_receipt AS INTEGER)
    JOIN m_item i ON trd.id_item = i.id
    LEFT JOIN m_supplier s ON tr.id_supplier = s.id
    LEFT JOIN mutasi_running mr
        ON mr.tipe = 'MASUK' AND mr.detail_id = trd.id
    WHERE trd.id_item = $1
    ORDER BY tr.tanggal DESC, trd.id DESC;
`;

const get_stock_movement_base = `
    WITH mutasi AS (
        -- 1. Penerimaan barang (Masuk +)
        SELECT
            trd.id_item,
            tr.tanggal::timestamp AS tgl_transaksi,
            tr.no_receipt::varchar AS no_dokumen,
            'RECEIPT'::varchar(20) AS jenis_mutasi,
            COALESCE(trd.qty, 0)::bigint AS qty_masuk,
            0::bigint AS qty_keluar,
            trd.id AS detail_id,
            1 AS prioritas_jenis
        FROM t_trans_receipt_detail trd
        JOIN t_trans_receipt tr ON trd.id_receipt = CAST(tr.no_receipt AS INTEGER)

        UNION ALL

        -- 2. Retur customer (Masuk +)
        SELECT
            rsd.id_item,
            rs.tanggal::timestamp AS tgl_transaksi,
            rs.no_retur::varchar AS no_dokumen,
            'RETUR_SALES'::varchar(20) AS jenis_mutasi,
            COALESCE(rsd.qty, 0)::bigint AS qty_masuk,
            0::bigint AS qty_keluar,
            rsd.id AS detail_id,
            2 AS prioritas_jenis
        FROM t_retur_sales_detail rsd
        JOIN t_retur_sales rs ON rsd.id_retur_sales = CAST(rs.no_retur AS INTEGER)

        UNION ALL

        -- 3. Retur supplier (Keluar -)
        SELECT
            rrd.id_item,
            rr.tanggal::timestamp AS tgl_transaksi,
            rr.no_retur::varchar AS no_dokumen,
            'RETUR_RECEIPT'::varchar(20) AS jenis_mutasi,
            0::bigint AS qty_masuk,
            COALESCE(rrd.qty, 0)::bigint AS qty_keluar,
            rrd.id AS detail_id,
            3 AS prioritas_jenis
        FROM t_retur_receipt_detail rrd
        JOIN t_retur_receipt rr ON rrd.id_retur_receipt = CAST(rr.no_retur AS INTEGER)

        UNION ALL

        -- 4. Penjualan (Keluar -)
        SELECT
            td.id_barang AS id_item,
            t.tanggal::timestamp AS tgl_transaksi,
            t.no_faktur::varchar AS no_dokumen,
            'SALES'::varchar(20) AS jenis_mutasi,
            0::bigint AS qty_masuk,
            COALESCE(td.qty, 0)::bigint AS qty_keluar,
            td.id AS detail_id,
            4 AS prioritas_jenis
        FROM t_transaksi_detail td
        JOIN t_transaksi t ON td.no_faktur = CAST(t.no_faktur AS INTEGER)
    ),
    mutasi_terurut AS (
        SELECT
            m.*,
            (m.qty_masuk - m.qty_keluar)::bigint AS delta_qty,
            SUM(m.qty_masuk - m.qty_keluar) OVER (
                PARTITION BY m.id_item
                ORDER BY m.tgl_transaksi ASC, m.prioritas_jenis ASC, m.detail_id ASC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )::bigint AS kumulatif_mutasi,
            SUM(m.qty_masuk - m.qty_keluar) OVER (
                PARTITION BY m.id_item
            )::bigint AS total_mutasi_item
        FROM mutasi m
    )
    SELECT
        mt.id_item,
        i.kode AS kode_item,
        i.nama AS nama_item,
        s.nama AS satuan_nama,
        mt.tgl_transaksi,
        mt.no_dokumen,
        mt.jenis_mutasi,
        mt.qty_masuk,
        mt.qty_keluar,
        mt.prioritas_jenis,
        mt.detail_id,
        (COALESCE(i.stok, 0)::bigint - mt.total_mutasi_item + mt.kumulatif_mutasi)::bigint AS sisa_stok,
        COALESCE(i.stok, 0)::bigint AS stok_akhir_item
    FROM mutasi_terurut mt
    JOIN m_item i ON i.id = mt.id_item
    LEFT JOIN m_satuan s ON s.id = i.id_satuan
`;

const get_stock_movement = `
    SELECT *
    FROM (${get_stock_movement_base}) sm
    WHERE ($1::integer IS NULL OR sm.id_item = $1)
      AND ($2::varchar IS NULL OR $2 = '' OR $2 = 'ALL' OR sm.jenis_mutasi = $2)
      AND ($3::timestamp IS NULL OR sm.tgl_transaksi >= $3)
      AND ($4::timestamp IS NULL OR sm.tgl_transaksi <= $4)
    ORDER BY sm.tgl_transaksi ASC, sm.prioritas_jenis ASC, sm.detail_id ASC
`;

const get_stock_movement_paged = `
    WITH filtered AS (
        SELECT *
        FROM (${get_stock_movement_base}) sm
        WHERE ($1::integer IS NULL OR sm.id_item = $1)
          AND ($2::varchar IS NULL OR $2 = '' OR $2 = 'ALL' OR sm.jenis_mutasi = $2)
          AND ($3::timestamp IS NULL OR sm.tgl_transaksi >= $3)
          AND ($4::timestamp IS NULL OR sm.tgl_transaksi <= $4)
          AND (
              $7::varchar IS NULL OR $7 = '' OR
              sm.no_dokumen ILIKE ('%' || $7 || '%') OR
              sm.kode_item ILIKE ('%' || $7 || '%') OR
              sm.nama_item ILIKE ('%' || $7 || '%') OR
              sm.jenis_mutasi ILIKE ('%' || $7 || '%')
          )
    )
    SELECT
        f.*,
        COUNT(*) OVER()::integer AS total_rows
    FROM filtered f
    ORDER BY f.tgl_transaksi ASC, f.prioritas_jenis ASC, f.detail_id ASC
    LIMIT $5 OFFSET $6
`;

const get_stock_movement_summary = `
    SELECT
        COALESCE(SUM(sm.qty_masuk), 0)::bigint AS total_masuk,
        COALESCE(SUM(sm.qty_keluar), 0)::bigint AS total_keluar
    FROM (${get_stock_movement_base}) sm
    WHERE ($1::integer IS NULL OR sm.id_item = $1)
      AND ($2::varchar IS NULL OR $2 = '' OR $2 = 'ALL' OR sm.jenis_mutasi = $2)
      AND ($3::timestamp IS NULL OR sm.tgl_transaksi >= $3)
      AND ($4::timestamp IS NULL OR sm.tgl_transaksi <= $4)
      AND (
          $5::varchar IS NULL OR $5 = '' OR
          sm.no_dokumen ILIKE ('%' || $5 || '%') OR
          sm.kode_item ILIKE ('%' || $5 || '%') OR
          sm.nama_item ILIKE ('%' || $5 || '%') OR
          sm.jenis_mutasi ILIKE ('%' || $5 || '%')
      )
`;


module.exports = {
    // get_all_m_item,
    get_all_user,
    get_report_transaksi,
    get_report_trans_receipt,
    get_report_returSuppllier,
    get_report_returCustomer,
    get_item_min5,
    get_riwayat_keluar_item,
    get_riwayat_masuk_item,
    get_stock_movement,
    get_stock_movement_base,
    get_stock_movement_paged,
    get_stock_movement_summary
};