import pandas as pd
import numpy as np
import random
import xlsxwriter

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
        Test = [' ',
                'Test of Details - [BP70 Section A-B]',
                ' ',
                '회사명',
                '작성일자',
                '작성자',
                '검토자',
                ' ',
                ' ',
                'Section A: 목적 ',
                ' ',
                '표본감사를 사용할 때 감사인의 목적은 추출된 표본이 모집단에 대해 결론을 도출하는 데 합리적인 근거를 제공하는 것이다. ',
                '표본감사란 계정잔액이나 특정 거래의 입증을 목적으로, 전체 항목보다 적은 수의 항목에 대해서 감사절차를 적용하는 것이다.',
                '표본항목들은 표본이 모집단을 대표하는 방식으로 추출되어야 한다. 그러므로 모집단의 모든 항목들은 추출될 기회를 가져야 한다. ',
                '감사인은 감사표본을 설계할 때 감사절차의 목적과 표본을 도출할 모집단의 특성을 고려하여야 한다. ',
                '감사인은 감사표본을 설계할 때 달성할 특정 목적과 그러한 목적을 가장 잘 달성할 수 있는 감사절차의 조합을 고려해야 한다. ',
                '감사인은 추출한 모집단의 표본이 감사 목적에 적절한 것인지 결정해야 한다.',
                ' ',
                ' ',
                '(1) 계정명(FSLI)  :               ',
                '(2) 기준일 (Coverage date)  :                ',
                '(3) 테스트되는 경영자의 주장 (Assertion)  :    정확성 (A), 실재성 및 발생사실(E/O)',
                ' ',
                ' ',
                'Section B: 표본 설계 - 모집단과 표본',
                ' ',
                '(1) 모집단의 성격 : ',
                '(2) 모집단의 완전성 확인 방법 : ',
                '(3) 표본단위의 정의  : ',
                '(4) 전체 모집단이 추출 대상인가?  : ',
                ' ',
                ' ',
                '* 표본 지표',
                '---------------------------------------------------------------------------------------------------------------------------- ',
                '모집단 크기 : ' + str(population),
                '예상오류 : ' + str(float(entry_PM.get()) * float(e.get())),
                '표본대상 항목들의 위험평가 결과 SignificantRisk? : ' + str(combobox1.get()),
                '통제에 의존하는 경우 : ' + str(combobox2.get()),
                '실증적 분석적 검토 절차를 통해 기대수준의 확신을 얻었는가? : ' + str(combobox3.get()),
                '---------------------------------------------------------------------------------------------------------------------------- ',
                ' ',
                ' ',
                '추출 방법 (MUS or Random): ',
                ' ',
                ' ',
                '---------------------------------------------------------------------------------------------------------------------------- ',
                '[Assurance factor]                                Planned Level of Assurance from Substantive Analytical Procedures',
                "SignificantRisk    RelianceonControls        High   Moderate   Low   APNP ",
                "Yes                     No                             1.1         1.6          2.8         3",
                "No                      No                             0          0.5          1.7         1,9",   
                "Yes                     Yes                             0          0.2          1.4         1.6",
                "No                     Yes                             0          0            0.3         0.5",
                '---------------------------------------------------------------------------------------------------------------------------- ',
                ' ',  
                ' ',
                '* 표본크기 결정',
                '---------------------------------------------------------------------------------------------------------------------------- ',
                '신뢰계수 (Assurance factor) : ' + str(AF), 
                '추출된 표본의 갯수 : '  + str(len(sampling)),
                '---------------------------------------------------------------------------------------------------------------------------- ',
                ' ',
                ' ',
                'Test에 대한 추가 기술 및 결론 : ']
        
        file_path = filedialog.askdirectory()
        
        excel_file = file_path + '/test_summary.xlsx'
        workbook = xlsxwriter.Workbook(excel_file)
        worksheet = workbook.add_worksheet('ToD')

        for row_num, value in enumerate(Test):
            worksheet.write(row_num, 1, value)
        cell_format1 = workbook.add_format()
        cell_format1.set_bottom(5)
        for i in range(4, 8):
            worksheet.write(f'C{i}', " ", cell_format1)
        for i in [20, 21, 27, 28, 29, 30, 43, 63]:
            worksheet.write(f'C{i}', " ", cell_format1)
        worksheet.set_column(1, 3, 40)

        cell_format2 = workbook.add_format()
        cell_format2.set_bold()
        cell_format2.set_font_color('blue')
        worksheet.write('B43','추출 방법 (MUS or Random): ', cell_format2)
        worksheet.write('B63','Test에 대한 추가 기술 및 결론 : ', cell_format2)

        cell_format3 = workbook.add_format()
        cell_format3.set_bg_color('green')

        cell_format4 = workbook.add_format()
        cell_format4.set_bg_color('#0099FF')


        worksheet.write('B2', 'Test of Details - [BP70 Section A-B]', cell_format3)
        worksheet.write('C2',' ',cell_format3)
        worksheet.write('D2','표본추출절차서 ',cell_format3)

        worksheet.write('B10', 'Section A: 목적 ', cell_format4)
        worksheet.write('B25', 'Section B: 표본 설계 - 모집단과 표본 ', cell_format4)
        for i in ['C10','D10','C25', 'D25']:
            worksheet.write(i, " ", cell_format4)



        workbook.close()



        excel_writer = pd.ExcelWriter(file_path + '/test_sample.xlsx', engine='xlsxwriter')
        sampling.to_excel(excel_writer, sheet_name='test_sample',index=False)
        excel_writer.save()
        msgbox.showinfo("Save complete", "test_sample.xlsx, test_summary.xlsx")
    except Exception as err:
        msgbox.showerror("Error", err)



##################################################################################### random
def rand():
    global pop
    global population
    global sampling
    global AF
    try:
        amount = str(combobox11.get())
        ## rename Data variable
        if amount != 'amount':
            pop = pop.rename(columns = {amount : 'amount'})   
        
        pop['amount'] = pd.to_numeric(pop['amount'])
        population = sum(pop['amount'])
        
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
        factor_filter = assurance_factor[assurance_factor['SignificantRisk'] == str(combobox1.get())]
        factor_filter = factor_filter[factor_filter['RelianceonControls'] == str(combobox2.get())]
        factor_filter = factor_filter[factor_filter['Planned_Level'] == str(combobox3.get())]
        AF = factor_filter["Assurance_Factor"].values[0]

        pop_amount = sum(pop['amount'])
        sample_size = int(pop_amount * AF / (int(entry_PM.get())  - int(entry_PM.get()) * float(e.get())))

        sampling_row = random.sample(range(total_line), sample_size)
        sampling = pop.loc[sampling_row]
        
        ## 추출된 샘플의 갯수
        lbl12.configure(text="Sample Output Size : " + str(len(sampling)))
        
    except Exception as err:
        msgbox.showerror("Error", err)


################################################################################### mus
def mus():
    global pop
    global population
    global sampling
    global AF
    try:
        amount = str(combobox11.get())
        ## rename Data variable
        if amount != 'amount':
            pop = pop.rename(columns = {amount : 'amount'})   
        
        pop['amount'] = pd.to_numeric(pop['amount'])
        population = sum(pop['amount'])

        assurance_factor_raw = pd.DataFrame({"SignificantRisk" : ["Yes", "No", "Yes", "No"],
                                        "RelianceonControls" : ["No","No","Yes","Yes"],
                                        "High" : [1.1, 0 ,0 ,0],
                                        "Moderate" : [1.6,0.5,0.2,0],
                                        "Low" : [2.8,1.7,1.4,0.3],
                                        "APNP" : [3,1.9,1.6,0.5]})
        assurance_factor = pd.melt(assurance_factor_raw, id_vars = ["SignificantRisk", "RelianceonControls"], 
                                var_name = "Planned_Level", 
                                value_name = "Assurance_Factor")
        factor_filter = assurance_factor[assurance_factor['SignificantRisk'] == str(combobox1.get())]
        factor_filter = factor_filter[factor_filter['RelianceonControls'] == str(combobox2.get())]
        factor_filter = factor_filter[factor_filter['Planned_Level'] == str(combobox3.get())]
        AF = factor_filter["Assurance_Factor"].values[0]


        high = pop[pop['amount'] > int(entry_PM.get()) ]
        sum_High_value_items = sum(high['amount'])
        high_index = list(high.index)
        pop_remain = pop.drop(high_index)
        minus = pop[pop['amount'] <= 0]
        minus_index = list(minus.index)
        pop_remain = pop_remain.drop(minus_index)

        sampling_interval = np.int64((int(entry_PM.get())  - int(entry_PM.get()) * float(e.get())) / AF)
        pop_amount = sum(np.int64(pop_remain['amount']))
        sample_size = int(np.int64(pop_amount * AF) / (int(entry_PM.get())  - int(entry_PM.get()) * float(e.get())))
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
        lbl12.configure(text="Sample Output Size : " + str(len(sampling_row) + len(high)))
        
        ## 샘플링 객체 생성
        pop_remain = pop_remain.drop('cum', axis = 1)
        pop_remain = pop_remain.reset_index()
        mus_sample = pop_remain.loc[sampling_row]
        sampling = pd.concat([high, mus_sample])
        
    except Exception as err:
        msgbox.showerror("Error", err)




# Title

label0 = Label(win, text = "Sampling Tool")
label0.grid(row = 0, column = 0, pady =20, columnspan=2)

label1 = Label(win, text = "Significant Risk")
label1.grid(row = 1, column = 0, sticky = W, padx =10)
    
label2 = Label(win, text = "Reliance of Controls")
label2.grid(row = 2, column = 0, sticky = W, padx =10)

label3 = Label(win, text = "Substantive Analytical Procedures")
label3.grid(row = 3, column = 0, sticky = W, padx =10)

label4 = Label(win, text = "Expected Misstatement Rate")
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

lbl11 = Label(win, text ="Select amount column")
lbl11.grid(row=11, column=1, sticky = W,  pady = 20)

lbl12 = Label(win, text ="Sampling output size")
lbl12.grid(row=12, column=1, sticky = W,  pady = 20)



win.mainloop()
