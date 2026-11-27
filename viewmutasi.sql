CREATE OR REPLACE VIEW v_stock_movement AS
WITH mutasi AS (
  -- 1. Barang masuk dari supplier (receipt)
  SELECT
    d.id_item,
    h.tanggal::timestamp AS tgl_transaksi,
    h.no_receipt::varchar AS no_dokumen,
    'RECEIPT'::varchar(20) AS jenis_mutasi,
    COALESCE(d.qty, 0)::integer AS qty_masuk,
    0::integer AS qty_keluar,
    d.id AS ref_id
  FROM t_trans_receipt_detail d
  JOIN t_trans_receipt h ON h.id = d.id_receipt

  UNION ALL

  -- 2. Barang masuk dari retur customer
  SELECT
    d.id_item,
    h.tanggal::timestamp AS tgl_transaksi,
    h.no_retur::varchar AS no_dokumen,
    'RETUR_SALES'::varchar(20) AS jenis_mutasi,
    COALESCE(d.qty, 0)::integer AS qty_masuk,
    0::integer AS qty_keluar,
    d.id AS ref_id
  FROM t_retur_sales_detail d
  JOIN t_retur_sales h ON h.id = d.id_retur_sales

  UNION ALL

  -- 3. Barang keluar / penjualan
  SELECT
    d.id_barang AS id_item,
    h.tanggal::timestamp AS tgl_transaksi,
    COALESCE(h.no_faktur::varchar, d.no_faktur::varchar) AS no_dokumen,
    'SALES'::varchar(20) AS jenis_mutasi,
    0::integer AS qty_masuk,
    COALESCE(d.qty, 0)::integer AS qty_keluar,
    d.id AS ref_id
  FROM t_transaksi_detail d
  JOIN t_transaksi h ON h.no_faktur::varchar = d.no_faktur::varchar

  UNION ALL

  -- 4. Barang keluar / retur ke supplier
  SELECT
    d.id_item,
    h.tanggal::timestamp AS tgl_transaksi,
    h.no_retur::varchar AS no_dokumen,
    'RETUR_RECEIPT'::varchar(20) AS jenis_mutasi,
    0::integer AS qty_masuk,
    COALESCE(d.qty, 0)::integer AS qty_keluar,
    d.id AS ref_id
  FROM t_retur_receipt_detail d
  JOIN t_retur_receipt h ON h.id = d.id_retur_receipt
),
hitung_saldo AS (
  SELECT
    m.*,
    (m.qty_masuk - m.qty_keluar) AS delta_qty,
    SUM(m.qty_masuk - m.qty_keluar) OVER (
      PARTITION BY m.id_item
      ORDER BY m.tgl_transaksi ASC, m.ref_id ASC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS kumulatif_mutasi,
    SUM(m.qty_masuk - m.qty_keluar) OVER (
      PARTITION BY m.id_item
    ) AS total_mutasi_item
  FROM mutasi m
)
SELECT
  hs.id_item,
  i.kode AS kode_item,
  i.nama AS nama_item,
  s.nama AS satuan_nama,
  hs.tgl_transaksi,
  hs.no_dokumen,
  hs.jenis_mutasi,
  hs.qty_masuk,
  hs.qty_keluar,
  (COALESCE(i.stok, 0) - hs.total_mutasi_item + hs.kumulatif_mutasi) AS sisa_stok,
  COALESCE(i.stok, 0) AS stok_akhir_item
FROM hitung_saldo hs
JOIN m_item i ON i.id = hs.id_item
LEFT JOIN m_satuan s ON s.id = i.id_satuan;