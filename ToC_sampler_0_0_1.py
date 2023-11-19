import pandas as pd
import random
import os
import xlsxwriter

import tkinter.ttk as ttk
from tkinter import *
from tkinter import filedialog
import tkinter.messagebox as msgbox

win =Tk()
win.geometry("700x700")
win.title("ToC Sampler 0.0.1")
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
        
        
    except Exception as err:
        msgbox.showerror("Error", err)

##################################################################################### save
def save_File():
    try:
        file_path = filedialog.askdirectory()
        excel_writer = pd.ExcelWriter(file_path + '/ToC_sample.xlsx', engine='xlsxwriter')
        sampling.to_excel(excel_writer, sheet_name='ToC_sample',index=False)
        excel_writer.close()
        msgbox.showinfo("Save complete", "ToC_sample.xlsx")
    except Exception as err:
        msgbox.showerror("Error", err)


##################################################################################### random
def toc():
    global pop
    global population
    global sampling
    try:
        total_line = len(pop)
        
        sample_size = pd.DataFrame({"NoSignificantRisk" : [1,2,2,3,5,8,14,20],
                                    "SignificantRisk" : [1,2,4,6,9,15,25,30]})        

        if str(combobox1.get()) == "Yes":
            sr = 1
        else:
            sr = 0
            
        occ_num = {"1-3":0,"4-11":1,"12-25":2,"26-47":3,"48-60":4,"61-104":5,"105-249":6,"250 over":7}
        occ = occ_num[str(combobox2.get())]
        
        size = sample_size.iloc[occ,sr]
        
        sampling_row = random.sample(range(len(pop)), size)
        sampling = pop.loc[sampling_row]

        ## 추출된 샘플의 갯수
        lbl11.configure(text="Sample Output Size : " + str(len(sampling)))
        
        
    except Exception as err:
        msgbox.showerror("Error", err)



# Title

label0 = Label(win, text = "RSM Test of Controls Sampling Tool")
label0.grid(row = 0, column = 0, pady =20, columnspan=2)

label1 = Label(win, text = "Significant Risk")
label1.grid(row = 1, column = 0, sticky = W, padx =10)
    
label2 = Label(win, text = "Number of Occurrences")
label2.grid(row = 2, column = 0, sticky = W, padx =10)





button1 = Button(win, text="Upload Excel File", command=readexcel)
button1.grid(row = 10, column = 0, sticky = N+E+W+S, padx =10)

button2 = Button(win, text="ToC sampling", command=toc)
button2.grid(row = 11, column = 0, sticky = N+E+W+S, padx =10)

button20 = Button(win, text="Save Sample File", command=save_File)
button20.grid(row = 20, column = 0, sticky = N+E+W+S, padx =10, columnspan =2)





sr_select = ["Yes", "No"]
combobox1 = ttk.Combobox(win,height =5, state="readonly", values = sr_select)
combobox1.grid(row = 1, column = 1)
combobox1.set("Yes")


occ = ["1-3","4-11","12-25","26-47","48-60","61-104","105-249","250 over"]
combobox2 = ttk.Combobox(win,height =5, state="readonly", values = occ)
combobox2.grid(row = 2, column = 1)
combobox2.set("105-249")




lbl10 = Label(win, text ="not uploaded yet")
lbl10.grid(row=10, column=1, sticky = W,  pady = 20)

lbl11 = Label(win, text ="Sampling output size")
lbl11.grid(row=11, column=1, sticky = W,  pady = 20)


label_table00 = Label(win, text = "Occurrences")
label_table00.grid(row = 30, column = 0, sticky = W, padx =10)
label_table01 = Label(win, text = "No Significant risk/ Significant Risk")
label_table01.grid(row = 30, column = 1, sticky = W, padx =10)
label_table10 = Label(win, text = "1-3")
label_table10.grid(row = 31, column = 0, sticky = W, padx =10)
label_table11 = Label(win, text = "1 / 1")
label_table11.grid(row = 31, column = 1, sticky = W, padx =10)
label_table20 = Label(win, text = "4-11")
label_table20.grid(row = 32, column = 0, sticky = W, padx =10)
label_table21 = Label(win, text = "2 / 2")
label_table21.grid(row = 32, column = 1, sticky = W, padx =10)
label_table30 = Label(win, text = "12-25")
label_table30.grid(row = 33, column = 0, sticky = W, padx =10)
label_table31 = Label(win, text = "2 / 4")
label_table31.grid(row = 33, column = 1, sticky = W, padx =10)
label_table40 = Label(win, text = "26-47")
label_table40.grid(row = 34, column = 0, sticky = W, padx =10)
label_table51 = Label(win, text = "3 / 6")
label_table51.grid(row = 34, column = 1, sticky = W, padx =10)
label_table60 = Label(win, text = "48-60")
label_table60.grid(row = 35, column = 0, sticky = W, padx =10)
label_table71 = Label(win, text = "5 / 9")
label_table71.grid(row = 35, column = 1, sticky = W, padx =10)
label_table80 = Label(win, text = "61-104")
label_table80.grid(row = 36, column = 0, sticky = W, padx =10)
label_table91 = Label(win, text = "8 / 15")
label_table91.grid(row = 36, column = 1, sticky = W, padx =10)
label_table100 = Label(win, text = "105-249")
label_table100.grid(row = 37, column = 0, sticky = W, padx =10)
label_table101 = Label(win, text = "14 / 25")
label_table101.grid(row = 37, column = 1, sticky = W, padx =10)
label_table110 = Label(win, text = "250 over")
label_table110.grid(row = 38, column = 0, sticky = W, padx =10)
label_table111 = Label(win, text = "20 / 30")
label_table111.grid(row = 38, column = 1, sticky = W, padx =10)



win.mainloop()
