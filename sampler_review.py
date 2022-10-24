import pandas as pd
import numpy as np
import random

pop = pd.read_excel("popul.xlsx", dtype=str)

amount = "금액"

## rename Data variable
if amount != 'amount':
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
factor_filter = assurance_factor[assurance_factor['SignificantRisk'] == "Yes"]
factor_filter = factor_filter[factor_filter['RelianceonControls'] == "No"]
factor_filter = factor_filter[factor_filter['Planned_Level'] == "APNP"]
AF = factor_filter["Assurance_Factor"].values[0]


high = pop[pop['amount'] > 700000000]
sum_High_value_items = sum(high['amount'])
high_index = list(high.index)
minus = pop[pop['amount'] <= 0]
minus_index = list(minus.index)
pop_remain = pop.drop(high_index)
pop_remain = pop_remain.drop(minus_index)

sampling_interval = np.int64( (700000000 - 700000000*0.05 )  /  3 )
pop_amount = sum(np.int64(pop_remain['amount']))
sample_size = int(np.int64(pop_amount * AF) / (700000000 - 700000000*0.05) )
sampling_array = np.array(list(range(1, sample_size + 1)), dtype='int64')
sampling_n = sampling_array * sampling_interval
sampling_row = list(range(sample_size))
pop_remain['cum'] = np.cumsum(pop_remain['amount'])
for i in range(sample_size):
    sampling_row[i] = np.where(pop_remain['cum'] > sampling_n[i])[0][0]

unique = set(sampling_row)
sampling_row = list(unique)
sampling_row.sort()


## 샘플링 객체 생성
pop_remain = pop_remain.drop('cum', axis = 1)
pop_remain = pop_remain.reset_index()
mus_sample = pop_remain.loc[sampling_row]
sampling = pd.concat([high, mus_sample])

sampling.to_excel("sampler_review.xlsx")