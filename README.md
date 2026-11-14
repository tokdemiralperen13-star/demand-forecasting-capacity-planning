# Production Demand Forecasting & Capacity Planning

Perakende satış verisiyle talep tahmini ve kısıtlı kapasite altında kaynak optimizasyonunu birleştiren uçtan uca bir proje.

## Problem
Bir perakende zincirinde, gelecek talebi doğru tahmin etmek tek başına yeterli değildir. üretim/depo kapasitesi kısıtlıysa, bu kapasiteyi ürünler arasında **nasıl adil dağıtacağını** da bilmek gerekir. Bu proje, ikisini birlikte ele almaktadır.

## Yöntem
1. **Talep Tahmini** — XGBoost ile, lag/rolling-mean özellikleri ve takvim bilgileriyle (10 mağaza × 50 ürün, 5 yıllık günlük satış)
2. **Kapasite Darboğazı Tespiti** — tahmini talep, sentetik üretim kapasitesiyle karşılaştırılıp aşım noktaları belirleniyor
3. **Kaynak Optimizasyonu** — PuLP ile doğrusal programlama. Önce tek bir örnek senaryoda (Mağaza 8, 2017-11-05) kısıtsız ve %70 minimum servis kısıtlı modeller karşılaştırıldı, sonra adil dağıtım modeli tüm mağaza-günler için (10 mağaza × 92 gün = 920 problem) çalıştırıldı
4. **SQL ile Sorgulama** — Sonuçlar SQLite veritabanına (`capacity_plan.db`) yazılıp SQL ile analiz edildi; sorgular `queries.sql` dosyasında

## Bulgular
- Model performansı: **MAE 6.10** (ortalama günlük satış ~60 civarı)
- Kapasite darboğazlarının tamamı **Pazar günlerine** denk geliyor — haftalık talep döngüsüyle doğrudan ilişkili
- Kısıtsız optimizasyon, açığı birkaç ürüne yükleyip onları tamamen stoksuz bırakıyor; %70 minimum servis kısıtı eklenince açık tüm ürünlere makul şekilde dağılıyor — gerçek kapasite planlamasında klasik bir trade-off
- Kapasite kısıtında kesintiye uğrayan ürünlerin ortalama talebi (~110), uğramayanlardan (~86) belirgin şekilde yüksek: yüksek talepli ürünler kapasite kısıtından daha çok etkileniyor
- - 920 mağaza-günün tamamında adil dağıtım modeli çözüm buldu
- Kapasite kesintisinin %99.9'u Pazar günlerinde (6.460 adet), Cumartesi'de ihmal edilebilir (4 adet), hafta içi sıfır
- Mağaza bazında en çok kesinti Mağaza 2'de (1.019 adet), en az Mağaza 6'da (370 adet)
- Mağaza 8 örneğinde kesintiye uğrayan ürünlerin ortalama talebi (~110), uğramayanlardan (~86) yüksek: yüksek talepli ürünler kapasite kısıtından daha çok etkileniyor

## Kullanılan Araçlar
Python (pandas, XGBoost, PuLP, matplotlib), SQL (SQLite) — Google Colab

## Sınırlamalar
- Üretim kapasitesi gerçek veri değil, sentetik: her mağaza-ürün için geçmiş satışın 90. persentiline %10-20 tampon eklenerek üretildi
- Mağaza ortak kapasitesi, ürün kapasitelerinin toplamının %85'i olarak varsayıldı. "Kesinti sadece Pazar günleri oluşuyor" sonucu bu varsayıma duyarlıdır
- %70 minimum servis seviyesi bir iş kararı varsayımıdır, farklı bir eşik farklı bir dağılım verir
- Modelin test dönemi son 3 ay (Ekim-Aralık 2017); tahminler bu dönemin gerçek verisiyle ölçüldü

## Veri
[Kaggle - Store Item Demand Forecasting Challenge](https://www.kaggle.com/c/demand-forecasting-kernels-only)

## Sıradaki Adımlar

- Power BI ile interaktif dashboard
