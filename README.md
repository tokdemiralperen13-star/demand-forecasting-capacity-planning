# Production Demand Forecasting & Capacity Planning

Perakende satış verisiyle talep tahmini ve kısıtlı kapasite altında kaynak optimizasyonunu birleştiren uçtan uca bir proje.

## Problem
Bir perakende zincirinde, gelecek talebi doğru tahmin etmek tek başına yeterli değildir. üretim/depo kapasitesi kısıtlıysa, bu kapasiteyi ürünler arasında **nasıl adil dağıtacağını** da bilmek gerekir. Bu proje, ikisini birlikte ele almaktadır.

## Yöntem
1. **Talep Tahmini** — XGBoost ile, lag/rolling-mean özellikleri ve takvim bilgileriyle (10 mağaza × 50 ürün, 5 yıllık günlük satış)
2. **Kapasite Darboğazı Tespiti** — tahmini talep, sentetik üretim kapasitesiyle karşılaştırılıp aşım noktaları belirleniyor
3. **Kaynak Optimizasyonu** — PuLP ile doğrusal programlama; kısıtsız senaryo (açığı minimize et) vs. minimum %70 servis seviyesi kısıtlı senaryo karşılaştırılıyor

## Bulgular
- Model performansı: **MAE 6.10** (ortalama günlük satış ~60 civarı)
- Kapasite darboğazlarının tamamı **Pazar günlerine** denk geliyor — haftalık talep döngüsüyle doğrudan ilişkili
- Kısıtsız optimizasyon, açığı birkaç ürüne yükleyip onları tamamen stoksuz bırakıyor; %70 minimum servis kısıtı eklenince açık tüm ürünlere makul şekilde dağılıyor — gerçek kapasite planlamasında klasik bir trade-off

## Kullanılan Araçlar
Python (pandas, XGBoost, PuLP, matplotlib) — Google Colab

## Veri
[Kaggle - Store Item Demand Forecasting Challenge](https://www.kaggle.com/c/demand-forecasting-kernels-only)

## Sıradaki Adımlar
- SQL ile veri katmanı ekleme
- Power BI ile interaktif dashboard
