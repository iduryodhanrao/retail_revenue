# 🛒 Retail Revenue Analysis Dashboard

## 📌 Executive Summary
This project examines the U.S. retail industry to identify which product categories generate the highest revenue and employment. Using data from the Census Bureau (2007, 2012, 2017), the analysis evaluates patterns across sectors such as automotive, grocery, and general merchandise. Hypothesis testing with ANOVA reveals significant revenue differences among retail subcategories.

---

## ❓ Problem Statement & Hypothesis
- **Research Question**: Which retail product category generates the highest revenue in the U.S.?
- **Null Hypothesis (H₀)**: No significant difference in revenue across categories.
- **Alternative Hypothesis (H₁)**: Significant differences exist in revenue generation between categories.

---

## 🔬 Data Analysis Process

- 📥 **Source**: U.S. Census Bureau's Economic Census
- 🧮 **Tools**: SAS University Edition for analysis, Tableau Public for visualization
- ⚙️ **Process**:
  - Imported pipe-delimited files and cleaned dataset
  - Grouped retail categories using NAICS codes
  - Performed univariate and bivariate analysis
  - Conducted ANOVA (GLM procedure) with Tukey adjustments
  - Created log transformations for non-normally distributed variables

---

## 📊 Dashboard Overview

Built using Tableau Public to visualize revenue and employment patterns:

1. 📈 Revenue trends (2007–2017) by retail subcategory  
2. 🌲 Tree map showing yearly revenue contribution  
3. 🟢 Bubble charts for establishment counts  
4. 👥 Employee distribution across categories  

🔗 **[View Tableau Dashboard](https://public.tableau.com/app/profile/duryodhan.rao/viz/USRetailAnalysis/Dashboard1)**
<img width="1404" height="775" alt="image" src="https://github.com/user-attachments/assets/93e46530-838d-455e-820d-843416015494" />

---

## 📈 Key Findings

- 🚗 Motor vehicles & parts dealers (NAICS 441) top revenue generators across all years  
- 🛍️ General merchandise stores overtaken by food & beverage by 2017  
- ⛽ Gasoline stations show revenue decline post-2012  
- 💻 Online retailers show steady positive revenue growth  
- 🧮 Five categories contribute nearly 70% of total retail revenue  
- 🧑‍💼 Food & beverage sector leads in company count and job creation  
- 📉 Electronics and appliance stores show declining employment rates

---

## ⚠️ Limitations

- Dataset last updated in 2017; no real-time or annual data granularity  
- SAS and Tableau Public have local access and feature constraints  
- Tool limitations include performance and data connectivity restrictions

---

## 🔍 Proposed Actions

- Analyze regional/population factors for deeper insights  
- Investigate electronics retail trends and workforce reduction  
- Explore strategic opportunities in non-store (online) retail channels

---

## 🎯 Expected Benefits

Entrepreneurs, investors, and retailers can leverage insights from this study to:
- Identify high-performing retail categories  
- Evaluate employment and infrastructure trends  
- Make informed investment decisions in the U.S. retail sector

---

## 📚 References

- [US Census Bureau](https://www.census.gov/about/what.html#par_textimage)  
- [Tableau Public for Associations](https://associationanalytics.com/2015/07/20/tableau-public-for-associations/)  
- [The Balance – Retail Industry Overview](https://www.thebalance.com/what-is-retailing-why-it-s-important-to-the-economy-3305718)
