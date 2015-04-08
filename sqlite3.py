con = sqlite3.connect('so-dump.db')
cursor = con.cursor()

# tablas del esquema
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
print(cursor.fetchall())

cursor.execute("SELECT * FROM tags limit 1;")
print(cursor.fetchall())

cursor.execute("SELECT * FROM posts limit 1;")
print(cursor.fetchall())
