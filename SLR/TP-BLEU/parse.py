f = open("hypothese-GoogleTrad-fr","r+")
d = f.readlines()
f.seek(0)

for i in d:
    if i != "\n":
        f.write(i)

f.truncate()
f.close()

