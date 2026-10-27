SELECT
"CustomerAreaName" AS "Город благотворителя",
COUNT(DISTINCT "CustomerIdsMindboxId") AS "Количество благотворителей",
COUNT("OrderIdsWebsiteID") AS "Количество заказов",
ROUND(SUM("OrderTotalPrice")/COUNT("OrderIdsWebsiteID")::numeric,2) AS "Средний чек",
SUM("OrderTotalPrice")/ COUNT(DISTINCT "CustomerIdsMindboxId") AS LTV
FROM aif_data.id_donor d JOIN aif_data.order o 
ON d."CustomerIdsMindboxId"=o."OrderCustomerIdsMindboxId"
WHERE "CustomerAreaName" IN('Москва','Санкт-Петербург','Екатеринбург') 
AND "OrderLineStatusIdsExternalId" = 'Paid'
GROUP BY "CustomerAreaName"
ORDER BY LTV DESC;
