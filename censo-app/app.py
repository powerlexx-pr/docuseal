from flask import Flask, render_template, request, redirect
import psycopg2
import os

app = Flask(__name__)
DB_URL = os.environ.get('DATABASE_URL')

def get_db():
    return psycopg2.connect(DB_URL)

@app.route('/', methods=['GET', 'POST'])
def index():
    status = None
    email = None
    if request.method == 'POST':
        email = request.form.get('email').strip().lower()
        conn = get_db()
        cur = conn.cursor()
        # Buscamos si existe en DocuSeal (Online) o en nuestra tabla (Mesa)
        query = """
            SELECT 'VOTÓ POR INTERNET (DocuSeal)' FROM submitters WHERE email = %s AND completed_at IS NOT NULL
            UNION
            SELECT 'VOTÓ EN MESA FÍSICA' FROM votos_presenciales WHERE email = %s
        """
        cur.execute(query, (email, email))
        result = cur.fetchone()
        if result:
            status = result[0]
        cur.close()
        conn.close()
    return render_template('index.html', status=status, email=email)

@app.route('/register', methods=['POST'])
def register():
    email = request.form.get('email').strip().lower()
    conn = get_db()
    cur = conn.cursor()
    try:
        cur.execute("INSERT INTO votos_presenciales (email) VALUES (%s)", (email,))
        conn.commit()
    except:
        pass
    finally:
        cur.close()
        conn.close()
    return redirect('/')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
