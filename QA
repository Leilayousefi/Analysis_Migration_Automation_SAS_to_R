Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore
 
@Leila-Yousefi 
moj-analytical-services
/
CRC_Workforce_QA_Tool
Internal
generated from moj-analytical-services/rshiny-template
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
CRC_Workforce_QA_Tool/00_script/qa_functions.R
@karthikkommalapatimoj
karthikkommalapatimoj changes as per email on 13 Nov
Latest commit 0a0ea2f on 17 Nov 2020
 History
 2 contributors
@sazizi123@karthikkommalapatimoj
2346 lines (1724 sloc)  110 KB
   

# Libraries ----
library(tidyverse)
library(tidylog)
library(readxl)
library(janitor)
library(openxlsx)
library(lubridate)

# Template ----
mapping_data_file_path <- "01_templates/mapping_tables.xlsx"


# ---------------------------- Column mapping data: data types ---------------------

excel_col_types <- c("Text", "Date", "Percentage", "Number", "Currency", "Character")
r_col_types     <- c("text", "date", "numeric", "numeric", "numeric", "text")
data_types_list <- list(excel_types = excel_col_types, 
                        r_types = r_col_types)

data_types_tbl <- dplyr::as_tibble(data_types_list) %>% 
    mutate(excel_types = str_to_lower(excel_types))
#-------------------------------------------------------------------------------------



# Functions ------

# Headers names function ----


fn_headers_tbl <- function(){
    
    '"
    Imports mapping data and maps with R data types tibble
    
    param  : mapping_data_file_path -> Path to the mapping file
    type   : excel file
    param  : data_types_tbl -> tibble with data to match R data types
    type   : tibble
    
    return : tibble | data frame
    "'
    # Extracts headers names and Data types
    mapping_data_tbl <- readxl::read_excel(path  = mapping_data_file_path,
                                           sheet = "Columns and Mapping") %>% 
        janitor::clean_names() %>% 
        dplyr::mutate(column_type = stringr::str_to_lower(column_type)) %>% 
        dplyr::left_join(data_types_tbl, by = c("column_type" = "excel_types"))
    
    return(mapping_data_tbl)
}

# Data extract function -----

fn_workforce_data_extract <- function(headers_tbl, qa_file_path, locations_data = F){
    
    '"
    Extracts Workforce and Locations data from the QA file selecte and converts column types R Data types
    
    param  : headers_tbl -> tibble with header names and R data types
    type   : tibble
    param  : qa_file_path -> Path to the QA file
    type   : excel file
    param  : locations_data -> select TRUE or T to import locations data
    type   : bollean
    
    return : tibble | data frame
    "'
    
    # Headers data 
    headers_list <- headers_tbl %>% 
        pull(mapping)
    # column types
    column_types_list <- headers_tbl %>% 
        pull(r_types)
    # Extract data from Staffing data tab
    if(locations_data == F) {
        
        data <- readxl::read_excel(path = qa_file_path,
                                   sheet = "Staffing Details",
                                   skip = 7,
                                   col_names = headers_list,
                                   col_types = column_types_list, 
                                   range = readxl::anchored(anchor = "B8",
                                                            dim    = c(NA,length(headers_list)))) %>% 
            tidylog::mutate(row_id = row_number()) %>% 
            tidylog::select(row_id, everything()) %>% 
            tidylog::mutate_if(lubridate::is.POSIXct, as.Date)
        
    } else {
        
        data <- readxl::read_excel(path = qa_file_path,
                                   sheet = "Locations",
                                   skip = 3,
                                   col_types = rep("text",6), 
                                   range = readxl::anchored(anchor = "B4",
                                                            dim    = c(NA,6))) %>% 
            tidylog::mutate(locations_row_id = row_number()) %>% 
            tidylog::select(locations_row_id, everything()) %>% 
            janitor::clean_names()
    }
    
    return(data)
}

fn_replace_na <- function(wf_data, replace_na = T){
    
    '"
    Replaces all numeric olumns values with 0 where null
    
    param  : wf_data -> Imported QA Data
    type   : tibble
    param  : replace_na -> select TRUE or T to replace NAs with 0s
    type   : boolean
    
    return : tibble | data frame
    "'
    # (Replace NA's ----
    if(replace_na) wf_data <- wf_data %>%
            tidylog::mutate_if(is.numeric, list(~ replace_na(., 0.00))) 
    
    return(wf_data)
}


# Extract CRC name ----

func_crc_name <- function(excel_file_path, sheet, cell_ref){
    
    # Returns CRC name, if no CRC names was found returns "TBC"
    '"
    Returns CRC name, if no CRC names was found returns "TBC"
    
    param  : excel_file_path -> file path
    type   : character | string
    param  : sheet -> sheet name to extract CRC name form
    type   : character | string
    param  : cell_ref -> Reference cell value
    type   : character | string
    
    return : character | string
    "'
    crc_name <- read_excel(excel_file_path, sheet = sheet, range = cell_ref) %>% 
        colnames()
    
    chr <- character(0)
    
    if (identical(chr, crc_name)) {
        return(crc_name <- "TBC")
    } else {
        return(crc_name )
    }
}



# Missing data fields function ----

fn_missing_data_fields <- function(headers_tbl, target_tbl, groupbysubcontractor = F){
    
    '"
    Calculates missing row values for specific columns
    
    param  : headers_tbl -> Headers names and data types table
    type   : tibble
    param  : target_tbl -> Workforce Data before NAs are replaced
    type   : tibble
    parm   : groupbysubcontractor -> select TRUE or T to export output by Subcontractor Name (default False)
    type   : boolean
    
    return : tibble | data frame
    "'
    # select relavent columns 
    missing_columns_list <- headers_tbl %>% 
        tidylog::filter(record_if_field_missing != "0") %>% 
        pull(mapping) %>% 
        c("pct_Other_Activity")
    
    result_tbl <- target_tbl %>% 
        select(missing_columns_list) %>% 
        tidylog::mutate(
            
            Subcontractor_Name_Original = Subcontractor_Name, 
            
            Subcontractor_Name                      = dplyr::case_when((Engaging_Org != "Subcontractor" | 
                                                                            Engaging_Org != "Supply Chain" |
                                                                            Agency_flag != "Yes") ~ "Not Null",
                                                                       T ~ Subcontractor_Name),
            
            Other_Contract_Type                     = dplyr::case_when(Contract_Type != "Other" ~ "Not Null",
                                                                       is.na(Contract_Type) ~ "Not Null",
                                                                       T~ Other_Contract_Type),
            
            Contract_End_Date                       = dplyr::case_when(Contract_Type != "Fixed term contract" ~ as.Date("2099-12-31"),
                                                                       T~ Contract_End_Date),
            
            Previous_Staff_Transfer                 = dplyr::case_when(Employment_Status != "Employee" ~ "Not Null",
                                                                       Employment_Status != "Worker" ~ "Not Null",
                                                                       Vacancy_flag == "Yes" ~ "Not Null",
                                                                       T~ Previous_Staff_Transfer),
            
            Previous_Staff_Transfer_Date_and_Name   = dplyr::case_when(Previous_Staff_Transfer != "Yes" ~ "Not Null",
                                                                       T~ Previous_Staff_Transfer_Date_and_Name),
            
            
            Subcontractor_Former_CRC_Employee_and_Transferred = dplyr::case_when(Engaging_Org != "Subcontractor" | 
                                                                                     Engaging_Org != "Supply Chain" ~ "Not Null",
                                                                                 Vacancy_flag == "Yes" ~ "Not Null",
                                                                                 T~ Subcontractor_Former_CRC_Employee_and_Transferred),
            
            Agency_flag                             = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       T~ Agency_flag),
            
            Reason_for_Agency                       = dplyr::case_when(Agency_flag != "Yes" ~ "Not Null",
                                                                       T~ Reason_for_Agency),
            
            Date_of_Birth                           = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       T~ Date_of_Birth),
            
            Long_Term_Absence                       = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Long_Term_Absence ),
            
            Date_Absence_Started                    = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       Long_Term_Absence == "None" ~ as.Date("2099-12-31"),
                                                                       T ~ Date_Absence_Started),
            Expected_Return_Date                    = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       Long_Term_Absence == "None" ~ as.Date("2099-12-31"),
                                                                       T ~ Expected_Return_Date),            
            Start_Date                              = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       T ~ Start_Date),
            Continuous_Service_Date_Employment      = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       T ~ Continuous_Service_Date_Employment), 
            Continuous_Service_Date_RMO             = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       T ~ Continuous_Service_Date_RMO), 
            
            Assignment_Supporting_Info              = dplyr::case_when(
                Assignment != "Not Assigned" ~ "Not Null",
                T ~ Assignment_Supporting_Info
                
            ),
            
            
            Other_Job_Title                         = dplyr::case_when(as.numeric(pct_Other_Activity) <= 0.00 ~ "Not Null",
                                                                       is.na(pct_Other_Activity) ~ "Not Null",
                                                                       T~ Other_Job_Title ),
            Other_Job_Description                   = dplyr::case_when(as.numeric(pct_Other_Activity) <= 0.00 ~ "Not Null",
                                                                       is.na(pct_Other_Activity) ~ "Not Null",
                                                                       T~ Other_Job_Description ),
            FTE_Equivalent                          = dplyr::case_when(Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Sessional_flag    == "Yes (adhoc)" ~ 0.00,
                                                                       Sessional_flag    == "Yes (regular)" ~ 0.00,
                                                                       Sessional_flag    == "Yes" ~ 0.00,
                                                                       T~ FTE_Equivalent ),
            FTE_in_Hours_per_Week                   = dplyr::case_when(Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Sessional_flag    == "Yes (adhoc)" ~ 0.00,
                                                                       Sessional_flag    == "Yes (regular)" ~ 0.00,
                                                                       Sessional_flag    == "Yes" ~ 0.00,
                                                                       T ~ FTE_in_Hours_per_Week),
            
            Contracted_Hours_per_Week               = dplyr::case_when(Contract_Type  == "Zero-hour contract / Casual contract"  ~ 0.00,
                                                                       Sessional_flag    == "Yes (adhoc)" ~ 0.00,
                                                                       T~ Contracted_Hours_per_Week),
            
            Average_Hours_Worked_per_Week           = dplyr::case_when(Sessional_flag != "Yes (adhoc)" ~ 0.00,
                                                                       Sessional_flag != "Yes (regular)" ~ 0.00,
                                                                       Sessional_flag != "Yes" ~ 0.00,
                                                                       Contract_Type  != "Zero-hour contract / Casual contract"  ~ 0.00,
                                                                       T ~ Average_Hours_Worked_per_Week),
            
            
            Other_Pay_Band                          = dplyr::case_when(Pay_Band != "Other" ~ "Not Null",
                                                                       T~ Other_Pay_Band),
            
            Basic_Salary                            = dplyr::case_when(Sessional_flag    != "Yes (adhoc)" ~ 0.00,
                                                                       Sessional_flag    != "Yes (regular)" ~ 0.00,
                                                                       Sessional_flag    != "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T ~ Basic_Salary),
            FTE_Salary                              = dplyr::case_when(Sessional_flag    != "Yes (adhoc)" ~ 0.00,
                                                                       Sessional_flag    != "Yes (regular)" ~ 0.00,
                                                                       Sessional_flag    != "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T ~ FTE_Salary),
            
            Pay_Rate_per_Day                        = dplyr::case_when(Employment_Status ==  "Employee" ~ 0.00,
                                                                       Basic_Salary != "" ~ 0.00,
                                                                       Pay_Rate_per_Hour != "" ~ 0.00,
                                                                       T ~ Pay_Rate_per_Day),
            
            Pay_Rate_per_Hour                       = dplyr::case_when(Employment_Status ==  "Employee" ~ 0.00,
                                                                       Basic_Salary != "" ~ 0.00,
                                                                       Pay_Rate_per_Day != "" ~ 0.00,
                                                                       T ~ Pay_Rate_per_Hour),
            
            Pay_Review_Frequency                    = dplyr::case_when( Agency_flag       == "Yes" ~  "Not Null",
                                                                        Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                        T ~ Pay_Review_Frequency),
            
            Next_Pay_Review_Date                    = as.Date("2099-12-31"),
            
            Pay_Protection                          = dplyr::case_when(Agency_flag       == "Yes" ~  "Not Null",
                                                                       Vacancy_flag      == "Yes" ~  "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~  "Not Null",
                                                                       T~ Pay_Protection),
            Salary_Once_Pay_Protection_Ends         = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       Pay_Protection    == "No" ~ 0.00,
                                                                       T ~ Salary_Once_Pay_Protection_Ends),
            
            Pay_Protection_End_Date                 = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       Pay_Protection    == "No" ~ as.Date("2099-12-31"),
                                                                       T ~ Pay_Protection_End_Date),
            
            Enhanced_Pension_Benefits_on_Redundancy_or_Retirement   = dplyr::case_when(Agency_flag       == "Yes" ~ "Not Null",
                                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                                       T~ Enhanced_Pension_Benefits_on_Redundancy_or_Retirement),
            
            Redundancy_Pay_Entitlement              = dplyr::case_when(Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Redundancy_Pay_Entitlement),
            
            Income_Protection                       = dplyr::case_when(Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T ~ Income_Protection),
            
            Level_of_Income_Protection              = dplyr::case_when(Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       Income_Protection == "No" ~ 0.00,
                                                                       Income_Protection == "Unknown" ~ 0.00,
                                                                       T~ Level_of_Income_Protection),
            
            Company_Private_Medical_Cover           = dplyr::case_when(Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Company_Private_Medical_Cover),
            
            Private_Medical_Cover_Annually          = dplyr::case_when(Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Private_Medical_Cover_Annually),
            
            Life_Assurance_Cover                    = dplyr::case_when(Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Life_Assurance_Cover),
            
            Contractual_Overtime                    = dplyr::case_when(Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Contractual_Overtime),
            
            Overtime_Hourly_Rate                    = dplyr::case_when(Contractual_Overtime       <= 0.00 ~ 0.00,
                                                                       is.na(Contractual_Overtime) ~ 0.00,
                                                                       T~ Overtime_Hourly_Rate),
            
            Overtime_Paid_last_12months             = dplyr::case_when(Agency_flag       == "Yes" ~ 0.00,
                                                                       Vacancy_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Overtime_Hourly_Rate),
            
            Baseline_Vetting_Held                   = dplyr::case_when( Vacancy_flag == "Yes"  ~ "Not Null",
                                                                        T~ Baseline_Vetting_Held),
            
            Baseline_Vetting_Date                   = dplyr::case_when( Vacancy_flag          == "Yes"  ~ as.Date("2099-12-31"),
                                                                        Baseline_Vetting_Held == "No" ~ as.Date("2099-12-31"),
                                                                        is.na(Baseline_Vetting_Held) ~ as.Date("2099-12-31"),
                                                                        T~ Baseline_Vetting_Date),         
            
            DBS_Check                               = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       T~ DBS_Check),
            
            DBS_Check_Date                          = dplyr::case_when(Vacancy_flag == "Yes" ~ as.Date("2099-12-31"),
                                                                       DBS_Check == "None" ~ as.Date("2099-12-31"),
                                                                       is.na(DBS_Check) ~ as.Date("2099-12-31"),
                                                                       # stringr::str_to_lower(DBS_Check, locale = "en") == "none" ~ as.Date("2099-12-31"),
                                                                       T~ DBS_Check_Date), 
            
            Other_Vetting_1                         = "Not Null",
            
            Other_Vetting_1_Date                    = "Not Null",
            
            Other_Vetting_2                         = "Not Null",
            
            Other_Vetting_2_Date                    = "Not Null",
            
            Authorised_Officer_of_the_Contractor    = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       T~ Authorised_Officer_of_the_Contractor),
            
            Probation_Qualification_Level           = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       T~ Probation_Qualification_Level), 
            
            Details_of_Qualification                = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       is.na(Probation_Qualification_Level)  ~ "Not Null",
                                                                       Probation_Qualification_Level == "None"  ~ "Not Null",
                                                                       T~ Details_of_Qualification),
            
            Other_Probation_Qualification_Details   = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       is.na(Probation_Qualification_Level)  ~ "Not Null",
                                                                       Probation_Qualification_Level == "None"  ~ "Not Null",
                                                                       Details_of_Qualification != "Other" ~ "Not Null",
                                                                       T~ Other_Probation_Qualification_Details),
            
            Annual_Leave_Entitlement                = dplyr::case_when(Vacancy_flag == "Yes" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Annual_Leave_Entitlement),
            
            Method_of_Calculating_Holiday           = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Method_of_Calculating_Holiday),
            
            Additional_Annual_Leave_Bought          = dplyr::case_when(Vacancy_flag == "Yes" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Additional_Annual_Leave_Bought),
            
            Service_Day_Entitlement                 = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Service_Day_Entitlement),
            
            Privilege_Days                          = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Privilege_Days),
            
            Notice_Period_by_Employer               = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                       Agency_flag       == "Yes" ~ 0.00,
                                                                       Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                       T~ Notice_Period_by_Employer),
            
            Apprenticeship                          = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       T~ Apprenticeship),
            
            Apprenticeship_End_Date                 = dplyr::case_when(Vacancy_flag         == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag          == "Yes" ~ as.Date("2099-12-31"),
                                                                       Apprenticeship       == "No" ~ as.Date("2099-12-31"),
                                                                       is.na(Apprenticeship) ~ as.Date("2099-12-31"),
                                                                       T~ Apprenticeship_End_Date),
            Undertaking_Qualification               = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       T~ Undertaking_Qualification),
            Secondment                              = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       Employment_Status ==  "Worker" ~ "Not Null",
                                                                       T~ Secondment),
            Where_on_Secondment                     = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       Employment_Status ==  "Worker" ~ "Not Null",
                                                                       Secondment        ==  "None" ~ "Not Null",
                                                                       is.na(Secondment)  ~ "Not Null",
                                                                       T~ Where_on_Secondment),
            Secondment_End_Date                              = dplyr::case_when(Vacancy_flag == "Yes" ~ as.Date("2099-12-31"),
                                                                                Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                                Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                                Employment_Status ==  "Worker" ~ as.Date("2099-12-31"),
                                                                                Secondment        ==  "None" ~ as.Date("2099-12-31"),
                                                                                T~ Secondment_End_Date),
            Secondment_Job_Role                              = dplyr::case_when(Vacancy_flag == "Yes" ~ "Not Null",
                                                                                Agency_flag       == "Yes" ~ "Not Null",
                                                                                Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                                Employment_Status ==  "Worker" ~ "Not Null",
                                                                                Secondment        ==  "None" ~ "Not Null",
                                                                                is.na(Secondment) ~ "Not Null",
                                                                                T~ Secondment_Job_Role),
            
            Pension_Scheme_Name                     = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Pension_Scheme_Name),
            Other_Pension_Scheme_Name_and_Website   = dplyr::case_when(Vacancy_flag        == "Yes" ~ "Not Null",
                                                                       Agency_flag         == "Yes" ~ "Not Null",
                                                                       Employment_Status   ==  "Self-employed contractor" ~ "Not Null",
                                                                       Pension_Scheme_Name != "Other" ~ "Not Null",
                                                                       is.na(Pension_Scheme_Name) ~ "Not Null",
                                                                       T~ Other_Pension_Scheme_Name_and_Website),
            
            Not_in_Pension_Scheme_Explanation       = dplyr::case_when(Vacancy_flag        == "Yes" ~ "Not Null",
                                                                       Agency_flag         == "Yes" ~ "Not Null",
                                                                       Employment_Status   ==  "Self-employed contractor" ~ "Not Null",
                                                                       Pension_Scheme_Name != "None" ~ "Not Null",
                                                                       is.na(Pension_Scheme_Name) ~ "Not Null",
                                                                       T~ Not_in_Pension_Scheme_Explanation),
            
            Occupational_or_Personal_Pension        = dplyr::case_when(Vacancy_flag        == "Yes" ~ "Not Null",
                                                                       Agency_flag         == "Yes" ~ "Not Null",
                                                                       Employment_Status   ==  "Self-employed contractor" ~ "Not Null",
                                                                       Pension_Scheme_Name == "None" ~ "Not Null",
                                                                       is.na(Pension_Scheme_Name) ~ "Not Null",
                                                                       T~ Occupational_or_Personal_Pension),
            
            Pension_Eligibility_Start_Date          = dplyr::case_when(Vacancy_flag        == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag         == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status   ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       Pension_Scheme_Name == "None" ~ as.Date("2099-12-31"),
                                                                       is.na(Pension_Scheme_Name) ~ as.Date("2099-12-31"),
                                                                       T~ Pension_Eligibility_Start_Date),
            
            Pension_Scheme_Type                     = dplyr::case_when(Vacancy_flag        == "Yes" ~ "Not Null",
                                                                       Agency_flag         == "Yes" ~ "Not Null",
                                                                       Employment_Status   ==  "Self-employed contractor" ~ "Not Null",
                                                                       Pension_Scheme_Name == "None" ~ "Not Null",
                                                                       is.na(Pension_Scheme_Name) ~ "Not Null",
                                                                       T~ Pension_Scheme_Type),
            
            Total_Pensionable_Earnings              = dplyr::case_when(Vacancy_flag        == "Yes" ~ 0.00,
                                                                       Agency_flag         == "Yes" ~ 0.00,
                                                                       Employment_Status   ==  "Self-employed contractor" ~ 0.00,
                                                                       Pension_Scheme_Name == "None" ~ 0.00,
                                                                       is.na(Pension_Scheme_Name) ~ 0.00,
                                                                       T~ Total_Pensionable_Earnings),
            Total_Non_Pensionable_Earnings          = dplyr::case_when(Vacancy_flag        == "Yes" ~ 0.00,
                                                                       Agency_flag         == "Yes" ~ 0.00,
                                                                       Employment_Status   ==  "Self-employed contractor" ~ 0.00,
                                                                       Pension_Scheme_Name == "None" ~ 0.00,
                                                                       is.na(Pension_Scheme_Name) ~ 0.00,
                                                                       T~ Total_Non_Pensionable_Earnings),
            Employee_Pension_Contribution           = dplyr::case_when(Vacancy_flag        == "Yes" ~ 0.00,
                                                                       Agency_flag         == "Yes" ~ 0.00,
                                                                       Employment_Status   ==  "Self-employed contractor" ~ 0.00,
                                                                       Pension_Scheme_Name == "None" ~ 0.00,
                                                                       is.na(Pension_Scheme_Name) ~ 0.00,
                                                                       T~ Employee_Pension_Contribution),
            Employer_Pension_Contribution           = dplyr::case_when(Vacancy_flag        == "Yes" ~ 0.00,
                                                                       Agency_flag         == "Yes" ~ 0.00,
                                                                       Employment_Status   ==  "Self-employed contractor" ~ 0.00,
                                                                       Pension_Scheme_Name == "None" ~ 0.00,
                                                                       is.na(Pension_Scheme_Name) ~ 0.00,
                                                                       T~ Employer_Pension_Contribution),
            
            
            LGPS_Eligibility_Status                 = "Not Null",
            
            
            LGPS_Retirement_Eligibility_Date        = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       LGPS_Eligibility_Status == "No longer eligible (as taken a promotion to the CRC)" ~ as.Date("2099-12-31"),
                                                                       LGPS_Eligibility_Status == "Other" ~ as.Date("2099-12-31"),
                                                                       is.na(LGPS_Eligibility_Status) ~ as.Date("2099-12-31"),
                                                                       T~ LGPS_Retirement_Eligibility_Date),
            
            LGPS_Additional_Pension_Bought          = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       LGPS_Eligibility_Status == "No longer eligible (as taken a promotion to the CRC)" ~  "Not Null",
                                                                       LGPS_Eligibility_Status == "Other" ~  "Not Null",
                                                                       is.na(LGPS_Eligibility_Status) ~ "Not Null",
                                                                       T~ LGPS_Additional_Pension_Bought),
            Add_Occupational_Pension                = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Add_Occupational_Pension),
            Add_Occupational_Pension_Scheme_Name    = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       Add_Occupational_Pension ==  "No" ~ "Not Null",
                                                                       is.na(Add_Occupational_Pension) ~ "Not Null",
                                                                       T~ Add_Occupational_Pension_Scheme_Name),
            
            Add_Occupational_Pension_Eligibility_Start_Date     = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                                   Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                                   Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                                   Add_Occupational_Pension == "No" ~ as.Date("2099-12-31"),
                                                                                   is.na(Add_Occupational_Pension) ~ as.Date("2099-12-31"),
                                                                                   T~ Add_Occupational_Pension_Eligibility_Start_Date),
            Add_Occupational_Total_Pensionable_Earnings         = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Occupational_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Occupational_Pension) ~ 0.00,
                                                                                   T~ Add_Occupational_Total_Pensionable_Earnings),
            Add_Occupational_Total_Non_Pensionable_Earnings     = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Occupational_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Occupational_Pension) ~ 0.00,
                                                                                   T~ Add_Occupational_Total_Non_Pensionable_Earnings),
            Add_Occupational_Employee_Pension_Contribution      = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Occupational_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Occupational_Pension) ~ 0.00,
                                                                                   T~ Add_Occupational_Employee_Pension_Contribution),
            Add_Occupational_Employer_Pension_Contribution      = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Occupational_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Occupational_Pension) ~ 0.00,
                                                                                   T~ Add_Occupational_Employer_Pension_Contribution),
            
            Add_Personal_Pension                    = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Add_Personal_Pension),
            Add_Personal_Pension_Scheme_Name        = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       Add_Personal_Pension == "No" ~ "Not Null",
                                                                       is.na(Add_Personal_Pension) ~ "Not Null",
                                                                       T~ Add_Personal_Pension_Scheme_Name),
            Add_Personal_Pension_Eligiblity_Start_Date          = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                                   Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                                   Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                                   Add_Personal_Pension == "No" ~ as.Date("2099-12-31"),
                                                                                   is.na(Add_Personal_Pension) ~ as.Date("2099-12-31"),
                                                                                   T~ Add_Personal_Pension_Eligiblity_Start_Date),
            Add_Personal_Total_Pensionable_Earnings             = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Personal_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Personal_Pension) ~ 0.00,
                                                                                   T~ Add_Personal_Total_Pensionable_Earnings),
            Add_Personal_Total_Non_Pensionable_Earnings         = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Personal_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Personal_Pension) ~ 0.00,
                                                                                   T~ Add_Personal_Total_Non_Pensionable_Earnings),
            Add_Personal_Employee_Pension_Contribution          = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Personal_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Personal_Pension) ~ 0.00,
                                                                                   T~ Add_Personal_Employee_Pension_Contribution),
            Add_Personal_Employer_Pension_Contribution          = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                                   Agency_flag       == "Yes" ~ 0.00,
                                                                                   Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                                   Add_Personal_Pension == "No" ~ 0.00,
                                                                                   is.na(Add_Personal_Pension) ~ 0.00,
                                                                                   T~ Add_Personal_Employer_Pension_Contribution),
            
            Any_other_Pension_Scheme_but_opted_out  = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       T~ Any_other_Pension_Scheme_but_opted_out),
            
            Other_Pension_Scheme_Name               = dplyr::case_when(Vacancy_flag      == "Yes" ~ "Not Null",
                                                                       Agency_flag       == "Yes" ~ "Not Null",
                                                                       Employment_Status ==  "Self-employed contractor" ~ "Not Null",
                                                                       Any_other_Pension_Scheme_but_opted_out == "No" ~ "Not Null",
                                                                       is.na(Any_other_Pension_Scheme_but_opted_out) ~ "Not Null",
                                                                       T~ Other_Pension_Scheme_Name),
            Other_Pension_Eligibility_Start_Date    = dplyr::case_when(Vacancy_flag      == "Yes" ~ as.Date("2099-12-31"),
                                                                       Agency_flag       == "Yes" ~ as.Date("2099-12-31"),
                                                                       Employment_Status ==  "Self-employed contractor" ~ as.Date("2099-12-31"),
                                                                       Any_other_Pension_Scheme_but_opted_out == "No" ~ as.Date("2099-12-31"),
                                                                       is.na(Any_other_Pension_Scheme_but_opted_out) ~ as.Date("2099-12-31"),
                                                                       T~ Other_Pension_Eligibility_Start_Date),
            
            Other_Pension_Total_Pensionable_Earnings        = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                               Agency_flag       == "Yes" ~ 0.00,
                                                                               Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                               Any_other_Pension_Scheme_but_opted_out == "No" ~ 0.00,
                                                                               is.na(Any_other_Pension_Scheme_but_opted_out) ~ 0.00,
                                                                               T~ Other_Pension_Total_Pensionable_Earnings),
            Other_Pension_Total_Non_Pensionable_Earnings    = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                               Agency_flag       == "Yes" ~ 0.00,
                                                                               Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                               Any_other_Pension_Scheme_but_opted_out == "No" ~ 0.00,
                                                                               is.na(Any_other_Pension_Scheme_but_opted_out) ~ 0.00,
                                                                               T~ Other_Pension_Total_Non_Pensionable_Earnings),
            Other_Pension_Employee_Pension_Contribution     = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                               Agency_flag       == "Yes" ~ 0.00,
                                                                               Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                               Any_other_Pension_Scheme_but_opted_out == "No" ~ 0.00,
                                                                               is.na(Any_other_Pension_Scheme_but_opted_out) ~ 0.00,
                                                                               T~ Other_Pension_Employee_Pension_Contribution),
            Other_Pension_Employer_Pension_Contribution     = dplyr::case_when(Vacancy_flag      == "Yes" ~ 0.00,
                                                                               Agency_flag       == "Yes" ~ 0.00,
                                                                               Employment_Status ==  "Self-employed contractor" ~ 0.00,
                                                                               Any_other_Pension_Scheme_but_opted_out == "No" ~ 0.00,
                                                                               is.na(Any_other_Pension_Scheme_but_opted_out) ~ 0.00,
                                                                               T~ Other_Pension_Employer_Pension_Contribution)
        )
    
    # Handling groupbysubcontractor inputs
    
    if(groupbysubcontractor) {
        percentage_missing_tbl <- result_tbl %>% 
            tidylog::mutate_if(is.double, as.character) %>% 
            tidyr::pivot_longer(- Subcontractor_Name_Original,
                                names_to = "Columns",
                                values_to = "Values"
            ) %>% 
            tidylog::group_by(Subcontractor_Name_Original, Columns) %>% 
            tidylog::summarise(No_of_Rows_Missing = sum(is.na(Values)),
                               Percentage_Missing = mean(is.na(Values))) %>% 
            tidylog::ungroup() %>%
            tidylog::rename(Subcontractor_Name = Subcontractor_Name_Original)
        
    } else {
        
        percentage_missing_tbl <- result_tbl %>% 
            tidylog::select(- Subcontractor_Name_Original) %>%
            tidylog::mutate_if(is.double, as.character) %>% 
            tidyr::pivot_longer(everything(),
                                names_to = "Columns",
                                values_to = "Values"
            ) %>% 
            tidylog::group_by(Columns) %>% 
            tidylog::summarise(No_of_Rows_Missing = sum(is.na(Values)),
                               Percentage_Missing = mean(is.na(Values))) 
    }
    
    
    percentage_missing_tbl <- percentage_missing_tbl %>% 
        dplyr::arrange(desc(Percentage_Missing)) %>% 
        dplyr::mutate(Percentage_Missing_int = Percentage_Missing) %>% 
        tidylog::mutate(Percentage_Missing = scales::percent(Percentage_Missing, accuracy = 0.01)) %>% 
        tidylog::filter(Percentage_Missing_int > 0.00) %>% 
        tidylog::select(- Percentage_Missing_int) %>%
        tidylog::left_join(select(headers_tbl, column_index, mapping), by = c("Columns" = "mapping"))
    
    return(percentage_missing_tbl)
    
}



#  Missing data fileds by engaging organisation ------

#  Missing engaging organisation: Engaging organisation = CRC OR Parent Organisation, Agency_flag = "No", Sessional_flag = "No" -----

fn_missing_data_fields_by_engaging_organisation <- function(tbl,
                                                            agency_only = F,
                                                            sessional_only = F,
                                                            exclude_agency = F,
                                                            exlude_sessional = F,
                                                            subcontractor = F) {
    
    '"
    Calculates missing row values for specific columns, where Engaging organisation = CRC OR Parent Organisation or Supply Chain or Subcontractors, with a choice to incude or exclude Agency and Sessional flags
    
    param   : tbl -> Workforce Data before NAs are replaced
    type    : tibble
    param   : include_agency -> select TRUE or T to export output where Agency employees are flagged (default False)
    type    : boolean
    param   : incude_sessional -> select TRUE or T to export output where Sessional employees are flagged (default False)
    type    : boolean
    param   : subcontractor -> select TRUE or T to export output where Engaging organisation is Supply Chain or Subcontractorsare  (default False)
    type    : boolean
    
    
    return  : tibble | data frame
    "'
    
    # Handling Subcontrctor request
    
    #if(subcontractor == T & (include_agency == T  | incude_sessional == T )) {
    # message("CAUTION: When Subcontractor is True, groupbysubcontractor parameter should be True too .......")
    #stop("Combination Not Possible: Agency and Sessional Flags Cannot be true when Subcontractor is True")
    #}
    
    if(subcontractor == T) {
        
        tbl <- tbl %>% 
            dplyr::filter(stringr::str_detect(stringr::str_to_lower(Engaging_Org), "chain|contractor"))
        message("CAUTION: When Subcontractor is True, groupbysubcontractor parameter should be True too for grouped outputs.......")
    }
    
    
    # Handling CRC request
    
    #if(include_agency == T  & incude_sessional == T ) {
    #   stop("Combination Not Possible: either include_agency or incude_sessional can be True")
    #}
    
    if(subcontractor == F) {
        tbl <- tbl %>% 
            dplyr::filter(stringr::str_detect(stringr::str_to_lower(Engaging_Org), "crc|parent")) 
    }
    
    
    if(exclude_agency == T & exlude_sessional == T) {
        tbl <- tbl %>% 
            dplyr::filter(Agency_flag != "Yes") %>% 
            dplyr::filter(Sessional_flag != "Yes (adhoc)" |
                              Sessional_flag != "Yes (regular)")
    }
    
    
    if(agency_only == T ) {
        tbl <- tbl %>% 
            dplyr::filter(Agency_flag == "Yes")
    } 
    
    if(sessional_only == T ) {
        tbl <- tbl %>% 
            dplyr::filter(Sessional_flag == "Yes (adhoc)" |
                              Sessional_flag == "Yes (regular)")
    }
    
    return(tbl %>% 
               tidylog::select(- row_id))
    
}




# 1. Missing Engaging Organisation ----

fn_missing_engaging_organisation <- function(tbl){
    
    '"
    Returns table where  Engaging_Org is not CRC  or Parent Org or Supply Chain or Subcontractor
    
    param   : tbl -> Workforce Data before NAs are replaced
    type    : tibble
    return  : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        dplyr::mutate(Engaging_Org_lowercase = Engaging_Org %>% stringr::str_to_lower()) %>% 
        dplyr::filter((Engaging_Org_lowercase != "crc" & 
                           Engaging_Org_lowercase != "parent organisation" &
                           Engaging_Org_lowercase != "supply chain" &
                           Engaging_Org_lowercase != "subcontractor") |
                          is.na(Engaging_Org_lowercase)) %>%
        dplyr::select(-Engaging_Org_lowercase, -row_id)
    
    return(tbl)
}




# 2.  Duplicates ----


fn_duplicates <- function(tbl, addn_check = F){
    
    '"
    Identifies duplicates based on EmployeeID and Job Title
    
    param  : tbl -> Workforce Cleaned Data
    type   : tibble
    param  : addn_check -> Include in additional check list
    type   : boolean
    
    
    return : tibble | data frame
    "'
    
    dups_list <- tbl %>% 
        tidylog::select(Employee_ID, Job_Title) %>% 
        tidylog::group_by(Employee_ID, Job_Title) %>% 
        tidylog::filter(n() > 1) %>% 
        tidylog::distinct() %>% 
        dplyr::ungroup() %>% 
        unlist()
    
    
    output <- tbl %>% 
        tidylog::filter(Employee_ID %in% dups_list) 
    
    # handling addn_check 
    #------------------- Check 1 : Duplicates check --------------------------------------
    
    if(addn_check) {
        
        return(output %>% 
                   tidylog::mutate(check_type = "#1: Duplicates Check",
                                   check_num = 1))
    } else  {
        return( output %>% 
                    tidylog::select(- row_id))
    }
    
    
}




# 3. FTE ----

fn_fte <- function(tbl){
    
    '"
    Identifies records where FTE is either blank or greater than 1
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    return(
        tbl %>% 
            tidylog::filter((is.na(FTE_Equivalent) |
                                 round(FTE_Equivalent, digits = 2) > 1.00)
            ) %>% 
            tidylog::select(- row_id)
    )
}


# 4.  Functional Area totals -----


fn_functional_area_total <- function(tbl){
    
    '"
    Extracts rows where functional areas do not add upto 100%
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl_temp <- tbl %>% 
        tidylog::select(row_id,
                        starts_with("pct_"),
                        - ends_with("_SM"), 
                        -ends_with("_PIS"),
                        -ends_with("_DF"), 
                        -ends_with("_SF"))
    
    tbl_temp[["sum_func_total"]] <- rowSums(tbl_temp[-1])
    
    over_threshold_list <- tbl_temp %>% 
        tidylog::filter(round(sum_func_total,digits = 2) != 1.00) %>% 
        tidylog::select(row_id) %>% 
        unlist()
    
    return( tbl %>% 
                tidylog::filter(row_id %in% over_threshold_list) %>% 
                tidylog::select(- row_id, 
                                - ends_with("_SM"), 
                                -ends_with("_PIS"),
                                -ends_with("_DF"), 
                                -ends_with("_SF")))
    
    
}


# 5 . Sub Functional Area totals -----
fn_sub_functional_area_total <- function(tbl){
    
    '"
    Extracts rows where functional areas do not add upto 100%
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl_temp <- tbl %>% 
        tidylog::select(row_id,
                        starts_with("pct_"),
                        - ends_with("_SM"), 
                        -ends_with("_PIS"),
                        -ends_with("_DF"), 
                        -ends_with("_SF"))
    
    
    tbl_temp_sm <- tbl %>% 
        tidylog::select(row_id,
                        ends_with("_SM"))
    
    tbl_temp_sm[["total_SM"]] <- rowSums(tbl_temp_sm[-1])
    
    tbl_temp_pis <- tbl %>% 
        tidylog::select(row_id,
                        ends_with("_PIS"))
    
    tbl_temp_pis[["total_PIS"]] <- rowSums(tbl_temp_pis[-1])
    
    tbl_temp_df <- tbl %>% 
        tidylog::select(row_id,
                        ends_with("_DF"))
    
    tbl_temp_df[["total_DF"]] <- rowSums(tbl_temp_df[-1])
    
    tbl_temp_sf <- tbl %>% 
        tidylog::select(row_id,
                        ends_with("_SF"))
    
    tbl_temp_sf[["total_SF"]] <- rowSums(tbl_temp_sf[-1])
    
    
    over_threshold_list <- tbl_temp %>% 
        tidylog::left_join(tbl_temp_sm) %>% 
        tidylog::left_join(tbl_temp_pis) %>% 
        tidylog::left_join(tbl_temp_df) %>% 
        tidylog::left_join(tbl_temp_sf) %>% 
        tidylog::filter(
            round((pct_Sentence_Management - total_SM), digits = 2) !=0.00 |
                round((pct_Probation_Intervention_Services - total_PIS), digits = 2) !=0.00 |
                round((pct_Dynamic_Framework - total_DF), digits = 2) !=0.00 |
                round((pct_Support_or_Corporate_Functions - total_SF), digits = 2) !=0.00
        ) %>% 
        tidylog::select(row_id) %>% 
        unlist()
    
    return( tbl %>% 
                tidylog::filter(row_id %in% over_threshold_list) %>% 
                tidylog::select(- row_id))
    
    
}




# 6 Missing Locations ------

fn_missing_locations <- function(wf_data, locations_data, addn_check = F) {
    
    '"
    Extracts rows where Postcodes from Staffing details does not exists and No Valid postcode is entered
    
    param  : wf_data -> Workforce Data
    type   : tibble
    param  : locations_data -> Locations Data
    type   : tibble
    param  : addn_check -> Include in additional check list
    type   : boolean
    
    
    return : tibble | data frame
    "'
    
    
    # post codes and patterns ----
    post_code_pattern <- "\\b(?:([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))\\s?[0-9][A-Za-z]{2}))\\b"
    
    outcode <- "[A-Za-z0-9]{1,4}"
    
    
    wf_tmp <- wf_data %>% 
        tidylog::mutate(pc_nospace = gsub(" ","",Work_Primary_Location_Postcode)) %>% 
        tidylog::mutate(postcode = stringr::str_trim(Work_Primary_Location_Postcode, side = "both")) %>% 
        tidylog::mutate(is_code = str_detect(postcode, pattern = post_code_pattern))
    
    is_postcode_tbl <- wf_tmp %>% 
        tidylog::filter(is_code == F) %>% 
        tidylog::mutate(Comment_box = stringr::str_glue("{Comment_box},
                                                        No Postcode Identified"))
    
    locations_list <- locations_data %>%
        tidylog::mutate(pc_nospace_locations = gsub(" ","",postcode)) %>%
        dplyr::pull(pc_nospace_locations)
    
    
    output_tbl <- wf_tmp %>%
        tidylog::filter(is_code) %>%
        tidylog::filter( ! pc_nospace %in% locations_list) %>%
        # tidylog::select(- pc_nospace, - row_id) %>%
        tidylog::mutate(Comment_box = stringr::str_glue("{Comment_box},
                                                        Post Code not in Location data Tab"))
    
    output_tbl <- dplyr::bind_rows(is_postcode_tbl, output_tbl) %>%
        tidylog::select(- row_id, - pc_nospace, -postcode, -is_code)
    
    
    #------------------- Check 16 : Location check --------------------------------------
    if(addn_check) output_tbl <- wf_tmp %>% 
        tidylog::filter(is_code == F) %>% 
        tidylog::select(- pc_nospace, -postcode, -is_code) %>% 
        tidylog::mutate(check_type = "#16: Location Check",
                        check_num = 16)
    
    
    
    return(output_tbl)
    
}


# Summary table function -----

fn_rows_dim <- function(tbl) {
    
    '"
    Helper functions: Extracts total no of rows for any given table
    
    param  : tbl
    type   : tibble
    
    return : tibble | data frame
    "'
    
    dim(tbl)[1] %>% 
        dplyr::as_tibble() %>% 
        dplyr::rename(Number_of_Records = value)
}



fn_summary <- function(missing_engaging_org_tbl,
                       duplicates_qa_tbl,
                       incorrect_fte_tbl,
                       functional_area_pct_tbl,
                       sub_functional_area_pct_tbl,
                       missing_locations_tbl,
                       tbl){
    
    '"
    Summary Table for the customed QAd data
    
    param  : missing_engaging_org_tbl -> Missing Engaging Organisation Data
    type   : tibble
    param  : duplicates_qa_tbl -> Duplicates Data 
    type   : tibble
    param  : incorrect_fte_tbl -> Incorrect FTE Data 
    type   : tibble
    param  : functional_area_pct_tbl -> Functional area percentages do not add to 100% Data 
    type   : tibble
    param  : sub_functional_area_pct_tbl -> Sub-functional area percentages incorrect Data 
    type   : tibble
    param  : missing_locations_tbl -> Missing Locations Data 
    type   : tibble
    param  : tbl -> Workforce Data 
    type   : tibble
    
    
    return : tibble | data frame
    "'
    
    total_records <- dim(tbl)[1] 
    
    inpt_lst <- list("Missing Engaging Organisation" = missing_engaging_org_tbl,
                     "Duplicates" = duplicates_qa_tbl,
                     "Incorrect FTE" = incorrect_fte_tbl,
                     "Functional area percentages do not add to 100%" = functional_area_pct_tbl,
                     "Sub-functional area percentages incorrect" = sub_functional_area_pct_tbl,
                     "Missing Locations" = missing_locations_tbl)
    
    
    for (i in seq_along(inpt_lst)) {
        
        list_name <- names(inpt_lst)[i]
        
        inpt_lst[i] <- inpt_lst[i] %>% 
            purrr::map(~ fn_rows_dim(.)) %>% 
            purrr::map(~ dplyr::mutate(.,QA_Check = list_name))
        
    }
    
    
    result_tbl <- inpt_lst %>% 
        purrr::map_df(~.) %>% 
        tidylog::select(QA_Check, Number_of_Records) %>% 
        tidylog::mutate(Percentage_Records_Affected      = (Number_of_Records/ total_records),
                        Percentage_Records_Affected  = scales::percent(Percentage_Records_Affected, 
                                                                       accuracy = 0.01))
    
    return(result_tbl)
}

# Extract data Entry Date ----

fn_crc_data_entry_date <- function(excel_file_path, sheet, cell_ref){
    
    # Returns CRC name, if no CRC names was found returns "TBC"
    '"
    Returns data entry date, if blank returns 2099-12-31
    
    param  : excel_file_path -> file path
    type   : character | string
    param  : sheet -> sheet name to extract CRC name form
    type   : character | string
    param  : cell_ref -> Reference cell value
    type   : character | string
    
    return : character | string
    "'
    entry_date <- read_excel(excel_file_path, sheet = sheet, range = cell_ref) %>% 
        colnames() %>% 
        as.integer() 
    
    chr <- integer(0) 
    
    if (identical(chr, entry_date)) {
        return(entry_date <- as.Date("2099-12-31"))
    } else {
        return(entry_date %>% 
                   as.Date( origin = "1899-12-30") %>% 
                   lubridate::ymd() )
    }
}



#------------------------ Additional checks calcs ---------------

#------------------- Check 2: Name Check --------------------------------------

fn_addn_02_name_check <- function(tbl){
    
    '"
    Checks if a name has been entered in Employee ID, To protect for GDPR reasons
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(!stringr::str_detect(Employee_ID,pattern = "\\d")) %>% 
               tidylog::filter(!stringr::str_detect(stringr::str_to_lower(Employee_ID),
                                                    pattern = "vacancy|temp|agency|agency worker")) %>% 
               tidylog::mutate(check_type = "#2: Name Check",
                               check_num = 2)
    )
    
}


#------------------- Check 3: Contract type consistency --------------------------------------
fn_addn_03_contract_type_consistency <- function(tbl){
    
    '"
    Not expected to see fixed-term contract or permanent contract for self employed contractors, or contract for services/consultancy agreement for employees
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter((Employment_Status  == "Self-employed contractor" &
                                    Contract_Type  == "Permanent contract") |
                                   (Employment_Status  == "Self-employed contractor" &
                                        Contract_Type  == "Fixed-term contract") |
                                   (Employment_Status  == "Employee" &
                                        Contract_Type  == "Contract for services / Consultancy agreement")
               ) %>% 
               tidylog::mutate(check_type = "#3: Contract Type Consistency Check",
                               check_num = 3)
    )
}



#------------------- Check 4: Contract End Date --------------------------------------
fn_addn_04_contract_end_date <- function(tbl, snapshot_date){
    
    '"
    To check this date is not in the past, or before the date of transfer
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : snapshot_date -> Data entered by CRCs
    type   : date
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(!is.na(Contract_End_Date)) %>% 
               tidylog::filter(Contract_End_Date < snapshot_date) %>% 
               tidylog::mutate(check_type = "#4: Contract End Date Check",
                               check_num = 4)
    )
}

# ------------------- Check #5: Long-term absence start date in future -----------------

fn_addn_05_absenceStart_inFuture <- function(tbl, snapshot_date){
    
    '"
    Flags if the start date of long-term absence is in the future or before start date with current employer
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>% 
               tidylog::filter(Date_Absence_Started < Start_Date
                               | Date_Absence_Started < Continuous_Service_Date_Employment
                               |Date_Absence_Started > snapshot_date) %>%
               tidylog::mutate(check_num = 5, check_type = "#5: Absence start date check")
    )
}

# ------------------- Check #6: Long-term absence return in past or after start of absence ------

fn_addn_06_absenceReturn_inPast <- function(tbl, snapshot_date){
    
    '"
    Flags if the return date of long-term absence is in the past or before the start date of long-term absence
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(Expected_Return_Date < Start_Date
                               |Expected_Return_Date < snapshot_date) %>%
               tidylog::mutate(check_num = 6, check_type = "#6: Absence return date check")
    )
}


#------------------- Check 7: Age consistency Date--------------------------------------
fn_addn_07_age_continuous_service_date <- function(tbl){
    
    '"
    To check this date is not in the past, or before the date of transfer
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Date_of_Birth > Continuous_Service_Date_Employment | 
                                   Date_of_Birth > Continuous_Service_Date_RMO |
                                   Date_of_Birth > Start_Date |
                                   (lubridate::interval(Date_of_Birth, Continuous_Service_Date_Employment) / lubridate::years(1)) < 16 |
                                   (lubridate::interval(Date_of_Birth, Continuous_Service_Date_RMO) / lubridate::years(1)) < 16 |
                                   (lubridate::interval(Date_of_Birth, Start_Date ) / lubridate::years(1)) < 16 |
                                   lubridate::year(Date_of_Birth) < 1940
               ) %>% 
               tidylog::mutate(check_type = "#7: Age consistency check",
                               check_num = 7) 
    )
    
}

# ------------------- Check #8: Start date and Continuous service date in future -----

fn_addn_08_startDate_continuousServiceDate_inFuture <- function(tbl, snapshot_date){
    
    '"
    Flags if the start date with existing employer or the continuous service dates are in the future
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>%
               tidylog::filter(Start_Date > snapshot_date
                               | Continuous_Service_Date_Employment > snapshot_date
                               | Continuous_Service_Date_RMO > snapshot_date) %>%
               tidylog::mutate(check_num = 8, check_type = "#8: Start date and/or Continuous service date in future check")
    )
}

# ------------------- Check #9: Employment start before continuous service date ------

fn_addn_09_startDate_before_continuousService <- function(tbl){
    
    '"
    Flags if the employment start date is before the continuous service date
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(Start_Date < Continuous_Service_Date_Employment
                               | Start_Date < Continuous_Service_Date_RMO) %>%
               
               tidylog::mutate(check_num = 9, check_type = "#9: Start date before Continuous service dates check")
    )
}

# ------------------- Check #10: Continuous service dates consistency -----
# flag if continuous service date for RMO is older than continuous service date for employment

fn_addn_10_continuousServiceDates <- function(tbl){
    
    '"
    Flags if these activities are recorded in ""Other functional areas""
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(Continuous_Service_Date_RMO < Continuous_Service_Date_Employment) %>% 
               tidylog::mutate(check_num = 9, check_type = "#10: Continuous service dates consistency check")
    )
}


# ------------------- Check #11: BCST2 or Resettlement recorded under wrong activity -----
# flag if these activities are recorded in 'Other functional areas'

fn_addn_11_resetllement_BCST <- function(tbl){
    
    '"
    Flags if these activities are recorded in ""Other functional areas""
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(grepl("Resettlement|BCST2|ETTG|TTG", Other_Job_Title, ignore.case = TRUE)
                               | grepl("Resettlement|BCST|ETTG|TTG", Other_Job_Description, ignore.case = TRUE)) %>%
               tidylog::mutate(check_num = 11, check_type = "#11: BCST2 or Resettlement recorded under wrong activity check")
    )
}

# ------------------- Check #12: Contracted hours consistent with FTE -----


fn_addn_12_contractedHours_FTE <- function(tbl){
    
    '"
    Flags if these activities are recorded in ""Other functional areas""
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter((Contracted_Hours_per_Week / FTE_in_Hours_per_Week) < FTE_Equivalent - 0.1
                               | (Contracted_Hours_per_Week / FTE_in_Hours_per_Week) > FTE_Equivalent + 0.1) %>%
               tidylog::mutate(check_num = 12, check_type = "#12: Contracted hours consistent with FTE check")
    )
}


# -------------------- Check #13: Average hours worked consistent with FTE -----

fn_addn_13_avg_contractedHours_FTE <- function(tbl){
    
    '"
    Flags if average hours worked per week is not consitent with FTE
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(Average_Hours_Worked_per_Week >= 0) %>%
               tidylog::filter((Average_Hours_Worked_per_Week / 37) > (FTE_Equivalent + 0.1)
                               | (Average_Hours_Worked_per_Week / 37) < (FTE_Equivalent - 0.1)) %>%
               tidylog::mutate(check_num = 13, check_type = "#13: Average hours worked consistent with FTE Check")
    )
}

# ------------------- Check #14: FTE per week as expected -----

fn_addn_14_FTE_asExpected <- function(tbl){
    
    '"
    Flags if FTE in hours is less than 35 or greater than 48
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(FTE_in_Hours_per_Week < 35
                               | FTE_in_Hours_per_Week > 48) %>%
               tidylog::mutate(check_num = 14, check_type = "#14: FTE per week as expected Check")
    )
}

# ------------------- Check #15: Salaries consistent with FTE equivalent -----

fn_addn_15_basicSalary_FTE_asExpected <- function(tbl){
    
    '"
    Flags if salaries not consistent with FTE, should only perform check if all thre variables are provided
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(Basic_Salary >= 0 & FTE_Salary >= 0 & FTE_Equivalent >= 0) %>%
               tidylog::filter((Basic_Salary / FTE_Salary > FTE_Equivalent + 0.05)
                               | (Basic_Salary / FTE_Salary < FTE_Equivalent - 0.05)) %>%
               tidylog::mutate(check_num = 15, check_type = "#15: Salaries consistent with FTE equivalent Check")
    )
}


#------------------- Check 17: Hourly Rate Check--------------------------------------

fn_addn_17_hourly_rate <- function(tbl, snapshot_date){
    
    '"
    National living wage 
        
        *apprentice : £4.15
        * 06-18 yrs : £4.55
        * 18-20 yrs : £6.45
        * 21-24 yrs : £8.20
        * 25+       : £8.72
    param  : tbl -> Workforce Data
    type   : tibble
    param  : snapshot_date -> Date Data reorded by CRC
    type   : tibble
    
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::mutate(age = (lubridate::interval(Date_of_Birth, snapshot_date) / lubridate::years(1))) %>% 
        tidylog::filter(Pay_Rate_per_Hour > 0) %>%
        tidylog::filter((age >= 25 & Pay_Rate_per_Hour < 8.72) |
                            (dplyr::between(age, 21, 24.99999) & Pay_Rate_per_Hour < 8.20) |
                            (dplyr::between(age, 18, 20.99999) & Pay_Rate_per_Hour < 6.45) |
                            (age < 18 & Pay_Rate_per_Hour < 4.55) 
                        
        )%>% 
        tidylog::mutate(check_type = "#17: Hourly pay rate Check",
                        check_num = 17) %>% 
        tidylog::select(- age)
    
    
    
    return(tbl)
    
}

#------------------- Check 18 : Maximum Bonus Potential --------------------------------------
fn_addn_18_mx_bonus_potential <- function(tbl){
    
    '"
    The average bonus pay out over the last 3 years is not more than maximum bonus potential as a % of salary
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Average_Bonus_Paid_last_3years > (Maximum_Bonus_Potential * Basic_Salary)
               ) %>% 
               tidylog::mutate(check_type = "#18: Maximum bonus potential Check",
                               check_num = 18) 
    )
    
}

#------------------- Check 19 : Next Pay Review --------------------------------------
fn_addn_19_nxt_pay_review <- function(tbl, snapshot_date){
    
    '"
    The average bonus pay out over the last 3 years is not more than maximum bonus potential as a % of salary
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : entry_date -> Date Data reorded by CRC
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Next_Pay_Review_Date < snapshot_date
               ) %>% 
               tidylog::mutate(check_type = "#19: Next pay review Check",
                               check_num = 19) 
    )
    
}


#------------------- Check 20 : Life assurance for LGPS  --------------------------------------
fn_addn_20_life_assurance_lgps <- function(tbl){
    
    '"
    Life assurance should be at least 3 times pensionable pay for LGPS 
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Pension_Scheme_Name == "LGPS" &
                            (Life_Assurance_Cover < 3 |
                                 is.na(Life_Assurance_Cover))
        ) %>% 
        tidylog::mutate(check_type = "#20: Life assurnace & LGPS Check",
                        check_num = 20) 
    
    
    return(tbl)
    
}

#------------------- Check 21 : Life assurance consistent with salary  --------------------------------------
fn_addn_21_life_assurance_salary <- function(tbl){
    
    '"
    Life assurance should be no more than 3 times salary for anyone non_LGPS
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Pension_Scheme_Name != "LGPS" &
                            Life_Assurance_Cover > 3 
        ) %>% 
        tidylog::mutate(check_type = "#21: Life assurance consistent with Salary Check",
                        check_num = 21) 
    
    
    return(tbl)
    
}

#------------------- Check 22 : Negative Values for Allowance and Deductions  --------------------------------------
fn_addn_22_neg_allowance_deductions <- function(tbl){
    
    '"
    No Negative vlaues for columns related to Allowance and Deductions
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::select(Shift_Allowance_Entitlement:Long_Service_Awards_Entitlement,
                        Total_Value_Other_Allowances:Season_Ticket_Loan_Annual_Deduction,
                        Total_Value_Other_Deductions) %>% 
        tidylog::filter_all(dplyr::all_vars(. < 0))%>% 
        tidylog::mutate(check_type = "#22: Negative values: Allowance and Deductions Check",
                        check_num = 22) 
    
    
    return(tbl)
    
}


#------------------- Check 23 : Season Ticket Loan End Date  --------------------------------------

fn_addn_23_season_tick_loan <- function(tbl, snapshot_date){
    
    '"
    Season ticket loan end date is in the future
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : snapshot_date -> Date Data reorded by CRC
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Season_Ticket_Loan_End_Date  < snapshot_date
               ) %>% 
               tidylog::mutate(check_type = "#23: Season ticket loan end date Check",
                               check_num = 23) 
    )
    
}

#------------------- Check 24 : Vetting Dates Check  --------------------------------------

fn_addn_24_vetting_dates <- function(tbl, snapshot_date){
    
    '"
    Check vetting dates are not in the future
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : snapshot_date -> Date Data reorded by CRC
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Baseline_Vetting_Date       > snapshot_date |
                                   DBS_Check_Date          > snapshot_date |
                                   NPPV_ViSOR_Vetting_Date > snapshot_date |
                                   Other_Vetting_1_Date    > snapshot_date |
                                   Other_Vetting_2_Date    > snapshot_date
               ) %>% 
               tidylog::mutate(check_type = "#24: Vetting dates Check",
                               check_num = 24) 
    )
    
}


# ------------------- Check 25: Annual leave consistent with FTE equivalent -----

fn_addn_25_annualleave_FTE_asExpected <- function(tbl){
    
    '"
    Flags if annual leave entitlement is not consistent with FTE
    param  : tbl -> Workforce Data
    type   : tibble
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter(Annual_Leave_Entitlement / FTE_Equivalent < 20) %>%
               tidylog::mutate(check_type = "#25: Annual leave entitlement consistent with FTE",
                               check_num = 25)
    )
}


#------------------- Check 26 : Apprentership End Date  --------------------------------------

fn_addn_26_apprenticieship_end_date <- function(tbl, snapshot_date){
    
    '"
    Apprenticieship end date is in the future
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : snapshot_date -> Date Data reorded by CRC
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Apprenticeship_End_Date  < snapshot_date
               ) %>% 
               tidylog::mutate(check_type = "#26: Apprentership end date Check",
                               check_num = 26) 
    )
    
}

#------------------- Check 27 : Know Qualification Completion Date  --------------------------------------

fn_addn_27_known_qualification_completion_date <- function(tbl, snapshot_date){
    
    '"
    Known qualification completion date is in the future
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : snapshot_date -> Date Data reorded by CRC
    type   : tibble
    
    return : tibble | data frame
    "'
    return(tbl %>% 
               tidylog::filter(Known_Qualification_Completion_Date  < snapshot_date
               ) %>% 
               tidylog::mutate(check_type = "#27: Known qualification completion date Check",
                               check_num = 27) 
    )
    
}

#------------------- Check 28 : Pension Eligibility Probation Trust Check  --------------------------------------

fn_addn_28_pension_eligibilty_probation_trust <- function(tbl, prev_transfer_date = as.Date("2014-06-01"),
                                                          crc_name){
    
    '"
     “Pension eligiblity start date” to be before employment start date for those who transferred in from the Probation Trusts.
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : start_date -> Date fransfered from Probation trust
    type   : tibble
    param  : continuous_service_date -> TBC
    type   : tibble
    param  : crc_name -> Name of the CRC
    type   : tibble
    
    
    return : tibble | data frame
    "'
    tbl <- tbl %>% 
        tidylog::filter(Engaging_Org == "CRC" &
                            Employment_Status == "Employee" &
                            (
                                (Start_Date == prev_transfer_date & Continuous_Service_Date_Employment  < prev_transfer_date)|
                                    grepl("probation trust", Previous_Staff_Transfer_Date_and_Name, ignore.case = TRUE)
                            ) &
                            (Pension_Eligibility_Start_Date > Start_Date) |
                            crc_name == "London CRC") %>% 
        tidylog::mutate(check_type = "#28: Pension Eligibilty - Probation Trust Check",
                        check_num = 28) 
    
    return(tbl)
    
}

#------------------- Check 29 : LGPS Start Date Check  --------------------------------------

fn_addn_29_lgps_start_date <- function(tbl){
    
    '"
     Employees recruited by the CRCs whilst shares owned by MoJ i.e. June 2014 to 31 Jan 2015, 
     LGPS start date expected to be the date they started employment.
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    tbl <- tbl %>% 
        tidylog::filter((Engaging_Org == "CRC" &
                             Employment_Status == "Employee" &
                             Start_Date > as.Date("2014-06-01") &
                             Start_Date < as.Date("2015-01-31") & (
                                 (Pension_Scheme_Name   == "LGPS") |
                                     (Pension_Scheme_Name == "Other" & grepl("GMPF", Other_Pension_Scheme_Name_and_Website, ignore.case = TRUE)))) &
                            (Start_Date != Pension_Eligibility_Start_Date)
        ) %>% 
        tidylog::mutate(check_type = "#29: LGPS start date Check",
                        check_num = 29) 
    
    return(tbl)
    
}

#------------------- Check 30 : Pension Eligibility Auto-Enrol Check  --------------------------------------

fn_addn_30_pension_eligibilty_auto_enrol <- function(tbl, start_date = as.Date("2015-01-31")){
    
    '"
    Employees recruited by CRCs whilst shares inprivate ownership, i.e after 31 Jan 2015, 
    pension eligible start date will be either the date employees joined or the auto enrolment start date where later.
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : start_date -> Date fransfered from Probation trust
    type   : tibble
    
    
    return : tibble | data frame
    "'
    tbl <- tbl %>% 
        tidylog::filter(Engaging_Org == "CRC" &
                            Employment_Status == "Employee" &
                            Start_Date > start_date  &
                            Pension_Eligibility_Start_Date   < Start_Date  
        )%>% 
        tidylog::mutate(check_type = "#30: Pension Eligibilty - Auto-Enrolment Check",
                        check_num = 30) 
    
    return(tbl)
    
}

# --- Check # 31: Pension eligibility start date --------------------------

fn_addn_31_pensionEligibilityStart_engagingOrg <- function(tbl){
    
    '"
    Flags for individuals who 
        1. are engaged with [CRC OR Parent organisation]
        2. have a start date > 31/01/2015
        3. Continuous_Service_Date_Employment < Start_Date
        4. either [Continuous_Service_Date_Employment > 01/06/2014 OR Continuous_Service_Date_RMO > 01/06/2014]
        5. either [Continuous_Service_Date_RMO is not blank OR Pension_eligibility_Start_Date < Start_Date]
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    return(tbl %>%
               tidylog::filter( Engaging_Org  == "CRC" |  Engaging_Org  == "Parent Organisation") %>%
               tidylog::filter(Start_Date > as.Date("2015-01-31")) %>%
               tidylog::filter(Continuous_Service_Date_Employment < Start_Date) %>%
               tidylog::filter((!is.na(Continuous_Service_Date_RMO)) | 
                                   (Pension_Eligibility_Start_Date < Start_Date)) %>%
               tidylog::mutate(check_type = "#31: Pension eligibility start date Check",
                               check_num = 31)
    )
}

#------------------- Check 32 : DB Pension Type Check  --------------------------------------

fn_addn_32_db_pension_type <- function(tbl) {
    
    '"
    DB pension type should onlt be for PCSPS/alpha or LGPS/GMPF
    
    param  : tbl -> Workforce Data
    type   : tibble
    param  : start_date -> Date fransfered from Probation trust
    type   : tibble
    
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Pension_Scheme_Type == "DB" &
                            (
                                stringr::str_detect(stringr::str_to_lower(Pension_Scheme_Name),
                                                    "lgps|pcsps|alpha", negate = TRUE) 
                                |
                                    (Pension_Scheme_Type == "Other" &
                                         !grepl("GMPF", Other_Pension_Scheme_Name_and_Website, ignore.case = TRUE))
                            )) %>% 
        tidylog::mutate(check_type = "#32: DB pension type Check",
                        check_num = 32) 
    
    return(tbl)
    
    
}

#------------------- Check 33 : LGPS Probation Trust Employee Check  --------------------------------------

fn_addn_33_lgps_probation_trust_emp <- function(tbl) {
    
    '"
    LGPS participants that are not probation trust employees or recruited between 1 June 2014 and 31 Jan 2015
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter((Engaging_Org       == "CRC" &
                             Employment_Status   == "Employee" &
                             (
                                 (Pension_Scheme_Name == "LGPS") |
                                     (Pension_Scheme_Type == "Other" &
                                          grepl("GMPF", Other_Pension_Scheme_Name_and_Website, ignore.case = TRUE))
                                 
                             )) &
                            (
                                Start_Date < as.Date("2014-06-01") |
                                    Start_Date > as.Date("2015-01-31")
                            )
        ) %>% 
        tidylog::mutate(check_type = "#33: LGPS Probation Trust employee Check",
                        check_num = 33) 
    
    
    
    
    return(tbl)
    
    
}

#------------------- Check 34 : LGPS Employer Contribution Check  --------------------------------------

fn_addn_34_lgps_employer_contribution <- function(tbl) {
    
    '"
    LGPS employer contribution should be no less than 16% (after April 2020)
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Pension_Scheme_Name == "LGPS" &
                            Employer_Pension_Contribution < 0.16
                        
        ) %>% 
        tidylog::mutate(check_type = "#34: LGPS employer contribution Check",
                        check_num = 34)
    
    return(tbl)
    
    
}

#------------------- Check 35 : LGPS Employer Contribution Check  --------------------------------------

fn_addn_35_non_pensionable_earnings <- function(tbl) {
    
    '"
    FC Should be significantly lower thab FB
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Total_Non_Pensionable_Earnings > Total_Pensionable_Earnings ) %>% 
        tidylog::mutate(check_type = "#35: Non-pensionable earnings Check",
                        check_num = 35)
    
    return(tbl)
    
    
}

#------------------- Check 36 : LGPS Eligibility  --------------------------------------

fn_addn_36_lgps_eligibility <- function(tbl) {
    
    '"
    FC Should be significantly lower thab FB
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Pension_Scheme_Name == "LGPS"|
                            (Pension_Scheme_Name == "Other" &
                                 stringr::str_detect(stringr::str_to_lower(Other_Pension_Scheme_Name_and_Website),
                                                     pattern = "gmpf")) &
                            Employment_Status != "Employee") %>% 
        tidylog::mutate(check_type = "36: LGPS eligibity Check",
                        check_num = 36)
    
    return(tbl)
    
    
}

#------------------- Check 37 : Employee and Employer Pension contribution  --------------------------------------

fn_addn_37_emp_emplyr_pension_contribution <- function(tbl) {
    
    '"
    FD and FE added shoulbe 8% or more unless Employee Opt Out
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Pension_Scheme_Name != "None") %>%
        tidylog::filter(Pension_Scheme_Name != "") %>%
        tidylog::filter((Employee_Pension_Contribution +  Employer_Pension_Contribution ) < 0.08 ) %>% 
        tidylog::mutate(check_type = "#37: Pension contributions Check",
                        check_num = 37)
    
    return(tbl)
    
    
}
#------------------- Check 38 : Employer Pension less than 3% --------------------------------------

fn_addn_38_emplyr_pension_contribution <- function(tbl) {
    
    '"
    FE to be 3% or more
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(!is.na(Employer_Pension_Contribution) ) %>%
        tidylog::filter(Agency_flag != "Yes") %>% 
        tidylog::filter(Sessional_flag != "Yes (adhoc)" |
                            Sessional_flag != "Yes (regular)") %>%
        tidylog::filter( Employer_Pension_Contribution  < 0.03 ) %>% 
        tidylog::mutate(check_type = "#38: Employer pension contribution Check",
                        check_num = 38)
    
    return(tbl)
    
    
}

#------------------- Check 39 : ETTG Assigned to SM Check --------------------------------------

fn_addn_39_ettg_assigned_to_sm <- function(tbl) {
    
    '"
    Flags where ETTG staff are not assigned to SM
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Majority_ETTG == "Yes, majority of time spent on TTG" ) %>%
        tidylog::filter(Assignment != "Assigned – NPS Sentence Management") %>% 
        tidylog::mutate(check_type = "#39: ETTG Assigned to SM Check",
                        check_num = 39)
    
    return(tbl)
    
    
}

#------------------- Check 40 : Supporting info not provided --------------------------------------

fn_addn_40_supporting_info_not_provided <- function(tbl) {
    
    '"
    Flags where supporting info not provided for unassigned staff
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Assignment == "Not Assigned" ) %>%
        tidylog::filter(is.na(Assignment_Supporting_Info)) %>% 
        tidylog::mutate(check_type = "#40: Supporting info not provided",
                        check_num = 40)
    
    return(tbl)
    
    
}


#------------------- Check 41 : PCC area not provided --------------------------------------

fn_addn_41_pcc_area_not_provided <- function(tbl) {
    
    '"
    Flags where PCC info not provided for Dynamic Framework staff
    
    param  : tbl -> Workforce Data
    type   : tibble
    
    return : tibble | data frame
    "'
    
    tbl <- tbl %>% 
        tidylog::filter(Assignment ==  "Assigned – Dynamic Framework (Day 1 services)" ) %>%
        tidylog::filter(is.na(PCC_Area)) %>% 
        tidylog::mutate(check_type = "#41: PCC area not provided",
                        check_num = 41)
    
    return(tbl)
    
    
}


#--------------------------Additional Check Output Table ---------------------------------------
fn_addn_check_output <- function(check_01_duplicates_tbl,
                                 check_02_names_tbl,
                                 check_03_contract_type_consistency_tbl,
                                 check_04_contract_end_date_tbl,
                                 check_05_absenceStart_inFuture_tbl,
                                 check_06_absenceReturn_inPast_tbl,
                                 check_07_age_continuos_service_date_tbl,
                                 check_08_startDate_continuousServiceDate_inFuture_tbl,
                                 check_09_startDate_before_continuousService_tbl,
                                 check_10_continuousServiceDates_tbl,
                                 check_11_resetllement_BCST_tbl,
                                 check_12_contractedHours_FTE_tbl,
                                 check_13_avg_contractedHours_FTE_tbl,
                                 check_14_FTE_asExpected_tbl,
                                 check_15_basicSalary_FTE_asExpected_tbl,
                                 check_16_missing_locations_tbl,
                                 check_17_hourly_rate_tbl,
                                 check_18_mx_bonus_potential_tbl,
                                 check_19_nxt_pay_review_tbl,
                                 check_20_life_assurance_lgps_tbl,
                                 check_21_life_assurance_salary_tbl,
                                 check_22_neg_allowance_deductions_tbl,
                                 check_23_season_tick_loan_tbl,
                                 check_24_vetting_dates_tbl,
                                 check_25_annualleave_FTE_asExpected_tbl,
                                 check_26_apprenticieship_end_date_tbl,
                                 check_27_known_qualification_completion_date_tbl,
                                 check_28_pension_eligibilty_probation_trust_tbl,
                                 check_29_lgps_start_date_tbl,
                                 check_30_pension_eligibilty_auto_enrol_tbl,
                                 check_31_pensionEligibilityStart_engagingOrg_tbl,
                                 check_32_db_pension_type_tbl,
                                 check_33_lgps_probation_trust_emp_tbl,
                                 check_34_lgps_employer_contribution_tbl,
                                 check_35_non_pensionable_earnings_tbl,
                                 check_36_lgps_eligibility_tbl,
                                 check_37_emp_emplyr_pension_contribution_tbl,
                                 check_38_emplyr_pension_contribution_tbl,
                                 check_39_ettg_assigned_to_sm_tbl,
                                 check_40_supporting_info_not_provided_tbl,
                                 check_41_pcc_area_not_provided_tbl) {
    
    
    checks_list <- list(check_01_duplicates_tbl,
                        check_02_names_tbl,
                        check_03_contract_type_consistency_tbl,
                        check_04_contract_end_date_tbl,
                        check_05_absenceStart_inFuture_tbl,
                        check_06_absenceReturn_inPast_tbl,
                        check_07_age_continuos_service_date_tbl,
                        check_08_startDate_continuousServiceDate_inFuture_tbl,
                        check_09_startDate_before_continuousService_tbl,
                        check_10_continuousServiceDates_tbl,
                        check_11_resetllement_BCST_tbl,
                        check_12_contractedHours_FTE_tbl,
                        check_13_avg_contractedHours_FTE_tbl,
                        check_14_FTE_asExpected_tbl,
                        check_15_basicSalary_FTE_asExpected_tbl,
                        check_16_missing_locations_tbl,
                        check_17_hourly_rate_tbl,
                        check_18_mx_bonus_potential_tbl,
                        check_19_nxt_pay_review_tbl,
                        check_20_life_assurance_lgps_tbl,
                        check_21_life_assurance_salary_tbl,
                        check_22_neg_allowance_deductions_tbl,
                        check_23_season_tick_loan_tbl,
                        check_24_vetting_dates_tbl,
                        check_25_annualleave_FTE_asExpected_tbl,
                        check_26_apprenticieship_end_date_tbl,
                        check_27_known_qualification_completion_date_tbl,
                        check_28_pension_eligibilty_probation_trust_tbl,
                        check_29_lgps_start_date_tbl,
                        check_30_pension_eligibilty_auto_enrol_tbl,
                        check_31_pensionEligibilityStart_engagingOrg_tbl,
                        check_32_db_pension_type_tbl,
                        check_33_lgps_probation_trust_emp_tbl,
                        check_34_lgps_employer_contribution_tbl,
                        check_35_non_pensionable_earnings_tbl,
                        check_36_lgps_eligibility_tbl,
                        check_37_emp_emplyr_pension_contribution_tbl,
                        check_38_emplyr_pension_contribution_tbl,
                        check_39_ettg_assigned_to_sm_tbl,
                        check_40_supporting_info_not_provided_tbl,
                        check_41_pcc_area_not_provided_tbl
    )
    
    
    output_tbl <- checks_list %>% 
        purrr::reduce(rbind) %>% 
        tidylog::mutate(check_num = as.factor(check_num),
                        test_value = 1) %>% 
        dplyr::arrange(check_num) %>% 
        tidylog::select(- check_num) %>% 
        tidyr::pivot_wider(names_from = check_type,
                           values_from = test_value,
                           values_fill = list(test_value = NA)) 
    
    
    output_errors_tbl <- output_tbl %>% 
        tidylog::select(row_id,207:dim(output_tbl)[[2]])
    
    c_names <- output_errors_tbl %>% 
        colnames()
    
    
    output_errors_tbl[["Total Count of Anomalies"]] <- rowSums(output_errors_tbl[-1], na.rm = T)
    
    
    output_tbl <- output_tbl %>% 
        select(- c_names) %>% 
        cbind(
            output_errors_tbl %>%
                tidylog::select(- "Total Count of Anomalies") %>% 
                tidylog::mutate_if(is.double, as.character) %>% 
                tidylog::select_if(is.character) %>% 
                tidylog::mutate_all(., ~str_replace(.,"1", "x")),
            output_errors_tbl %>% 
                tidylog::select("Total Count of Anomalies")
        ) %>% 
        dplyr::as_tibble()
    
    
    return(output_tbl)
}
