SELECT
"CustomerSex" AS "Пол благотворителя",
COUNT("OrderIdsMindboxId") AS "Количество заказов",
ROUND(SUM("OrderTotalPrice")/COUNT("OrderIdsMindboxId")::numeric,2) AS "Средний чек"
FROM aif_data.id_donor d JOIN aif_data.order o 
ON d."CustomerIdsMindboxId"=o."OrderCustomerIdsMindboxId"
WHERE "CustomerSex" IS NOT NULL AND "OrderLineStatusIdsExternalId" = 'Paid'
GROUP BY "CustomerSex";
