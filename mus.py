import pandas as pd
import numpy as np
import random

######################################### input
SR = "Yes"         ## "No"
RC = "Yes"         ## "No"
PL = "APNP"     ##  "Low", "Moderate", "High"
EM = 0.05

## 수행중요성 금액 및 허용오류율(5% 등) 입력

PM = 700000000     ## Tolerable misstatement (generally performance materiality)
EA = PM * EM       ## Expected misstatement

######################################### read file
pop = pd.read_excel("popul.xlsx")

amount = 'CR'  # 변수명 선택 할 수 있게

## rename Data variable
pop = pop.rename(columns = {amount : 'amount'})   # CR 자리에 현재 data 변수명 입력
pop['amount'] = pd.to_numeric(pop['amount'])

def mus():
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
    pop.drop(high_index)

    sampling_interval = int((PM - EA) / AF)
    pop_amount = sum(pop['amount'])
    sample_size = int(pop_amount * AF / (PM - sum_High_value_items - EA))
    sampling_array = np.array(list(range(1, sample_size + 1)))
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



mus()
sampling = pd.concat([high, sampling])

