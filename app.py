import os
import mariadb
from flask import Flask, render_template, request, redirect, url_for, send_from_directory, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.utils import secure_filename

# Konfigurasi Flask
app = Flask(__name__)
app.secret_key = "$SECRET_KEY"

# Konfigurasi folder upload
UPLOAD_FOLDER = 'uploads'
TEMPLATES_FOLDER = 'templates'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ekstensi file yang diizinkan
ALLOWED_EXTENSIONS = {'html', 'zip', 'rar', 'iso', 'img', 'avi', 'svg', 'sh', 'gz', 'mp3', 'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mkv'}

#code
REGISTER_CODE = "FREE"
# Login manager setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

# MariaDB configuration
def get_db_connection():
    return mariadb.connect(
        user="taufiqul",
        password="new_password",
        host="localhost",
        port=3306,
        database="flask_app"
    )

class User(UserMixin):
    def __init__(self, id):
        self.id = id

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT username FROM users WHERE id = ?", (user_id,))
    row = cur.fetchone()
    conn.close()
    if row:
        return User(user_id)
    return None

# Fungsi untuk memeriksa ekstensi file
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Rute untuk login
@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, password FROM users WHERE username = ?", (username,))
        row = cur.fetchone()
        conn.close()
        if row and row[1] == password:
            user = User(row[0])
            login_user(user)
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid username or password', 'danger')
    return render_template('login.html')

# Rute untuk pendaftaran
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        code = request.form['code']

        if code != REGISTER_CODE:
            flash('❌ Registration code salah.', 'danger')
            return redirect(url_for('register'))

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT username FROM users WHERE username = ?", (username,))
        if cur.fetchone():
            flash('❗Username sudah ada.', 'warning')
        else:
            cur.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, password))
            conn.commit()
            flash('✅ Registrasi akun berhasil.', 'success')
        conn.close()

    return render_template('register.html')

# Rute untuk dashboard
@app.route('/dashboard')
@login_required
def dashboard():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT username FROM users")
    users = [row[0] for row in cur.fetchall()]
    conn.close()
    files = os.listdir(app.config['UPLOAD_FOLDER'])
    return render_template('dashboard.html', files=files, users=users)

# Rute untuk mengunggah file
@app.route('/upload', methods=['POST'])
@login_required
def upload_file():
    if 'file' not in request.files:
        flash('No file part in the request', 'danger')
        return redirect(url_for('dashboard'))
    file = request.files['file']
    if file.filename == '':
        flash('No selected file', 'warning')
        return redirect(url_for('dashboard'))
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        try:
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            flash('File successfully uploaded', 'success')
        except Exception as e:
            flash(f'File upload failed: {str(e)}', 'danger')
        return redirect(url_for('dashboard'))
    else:
        flash('File type not allowed', 'danger')
        return redirect(url_for('dashboard'))

# Rute untuk mengunduh file
@app.route('/get/<filename>')
def download_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

# Rute untuk logout
@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=151, debug=True)
