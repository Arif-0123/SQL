-- #data set kurir,menu,pelanggan,pembayaran,transaksi_2021,transaksi_2022
select * from `nguliksql.kurir`;

select * from `nguliksql.menu`;

select * from `nguliksql.pelanggan`;

select * from `nguliksql.pembayaran`;

select * from `nguliksql.transaksi_2021`;

select * from `nguliksql.transaksi_2022`;


-- 1. Mengambil informasi transaksi tahun 2021 yang berisi id, invoice_id, quantity, tanggal, nama produk, dan harga jual. (INNER JOIN)
select 
  t21.id,
  t21.invoice_id,
  t21.quantity,
  t21.tanggal_transaksi,
  m.nama as nama_produk,
  m.harga_jual,
  p.nama_depan as nama_pelanggan
from `nguliksql.transaksi_2021` as t21
inner join `nguliksql.menu` as m
  on t21.produk_id=m.id
inner join `nguliksql.pelanggan` as p
  on t21.customer_id=p.id;



-- 2. Menampilkan semua pelanggan dan transaksinya di 2021 jika ada, dengan menampilkan nama depan pembeli, umur, transaksi id, invoice_id, tanggal transaksi (LEFT JOIN)
select 
  p.nama_depan,
  p.umur,
  p.id,
  t21.invoice_id,
  t21.tanggal_transaksi
from `nguliksql.pelanggan` as p
left join `nguliksql.transaksi_2021` as t21
  on p.id=t21.customer_id



-- 3. Menampilkan semua jenis kurir dan pesanan di tahun 2022 jika ada, tampilkan nama kurir, tanggal transaksi, transaksi id, invoice id dan quantity (RIGHT JOIN)
select
  k.kurir,
  t22.tanggal_transaksi,
  t22.id,
  t22.invoice_id,
  t22.quantity
from `nguliksql.transaksi_2022` as t22
right join `nguliksql.kurir` as k 
  on t22.kurir_id=k.id;



-- 4. Menampilkan semua jenis kurir dan pesanan di tahun 2022 jika ada, tampilkan nama kurir, tanggal transaksi, transaksi id, invoice id dan quantity. 
--    Selain itu tampilkan juga semua transaksi yang tidak menggunakan kurir (FULL OUTER JOIN)
select
  k.kurir,
  t2.tanggal_transaksi,
  t2.id,
  t2.invoice_id,
  t2.quantity
from `nguliksql.transaksi_2022` as t2 
full outer join  `nguliksql.kurir` as k 
  on t2.kurir_id=k.id;



-- 5. Tampilkan semua data transaksi di tahun 2021 dan 2022
select * from `nguliksql.transaksi_2021`
union all
select *from `nguliksql.transaksi_2022`

-- cte (buat tabel shadow)
with all_trasactions as(
  select *
  from `nguliksql.transaksi_2021`
  union all
  select *
  from `nguliksql.transaksi_2022`
)

select 
  date_trunc(tanggal_transaksi, month) as bulan,
  kurir as nama_kurir,
  count(distinct invoice_id) as transaksi
from `nguliksql.kurir` as k
left join all_trasactions as t
  on k.id=t.kurir_id
group by bulan,kurir
order by bulan,transaksi desc



------------------------------------------

-- -- 1. Trend penjualan
-- Selanjutnya, manajemen ingin mengidentifikasi tren jumlah penjualan (qty) bulanan di tahun 2021 dan 2022. Analisis ini akan membantu mereka memahami pola penjualan dan mengantisipasi permintaan di masa mendatang.

-- Tampilkan datanya dengan format tahun, bulan, dan jumlah penjualan
select 
  extract(YEAR from tanggal_transaksi) as tahun,
  extract(MONTH FROM tanggal_transaksi) as bulan,
  sum(quantity) AS total_penjualan
from `nguliksql.transaksi_2021`
group by bulan,tahun

UNION ALL

select 
  extract(YEAR from tanggal_transaksi) as tahun,
  extract(MONTH FROM tanggal_transaksi) as bulan,
  sum(quantity) AS total_penjualan
from `nguliksql.transaksi_2022`
group by bulan,tahun


-- -- 2. Produk paling banyak terjual
-- Pertama, manajemen ingin mengetahui 5 produk terlaris di tahun 2022. Buat analisis untuk menampilkan 5 produk tersebut beserta total penjualannya. Hasil analisis ini akan membantu manajemen untuk mempertahankan atau bahkan meningkatkan strategi pemasaran untuk produk-produk tersebut.

-- Tampilkan nama produk dan jumlah penjualan (quantity) dari masing masing produk dan urutkan

SELECT 
  m.nama as nama_produk,
  sum(quantity) as jumlah_penjualan
FROM `nguliksql.transaksi_2022` as t22
inner join `nguliksql.menu` as m
  on t22.produk_id = m.id
group by m.nama
order by jumlah_penjualan desc
limit 5

-- 3. Metode pembayaran paling populer
-- Manajemen juga tertarik untuk mengevaluasi metode pembayaran yang paling populer di kalangan pelanggan pada tahun 2022. Dengan informasi ini, mereka dapat menawarkan promosi khusus atau mengoptimalkan proses pembayaran yang ada.

-- Tampilkan datanya dalam bentuk tipe dan jenis pembayaran dan jumlah transaksi.

select  
  p.tipe_pembayaran,
  p.jenis_pembayaran,
  count(invoice_id) as jumlah_transaksi
from `nguliksql.transaksi_2022` as t
inner join `nguliksql.pembayaran` as p
  on t.payment_id=p.id
group by p.tipe_pembayaran,p.jenis_pembayaran
order by jumlah_transaksi desc


-- 4. Performa restoran berdasarkan hari dalam seminggu
-- Manajemen ingin mengetahui bagaimana performa restoran pada hari-hari tertentu dalam seminggu. Analisis ini akan membantu mereka memutuskan apakah perlu menyesuaikan jam operasional atau membuat promosi khusus pada hari-hari tertentu.

SELECT
  EXTRACT(DAYOFWEEK FROM tanggal_transaksi) as hari,
  SUM(quantity*harga_jual) as total_pemasukan
FROM `nguliksql.transaksi_2022` as trx_22
LEFT JOIN `nguliksql.menu` as menu
  ON trx_22.produk_id = menu.id
GROUP BY hari
ORDER BY hari;


-- 5. Pelanggan dengan transaksi terbanyak
-- Manajemen ingin mengetahui siapa pelanggan terbaik berdasarkan jumlah transaksi yang pernah dilakukan dan juga pemasukan terbanyak di tahun 2021 dan 2022.

-- Tampilkan dalam format nama yang merupakan gabungan dari nama depan dan nama belakang, jumlah transaksi, dan total pembayaran.

SELECT
  CONCAT(nama_depan,' ',nama_belakang) as nama_pelanggan, --nama_depan||' '||nama_belakang
  COUNT(DISTINCT invoice_id) as jumlah_transaksi,
  SUM(quantity*harga_jual) as total_pembayaran
FROM 
  (
    SELECT *
    FROM `nguliksql.transaksi_2021`
    
    UNION ALL

    SELECT *
    FROM `nguliksql.transaksi_2022`
  ) as trx
INNER JOIN `nguliksql.pelanggan` as pelanggan
  ON trx.customer_id = pelanggan.id
LEFT JOIN `nguliksql.menu` as menu
  ON trx.produk_id = menu.id
GROUP BY nama_pelanggan
ORDER BY jumlah_transaksi DESC
LIMIT 10
;




