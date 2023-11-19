import pandas as pd
import random
import os
import xlsxwriter

filename = "population_PO_example.xlsx"

pop = pd.read_excel(filename, dtype=str)
print(pop.shape)
        

##################################################################################### save
def save_File():
    file_path = "c:/py"
    excel_writer = pd.ExcelWriter(file_path + '/ToC_sample.xlsx', engine='xlsxwriter')
    sampling.to_excel(excel_writer, sheet_name='ToC_sample',index=False)
    excel_writer.close()
    

##################################################################################### random
total_line = len(pop)
sample_size = pd.DataFrame({"NoSignificantRisk" : [1,2,2,3,5,8,14,20],
                            "SignificantRisk" : [1,2,4,6,9,15,25,30]})        

sr = 1
occ_num = {"1-3":0,"4-11":1,"12-25":2,"26-47":3,"48-60":4,"61-104":5,"105-249":6,"250 over":7}
occ_selected = occ_num["105-249"]
        
size = sample_size.iloc[occ_selected, sr]
        
sampling_row = random.sample(range(len(pop)), size)
sampling = pop.loc[sampling_row]

## 추출된 샘플의 갯수
 str(len(sampling))
        
