import pandas as pd
import numpy as np
import random

def read():
    global pop
    pop = pd.read_excel("popul.xlsx", dtype=str)


SR = "Yes"
RC = "No"
PL = "APNP"

PM = 700000000
EA = int(PM * 0.05)


def mus():
    global pop
    global sampling
    
    amount = "금액"
    ## rename Data variable
    pop = pop.rename(columns = {amount : 'amount'})   
    pop['amount'] = pd.to_numeric(pop['amount'])
    assurance_factor_raw = pd.DataFrame({"SignificantRisk" : ["Yes", "No", "Yes", "No"],
                                    "RelianceonControls" : ["No","No","Yes","Yes"],
                                    "High" : [1.1, 0 ,0 ,0],
                                    "Moderate" : [1.6,0.5,0.2,0],
                                    "Low" : [2.8,1.7,1.4,0.3],
                                    "APNP" : [3,1.9,1.6,0.5]})
    assurance_factor = pd.melt(assurance_factor_raw, id_vars = ["SignificantRisk", "RelianceonControls"], 
                            var_name = "Planned_Level", 
                            value_name = "Assurance_Factor")
    factor_filter = assurance_factor[assurance_factor['SignificantRisk'] == SR]
    factor_filter = factor_filter[factor_filter['RelianceonControls'] == RC]
    factor_filter = factor_filter[factor_filter['Planned_Level'] == PL]
    AF = factor_filter["Assurance_Factor"].values[0]
    
    high = pop[pop['amount'] > PM]
    sum_High_value_items = sum(high['amount'])
    high_index = list(high.index)
    pop = pop.drop(high_index)
    
    sampling_interval = np.int64((PM - EA) / AF)
    pop_amount = sum(np.int64(pop['amount']))
    sample_size = int(np.int64((pop_amount - sum_High_value_items) * AF) / (PM - EA))
    sampling_array = np.array(list(range(1, sample_size + 1)), dtype='int64')
    sampling_n = sampling_array * sampling_interval
    sampling_row = list(range(sample_size))
    pop['cum'] = np.cumsum(pop['amount'])
    for i in range(sample_size):
        sampling_row[i] = np.where(pop['cum'] > sampling_n[i])[0][0]
    
    unique = set(sampling_row)
    sampling_row = list(unique)
    sampling_row.sort()
    ## 추출된 샘플의 갯수
    len(sampling_row)
    ## 샘플링 객체 생성
    pop = pop.drop('cum', axis = 1)
    sampling = pop.loc[sampling_row]
    sampling = pd.concat([high, sampling])


pop

read()
mus()
sampling






################################################
amount = "차변금액"

## rename Data variable
pop = pop.rename(columns = {amount : 'amount'})   
pop['amount'] = pd.to_numeric(pop['amount'])
assurance_factor_raw = pd.DataFrame({"SignificantRisk" : ["Yes", "No", "Yes", "No"],
                                "RelianceonControls" : ["No","No","Yes","Yes"],
                                "High" : [1.1, 0 ,0 ,0],
                                "Moderate" : [1.6,0.5,0.2,0],
                                "Low" : [2.8,1.7,1.4,0.3],
                                "APNP" : [3,1.9,1.6,0.5]})
assurance_factor = pd.melt(assurance_factor_raw, id_vars = ["SignificantRisk", "RelianceonControls"], 
                        var_name = "Planned_Level", 
                        value_name = "Assurance_Factor")
factor_filter = assurance_factor[assurance_factor['SignificantRisk'] == SR]
factor_filter = factor_filter[factor_filter['RelianceonControls'] == RC]
factor_filter = factor_filter[factor_filter['Planned_Level'] == PL]
AF = factor_filter["Assurance_Factor"].values[0]


high = pop[pop['amount'] > PM]
sum_High_value_items = sum(high['amount'])
high_index = list(high.index)
pop = pop.drop(high_index)

sampling_interval = np.int64((PM - EA) / AF)
pop_amount = sum(np.int64(pop['amount']))
sample_size = int(np.int64((pop_amount - sum_High_value_items) * AF) / (PM - EA))
sampling_array = np.array(list(range(1, sample_size + 1)), dtype='int64')
sampling_n = sampling_array * sampling_interval
sampling_row = list(range(sample_size))
pop['cum'] = np.cumsum(pop['amount'])
for i in range(sample_size):
    sampling_row[i] = np.where(pop['cum'] > sampling_n[i])[0][0]

unique = set(sampling_row)
sampling_row = list(unique)
sampling_row.sort()
## 추출된 샘플의 갯수
len(sampling_row)
## 샘플링 객체 생성
pop = pop.drop('cum', axis = 1)
sampling = pop.loc[sampling_row]
sampling = pd.concat([high, sampling])