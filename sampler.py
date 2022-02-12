import pandas as pd
import numpy as np
import random

import os
import tkinter.ttk as ttk
from tkinter import *
from tkinter import filedialog
import tkinter.messagebox as msgbox

win =Tk()
win.geometry("700x500")
win.title("Sampler")
win.option_add("*Font","NanumGothic 16")



######################################### def
def readexcel():
    global pop
    global combobox11
    try:
        filename = filedialog.askopenfilename(initialdir="/", title="Select file",
                                              filetypes=(("XLSX files", "*.xlsx"),
                                                         ("All files", "*.*")))
        pop = pd.read_excel(filename, dtype=str)
        lbl10.configure(text="file (Row, Col) : " + str(pop.shape))

        pop_col = list(pop.columns)
        combobox11 = ttk.Combobox(win, height=5, state="readonly", values=pop_col)
        combobox11.grid(row=11, column=1)
        combobox11.set("Select amount column")
    except Exception as err:
        msgbox.showerror("Error", err)

##################################################################################### save
def save_File():
    try:
        file_path = filedialog.askdirectory()

        excel_writer = pd.ExcelWriter(file_path + '/test_sample.xlsx', engine='xlsxwriter')
        sampling.to_excel(excel_writer, sheet_name='test_sample')
        excel_writer.save()
        msgbox.showinfo("Save complete", "test_sample.xlsx")
    except Exception as err:
        msgbox.showerror("Error", err)



##################################################################################### random
def rand():
    global pop
    global sampling
    try:
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
        sample_size = int(pop_amount * AF / (PM - EA))

        sampling_row = random.sample(range(total_line), sample_size)
        sampling = pop.loc[sampling_row]
        
        ## 추출된 샘플의 갯수
        lbl11.configure(text="Sample Output Size : " + str(len(sampling)))
        
    except Exception as err:
        msgbox.showerror("Error", err)


################################################################################### mus
def mus():
    global pop
    global sampling
    try:
        amount = str(combobox11.get())
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
        factor_filter = assurance_factor[assurance_factor['SignificantRisk'] == SR]
        factor_filter = factor_filter[factor_filter['RelianceonControls'] == RC]
        factor_filter = factor_filter[factor_filter['Planned_Level'] == PL]
        AF = factor_filter["Assurance_Factor"].values[0]


        high = pop[pop['amount'] > PM]
        sum_High_value_items = sum(high['amount'])
        high_index = list(high.index)
        pop_remain = pop.drop(high_index)

        sampling_interval = np.int64((PM - EA) / AF)
        pop_amount = sum(np.int64(pop_remain['amount']))
        sample_size = int(np.int64((pop_amount - sum_High_value_items) * AF) / (PM - EA))
        sampling_array = np.array(list(range(1, sample_size + 1)), dtype='int64')
        sampling_n = sampling_array * sampling_interval
        sampling_row = list(range(sample_size))
        pop_remain['cum'] = np.cumsum(pop_remain['amount'])
        for i in range(sample_size):
            sampling_row[i] = np.where(pop_remain['cum'] > sampling_n[i])[0][0]

        unique = set(sampling_row)
        sampling_row = list(unique)
        sampling_row.sort()

        ## 추출된 샘플의 갯수
        lbl11.configure(text="Sample Output Size : " + str(len(sampling_row) + len(high)))
        
        ## 샘플링 객체 생성
        pop_remain = pop_remain.drop('cum', axis = 1)
        mus_sample = pop_remain.loc[sampling_row]
        sampling = pd.concat([high, mus_sample])
    except Exception as err:
        msgbox.showerror("Error", err)




# Title

Label(win, text = "Sampling Tool").grid(row = 0, column = 0, pady =20, columnspan =2)

label1 = Label(win, text = "Significant Risk")
label1.grid(row = 1, column = 0, sticky = W, padx =10)
    
label2 = Label(win, text = "Reliance of Controls")
label2.grid(row = 2, column = 0, sticky = W, padx =10)

label3 = Label(win, text = "Substantive Analytical Procedures")
label3.grid(row = 3, column = 0, sticky = W, padx =10)

label4 = Label(win, text = "Expected Misstatement")
label4.grid(row = 4, column = 0, sticky = W, padx =10)

label5 = Label(win, text = "Tolerable Misstatement")
label5.grid(row = 5, column = 0, sticky = W, padx =10)




button1 = Button(win, text="Upload Excel File", command=readexcel)
button1.grid(row = 10, column = 0, sticky = N+E+W+S, padx =10)

button2 = Button(win, text="Monetary unit sampling", command=mus)
button2.grid(row = 11, column = 0, sticky = N+E+W+S, padx =10)

button3 = Button(win, text="Random Sampling", command=rand)
button3.grid(row = 12, column = 0, sticky = N+E+W+S, padx =10)

button20 = Button(win, text="Save Sample File", command=save_File)
button20.grid(row = 20, column = 0, sticky = N+E+W+S, padx =10, columnspan =2)





SR_sel = ["Yes", "No"]
combobox1 = ttk.Combobox(win,height =5, state="readonly", values = SR_sel)
combobox1.grid(row = 1, column = 1)
combobox1.set("Yes")

RC_sel = ["Yes", "No"]
combobox2 = ttk.Combobox(win,height =5, state="readonly", values = RC_sel)
combobox2.grid(row = 2, column = 1)
combobox2.set("No")

PL_sel = ["APNP", "Low", "Moderate", "High"]
combobox3 = ttk.Combobox(win,height =5, state="readonly", values = PL_sel)
combobox3.grid(row = 3, column = 1)
combobox3.set("APNP")

e=Entry(win)
e.grid(row=4, column =1)
e.insert(0, "0.05")

entry_PM = Entry(win)
entry_PM.grid(row=5, column =1)
entry_PM.insert(0, "700000000")




lbl10 = Label(win, text ="not uploaded yet")
lbl10.grid(row=10, column=1, sticky = W,  pady = 20)

lbl11 = Label(win, text ="Sampling output size")
lbl11.grid(row=12, column=1, sticky = W,  pady = 20)



######################################### input
SR = str(combobox1.get())
RC = str(combobox2.get())
PL = str(combobox3.get())

PM = int(entry_PM.get())     ## Tolerable misstatement (generally performance materiality)
EA = PM * float(e.get())        ## Expected misstatement



win.mainloop()
