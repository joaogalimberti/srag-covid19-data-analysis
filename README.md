# 📊 SRAG MONITORING DUE TO COVID-19 IN ESPÍRITO SANTO (ES)

This is the final project for **Module 1** of the Data Analysis Training Program for Health Management Qualification.  
The report focuses on the analysis of **Severe Acute Respiratory Syndrome (SARS)** cases related to COVID-19 in the state of Espírito Santo, Brazil, between **2020 and 2024**.

---

## 📖 About the Project

The main objective of this project is to present, using data analysis and visualization techniques, the evolution of SARS due to COVID-19 during and after the pandemic in Espírito Santo.  
The analysis helps to identify trends, age group variations, and yearly distributions, contributing to a clearer understanding of the disease’s impact on the population of Espírito Santo.

---

## 📚 Features

- **Data Import:** Loads CSV files extracted from OpenDataSUS containing SARS case notifications from 2020 to 2024.  
- **Regional Filtering:** Focused exclusively on data from the state of Espírito Santo (ES).  
- **Data Cleaning & Preparation:** Selects relevant columns, handles missing values, and standardizes age information.  
- **Temporal & Demographic Analysis:** Generates charts by age group and year to identify patterns and trends.  
- **Graphical Visualization:** Uses the `ggplot2` package to display clear and informative graphics.

---

## 💻 Technologies Used

- **R (RStudio):** Programming language and environment used for data manipulation, analysis, and visualization.  
- **Quarto:** Tool used to generate the final HTML report.  
- **ggplot2:** R package used to create statistical graphics.  
- **OpenDataSUS:** Official data source for SARS cases in Brazil.

---

## 📦 Datasets Used

The data was obtained directly from the **OpenDataSUS** platform. Direct links to the datasets:

- [SARS 2020](https://opendatasus.saude.gov.br/dataset/srag-2020)
- [SARS 2021](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024)
- [SARS 2022](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024)
- [SARS 2023](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024)
- [SARS 2024](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024)

---

## 📊 Sample Analyses

### ➤ **Case distribution by age group**
Reveals which age groups were most affected by COVID-19 over time.

### ➤ **Yearly case trends**
Highlights the peaks and declines in SARS notifications across the years of the pandemic.

---

## ⚠️ Notes

- **Code Execution:** Code used in the analysis is not executed automatically in this report due to large data volume. It is recommended to run the scripts in an environment like RStudio.  
- **Classification Source & Data Dictionary:**  
  - [SRAG - Hospitalized Data Dictionary (in Portuguese)](https://www.saude.ba.gov.br/wp-content/uploads/2021/06/Dicionario_de_Dados_SRAG_Hospitalizado_23.03.2021.pdf)

---

## 📘 Additional Resources

For more information on the topics discussed in this report:

- 🔗 [OpenDataSUS Portal](https://opendatasus.saude.gov.br/)
- 🔗 [R Documentation](https://www.r-project.org/)
- 🔗 [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- 🔗 ICEPi Training Course *(add official link if available)*

---

**Project developed by João Vitor Galimberti Contarato**  
As part of the training course offered by the **Instituto Capixaba de Ensino, Pesquisa e Inovação em Saúde (ICEPi)**.
