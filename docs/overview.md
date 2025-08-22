# Project Overview: Big Data Smart Home

## 1. Abstract
This work focuses on the design of a database system for **LSBU Smart Home**, automating the management of clients, buildings, IoT sensors, and installations. Queries, triggers, and stored procedures ensure efficiency, prevent conflicts, and enable advanced reporting. The system supports inventory control, staff allocation, billing, and data visualisation through Tableau.

## 2. Introduction
Smart home technology requires reliable data management. This project delivers a prototype information system for LSBU Smart Home, covering:
- Client and building management  
- Sensor and controller design  
- Installation and staff assignment  
- Inventory and suppliers  
- Billing and payments  

## 3. Database Design
- **Entity Relationship Diagram (ERD)** with 20 tables  
- Fully normalised to **3NF/BCNF**  
- Includes bridge tables (e.g., ClientBuilding, TeamMember)  
- Functional dependencies verified  

## 4. Implementation
- SQL Server used to implement tables, constraints, and data insertion  
- Stored procedures and triggers (e.g., `trg_PreventDoubleBooking`)  
- Queries covering:
  - Top/bottom clients by spend  
  - Supplier Wi-Fi order status  
  - Specialist staff availability  
  - Automatic prevention of double booking  
  - Costed device lists by installation period  

## 5. Data Visualisation
Dashboards created in **Tableau** include:
- Top/bottom clients  
- Supplier performance  
- Staff availability  
- Stock distribution  
- Revenue over time  
- Client revenue vs targets  

## 6. Final Report
The detailed methodology, SQL scripts, queries, and dashboards are available in the **academic report**:  
👉 [`report/BigDataSmartHome_Public.pdf`](../report/BigDataSmartHome_Public.pdf)

## 7. Video Demonstration
- GitHub Pages Dashboard: https://raulcimpe.github.io/Dashboard/  
- Microsoft Stream / Google Drive links (see report for details)

## 8. References
See final report for a complete reference list.
