WITH new_users AS (
    SELECT
    DISTINCT DATE_TRUNC('month', "OrderFirstActionDateTimeUtc") :: date AS august,
    "OrderCustomerIdsMindboxId" AS user_id,
    "CustomerSex" AS customer_sex
    FROM aif_data.order o
    JOIN aif_data.id_donor d ON o."OrderCustomerIdsMindboxId"=d."CustomerIdsMindboxId"
    WHERE "OrderLineStatusIdsExternalId" = 'Paid' 
    AND DATE_TRUNC('month', "OrderFirstActionDateTimeUtc") :: date = '2022-08-01'
    AND "CustomerSex" IS NOT NULL
),
active_users AS (
    SELECT
    DISTINCT DATE_TRUNC('month', "OrderFirstActionDateTimeUtc") :: date AS active_month,
    "OrderCustomerIdsMindboxId" AS user_id,
    "CustomerSex" AS customer_sex
    FROM aif_data.order o 
    JOIN aif_data.id_donor d ON o."OrderCustomerIdsMindboxId"=d."CustomerIdsMindboxId"
    WHERE "OrderLineStatusIdsExternalId" = 'Paid' 
    AND DATE_TRUNC('month', "OrderFirstActionDateTimeUtc") :: date >= '2022-08-01'
    AND "CustomerSex" IS NOT NULL
),
monthly_retention AS (
    SELECT 
    nu.user_id,
    nu.customer_sex,
    (active_month :: date - august :: date)/30 AS month_since_install
    FROM new_users nu JOIN active_users au ON nu.user_id=au.user_id 
    WHERE active_month >= august 
)
SELECT
customer_sex AS "Пол пользователя",
month_since_install "Количество месяцев",
ROUND(COUNT(DISTINCT user_id)/MAX(COUNT(DISTINCT user_id)) 
OVER (PARTITION BY customer_sex ORDER BY month_since_install)::numeric,2) AS retention_rate
FROM monthly_retention
GROUP BY customer_sex, month_since_install
ORDER BY customer_sex, month_since_install;
