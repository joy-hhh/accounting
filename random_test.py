import pandas as pd
import numpy as np
import random

def read():
    global pop
    pop = pd.read_excel("popul.xlsx", dtype=str)


SR = "No"
RC = "Yes"
PL = "APNP"

PM = 700000000
EA = int(PM * 0.05)

def rand():
    global pop
    global sampling
    try:
        amount = "금액"
        ## rename Data variable
        if amount != 'amount':
            pop = pop.rename(columns = {amount : 'amount'})   
        
        pop['amount'] = pd.to_numeric(pop['amount'])
        
        total_line = len(pop)

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

        pop_amount = sum(pop['amount'])
        sample_size = int(pop_amount * AF / PM  - PM * 0.0)

        sampling_row = random.sample(range(total_line), sample_size)
        sampling = pop.loc[sampling_row]
        
        ## 추출된 샘플의 갯수
        # lbl11.configure(text="Sample Output Size : " + str(len(sampling)))
        
    except Exception as err:
        msgbox.showerror("Error", err)

read()
rand()
sampling


amount = "금액"
## rename Data variable
if amount != 'amount':
    pop = pop.rename(columns = {amount : 'amount'})   

pop['amount'] = pd.to_numeric(pop['amount'])
total_line = len(pop)
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
pop_amount = sum(pop['amount'])
sample_size = int(pop_amount * AF / PM  - PM * 0.0)
sampling_row = random.sample(range(total_line), sample_size)
sampling = pop.loc[sampling_row]

## 추출된 샘플의 갯수
len(sampling)
