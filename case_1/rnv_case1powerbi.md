# RNV Power BI Case Study - Data Analysis & Dashboard Development

## Project Overview
This project demonstrates the development of a comprehensive sales analytics dashboard using Power BI for RNV company. The project covers data preparation, modeling, DAX formula development, and interactive visualizations.

## Technical Approach

### 1. Data Preparation & Import
- **Source Data**: `order_line_data` sheet from `rnv_data.xlsx` file
- **Data Transfer**: Order data transferred to separate Excel file
- **Power BI Connection**: Imported using Get Data → Excel Workbook

### 2. Data Modeling & Transformation
- **Date Format Conversion**: Optimized `order_date` column format
- **Temporary Table Creation**: Created `Temporders` table using Modeling → New Table
- **Column Additions**: Added necessary columns for analysis

### 3. DAX Formulas Development
The following DAX measures were created for dashboard components:

#### Revenue Metrics
```dax
Total Revenue ₺ = SUM(orders[total_per_sku])

Item Tax ₺ = SUM(orders[item_tax])

Net Revenue exTax ₺ = [Total Revenue ₺] - [Item Tax ₺]

Cancelled ₺ = SUM(orders[cancelled_value])

Net Sales ₺ = [Net Revenue exTax ₺] - [Cancelled ₺]
```

#### Cost & Margin Metrics
```dax
Transport Cost ₺ = SUM(orders[transport_cost_actual])

GM (from column) ₺ = SUM(orders[gm_estimated])

GM (final) ₺ = COALESCE([GM (from column) ₺], [Net Revenue exTax ₺] - [Transport Cost ₺])

GM % = DIVIDE([GM (final) ₺], [Net Revenue exTax ₺])
```

#### Order Metrics
```dax
Orders = DISTINCTCOUNT(orders[mkp_order_no])

SKUs = DISTINCTCOUNT(orders[sku])

AOV ₺ = DIVIDE([Total Revenue ₺], [Orders])

Cancelled Orders = CALCULATE(
    DISTINCTCOUNT(orders[mkp_order_no]),
    FILTER(orders, orders[order_status] = "Cancelled")
)

Cancel Rate (Orders) = DIVIDE([Cancelled Orders], [Orders])
```

#### Commission Metrics
```dax
MKP Commission (actual) ₺ = SUM(orders[mkp_actual_commission])

MKP Commission % = DIVIDE([MKP Commission (actual) ₺], [Total Revenue ₺])

Marketplace Revenue Share % = DIVIDE(
    [Total Revenue ₺],
    CALCULATE([Total Revenue ₺], ALL(orders[mkp_name]))
)
```


## Technical Skills Demonstrated

### Power BI Skills
- ✅ Data connection and import
- ✅ Data modeling and transformation
- ✅ DAX formula development
- ✅ Visualization design
- ✅ Dashboard optimization

### Data Analysis Skills
- ✅ Data cleaning and preparation
- ✅ Statistical analysis
- ✅ Trend analysis
- ✅ Performance metrics

## Project Outcomes

### Dashboard Features
1. **Interactive Filters**: Date range, category, region filters
2. **Drill-down Capabilities**: Detailed level analysis
3. **Real-time Updates**: Automatic refresh with data source updates
4. **Responsive Design**: Adapts to different screen sizes

### Business Value
- Real-time sales performance tracking
- Strategic decision making through trend analysis
- Category-based optimization opportunities

## Key Learnings
- Effective modeling of complex datasets
- User-friendly dashboard design
- Performance-focused DAX optimization
- Business value creation through data insights

## Conclusion
This project successfully demonstrates the ability to develop comprehensive dashboard solutions using Power BI's powerful data analysis and visualization capabilities. The technical skills and business understanding acquired during this project show potential for creating value in data-driven decision-making processes.

---

