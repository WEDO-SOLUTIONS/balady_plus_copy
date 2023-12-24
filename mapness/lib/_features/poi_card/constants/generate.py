import pandas

ds = pandas.read_csv('descriptions-malls-and-interesting-places.csv', sep=';').values

about_en = "const aboutEn = {"
about_ar = "const aboutAr = {"

for d in ds:
    en = str(d[2]).replace("'", "\\'").replace("\n", "\\n")
    ar = str(d[3]).replace("'", "\\'").replace("\n", "\\n")
    about_en += f"{d[1]}: '{en}',"
    about_ar += f"{d[1]}: '{ar}',"

about_en += "};"
about_ar += "};"

with open("about_ar.dart", 'w') as ar:
    ar.write(about_ar)

with open("about_en.dart", 'w') as en:
    en.write(about_en)