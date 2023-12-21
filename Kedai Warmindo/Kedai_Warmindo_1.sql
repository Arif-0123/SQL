-- # menggunakan data set ngulik-sql-basic-dataset.csv

select * from `nguliksql.transaksi_warmindo`
where jenis_kelamin = 'M';

select * from `nguliksql.transaksi_warmindo`
where total_pembayaran > 10000 AND jenis_produk = 'mie-kuah';

select * from `nguliksql.transaksi_warmindo`
where jenis_pembayaran in ('QRIS-DANA','QRIS-OVO','QRIS-SHOPEEPAY');

select * from `nguliksql.transaksi_warmindo`
where tanggal_transaksi between '2022-02-01' and '2022-02-28';

select * from `nguliksql.transaksi_warmindo`
where jenis_pembayaran = 'CASH' OR jenis_pembayaran = 'QRIS-DANA';

select 
  tanggal_transaksi,
  sum(total_pembayaran) jumlah_pembayaran,
  max(total_pembayaran) max_pembayaran,
  round(avg(total_pembayaran),0) rata_pembayaran
from `nguliksql.transaksi_warmindo`
group by tanggal_transaksi
order by tanggal_transaksi asc;


-- 

select * from `nguliksql.transaksi_warmindo`

-- 1. Bagaimana trend penjualan dari bulan ke bulan untuk makanan saja?
select 
  date_trunc(tanggal_transaksi, month) as bulan,
  sum(total_penjualan) as total_penjualan
from `nguliksql.transaksi_warmindo`
where kategori_produk = 'makanan'
group by bulan
order by bulan asc;


-- 2. Metode makan mana yang paling sering di gunakan? 
select 
  jenis_pesanan,
  count(distinct invoice_id) as jumlah_transaksi
from `nguliksql.transaksi_warmindo`
group by jenis_pesanan;



-- 3. Siapa saja pelanggan warmindo yang paling loyal?
select  
  customer_id,
  nama_pelanggan,
  count(distinct invoice_id) jumlah_transaksi,
  sum(total_pembayaran) jumlah_pembayaran
from `nguliksql.transaksi_warmindo`
group by nama_pelanggan,customer_id
order by jumlah_transaksi desc
limit 10;

-- 4. Apa lima menu makanan yang paling banyak di beli oleh pelanggan yang berusia < 30 tahun?
select 
  nama_produk,
  sum(quantity) jumlah_pembelian
from `nguliksql.transaksi_warmindo`
where umur_pelanggan < 30 And kategori_produk='makanan'
group by nama_produk
order by jumlah_pembelian desc
limit 5;

-- 5. Apa lima produk yang paling banyak dibeli oleh pelanggan laki-laki di bawah 30 tahun atau pelanggan perempuan di bawah 25 tahun?
select 
  nama_produk,
  sum(quantity) jumlah_pembelian
from `nguliksql.transaksi_warmindo`
where (umur_pelanggan < 30 And jenis_kelamin='M') OR (umur_pelanggan < 25 And jenis_kelamin='F') AND  kategori_produk='makanan'
group by nama_produk
order by jumlah_pembelian desc
limit 5;

'''
Berdasarkan hasil analisa data yang kamu lakukan ada beberapa key point yang dapat di simpulkan, diantaranya:

- Trend penjualan dari bulan ke bulan cenderung `stabil`, dapat diketahui bahwa penjualan tertinggi terjadi di bulan juli dengan pemasukan sebesar `4.57 juta rupiah`.
- Sebagian besar transaksi terjadi di delivery di bandingkan menggunakan dine-in.
- Pelanggan paling loyal di warmindo adalah Dewi Susanti dengan `101 total transaksi` dan jumlah pembayaran `698 ribu` kita bisa memberikan program loyalti khusus ke mereka untuk menarik perhatian pelanggan lain agar bisa menjadi pelanggan loyal juga
- Ketika kita ingin membuat promo untuk anak muda di bawah 30 tahun, kita perlu memprioritaskan produk `Indomie Soto Mie` karena menjadi produk paling favorit dengan total pembelian sebanyak `95 kali`
- Produk makanan favorit untuk pelanggan laki-laki di bawah 30 tahun atau pelanggan perempuan di bawah 25 tahun adalah `Indomie Ayam Bawang`.
'''

  

