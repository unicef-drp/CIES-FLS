# MICS6 Foundational Learning Skills Analysis
### A Demonstration Repository for Working With MICS6 Foundational Learning Data in R

This repository contains demonstration code and data for analyzing MICS6 Foundational Learning Skills (FLS) microdata across three countries: **Bangladesh**, **Nigeria**, and **Suriname**.

It is designed for use in a guided workshop, where you will:
- Learn how to process MICS microdata
- Construct foundational reading and numeracy indicators
- Use pre-built UNICEF datasets using the `unicefData` package
- Create and interpret visualizations

No prior experience with R or GitHub is required.

⚠️ **Please read this entire README before starting the workshop**
This document explains the full workshop structure, how to set up your environment, and how to run the code.
👉 Taking 5–10 minutes to read it carefully will make the workshop much easier to follow

---

## Before You Begin: Install Required Software

If you are new to R or GitHub, follow these steps.

### 1. Install R
R is the programming language used in this workshop.

- Go to: https://cran.r-project.org  
- Click **"Download R for..."** and choose your operating system  
- Install using the default settings  

---

### 2. Install RStudio
RStudio is the application we use to write and run R code.

- Go to: https://posit.co/download/rstudio-desktop  
- Download **RStudio Desktop (free version)**  
- Install using the default settings  

⚠️ You must install R before RStudio.

---

### 3. Install GitHub Desktop (Recommended)

GitHub Desktop helps you download and manage the repository easily (no coding needed).

- Go to: https://desktop.github.com  
- Download and install  
- You can skip signing in — no account is required  

---

## Getting Started

### Step 1 — Download the Repository (Clone)

“Cloning” means downloading a full copy of this project to your computer.

**Option A — Using GitHub Desktop (recommended):**
1. Open **GitHub Desktop**
2. Go to **File → Clone Repository**
3. Click the **URL** tab
4. Paste in this repository's URL: `https://github.com/unicef-drp/CIES-FLS.git`
5. Under **"Local Path"**, choose a location on your computer where you want to save the repository (e.g., your Documents folder)
6. Click **Clone**

---

**Option B — Without GitHub Desktop:**
1. Go to the repository page in your browser  
2. Click the green **Code** button  
3. Click **Download ZIP**  
4. Extract the folder to your computer  

---

### Step 2 — Open the Project in RStudio

⚠️ **This is the most important step**

1. Open the folder you just downloaded  
2. Double-click: `CIES_Workshop_MICS_FLS.Rproj`


This opens the project in RStudio.

---

### Step 3 — Check That the Project Is Open

In RStudio:

- Look at the **top-right corner**
- You should see:
 ```
 CIES_Workshop_MICS_FLS
 ```
- If it says **"Project: (None)"**, something went wrong — reopen the `.Rproj` file

---

### Step 4 — Navigate the Files

In RStudio:

- Look at the **bottom-right panel → "Files" tab**
- This shows all folders in the project
- You can click through folders and open scripts from here

👉 Always open scripts from the **Files pane**, not from outside RStudio

---

## Important Concept: No File Paths Needed

You do **not** need to manually set file paths.

Because you opened the `.Rproj` file:
- R automatically knows where your project with all code and data is
- All scripts will run without modification

If the project is not opened correctly → paths will break.

---

## Repository Structure

```
├── Profile.R                          	# Setup script: packages and filepaths
│
├── 00_documentation/                  	# Background materials
│   ├── Questionnaires
│   └── Survey findings reports
│
├── 01_process_fls_microdata/          	# MICS6 microdata processing
│   ├── 011_data/                      	# Raw MICS FLS microdata (3 countries)
│   ├── 012_code/
│   │   ├── 0121_merge_data.R          	# Demo: merging MICS6 datasets
│   │   ├── 0122_example_BGD_NGA.R     	# Demo: processing Bangladesh & Nigeria
│   │   ├── 0123_practice_SUR.R        	# ★ Your turn: process Suriname's data
│   │   └── 0124_unicefData_demo.R     	# Demo: how to use the unicefData package
│   └── 013_output/                    	# Output from processing scripts
│
└── 02_learning_gradient_analysis/     	# Visualization and analysis
    ├── 021_data/                      	# Fully processed FLS data (all countries)
    ├── 022_code/
    │   └── 0221_learning_gradient_demo.R    	# Reproduces FLS learning gradient plots
    └── 023_output/                    	# Saved .png visualizations
```


---

## Workshop Steps

### Step 0 — Setup

- Install R and RStudio  
- Download the repository  
- Open `CIES_Workshop_MICS_FLS.Rproj`  
- Open scripts from the **Files pane (bottom-right)**  

---

### Step 1 — Merge MICS6 Modules

Script: `01_process_fls_microdata/012_code/0121_merge_data.R`

Learn how to:
- Load MICS datasets
- Merge household and child modules
- Understand identifiers (HH1, HH2, LN)

---

### Step 2 — Calculate Foundational Learning Indicators

#### Example (follow along)

Script: `0122_example_BGD_NGA.R`


Learn how to:
- Filter the correct population
- Detect reading structure
- Calculate:
  - Foundational reading
  - Foundational numeracy

---

#### Practice (your turn)

Script: `0123_practice_SUR.R`


Your task:
- Copy **selected parts** of the example script
- Adapt them to process **Suriname**

This helps you understand:
- What each step does
- How the processing pipeline works

---

#### ⭐ Bonus (optional)

If you finish early:
- Create your own simple visualizations
- Explore differences by:
  - Sex
  - Wealth
  - Area

---

### Step 3 — Use UNICEF Data Directly  

Script:  
`0124_unicefData_demo.R`

Learn how to:
- Access harmonized indicators directly through the new unicefData package
- Compare countries quickly  
- Understand differences between microdata vs aggregated data  

---

### Step 4 — Learning Gradient Analysis

Script: `02_learning_gradient_analysis/022_code/0221_learning_gradient_demo.R`


Learn how to:
- Use processed MICS data
- Reproduce learning gradient charts
- Compare countries

---

## 🧠 If You Are New to R  

Think of **R as a calculator, but much more powerful**.

- You give it instructions (code)
- It gives you results

---

### ▶️ How to Run Code  

- Place your cursor on a line  
- Press **Ctrl + Enter**  
- Or click **Run**

---

### ▶️ Running a Full Script  

You can run all code in a file by clicking **Source** (top-right of the top-left pane).

---

### ⚠️ Messages You Will See  

- **Messages / Warnings** → Not a problem  
- **Errors** → Something is wrong and needs fixing  

---

### 🤖 Tip: Use AI to Help  

If you get stuck:

- Ask people around you to help / the facilitator
- Otherwise, use AI!:
	- Copy your code  
	- Copy the error message  
	- Paste both into AI  

This is a very normal and effective way to debug.

---

## Data Sources

This repository uses publicly available MICS6 data from UNICEF.

More information:
https://mics.unicef.org

---

## Troubleshooting

**Top-right says "No Project"**
→ Open `CIES_Workshop_MICS_FLS.Rproj`

**File paths not working**
→ You did not open the project correctly

**Packages fail to install**
→ Run: `install.packages("package_name")`


---

*Prepared for workshop demonstration. No prior coding experience required.*
