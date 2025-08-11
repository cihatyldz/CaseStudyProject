# RNV Case 3 - Executive Dashboard & Analytics Requirements

## 🤖 AI-Powered Analytics Assistant

**Live LLM API Service:** This case analysis is now available through our deployed AI assistant powered by Mistral on Hugging Face, deployed on AWS with FastAPI.

**API Endpoint:** [http://91.102.161.205:8000/docs#/](http://91.102.161.205:8000/docs#/)

**Capabilities:**
- Ask questions about executive dashboard requirements
- Get clarification on backlog prioritization
- Receive guidance on revenue data quality investigation
- Interactive Q&A for all case components

**Technology Stack:**
- **LLM Model:** Mistral (via Hugging Face)
- **Backend:** FastAPI
- **Deployment:** AWS
- **Interface:** Interactive API documentation

---

## 1. Executive Dashboard Specifications

### 1a. Dashboard Components
**Format:** One-page executive dashboard with comprehensive KPI monitoring

**Core Elements:**
- **KPI Cards:** Sales, Returns, Cancellations, Net Revenue, Return Rate (%), Cancellation Rate (%)
- **Trend Analysis:** Daily trends for Last 7 Days / Last Month
- **Category Performance:** Top-N category contribution chart
- **Periodic Comparisons:** Week-over-Week (WoW) and Month-over-Month (MoM) deltas
- **Detailed Matrix:** Comprehensive data breakdown
- **Interactive Filters:** Date range, marketplace, and channel slicers
- **Alert System:** Automated flags for abnormal Return% and Cancellation% thresholds

### 1b. Requirements Clarification
**Critical Questions for Stakeholder Alignment:**

1. **Time Definitions:** Exact specifications for "last week/month" and timezone requirements
2. **Revenue Metrics:** Net vs. gross sales definitions and currency specifications
3. **Data Attribution:** Date attribution methodology for returns and cancellations
4. **Data Granularity:** Order-level vs. line-item level analysis and category taxonomy structure
5. **Data Pipeline:** Source systems and refresh Service Level Agreements (SLAs)
6. **Scope Parameters:** Geographic and channel filtering requirements
7. **Security Requirements:** Row-Level Security (RLS) implementation needs
8. **Metric Definitions:** Whether returns/cancellations should be measured as counts, values, or both

---

## 2. Backlog Prioritization Framework

### 2a. Prioritization Methodology
**Approach:** Weighted Shortest Job First (WSJF) scoring using Business Value / Effort ratio

**Scoring Scale:**
- **Effort:** 1-40 (1=Low, 5=Medium, 10=High, 15=Very High, 40=Extreme, 45=Critical)
- **Business Value:** S=Small (1), M=Medium (2), L=Large (3), XL=Extra Large (4)

### 2b. Prioritized Backlog
| Requirement | Effort | Business Value | WSJF Score (B/E) | Priority Rank |
|-------------|--------|----------------|-------------------|---------------|
| Backlog 4  | 5      | XL (4)         | 0.80             | **1**         |
| Backlog 3  | 3      | S (1)          | 0.33             | **2**         |
| Backlog 6  | 10     | L (3)          | 0.30             | **3**         |
| Backlog 2  | 15     | XL (4)         | 0.27             | **4**         |
| Backlog 1  | 45     | M (2)          | 0.04             | **5**         |
| Backlog 5  | 40     | S (1)          | 0.03             | **6**         |

**Note:** If separate Impact scoring is available, the formula would be adjusted to: **(Business Value + Impact) / Effort**

---

## 3. Revenue Data Quality Investigation

### 3a. Systematic Troubleshooting Approach
**Investigation Steps:**

1. **Data Validation:** Verify filters and time window configurations
2. **Metric Definition Review:** Confirm net vs. gross revenue calculations
3. **Source Reconciliation:** Execute SQL queries for day-by-day validation
4. **Data Integrity Check:** Review joins, deduplication logic, and data relationships
5. **Returns/Cancellations Analysis:** Examine data treatment and calculation methodologies
6. **Refresh Verification:** Confirm successful data pipeline execution
7. **Currency Handling:** Validate exchange rate conversions and currency formatting
8. **Security Validation:** Verify Row-Level Security (RLS) implementation

### 3b. Resolution Strategy
**Immediate Actions:**
- Identify and resolve root cause of revenue discrepancies
- Implement comprehensive data quality monitoring and alerting
- Establish automated validation checks for critical metrics

**Long-term Improvements:**
- Develop data quality dashboards and monitoring frameworks
- Implement proactive alerting for data anomalies
- Establish data governance and quality assurance processes