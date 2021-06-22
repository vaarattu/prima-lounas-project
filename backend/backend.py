import win32com.client as win32
import pathlib

path = pathlib.Path(__file__).parent.absolute()
filePath = str(pathlib.Path.joinpath(path, "Ruokalista.doc"))
filePath = filePath.replace("\\", "\\\\")
word = win32.gencache.EnsureDispatch('Word.Application')
word.Visible = False
word.Documents.Open(filePath)
doc = word.ActiveDocument
docastxt = filePath.rstrip('doc') + 'txt'
word.ActiveDocument.SaveAs(docastxt, 7)
word.ActiveWindow.Close()
with open(docastxt, 'r') as file:
    data = file.read()
    print(data)
