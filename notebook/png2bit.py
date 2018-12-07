import os

firDir="charset/"
files=os.listdir(firDir)
for each in files:
    os.rename(firDir+each,firDir+str(int(each.strip(".png"))-96)+".png")
