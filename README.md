# E-commerce Sales Analysis

**Author / Автор:** Sergey Fedulov (Федулов Сергей)

## Project Goal / Цель проекта

Analyze e-commerce sales data to understand what drives revenue, which products and customers generate the most value, and how sales performance changes over time.

Проанализировать данные интернет-магазина, чтобы понять, что формирует выручку, какие товары и клиенты вносят наибольший вклад и как меняются продажи со временем.

## Business Questions / Бизнес-вопросы

1. What is the total revenue and average order value?
2. How does revenue change over time?
3. Which product categories and products generate the most revenue?
4. Which customers generate the most revenue?
5. Do customers make repeat purchases?
6. Which customer segments and cities are the most valuable?
7. Are there data quality issues that could affect the analysis?

## Data / Данные

The project uses four related tables:

В проекте используются четыре связанные таблицы:

- `customers` — customer information / информация о клиентах
- `products` — product catalog / каталог товаров
- `orders` — order information / информация о заказах
- `order_items` — products included in orders / товарные позиции в заказах

## Data Quality / Качество данных

The raw data contains several quality issues that were identified during the initial audit and handled in the analysis:

В исходных данных были выявлены проблемы качества, которые были проверены на этапе первичного аудита и учтены при очистке:

- duplicate records;
- missing customer attributes;
- missing product category and transaction prices;
- invalid customer and product IDs;
- invalid quantities;
- an obvious transaction price outlier;
- completed orders without matching order items.

The cleaning process is documented in `check_files.ipynb` and `analysis.ipynb`.

Процесс проверки и очистки данных отражён в `check_files.ipynb` и `analysis.ipynb`.

## Methodology / Методология

The analysis follows the workflow:

Анализ выполнен по следующему процессу:

1. Audit the raw CSV files.
2. Clean the data in pandas.
3. Load the cleaned data into MySQL.
4. Validate the imported tables.
5. Analyze revenue, products, customers, segments, cities and order behavior using SQL.
6. Repeat key calculations in pandas.
7. Visualize the main findings.
8. Summarize the results in business conclusions.

1. Аудит исходных CSV-файлов.
2. Очистка данных в pandas.
3. Загрузка очищенных данных в MySQL.
4. Проверка загруженных таблиц.
5. Анализ выручки, товаров, клиентов, сегментов, городов и поведения заказов с помощью SQL.
6. Повторение ключевых расчётов в pandas.
7. Визуализация основных результатов.
8. Формирование бизнес-выводов.

## Key Results / Основные результаты

- Total revenue from completed orders with known transaction prices: **3.43M**.
- Average order value: **203.92**.
- **4,873** customers made at least one completed purchase.
- **4,359** customers made repeat purchases, representing **89.45%** of customers with completed purchases.
- `Home` is the highest-revenue category at **956.3K**.
- `Product_054` is the top product by revenue at **175.0K**.
- Monthly revenue does not show a stable upward or downward trend across 2024–2025.

- Выручка по завершённым заказам с известной ценой транзакции: **3,43 млн**.
- Средний чек: **203,92**.
- **4 873** клиента совершили хотя бы одну завершённую покупку.
- **4 359** клиентов совершали повторные покупки — **89,45%** клиентов с завершёнными покупками.
- `Home` — категория с наибольшей выручкой: **956,3 тыс.**
- `Product_054` — лидер по выручке: **175,0 тыс.**
- За 2024–2025 годы стабильного тренда роста или падения месячной выручки не наблюдается.

## Business Conclusions / Бизнес-выводы

### 1. Revenue dynamics / Динамика выручки

No stable upward or downward revenue trend is observed. Monthly revenue fluctuates within approximately 130–156 thousand, while the highest values in 2025 are lower than the peaks observed in 2024. These fluctuations may be related to seasonality, although two years of data are not sufficient to confirm a seasonal effect with confidence.

Стабильного тренда роста или падения выручки не наблюдается. Месячная выручка колеблется примерно в диапазоне 130–156 тыс., при этом максимальные значения в 2025 году ниже пиков 2024 года. Наблюдаемые колебания могут быть связаны с сезонностью, однако двух лет данных недостаточно для уверенного подтверждения сезонного эффекта.

### 2. Category performance / Категории товаров

The Home category generates the highest revenue at 956.3 thousand, clearly ahead of Sports (655.9 thousand) and Electronics (611.6 thousand). These three categories are the main sources of revenue and may be priority areas for assortment development and marketing activities.

For categories with lower revenue, demand and profitability should be analyzed further before making decisions about reducing the assortment or launching discount campaigns.

Категория Home формирует наибольшую выручку — 956,3 тыс., заметно опережая Sports (655,9 тыс.) и Electronics (611,6 тыс.). Эти три категории являются основными источниками выручки и могут быть приоритетными направлениями для развития ассортимента и маркетинговых предложений.

Для категорий с меньшей выручкой целесообразно дополнительно проанализировать спрос и маржинальность перед принятием решений о сокращении ассортимента или проведении скидочных кампаний.

### 3. Product performance / Товары

Product_054 is the revenue leader at 175.0 thousand, clearly ahead of the other products. This may indicate strong demand or a significant contribution to sales, so it can be considered one of the key products in the assortment. At the same time, lower revenue from other products does not necessarily mean lower customer interest and requires further analysis of sales volume and prices.

Product_054 является лидером по выручке — 175,0 тыс., заметно опережая остальные товары. Это может указывать на высокий спрос или значительный вклад товара в продажи, поэтому его стоит рассматривать как один из ключевых товаров ассортимента. При этом более низкая выручка остальных товаров сама по себе не означает низкий интерес покупателей и требует дополнительного анализа количества продаж и цен.

### 4. Customer behavior / Поведение клиентов

Among 4,873 customers with completed orders, 4,359 made repeat purchases, representing 89.45% of the customer base. The high share of repeat customers indicates strong repeat purchasing behavior, although the reasons behind it cannot be determined from these data. A deeper analysis should examine repeat purchases by product, category, customer segment, and other customer characteristics.

Из 4 873 клиентов с завершёнными заказами 4 359 совершали повторные покупки, что составляет 89,45% клиентской базы. Высокая доля повторных клиентов указывает на выраженное повторное покупательское поведение, однако по этим данным нельзя определить его причины. Для более глубокого анализа необходимо изучить повторные покупки по товарам, категориям, сегментам и другим характеристикам клиентов.

## Limitations / Ограничения

- Revenue is calculated only for `Completed` orders.
- Revenue uses transaction prices from `order_items`, not catalog prices from `products`.
- Missing transaction prices are ignored by `SUM`, so reported revenue represents revenue from items with known prices.
- Some completed orders have no matching `order_items`, which affects order-level metrics such as AOV when calculated from joined order data.
- The dataset covers two years, so seasonality cannot be confirmed confidently.
- Revenue should not be interpreted as profit because product costs and margins are not available.

- Выручка рассчитывается только по заказам со статусом `Completed`.
- Для выручки используются цены транзакций из `order_items`, а не цены каталога из `products`.
- Пропущенные цены транзакций не учитываются в `SUM`, поэтому рассчитанная выручка относится к позициям с известной ценой.
- Часть завершённых заказов не имеет связанных `order_items`, что влияет на метрики уровня заказа, например AOV при расчёте через объединённые таблицы.
- Данных только за два года недостаточно для уверенного подтверждения сезонности.
- Выручку нельзя интерпретировать как прибыль, поскольку данные о себестоимости и маржинальности отсутствуют.

## Project Structure / Структура проекта

```text
ecommerce-sales-analysis-first_pr/
├── .gitignore
├── README.md
├── requirements.txt
├── data/
│   ├── raw/
│   └── processed/
├── sql/
└── notebooks/
    ├── check_files.ipynb
    └── analysis.ipynb
```

## Tools / Инструменты

- Python
- pandas
- NumPy
- Matplotlib
- Seaborn
- MySQL
- DBeaver
- Jupyter Notebook
- Git / GitHub

## Author / Автор

**Sergey Fedulov (Федулов Сергей)**

This project was created as a portfolio data analysis project.

Проект выполнен как портфолио-проект по анализу данных.
