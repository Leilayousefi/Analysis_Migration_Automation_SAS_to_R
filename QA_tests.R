# Source file ---

source("00_script/qa_functions.R")

# File Paths -----

# qa_file_path           <- "02_tests/CRC03 - ARCC - July2020- v2.2 - cleaned (1).xlsx"
qa_file_path           <- "02_tests/CRC template - example.xlsx"
# qa_file_path           <- "r_workings/workforce/qa_tool/template/London Novu_testing_date.xlsx"


# Headers tbl ----
headers_tbl <- fn_headers_tbl()

wf_data <- fn_workforce_data_extract(headers_tbl = headers_tbl,
                                     qa_file_path = qa_file_path,
                                     locations_data = F)
locations_data <- fn_workforce_data_extract(headers_tbl = headers_tbl,
                                            qa_file_path = qa_file_path,
                                            locations_data = T)

wf_data %>% glimpse()

crc_name <- func_crc_name(excel_file_path = qa_file_path ,
                          sheet = "Staffing Details",cell_ref =  "d2")

snapshot_date <- fn_crc_data_entry_date(excel_file_path = qa_file_path ,
                                        sheet = "Staffing Details",cell_ref =  "d3")

## Data by tabs ------------------
# Clean Data

# clean_data_tbl <- wf_data %>% 
#                     fn_replace_na()


# missing data fields percentage table  -----

# COntractor Missing fields 

missing_fields_subcontractor_tbl <- fn_missing_data_fields_by_engaging_organisation(tbl = wf_data,
                                                                                    agency_only = F,
                                                                                    sessional_only = F,
                                                                                    exclude_agency = F,
                                                                                    exlude_sessional = F,
                                                                                    subcontractor = T) %>% 
    fn_missing_data_fields(headers_tbl = headers_tbl,
                           groupbysubcontractor = T)

# (Engaging organisation = CRC OR Parent Organisation, Agency_flag = "No", Sessional_flag = "No")
missing_fields_crc_tbl <- fn_missing_data_fields_by_engaging_organisation(tbl = wf_data,
                                                                          agency_only = F,
                                                                          sessional_only = F,
                                                                          exclude_agency = T,
                                                                          exlude_sessional = T,
                                                                          subcontractor = F) %>% 
    fn_missing_data_fields(headers_tbl = headers_tbl,
                           groupbysubcontractor = F)

# (Engaging organisation = CRC OR Parent Organisation, Agency_flag = "Yes")

missing_fields_crc_agency_tbl <- fn_missing_data_fields_by_engaging_organisation(tbl = wf_data,
                                                                                 agency_only = T,
                                                                                 sessional_only = F,
                                                                                 exclude_agency = F,
                                                                                 exlude_sessional = F,
                                                                                 subcontractor = F) %>% 
    fn_missing_data_fields(headers_tbl = headers_tbl,
                           groupbysubcontractor = F)
# (Engaging organisation = CRC OR Parent Organisation, Sessional_flag = "Yes (adhoc)" OR Sessional_flag = "Yes (regular)")

missing_fields_crc_sessional_tbl <- fn_missing_data_fields_by_engaging_organisation(tbl = wf_data,
                                                                                    agency_only = F,
                                                                                    sessional_only = T,
                                                                                    exclude_agency = F,
                                                                                    exlude_sessional = F,
                                                                                    subcontractor = F) %>% 
    fn_missing_data_fields(headers_tbl = headers_tbl,
                           groupbysubcontractor = F)


missing_engaging_org_tbl <- fn_missing_engaging_organisation(wf_data)

duplicates_qa_tbl    <- fn_duplicates(tbl = wf_data,addn_check = F)
duplicates_check_tbl <- fn_duplicates(tbl = wf_data,addn_check = T)

incorrect_fte_tbl <- fn_fte(tbl = wf_data)

functional_area_pct_tbl <- fn_functional_area_total(tbl = wf_data)

sub_functional_area_pct_tbl <- fn_sub_functional_area_total (tbl = wf_data)

missing_locations_tbl <- fn_missing_locations(wf_data = wf_data, locations_data = locations_data)


summary_tbl <- fn_summary(missing_engaging_org_tbl= missing_engaging_org_tbl,
                          duplicates_qa_tbl = duplicates_qa_tbl,
                          incorrect_fte_tbl = incorrect_fte_tbl,
                          functional_area_pct_tbl = functional_area_pct_tbl,
                          sub_functional_area_pct_tbl = sub_functional_area_pct_tbl,
                          missing_locations_tbl = missing_locations_tbl,
                          tbl  = wf_data)


## Additional checks -----
check_01_duplicates_tbl <- fn_duplicates(tbl = wf_data, addn_check = T)
check_02_names_tbl <- fn_addn_02_name_check(tbl = wf_data)
check_03_contract_type_consistency_tbl <- fn_addn_03_contract_type_consistency(tbl = wf_data)
check_04_contract_end_date_tbl <- fn_addn_04_contract_end_date(tbl = wf_data, snapshot_date = snapshot_date)
check_05_absenceStart_inFuture_tbl <- fn_addn_05_absenceStart_inFuture(tbl = wf_data, snapshot_date = snapshot_date)
check_06_absenceReturn_inPast_tbl <- fn_addn_06_absenceReturn_inPast(tbl = wf_data, snapshot_date = snapshot_date)
check_07_age_continuos_service_date_tbl <- fn_addn_07_age_continuous_service_date(tbl = wf_data)
check_08_startDate_continuousServiceDate_inFuture_tbl <- fn_addn_08_startDate_continuousServiceDate_inFuture(tbl = wf_data,
                                                                                                             snapshot_date = snapshot_date)
check_09_startDate_before_continuousService_tbl <- fn_addn_09_startDate_before_continuousService(tbl = wf_data)
check_10_continuousServiceDates_tbl <- fn_addn_10_continuousServiceDates(tbl = wf_data)
check_11_resetllement_BCST_tbl <- fn_addn_11_resetllement_BCST(tbl = wf_data)
check_12_contractedHours_FTE_tbl <- fn_addn_12_contractedHours_FTE(tbl = wf_data)
check_13_avg_contractedHours_FTE_tbl <- fn_addn_13_avg_contractedHours_FTE(tbl = wf_data)
check_14_FTE_asExpected_tbl <- fn_addn_14_FTE_asExpected(tbl = wf_data)
check_15_basicSalary_FTE_asExpected_tbl <- fn_addn_15_basicSalary_FTE_asExpected(tbl = wf_data)
check_16_missing_locations_tbl <- fn_missing_locations(wf_data = wf_data, locations_data = locations_data,
                                                       addn_check = T)
check_17_hourly_rate_tbl <- fn_addn_17_hourly_rate(tbl = wf_data, snapshot_date = snapshot_date)
check_18_mx_bonus_potential_tbl <- fn_addn_18_mx_bonus_potential(tbl = wf_data)
check_19_nxt_pay_review_tbl <- fn_addn_19_nxt_pay_review(tbl = wf_data, snapshot_date = snapshot_date)
check_20_life_assurance_lgps_tbl <- fn_addn_20_life_assurance_lgps(tbl = wf_data)
check_21_life_assurance_salary_tbl <- fn_addn_21_life_assurance_salary(tbl = wf_data)
check_22_neg_allowance_deductions_tbl <- fn_addn_22_neg_allowance_deductions(tbl = wf_data)
check_23_season_tick_loan_tbl <- fn_addn_23_season_tick_loan(tbl = wf_data, snapshot_date = snapshot_date)
check_24_vetting_dates_tbl <- fn_addn_24_vetting_dates(tbl = wf_data, snapshot_date = snapshot_date)
check_25_annualleave_FTE_asExpected_tbl <- fn_addn_25_annualleave_FTE_asExpected(tbl = wf_data)
check_26_apprenticieship_end_date_tbl <- fn_addn_26_apprenticieship_end_date(tbl = wf_data, snapshot_date = snapshot_date)
check_27_known_qualification_completion_date_tbl <- fn_addn_27_known_qualification_completion_date(tbl = wf_data,
                                                                                                   snapshot_date = snapshot_date)
check_28_pension_eligibilty_probation_trust_tbl <- fn_addn_28_pension_eligibilty_probation_trust(tbl = wf_data,
                                                                                                 prev_transfer_date = as.Date("2014-06-01"),
                                                                                                 crc_name = crc_name)
check_29_lgps_start_date_tbl <- fn_addn_29_lgps_start_date(tbl = wf_data)
check_30_pension_eligibilty_auto_enrol_tbl <- fn_addn_30_pension_eligibilty_auto_enrol(tbl = wf_data,
                                                                                       start_date = as.Date("2015-01-31"))
check_31_pensionEligibilityStart_engagingOrg_tbl <- fn_addn_31_pensionEligibilityStart_engagingOrg(tbl = wf_data)
check_32_db_pension_type_tbl <- fn_addn_32_db_pension_type(tbl = wf_data)
check_33_lgps_probation_trust_emp_tbl <- fn_addn_33_lgps_probation_trust_emp(tbl = wf_data)
check_34_lgps_employer_contribution_tbl <- fn_addn_34_lgps_employer_contribution(tbl = wf_data)
check_35_non_pensionable_earnings_tbl <- fn_addn_35_non_pensionable_earnings(tbl = wf_data)
check_36_lgps_eligibility_tbl <- fn_addn_36_lgps_eligibility(tbl = wf_data)
check_37_emp_emplyr_pension_contribution_tbl <- fn_addn_37_emp_emplyr_pension_contribution(tbl = wf_data)
check_38_emplyr_pension_contribution_tbl <- fn_addn_38_emplyr_pension_contribution(tbl = wf_data)
check_39_ettg_assigned_to_sm_tbl <- fn_addn_39_ettg_assigned_to_sm(tbl = wf_data)
check_40_supporting_info_not_provided_tbl <- fn_addn_40_supporting_info_not_provided(tbl = wf_data)
check_41_pcc_area_not_provided_tbl <- fn_addn_41_pcc_area_not_provided(tbl = wf_data)
#------------------
additional_checks_output_tbl <- fn_addn_check_output(check_01_duplicates_tbl,
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
                                                     check_39_ettg_assigned_to_sm_tbl ,
                                                     check_40_supporting_info_not_provided_tbl,
                                                     check_41_pcc_area_not_provided_tbl )

additional_checks_output_tbl[1:205] %>% glimpse()

additional_checks_output_tbl %>% 
    select(Employee_ID, 206:dim(additional_checks_output_tbl)[[2]]) %>%
    glimpse()
