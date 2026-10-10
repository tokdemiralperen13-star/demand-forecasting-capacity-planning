--- Sorgu 1: Kesinti yaşayan ürünler (en çok kesintiden en aza)
SELECT item, pred, daily_capacity, unmet_fair
FROM capacity_plan
WHERE unmet_fair > 0
ORDER BY unmet_fair DESC;

-- SORGU 2: Kesinti Var/yok gruplarının karşılaştırması
SELECT 
  CASE WHEN unnmet_fair > 0 THEN 'Kesinti Var' ELSE 'Kesinti Yok' END AS durum, 
  COUNT(*) AS urun_sayisi,
  ROUND(AVG(pred), 1) AS ortalama_talep
FROM capacity_plan
GROUP BY durum;
