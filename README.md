## 🚀 Workplace Injuries Analysis — Transportation & Storage (Italy)

👉 **Focus:** Data Analysis • Risk Modeling • Data Visualization  
👉 **Tools:** SQL (SQLite) | Tableau | Excel  
👉 **Tech Stack:** SQL | SQLite | Tableau | Excel | Data Modeling | EDA

---

---

## 🧠 Executive Summary

This project analyzes workplace injuries in the **Transportation and Storage sector (NACE H)** across Europe, with a focused deep dive on Italy.

By combining employment (exposure) and accident data (risk), the analysis identifies **structural patterns in occupational safety**.

Key findings:
- Injury risk is **stable over time** → structural, not cyclical  
- Cross-country differences are driven by **workforce size, not risk intensity**  
- Risk is **concentrated in a few operational activities**  
- Italy shows **consistently higher-than-average risk**

The project is designed as a **decision-support tool**, enabling stakeholders to identify **where risk is concentrated and where to act**.

![Datafolio Preview](visuals/Datafolio.PNG)

---

## 📌 Key Metrics

These metrics highlight that risk in the sector is both **structural and concentrated**, reinforcing the need for targeted safety interventions.

- **Injury risk (Italy, H sector):** 25.8 vs 12.2 national average → **~2.1× higher risk**  
- **Relative risk vs EU peers:** ~18% higher than peer-country average  

- **EU context:**  
  - Italy represents **10.2% of total EU employment** in the sector  
  - Italy is the **3rd largest Transportation & Storage sector** in Europe  

- **National context (Italy):**  
  - Sector accounts for **4.9% of total employment**  
  - Ranked **3rd highest-risk sector** within the Italian economy  

- **Cross-country ranking:**  
  - Italy is the **5th highest-risk country** in the EU for this sector  

- **Workforce structure:**  
  - **79.6% male workforce**, reflecting sector composition

---

## 📊 Interactive Dashboard

🔗 **View on Tableau Public:**  
https://public.tableau.com/app/profile/giulio.galbiati/viz/Work-relatedinjuriesintheItaliantransportationandstoragesector/ItalyDeepDive2

---

## 🧩 Problem Statement

Workplace injuries in logistics and transport are often analyzed descriptively, but rarely through a **structured, comparative, and decision-oriented approach**.

This project answers:

> **Where is risk concentrated, what drives it, and how should we act?**

---

## 🎯 Objectives

- Identify **structural injury patterns over time**  
- Analyze **operational risk drivers**  
- Understand **workforce composition (gender, exposure)**  
- Benchmark Italy vs **peer European countries**  
- Support **data-driven safety prioritization**  

---

## 🏗️ Data Architecture

The analysis is built on a **relational data model**:

- **Fact tables** → injuries, employment  
- **Dimension tables** → country, activity, gender, age, circumstances  

All data is integrated into a **SQLite database** to enable scalable querying and analysis.

---

## ⚙️ Methodology

### 1. Data Curation
- Data collection, cleaning, and validation  
- Integration into relational database  

### 2. Exploratory Analysis
- Time trends  
- Cross-country benchmarking  
- Sector and demographic analysis  

### 3. KPI Development
- Injury rates (per 1,000 employees)  
- Exposure vs risk metrics  
- Gender and sector indicators  

### 4. Visualization
- SQL → Tableau pipeline  
- Dashboard designed for **decision-making**

---

## 📊 Dashboard Logic

Provides interactive exploration of risk patterns, drivers, and cross-country comparisons.

**Context → Risk → Drivers → Focus**

- **Context** → Workforce structure  
- **Risk** → Injury incidence patterns  
- **Drivers** → Operational causes  
- **Focus** → Where action is needed  

---

## 📁 Project Structure

```text
workplace-injuries-analysis/
│
├── data/
│ ├── raw/
│ └── processed/
│
├── db/
│ └── WRI_1.0.db
│
├── sql/
│ ├── 3.1/
│ ├── 3.2/
│ ├── 3.3/
│ ├── 3.4/
│ ├── 3.5/
│ ├── 4/
│ └── KPI/
│
├── visuals/
├── reports/
│
├── README.md
└── LICENSE
```

---

## 📊 SQL Output Samples

### 📖 How to read
Each query is mapped to its analytical purpose, showing:
- output structure  
- example results  
- role in the pipeline

---

### 🔹 Section 3.1 — Employment Structure (Cross-Country, NACE H)
*Defines workforce size and structure across countries.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| A7_1_avg_employment_top10_other_gender.sql | country_group, avg_employment, pct_of_total, female_share_pct, male_share_pct | Germany, 1200000, 18.5, 28.4, 71.6 |
| S1.1 Base employment H36.sql | country_id, time_period, sex_id, employment_value | AT, 2014, F, 125000 |
| S1.2 Emplymment CxY.sql | country_id, time_period, female_employment, male_employment, total_employment, female_share_pct, male_share_pct | AT, 2014, 120000, 300000, 420000, 28.57, 71.43 |
| S1.3 AVG emplyment by C.sql | country_id, avg_employment | DE, 1500000 |
| S1.4 Country share.sql | country_id, avg_employment, employment_share_pct | FR, 1300000, 17.8 |
| S1.5 Overall Gender comp.sql | sex_id, total_employment, share_pct | F, 3500000, 28.0 |
| S1.5 Tot Emp x Y.sql | time_period, total_employment | 2014, 12000000 |
| Top 10 country and other.sql | time_period, display_country, employment | 2014, Germany, 1500000 |
| TOP 10 VS OTHERS.sql | group_name, avg_employment, employment_share_pct | Top 10 Countries, 9000000, 75.0 |
| TOP 10-IT VS IT.sql | group_name, avg_employment, employment_share_pct | Top 10 excl. Italy, 8000000, 70.0 |
| WRI H10 Y.sql | country_id, 2014–2023 (pivoted years) | AT, 1200, 1300, ... |
| WRI IT AU Y.sql | activity_id, 2014–2023 (pivoted years) | H, 5000, 5200, ... |

---

### 🔹 Section 3.2 — Injury Incidence (Cross-Country, NACE H)
*Measures normalized injury incidence across countries.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| AV CAS X 1K.sql | country, avg_injury_rate_x1k | Germany, 7.25 |
| eda_3_2_temporal_trend_peer_avg.sql | year, country, injury_rate_x1k, peer_avg_rate | 2018, Italy, 6.80, 7.10 |
| FATAL VS NON FATAL ACC.sql | period, fatal_casualties, nonfatal_casualties, total_casualties, fatal_share_pct | 2018, 120, 4800, 4920, 2.44 |
| TOTAL AV CASUALTIES.sql | country, avg_annual_casualties | France, 5200 |
| WRI 1 K TRENDS.sql | year, country, injury_rate_x1k | 2019, Spain, 7.10 |
| WRI BY GENDER.sql | country, male_rate_x1k, female_rate_x1k | Italy, 8.20, 3.10 |
| TOP 2 BY GENDER QUERY 1.sql | category_description, subcategory_description, avg_share_pct, avg_male_share_pct, avg_female_share_pct | Movement, Walking, 35.2, 72.5, 27.5 |
| TOP 2 BY GENDER QUERY 2.sql | country_scope, category_description, subcategory_description, gender, gender_share_pct | Italy, Movement, Walking, Male, 73.1 |

---

### 🔹 Section 3.3 — Italy Cross-Sector Benchmark (NACE A–U)
*Compares sector risk vs national economy.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| 3.2 WRI IT AU ABSOLUTE V.sql | activity_id, activity_description, avg_annual_casualties | H, Transportation and Storage, 5200 |
| it_avg_injury_incidence_by_sector_2014_2023.sql | activity_id, activity_description, avg_casualties_x1k | H, Transportation and Storage, 7.20 |
| Injury Incidence by Gender across Economic Activities.sql | activity_id, activity_description, avg_male_rate, avg_female_rate | H, Transportation and Storage, 8.50, 3.20 |
| Injury Incidence Trend — NACE H vs Italy Cross-Sector Average.sql | time_period, series, rate | 2018, Transportation and Storage (H), 7.10 |

---

### 🔹 Section 3.4 — Accident Circumstances (Risk Drivers)
*Identifies where and how injuries occur.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| TOP 2 SUBCATEGORIES.sql | category_description, subcategory_description, avg_share_pct | Movement, Walking, 34.8 |
| TOP 2 SUBCATEGORIES IT.sql | category_description, subcategory_description, avg_share_pct | Transport, Driving, 29.5 |
| TOP 2 BY GENDER QUERY 1.sql | category_description, subcategory_description, avg_share_pct, avg_male_share_pct, avg_female_share_pct | Movement, Walking, 35.2, 72.5, 27.5 |
| TOP 2 BY GENDER QUERY 2.sql | country_scope, category_description, subcategory_description, gender, gender_share_pct | Italy, Movement, Walking, Male, 73.1 |
| TOP 2 IT VS PEERS.sql | country_group, category_description, subcategory_description, avg_share_pct | Italy, Movement, Walking, 36.0 |
| TOP 2 IT VS PEERS 3.sql | country_group, category_description, subcategory_description, avg_share_pct | Top10_excl_IT, Transport, Driving, 31.2 |

---

### 🔹 Section 3.5 — Employment Structure (Italy, NACE A–U)
*Analyzes workforce structure within Italy.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| IT Employment AU SHORT.sql | activity_id, avg_employment_2014_2023 | H, 850000 |
| IT Employment AU.sql | activity_id, avg_employment_2014_2023, activity_label, highlight_group | H, 850000, H Transportation and storage, Transportation and Storage |
| IT EMPLOYMENT by gender.sql | group_name, sex_id, avg_employment, employment_share_pct, sex_label | Transportation and Storage (H), M, 600000, 72.0, Male |
| IT EMPLOYMENT TRENDS.sql | activity_id, time_period, total_employment | H, 2018, 820000 |
| IT EMPLOYMENT TRENDS 2.sql | sector_group, time_period, employment | Transportation & Storage (H), 2018, 820000 |
| IT EMPLOYMENT TRENDS 3.sql | activity_id, time_period, total_employment, employment_index, highlight_group | H, 2018, 820000, 102.5, Transportation and Storage |

---

### 🔹 Section 4 — Synthesis (Exposure vs Risk)
*Combines exposure and risk into structural insights.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| EMPLOYMENT PER YEAR IT AU.sql | activity_id, time_period, total_employment | H, 2018, 820000 |
| EMPLOYMENT PER YEAR TOP10.sql | country_id, time_period, total_employment | DE, 2018, 1500000 |
| TOT CASUALTIES 1k PER YEAR IT AU.sql | activity_id, time_period, total_casualties | H, 2018, 7.10 |
| TOT CASUALTIES 1k PER YEAR TOP 10.sql | country_id, time_period, total_casualties | DE, 2018, 6.90 |
| TOT CASUALTIES PER YEAR IT AU.sql | activity_id, time_period, total_casualties | H, 2018, 5200 |
| TOT CASUALTIES PER YEAR IT AU ABSOLUTE.sql | activity_id, time_period, total_casualties | H, 2018, 5200 |
| TOT CASUALTIES PER YEAR TOP 10.sql | country_id, time_period, total_casualties | DE, 2018, 4800 |

---

### 🔹 Appendix — KPIs & Validation Tables
*Defines key metrics and validates results.*

| SQL File | Output Columns | Example Row |
|----------|---------------|------------|
| KPI 7.4.1.1.sql | top10_avg_employment, total_avg_employment, employment_exposure_concentration_pct | 8500000, 12000000, 70.8 |
| KPI 7.4.1.2.sql | employment_2023, employment_2014, growth_index_2014_100 | 12500000, 12000000, 104.2 |
| KPI 7.4.1.3.sql | avg_male_employment, avg_female_employment, gender_employment_ratio | 8000000, 3200000, 2.50 |
| KPI 7.4.1.4.sql | female_workforce_share_pct | 28.5 |
| KPI 7.4.2.1.sql | indicator, peer_group_value, italy_value, period | Avg Injury Incidence — NACE H, 7.10, 7.25, 2014–2023 avg |
| KPI 7.4.2.2.sql | peer_group_avg_injury_incidence | 7.05 |
| KPI 7.4.2.3.sql | italy_avg_injury_incidence | 7.25 |
| KPI 7.4.2.4.sql | italy_relative_risk_vs_peer_avg | 1.03 |
| KPI 7.4.3.1.sql | avg_total_economy_casualties_x1k | 6.80 |
| Table 7.3.sql | country, avg_casualties, avg_employment, injury_rate_per_1000, rank | Germany, 5200, 1500000, 6.90, 1 |
| TABLE 7.4.sql | activity_id, activity, avg_casualties, avg_employment, injury_rate_per_1000, rank | H, Transportation and Storage, 5200, 820000, 7.20, 3 |
| TABLE 7.4 BIS.sql | activity, avg_casualties, avg_employment, injury_rate_per_1000, rank | Transportation and Storage, 5200, 820000, 7.20, 3 |
| TABLE 7.5.sql | category_id, category, subcategory_id, subcategory, avg_casualties, share_within_category_pct, category_rank | Movement, Walking, 1800, 35.2, 1 |
| TABLE 7.6.sql | activity_id, activity, male_employment, female_employment, male_share_pct, female_share_pct | H, Transportation and Storage, 600000, 220000, 73.2, 26.8 |
| TABLE 7.6 BIS.sql | sector, male_employment, female_employment, male_share_pct, female_share_pct | Transportation and Storage (H), 600000, 220000, 73.2, 26.8 |

---

## 📌 Key Insights

* Injury incidence in the Transportation and Storage sector remained **relatively stable over 2014–2023**, with no clear long-term trend in normalized accident rates.  
* Differences in **absolute accident counts across countries are mainly driven by workforce size**, while normalized indicators show **comparable risk levels** across major European economies.  
* Workplace injuries are **concentrated in recurring operational contexts**, particularly:
  - transport operations  
  - goods handling  
  - vehicle-related activities  
* The sector workforce is **structurally male-dominated**, which explains the higher share of male casualties observed in the data.  
* In Italy, the Transportation and Storage sector shows **consistently higher injury incidence than the national average**, confirming it as a **relatively high-risk sector** within the economy.  

---

## 🔄 Data Pipeline

Raw Data
→ Cleaning & Validation
→ SQLite Database
→ SQL Analysis
→ Processed Datasets
→ Tableau Dashboard

---

## 💼 Business Value

This project enables:

- **Clear prioritization** → risk is concentrated, not everywhere  
- **Targeted interventions** → focus on high-frequency activities  
- **Scalable insights** → applicable across logistics operations
- **Operational focus** → translates analysis into actionable safety priorities

---

## 📄 License

This project is licensed under the MIT License.

---

## 👤 Author

**Giulio Galbiati**  
Data Analyst  

---

## 📫 Contact

* Email: galbiati.giulio@gmail.com
* LinkedIn: https://www.linkedin.com/in/giulio-galbiati-bg
