SELECT
DATE_TRUNC('month', "OrderFirstActionDateTimeUtc"):: date AS "Месяц",
COUNT(DISTINCT "OrderCustomerIdsMindboxId") AS "Количество благотворителей"
FROM aif_data.order
WHERE "OrderLineStatusIdsExternalId" = 'Paid'
GROUP BY DATE_TRUNC('month', "OrderFirstActionDateTimeUtc")
ORDER BY "Месяц";
