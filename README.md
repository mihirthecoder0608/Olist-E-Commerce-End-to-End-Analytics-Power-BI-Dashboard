# Olist E-Commerce End-to-End Analytics & Power BI Dashboard

## 1. Project Overview

Analyzing operational efficiency, delivery performance, payment dynamics, and customer satisfaction is critical for optimizing e-commerce profitability.

This project analyzes transactional data from the Olist Brazilian E-Commerce dataset, containing approximately 100,000 orders from 2016 to 2018, to uncover delivery SLA bottlenecks, evaluate revenue distributions across payment methods, and assess logistics impacts on customer review scores.

The project integrates **Python (Pandas), MySQL, and Power BI** to transform relational operational data into actionable business and supply chain insights.

## 2. Business Objectives

- Measure platform revenue trends, order growth, and peak sales periods.
- Evaluate logistics performance by calculating late delivery rates across order cohorts.
- Analyze the relationship between delivery delays and customer satisfaction scores.
- Assess payment method preferences, including Credit Card, Boleto, and Vouchers, and examine installment behavior in relation to Average Order Value (AOV).
- Quantify freight expenditure and evaluate category-level Freight-to-Price ratios.
- Build an interactive, multi-page Power BI dashboard for executive reporting and operational monitoring.

## 3. Tools and Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas) | Data ingestion, exploratory data analysis, data cleaning, and schema validation |
| MySQL Workbench | Relational database setup, cross-table queries, and complex aggregations |
| Power BI Desktop | Data modeling, DAX measures, and interactive dashboard development |
| Power BI Service | Cloud deployment and report sharing |

## 4. Dataset

The project utilizes the relational **Olist Brazilian E-Commerce Dataset**, covering Brazilian e-commerce transactions from 2016 to 2018.

- **Total completed orders analyzed:** 96,478
- **Total Gross Merchandise Value (GMV):** Approximately $14 million
- **Primary tables:** `olist_orders_dataset`, `olist_order_items_dataset`, `olist_order_payments_dataset`, `olist_order_reviews_dataset`, `olist_customers_dataset`, `olist_products_dataset`, and `olist_sellers_dataset`

The relational structure connects customer geographic attributes, order statuses, itemized prices, payment installments, product categories, seller information, and delivery timestamps for end-to-end analytical reporting.

Dataset source: [Olist Brazilian E-Commerce Public Dataset on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## 5. Project Workflow

1. **Data Inspection and ETL:** Ingest CSV files using Python and Pandas to inspect data types, identify missing values, and validate primary and foreign key relationships.
2. **Relational Database Setup:** Import datasets into MySQL Workbench and perform cross-table queries for order analysis, freight metrics, and payment breakdowns.
3. **Power BI Data Modeling:** Build a relational data model connecting orders, order items, payments, reviews, customers, products, and sellers.
4. **DAX Measure Engineering:** Create measures for GMV, AOV, late delivery rate, total freight, and Freight-to-Price ratio.
5. **Dashboard Development:** Design an interactive, multi-page Power BI report covering executive performance metrics and payment and price dynamics.
6. **Strategic Insights:** Translate analytical findings into recommendations for improving delivery performance, understanding installment behavior, and managing freight costs.

## 6. Key Findings

### Executive Metrics and Delivery Performance

| KPI | Value |
|---|---:|
| Total GMV Analyzed | Approximately $14M |
| Total Orders Analyzed | 96,478 |
| Average Order Value (AOV) | Approximately $141 |
| Overall Late Delivery Rate | 8.11% |

*Note: These values should be validated against the final SQL queries and Power BI measures before publication. GMV and AOV depend on the chosen aggregation and order-level definitions.*

### Delivery SLA vs. Customer Review Scores

| Review Score | Late Delivery Rate | Key Observation |
|---|---:|---|
| 1-Star Reviews | ~38.0% | Severe delivery delays are associated with negative feedback |
| 2-Star Reviews | ~21.5% | Delivery problems may contribute to poor customer experiences |
| 3-Star Reviews | ~11.2% | Moderate satisfaction may coincide with delivery friction |
| 4-Star Reviews | ~4.8% | Higher satisfaction is associated with fewer delivery delays |
| 5-Star Reviews | <3.0% | High ratings are associated with better delivery performance |

**Key takeaway:** Delivery delays appear to be associated with lower customer review scores. Identifying high-risk regions, sellers, and delivery routes could help prioritize logistics improvements.

These figures represent associations and should not be interpreted as proof that delivery delays alone cause lower review scores.

### Payment Method Distribution

| Payment Type | GMV Share | Approximate Transaction Value | Key Characteristic |
|---|---:|---:|---|
| Credit Card | 78.44% | $11.0M | Dominant payment method |
| Boleto Bancário | 17.23% | $2.4M | Important local ticket-based payment method |
| Voucher | 2.61% | $0.36M | Promotional and voucher-based payments |
| Debit Card | 1.72% | $0.24M | Smaller share of payment value |

*Note: Payment shares and values should be verified using the same aggregation basis. Payment records may contain multiple installments or payment entries for a single order.*

### Installment Behavior vs. Average Order Value

| Installment Count | Reported AOV | Analytical Observation |
|---:|---:|---|
| 1 | $65 | Lower average order value |
| 2 | $110 | Higher average order value than single-installment payments |
| 3 | $128 | Continued increase |
| 4 | $145 | Moderate increase |
| 5 | $162 | Higher average order value |
| 6 | $190 | Increased average order value |
| 7 | $170 | Lower than the six-installment group |
| 8 | $289 | Relatively high average order value |
| 9 | $98 | Lower average order value |
| 10 | $387 | High average order value |
| 11 | $132 | Lower average order value |
| 12 | $418 | Highest reported average order value |

**Key takeaway:** Several installment groups show higher average order values, but the pattern is not consistently increasing. The results may reflect differences in product mix, customer behavior, and order composition rather than a direct effect of installment availability.

*Note: Validate whether AOV is calculated at the order level or payment-record level before drawing conclusions.*

## 7. Power BI Dashboard

The Power BI report contains two analytical pages.

### Executive Overview — Page 1

- KPI cards for Total GMV, Total Orders, AOV, and Late Delivery Rate.
- Monthly GMV trends highlighting sales peaks and seasonal patterns.
- Late Delivery Rate analysis by Customer Review Score.
- Interactive visualizations for exploring operational performance.

### Payment and Price Dynamics — Page 2

- Financial KPIs covering Total Freight and Freight-to-Price Ratio.
- Donut chart displaying payment value distribution across payment methods.
- Clustered column chart comparing installment counts and AOV.
- Interactive slicers for Date Range and Product Category.

### How to Explore the Dashboard

[Click to see the Dashboard](https://app.powerbi.com/links/zw6-F76Uud?ctid=edc5c3bf-4ab5-4697-84fa-41b44eb08b5e&pbi_source=linkShare)

Use the available slicers and visual interactions to explore sales trends, payment behavior, delivery performance, and freight expenditure.

## 8. Business Recommendations

### 1. Improve Regional Fulfillment Performance

Identify geographic regions, sellers, and delivery routes with consistently high late delivery rates. Evaluate targeted logistics improvements and regional fulfillment options based on order density and delivery costs.

**Expected benefit:** Better delivery reliability and improved customer experience.

### 2. Evaluate Installment Options for High-Value Purchases

Analyze conversion rates, order values, payment fees, and customer segments before introducing installment promotions for high-value products.

**Expected benefit:** Potential improvement in purchase conversion and basket value, subject to profitability analysis.

### 3. Optimize Freight Costs

Identify product categories with high Freight-to-Price ratios and evaluate shipping subsidies, seller negotiations, packaging changes, and delivery options.

**Expected benefit:** More competitive delivery costs and improved customer purchasing experience.

*These recommendations are proposed actions. Their actual business impact should be measured through controlled tests or before-and-after performance analysis.*

## 9. Repository Structure

```text
Olist-E-Commerce-End-to-End-Analytics-Power-BI-Dashboard/
│
├── data/
│   └── README.md
│
├── powerbi/
│   └── Olist_Analytics_Dashboard.pbix
│
├── sql/
│   └── olist_queries.sql
│
├── python/
│   └── data_inspection.ipynb
│
├── screenshots/
│   ├── page1_executive_overview.png
│   └── page2_payment_dynamics.png
│
└── README.md
```

## 10. How to Run and Explore

### Python Data Inspection

**Step 1: Clone the repository**

```bash
git clone https://github.com/mihirthecoder0608/Olist-E-Commerce-End-to-End-Analytics-Power-BI-Dashboard.git
cd Olist-E-Commerce-End-to-End-Analytics-Power-BI-Dashboard
```

**Step 2: Install the required packages**

```bash
pip install pandas numpy matplotlib seaborn jupyter
```

**Step 3: Open the Python notebook**

Open `python/data_inspection.ipynb` in Jupyter Notebook and execute all cells to inspect the dataset, examine data types, identify missing values, and perform exploratory data analysis.

Ensure the dataset files are downloaded and placed in the expected directory before running the notebook.

### MySQL Analysis

1. Open MySQL Workbench and connect to your MySQL server.
2. Create or select the database configured in your SQL scripts.
3. Import the required Olist dataset tables.
4. Execute the queries in `sql/olist_queries.sql`.

Update database names and file paths if they differ from your local setup.

### Power BI Report

1. Download `Olist_Analytics_Dashboard.pbix` from the `powerbi/` directory.
2. Open the file using Power BI Desktop.
3. If prompted, configure the data source paths and refresh the data.
4. Explore the dashboard using the Date Range and Product Category slicers.

## 11. Limitations

- The analysis uses historical transaction data from 2016–2018 and does not reflect real-time prices, inventory, or logistics conditions.
- External macroeconomic factors influencing consumer credit availability in Brazil are outside the scope of this dataset.
- Customer satisfaction analysis relies on available review scores and does not include comprehensive sentiment analysis of unstructured review text.
- Payment-level records and order-level records have different granularities. Incorrect joins or aggregations can lead to double-counting.
- Historical associations between delivery delays and review scores do not establish causation.
- Business recommendations are analytical proposals; their effectiveness requires further testing and operational validation.

## 12. Conclusion

This project demonstrates how **Python, SQL, and Power BI** can be integrated to analyze e-commerce operations, payment behavior, logistics efficiency, and customer satisfaction.

By analyzing approximately 96,478 orders, the project explores opportunities to improve delivery performance, understand payment preferences, evaluate freight costs, and support data-driven business decisions.

The interactive Power BI dashboard translates transactional data into actionable insights for operational monitoring and strategic decision-making.

## Author

**Mihir Mishra**

- [LinkedIn](https://www.linkedin.com/in/mihirmishra74638ghy)
- [Email](mihirmishra006@gmail.com)

**Skills Demonstrated:** Data Cleaning · Exploratory Data Analysis · SQL · Relational Data Modeling · DAX · Supply Chain Analytics · Python (Pandas) · Power BI Dashboard Design
