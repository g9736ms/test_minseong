import openpyxl as xl
import qrcode

wb = xl.load_workbook('C:\qrcode\qrcode.xlsx')
sheet1 = wb['Sheet1']
sheet2 = wb['Sheet1']
# A1 데이터를 가져오는 방법
i = 1

for data in sheet1['A2':'A390']:
    for cell in data:
        print('[', cell.value, ']')
        img = qrcode.make(cell.value)
        if i < 10 :
            img.save('C:\qrcode\qr_00%s.png' %i)
        elif 10 <= i < 100:
            img.save('C:\qrcode\qr_0%s.png' %i)
        else:
            img.save('C:\qrcode\qr_%s.png' %i)
        i = i + 1

wb.close()
