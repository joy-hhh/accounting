import rsmmus
import xlsxwriter
import pandas as pd
import numpy as np


## input parameters
# significant_risk = "Yes"  # 이 값을 설정하세요  ["Yes", "No"]
# reliance_on_controls = "No"  # 이 값을 설정하세요  ["Yes", "No"]
# tm = 700000000  # 이 값을 설정하세요 [int]
# emr = 0.05  # 이 값을 설정하세요 [float]
# sap = "APNP"  # 이 값을 설정하세요  ["High", "Moderate", "Low", "APNP"]

file_path = "/home/joy/py"
amount = "금액"

sample_generator = rsmmus.SampleGenerator()
pop_data = pd.read_excel("/home/joy/py/accounting/popul_na.xlsx")  # 팝 데이터를 여기에 입력하세요


sampling_result = sample_generator.mus(pop_data, amount) 
sample_generator.save_file(pop_data, sampling_result, amount, file_path)


